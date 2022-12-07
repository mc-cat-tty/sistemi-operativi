# id
```bash
id [OPZIONI] [USERS]
```

Stampa:
- uid
- gid -> id gruppo primario
- gruppi secondari
degli utenti passati come argomenti, oppure di quello correntemente attivo (che ha eseguito)

# su
`su` ovvero **Switch User** permette di cambiare l'utente. Bisogna conoscere la password dell'utente di arrivo.

Nella sua forma più semplice:
```bash
su
```

Si diventa root, poi viene eseguita una semplice shell Bash.

Problema: non si passa per la shell di login, quindi l'ambiente di *root* non viene caricato. Lo si può vedere con `export` dopo essere diventati `root`.

Soluzione:
```bash
su - [USERNAME]
```
Con l'opzione `-` viene caricato l'ambiente dell'utente destinazione

Oppure:
```bash
su -l [USERNAME]
```

In questo modo viene lanciata una shell di login, che esegue gli script per caricare l'ambiente.

La bash pura viene usata per eseguire gli script o altri comandi.

Esecuzione comando come altro utente:
```bash
su -c "CMD [OPTS] [ARGS]" -l [USERNAME]
```
Il quoting debole non è necessario se il comando non ha argomenti o opzioni.

Esempio - elencare solo file e dir nascoste nella home di root:
```bash
su -l -c "pwd; ls -lad .*" root
``` 

*Senza colpo ferire*: ottenere qualcosa senza bisogno di combattere/opporre resistenza
*Nocciolo duro*

Problema: con `su` bisogna chidere la password dell'utente di arrivo, ma non la si vuole distribuire a tutti gli utenti di una macchina.

# sudo
Tutti gli utenti del gruppo `sudores`, possono diventare root (o comunque utente di destinazione) senza conoscere la sua password: basta quella dell'utente di arrivo.

La configurazione di `sudo` è contenuta in `/etc/sudores`.

Se si sbaglia la configurazione, `sudo` smette di funzionare. Su distro come Ubuntu, dove la password di `root` è generata casualmente, mentre il primo utente configurato è sudoer, ci si traglierebbe fuori dal SO.

## visudo
Per evitare questa eventualità esiste `visudo`, che non salva la configurazione finchè non è valida. In più usa un lock per regolare l'accesso al file di configurazione, utile nel caso in cui più utenti tentino di modificarla.

Posso modificare il fle con:
```bash
su -
EDITOR=vim visudo
```

Come leggere il file?
- ogni riga con primo carattere `#` è un commento
- ogni riga che **non** inizia con `#` è una direttiva

Il formato si trova nella sezione *SUDOERS  FILE FORMAT* in `man 5 sudoers`
- `env_reset` lancia il nuovo processo con un ambiente castrato
- `mail_badpass` invia una mail all'amministratore se un utente sbaglia il login
- `secure_path` è una PATH sicura passata ai processi creati con sudo

Gli **alias** sono stringhe che semplificano il processo di configurazione di `sudoers`. Esempio:
```bash
User_Alias WEBMASTERS = will, wendy, wim
```

Stringa privilegi: `<who> <where> = <as whom> <what>`
- who - chi ha il permesso
- where - da quale host
- as whom - utente destinazione sudo (`<user>:<group>`)
- what - cosa può eseguire

Se antepongo `%` ad un nome, esso viene valutato come **gruppo** e non come username.

`includedir DIRECTORY` include in ordine alfabetitco tutti i file di una directory

## sudo e i gruppi
```bash
sudo -l  # login
sudo -ll  # login verboso
sudo -llU francesco   # -U specifica username
```

Solo chi appartiene al gruppo `sudo` può usare questo comando. Per aggiungere un utente:
```bash
gpasswd -a studente sudo
```

Nella forma più generale, il primo argomento di `sudo` è un comando da eseguire:
```bash
sudo id -r -u
sudo id -r -g
sudo id -r -G
# -r stampa username id, group primario e secondario REALI
```

`sudo` crea un processo figlio, copia un **ambiente minimale**, sostituisce a se il processo con `execve` e gli passa l'ambiente.
Lo vedi con:
```bash
env
# vs
sudo -u francesco env
```

Posso scegliere anche il gruppo primario con `-g`:
```bash
sudo -u docente -g root id
```
Carica comunque come gruppo secondario il gruppo primario dell'utente passato con `-u`

Per accedere a file come */dev/sata* mi basta inserirmi in **disk** con `sudo`:
```bash
sudo -u francesco -g disk cat /dev/sda1
```

## Gestione delle credenziali
`sudo` può chiedere la password ogni volta, oppure dopo N minuti di inattività.

Questo N (in minuti) si configura con la direttiva: `Defaults timestamp_timeout=5`
Il valore ottimale è 0, ovvero password ad ogni comando -> un attaccante può installare un meccanismo di persistenza in *.bashrc* che comunica con un server C2 (command and control o casa madre).

Il livello di sicurezza più basso è: `Defualts !authenticate`

Vedi: `Tag_Spec` con `man 5 sudoers` per personalizzare l'esperienza a livello di singolo comando.

```bash
sudo ALL=(ALL:ALL) NOPASSWD:ALL  # NOPASSWD è l'etichetta, ALL il comando
```

Esempio: `slabtop` e `cat /dev/mem` senza password
```bash
ALL ALL=(ALL) NOPASSWD:/usr/bin/slabtop,/usr/bin/cat /dev/mem
```

Questa riga si interpreta come segue:
- users allowed
- host
- target user di sudo
- comandi permessi

Con `/dev/mem` posso accedere alla memoria del processo corrente. Dopo 1Gb di dump ritorna *Operation not permitted* perchè ubuntu limita l'estrazione della RAM ad 1Gb con `STRICT_DEVMEM=y"

