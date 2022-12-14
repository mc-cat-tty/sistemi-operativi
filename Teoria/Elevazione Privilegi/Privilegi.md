https://xkcd.com

# Introduzione
Scenario: ci troviamo su in SO moderno, multiutente.

>Secondo il principio del **minimo privilegio** il SO deve assegnare ad ogni processo le risorse minimie, necessarie per il suo funzionamento immediato, senza eccedere con la "potenza" (in termini di libertà del processo) ad esso assegnata.

Concedendo l'insieme minimo di privilegi ad ogni istante, si aumenta la protezione del sistema, sia contro malfunzionamenti che contro comportamenti maliziosi.

# Cambio di privilegio
I SO moderni forniscono dei meccanismi per il cambio di privilegio. Questo meccanismo permette ad utenti ordinari di eseguire, ad esempio, alcuni processi come utente root (amministratore).

Ne è un esempio il comando `passwd`, che consente di modificare la propria password di login, scrivendo sul file */etc/shadow* senza che ad eseguirlo sia l'utente root.
->l'utente lancia un comando che assume automaticamente i privilegi necessari (dopo che il kernel glieli ha concessi)

## UID/GID Effettivi
Il SO fornisce un'astrazione per mandare in esecuzione un processo con due "personalità distinte".

All'interno del PCB - Process Control Group - vengono salvati due campi:
- **EUID** - Effective User ID
- **EGID** - Effective Group ID
Associati al processo in esecuzione -> credenziali di processo

Per distinguere questi due descrittori da quelli visti fin'ora, questi ultimi vengono chiamati:
- **RUID** - Real User ID
- **RGID** - Real Group ID

### Controllo degli accessi
Come funziona l'algoritmo di controllo degli accessi?
Il kernel usa delle ACL - Liste di Controllo degli Accessi - per determinare i permessi necessari ad accedere ad un file, directory o eseguibile.

Se RUID == 0 -> l'accesso è garantito sempre e comunque
Se RUID != 0 -> avviene il controllo degli accessi, con EUID e EGID.
- Se EUID == UID owner file -> sono rilasciati i permessi associati alla prima terna rwx
- Se EGID primario o secondario == GID owner -> ...
- Permessi di other

Solitamente quando un processo ha EUID/GIUD == RUID/RGID

In alternativa al flag `x` possiamo trovare il flag `s` -> SETUID
In questo caso l'EUID o l'EGID del processo creato dall'immagine con questo flag attivo, corrisponde all'UID o GID dell'owner del file.

# SETUID e SETGID
Il flag Set UID e Set GID permettono di eseguire un file eseguibile con i permessi dell'utente/gruppo a cui appartiene il file. Questo eseguibile, come `/etc/passwd`, esegue con Effective UID pari a quello del proprietario del file.

## Esempio passwd
Permessi `passwd`:
```bash
-rwsr-xr-x root root ... /usr/bin/passwd
```

Quando viene creato un processo da questo eseguibile, se lanciato da studente, abbiamo che:
- RUID = studente
- GUID = studente (solitametne, o comunque il gruppo primario di studente)
- EUID = root
- GUID = studente

## Svantaggio
SUID e SGID hanno vita pari alla vita del processo.
Se un attaccante ha la possibilita di iniettare codice surretizio -> posso eseguirlo come 

Il bit SETGID è analogo al SUID, ma si applica alla seconda terna.

Posso abbassare (sganciarli, *drop*) i privilegi? è compito dell'applicazione (programmatore), non esiste una via di mezzo (che sia sotto il controllo del kernel).

Si viola il **principio di privilegio minimo**.

Soluzione -> Saved UID e Saved GID

# SUID e SGID
Questa coppia permette al sistema operativo di ricordarsi quale era l'UID effettivo (o EGID) all'avvio del programma. Il programmatore può a questo punto droppare tranquillamente i privilegi, ripristinandoli in futuro se necessario.

Un bravo programmatore sgancia quindi i privilegi dati da EUID e EGID iniziali all'avvio del programma, esegue le operazioni critiche, ripristina (**privilege restore**) EUID e EGID con SUID e SGID per eseguire le operazioni ad alto privilegio, poi torna a impostare E{UID,GID} = R{UID,GID}.

