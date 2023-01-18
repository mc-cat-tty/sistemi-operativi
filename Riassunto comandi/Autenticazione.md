# Autenticazione

## Gestione degli utenti

Per creare un utente in Debian basta usare il comando

```bash
adduser nome_di_login
```

Per la rimozione di un utente in Debian

```bash
deluser nome_di_login
deluser --remove-home nome_di_login #rimuove anche la homedir
```

Per le altre distribuzioni LINUX si utilizzano i comandi

```bash
useradd [options] LOGIN #per creare un utente
userdel [options] LOGIN #per eliminare un utente
```

```bash
useradd -m prova #per creare anche una homedir
userdel -r prova #per rimuovere anche la homedir
```

### usermod

Il comando **usermod** permette di modificare le proprietà e le risorse di un utente esistente.

```bash
usermod [opzioni] nome_di_login
```

```bash
-l #cambia il nome di login
-u #cambia l'identificatore utente
-d #specifica la nuova home in /etc/passwd
-m #spostare il contenuto della vecchia directory nella nuova/c
```

```bash
usermod -L nome_di_login #blocca l'utente desiderato
usermod -U nome_di_login #sbloccare un utente
```

l’utente può cambiare alcune parametri senza per forza dover essere root

- **chfn**: cambia il nome dell'utente (se eseguito da utente root) e le altre informazioni.
- **passwd**: modifica la password.
- **chsh**: modifica l'interprete dei comandi.