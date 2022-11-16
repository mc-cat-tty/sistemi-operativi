# Intro
Obiettivi: il SO deve applicare restrizioni sull'accesso ad una risorsa
> **Autorizzazione**: procedura con cui (il SO) si controlla se un processo ha i permessi necessari per accedere ad una risorsa

I sistemi UNIX usano le seguenti astrazioni per gestire l'aurizzazione all'accesso di file:
- gruppo di lavoro: insieme di utenti che condividono gli stessi privilegi ad una risorsa
- attributi di un file: privilegi minimi per l'accesso ad una risorsa
- credenziali di un'applicazione: credenziali con cui un processo si presenta per accedere ad una risorsa

## Informazioni sul gruppo
GID, groupname, password, lista utenti (lista nomi di login appartenenti ad un gruppo)

Nella maggior parte dei casi la password di un gruppo è nulla, ma è possibile configurare l'autenticazione anche per i gruppi.

`/etc/group` contiene l'elenco di tutti i gruppi presenti sul sistema. Database testuale con separatore `:`:
- nome gruppo
- passwrod cifrata
- identificatore gruppo
- lista utenti appartententi al gruppo

`/etc/gshadow` contiene informazioni associate ad ogni gruppo:
- nome gruppo
- password cifrata
- utenti amministratori del gruppo
- utenti membri del gruppo

## Risorse
Le risorse in UNIX sono accessibili come file:
- periferiche fisiche in /dev
- dispositivi virtuali in /dev
- archivi dati accessibili attraverso il fs

Un utente può fare parte di più gruppi, ad ogni istante uno solo primario, mentre gli altri secondari.

# Permessi
## Comandi di visualizzazione
## id
Mostra:
- user id
- primary group id
- secondary group ids

## groups
Ritorna la lista di groupnames secondari

Per ogni nuovo utente viene creato un gruppo di lavoro con il suo stesso nome e associato di default come gruppo primario.

## Mode
Rappresentazione (10 caratteri di cui 9 significativi):
```
CREATORE GRUPPO ALTRI
---      ---    ---
```


Ognuna di queste 3 terne va interpretata come segue:
 - `-` se non posso leggere il fie/la dir, `r` altrimenti
 - `-` se non posso scrivere il file/la dir, `w` altrimenti
 - `-` se non posso eseguire il file o accedere alla directory, `-` altrimenti

Il primo carattere del *mode* indica il tipo di file:
- *d* directory
- *l* link simbolico
- *-* file regolare
- *b* dispositivo a blocchi
- *c* dispositivo a caratteri

*surretizio*: furtivo, nel linguaggio giuridico

### Credenziali di un'applicazione
Ogni applicazione in esecuzione tiene in pancia dei metadati con:
- identificatore utente (user identifier) -> utente che ha lanciato l'applicazione
- identificatore gruppo primario (primary group id)
- identificatori gruppo secondario (secondary group id)

Quando viene creato un processo che cerca di accedere ad un file, si confrontano i permessi contenuti nei metadati, con quelli appioppati ad un file.
1. Se UID del processo matcha con UID creatore uso i permessi ad essso assegnati
2. Se uno dei GID matcha con GID creatore uso i permessi assegnati da qeusta terna
3. Vengono assegnati i permessi di *others*

La procedura di controllo viene applicata prima di aprire il file descriptor di un file, successivamente non vengono effettuati più controlli. Il controllo sui permessi si applica ad ogni pezzetto del path a cui si vuole accedere. La directory è queindi "spezzata" e il check fatto pezzo per pezzo.

**Esempio**: `less -Mr -f /dev/sda` da utente *studente*
Dove:
- M disabilita i colori
- r mostra la barra di progressione
- f serve per la lattura di file binari
Non funziona perchè i permessi del gruppo others di /dev/sda è `---`. Per leggere questo dispositivo a blocchi dovrei appartenere al gruppo disk, oppure essere l'utente creatore (root).


