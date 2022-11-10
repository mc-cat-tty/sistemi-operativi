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

