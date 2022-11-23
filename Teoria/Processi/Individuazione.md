**Lennart Poettering** è l'autore di `systemd`.

Nei blocchi di controllo di processi e thread contengono rispettivamente PID e TID.

# pidof
```bash
pidof bash  # nome preciso del processo
```

# pgrep
Utile quando non ci si ricorda il nome del comando completo che è stato lanciato. `pidof` non può fare il matching con wildcard, `pgrep` invece sì.

```bash
pgrep '^ba.*$' # trovo bash se non me lo ricordavo 
```

| Opzione     | Descrizione                                              |
| ----------- | -------------------------------------------------------- |
| -n          | newest process that matches                              |
| -o          | oldest process that matches                              |
| -l          | sia pid che nome processi                                |
| -U username | lista tutti i processi con realuid pari a username       |
| -u username | lista tutti i processi con effective uid pari a username |


Elenco tutti i processi di GNOME:
```bash
pgrep -al '^bash.*^*'
```
