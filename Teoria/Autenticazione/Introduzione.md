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