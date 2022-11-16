*DefCon* -> Defense Condition

## Autenticazione
I SO moderni forniscono astrazioni per l'autenticazione (login), che può essere scomposta in:
- identificazione: capire quale utente è
- verifica delle credenziali: verifica che l''utente sia davvero chi dice di essere

Il login può essere fatto da automi o esseri umani che usano la macchina

### Fattori di autenticazione
Sono i singoli pezzi di informazione che l'utente fornisce per fornire la propria identità, vengono chiamati **fattori di autenticazione**. Possono essere informazioni segrete che l'utente solo conosce, firma olografica, dati genetici, badge (fisici), ecc.

Esistono altri fattori di autenticazione oltre alla password, che rimane sicura solo se inviata su un canale separato non accessibile dall'attaccante. In questo corso si considera quindi un canale sicuro:
- chiave pubblica GPG
- codice OTP - One Time Password
- fingerprint
- ecc.

Un singolo fattore di autenticazione è troppo debole: **two factor authentication**. In cui il secondo fattore è inviato su un canale diverso.

> Tradeoff del software engineering: funzionalità, prestazioni, sicurezza. Possono convivere solo due di queste proprietà insieme.

## User
In concetto di **user** (utente) è l'astrazione del SO per identificare gli utilizzatori del sistema.

Ad ogni utente vengono associate le seguenti informazioni:
- *user id* (identificatore utente): interno non negativo univoco per ogni utente, usato dal codice del SO per distinguere gli utenti
- *username* (nome di login): stringa alfanumerica di lunghezza non nulla comoda agli umani per identificare l'utente
- *password*: sequenza alfanumerica per autenticare l'utente
- *shell di login*
- *home directory*

### Classificazione
Gli utenti umani hanno uno user id nell'intervallo \[1000, (2^64)-1\]
A questi utenti non sono consentite interazioni di basso livello con Linux

Nei sistemi UNIX l'utente **amministratore** (**superutente**) ha *id=0* e nome *root*. Questo utente può comandare a basso livello hw/sw.

Gli **utenti di sistema** rappresentano dei servizi, non sono umani, hanno un id tra \[1, 1000\].
Non hanno shell e home directory.
Esempi sono: *www* e *mysql*.

## /etc/passwd
È un database testuale che contiene diversi record separati da (":"):
- nome utente
- password cifrata (ora non più, sostituita da *x* per evitare attacchi a forza bruta, vedi sotto)
- gruppo di lavoro
- ...
- home dir
- shell di lavoro

Per riassumere si trovano i metadati sugli utenti.

## /etc/shadow
Database testuale che contiene i metadati delle password degli utenti.
Visibile sono da *root* e da chi appartiene al gruppo *shadow*.

Metadati password:
- nome di login
- password cifrata
- data ultimo cambio password
- età min e max della password
- periodo avviso
- periodo inattività
- data scadenza account
## Aggiunta utenti
Le distribuzioni basate su Debian forniscono il comando `adduser`, che interattivamente richiede una serie di informazioni per la creazione di un utente.

La directory creata come home per il nuovo utente, contiene:
- .bashrc -> avviato all'apertura di una shell non di login
- .bash_logout -> script per la pulizia della shell principale (livello 1) alla terminazione della sessione
- .profile -> eseguito sulle login shell

Questi file vengono copiati da */etc/skel* alla creazione

La variabile d'ambiente $SHLVL mantiene il *livello di shell*

In /etc/passwd vediamo:
*nome:xpass:id:user:...:home:shell*

## Rimozione utenti
```bash
deluser username
```

Comando non interattivo, a differenza di `adduser`. Linux è un sistema scopribile: nomi significativi ed intuibili.

La rimozione non è completa, perchè rimane la home directory dell'utente appena cancellato. Soluzione:
```bash
deluser username
```

-----
### Cancellazione di un file in modo sicuro
```bash
shred filename  # sovrascrittura con byte casuali da /dev/random
```

Oppure forare l'hdd facendo 

Vedi: **wear leveling**

----

# Gestione utenti

`adduser` e `deluser` sono script bash/perl messi a disposizione dalla comunity ubuntu/debian per ragioni di comodità.

## useradd
Sugli altri SO sono presenti `useradd` e `userdel`. Di default l'utente creato non ha password, nè home directory.  La shell di default è /bin/sh

```bash
useradd -m studente
```

## userdel
Se elimino un utente, la stringa associata allo UID viene eliminata, quindi nel mode (stampato per esempio da ls) non viene inserito lo username.

```bash
userdel -r studente
```

Gli spool di posta sono un retaggio dei primi sistemi UNIX.

**Gruppo di lavoro** = gruppo di utenti che condividono i permessi di accesso ad una risorsa

### Configurazioni ulteriori
```bash
adduser --ingroup video studente
# Oppure
useradd -G video studente
```

## Modfica utenti esistenti
### usermod
Con questo comando posso cambiare i metadati relativi ad un utente.

| Opzione     | Descrizione                                               |
| ----------- | --------------------------------------------------------- |
| -d HOME     | Cambia logicamente il nome della directory                |
| -m          | Move home nella nuova directory                           |
| -u UID      | Aggiorna lo user id dell'utente                           |
| -l USERNAME | Aggiorna il loginname                                     |
| -L          | Lock dell'account. Non può più essere effettuato il login |
| -U          | Unlock dell'account                                       |

### Finger
Il comando finger su un utente ritorna tutte le informazioni utili su di esso. Finger è un servizio esposto sulla porta 79 TCP e serviva per ottenere informazioni sui colleghi.

Altri comandi utili:
- `chfn` cambia il fullname, roomnumber, ecc.
- `passwd` cambia la password
- `chsh` cambia la shell dell'utente
- `groupdel` rimozione gruppo

`rbash` -> restricted bash per motivi di sicurezza

Nota: loggandomi come *studente* sono riuscito a modificare la password dell'utente stesso, senza essere *root*, nonostante il file */etc/shadow* sia scrivibile solo da root