Vedi: eBPF e ciclo di Carnot. Minimizzare area (diagramma tempo - privilegio).

# Capability
Il modello attualmente utilizzato (da GNU/Linux) per l'assegnazione dei permessi è quello delle capability. Ogni cap è un token che fa riferimento e ad un insieme di diritti d'accesso.

Nell'esempio di `passwd` non è necessario che l'eseguibile abbia i permessi di root integrali (monitorare processi, tracciarli, forgiare e inviare pacchetti in rete, controllare i driver, ecc.).

Il privilegio di root integrale viene spezzato in più privilegi disgiunti (minori).

Linux introduce il meccanismo delle **capability** -> lista completa alla pagina 7 del manuale.
Tutte le macro che iniziano con *CAP*

```bash
man 7 capabilities
```

Ogni processo presenta un insieme di 3 capability. Ogni capability è un flag (si ha o non si ha).

## Capability permesse
Le **permitted capability** sono concesse dal kernel al programma. Il programma può decidere di scartarle (spegnere le capability che non servono).

Non si possono riprendere le capability rilasciate.

## Capability effettive
Le **effective capability** sono un sottoinsieme delle capability effettive, dopo l'applicazione del filtro all'avvio del processo.

Questo sottoset di capability può essere modificato a runtime (il drop non è permanente). Il processo che vuole abbassare temporaneamente i suoi privilegi spegne le capability effettive, poi le riattiva quando necessario. 

In breve:
- drop c. permessa -> permanete
- drop c. effettive -> temporaneo

## Capability eredite
Sono un sottoinsieme delle capability permesse, che un processo può trasferire ad un nuovo processo figlio, nel campo capability permesse, quando carica una nuova immagine in memoria.

Le capability vengono ereditate quando un processo esegue una nuova immagine con `execve()`.

## Capability di file
https://man7.org/linux/man-pages/man7/capabilities.7.html

Come per l'algoritmo di controllo dei permessi, le capability del processo vengono confrontate con quelle di file. Ogni file che contiene informazioni sulle CAPs, mantiene al suo interno 3 insiemi.
Sono:
- permesse -> capability inserite nell'insieme delle capability permesse all'avvio dell'immagine
- effettive -> un singolo bit. Se acceso il processo nato dall'esecuzione di `execve()` ha il set delle effective capability = set permitted capability. Altrimenti effective capability è vuoto all'avvio.
- ereditabili ->le capability ereditabili di un'immagine sono messe in AND bit a bit con le capability ereditabili dal processo. Il risultato sono le capability che un eventuale processo figlio potrà ereditare.

Sono visualizzabili con `getcap`:
```bash
getcap /usr/bin/ping

# ritorna: cap_net_raw=ep
```

Dove:
- e -> effective
- i -> inherited
- p -> permitted

## Algortimo
- P insieme delle capability del processo prima del caricamento di un'immagine
- P' insieme delle capability del processo dopo l'esecuzione dell'immagine: Bash quando viene eseguito `ls` si forka, inizialmente è un processo Bash, ma successivamente con `execve` carica l'immagine del nuovo processo.
- F insieme delle CAPs del file
- M maschera di CAPs da spegere per il processo figlio (che il padre non vuole far ereditare ai processi figli)

### Permitted
```
P'(permitted) = 
	(P(inheritable)  # capability ereditate dal processo prima di diventare P'
	&  // and bit a bit
	F(inheritable))  // capability ereditabili del file eseguibile
	|
	(F(permitted)  // capability permesse al file
	&  // and bit a bit
	M  // maschera che disattiva le caps del figlio, comandata dal padre
	)	
```

## Effective
Ricorda che F(effective) è un solo bit che indica se Eset deve essere vuoto o uguale Pset
```
P'(effective) = F(effective) ? P'(permitted) : 0  // dove P'(permitted) è l'insieme calcolato prima
```

### Inheritable
```
P'(inheritable) = P(inheritable)
```

# Comportamenti anomali
Cosa succede se l'amministratore imposta sia le capability che il SETUID/SETGID?

Vengono usati prima i bit SETUID e SETGID, che forniscono l'intero set di privilegi, poi le CAPs.

Vedi: lezione 5 sviluppo codice sicuro