Dati come UID, GID primario e GIDs secondari vengono mantenuti nel PCB - Process Control Block.

# Gestione dei gruppi
## Debian based distro
`addgroup` e `delgroup` utili a creare ed eliminare gruppi che diventeranno in futuro gruppi secondari o gruppi primari.

## UNIX Compliant
Ricerca: `grep groupname /etc/group`

Per aggiunta e rimozione: `groupadd gruppo` e `groupdel gruppo`

## groupmod
```bash
groupmode [opzioni] groupname
```

Con `-n` modifico il nome del gruppo, mentre con `-g` posso cambiare il GID

I permessi dei file relativi al gruppo primario non vengono aggiornati se si cambia il GID o il groupname di un gruppo già esistente.

Posso farlo a mano filtrando con `grep` un GID specifico e lanciare `chgrp grupponuovo {} \;`

## groups
```bash
groups nomeutente
```

Nota: `groups root` -> dentro solo al gruppo root, a cui vengono garantiti gli accessi no matter whats

## usermod
Anche con questo comando posso modificare i gruppi a cui appartiene l'utente:
- `-g groupname` specifica il nuovo gruppo primario
- `-G grouplist` specifica una lista di gruppi secondari

Attenzione: tutti gli altri gruppi assegnati all'utente verrranno cancellati

Per aggiungere gruppi al posto di sovrascriverli su usa l'opzione `-a`

## gpasswd
```bash
gpasswd -a username group  # aggiunta group a user
gpasswd -d username group  # rimozione group da user
```
Di lunga più comodo rispetto a `usermod`

Attenzione: i gruppi associati ad un utente non sono associati dinamicamente ai processi da esso posseduto. Quindi se aggiungo un gruppo di lavoro secondario all'utente in questione, la modifica non viene notata finchè non si rifa il login dell'utente.
Soluzione: riavvio macchina o logout, stando attendo

Si possono importare di dinamicamente i gruppi rendendo un gruppo di lavoro primario:
```bash
newgrp gruppo
```

# Modifica Proprietà
### chown
Modifica l'utente creatore di un utente o una directory:
```bash
chown [opzioni] username filename
```

Può lavorare anche in maniera ricorsiva sul contenuto di una directory.

### chgrp
Modifica il gruppo di lavoro a cui appartiene un file:
```bash
chgrp [opzioni] username filename
```

Per evitare la modifica di proprieterio e gruppo in due passaggi posso fare:
```bash
chown username:group filename
```

Modifica ricorsiva:
```bash
chown -R studente:studente /home/studente
```

## Modifica Mode
```bash
chmod [opzioni] permessi filename
```

I permessi possono essere espressi in 2 rappresentazioni differenti:
- ottale
- testuale

I permessi in forma testuale sono espressi come: `insieme_di_utenti -+ insieme_permessi`.
Più permessi in questa forma sono permessi, separati da una virgola.

Insieme dei letterali che rappresentano gli utenti:
- u user creatore
- g gruppo creatore
- o others
- a all (tutti i precedenti)

Insieme dei letterali dei permessi:
- r read
- w write
- x esecuzione file o entrada in directory
- s set uid o gid

*apostrofare*

Esempio modifica additiva:
```bash
chmod a-x,o-w,ug+rw,o+r prova.txt  # per essere sicuro che i permessi siano quelli desiderati
```
Oppure rimuovo tutti i permessi e poi aggiungo quelli che mi servono.

Alternativa più comoda:
```bash
chmod 0755 prova.txt
```

Ogni digit rappresenta un permesso da assegnare ad un campo del mode.

La prima cifra rappresenta uid/gid:
- 0 nulla
- 1 sticky bit
- 2 setgid
- 4 setuid

Per le ultime 3 cifre vale:
- 0 nulla
- 1 x
- 2 w
- 4 r

Questa rappresentazione non è additiva, ma "troncante".

Esempio: sul file `/dev/sda` è possibile leggere e scrivere solo se si è root o se si appartiene a disk.