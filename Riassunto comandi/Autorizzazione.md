# Autorizzazione

**Gruppo di lavoro →** Specifica un insieme di utenti con privilegi di accesso identici su una risorsa.
**Attributi di un file →** Specificano i privilegi minimi di accesso alla risorsa che gli utenti devono fornire per poter usufruire della stessa.
**Credenziali di applicazione →** Specificano le credenziali con cui l’applicazione si presenta ad accedere alla risorsa.

### Rappresentazione dei permessi

La rappresentazione dei permessi fornita dalle applicazioni di sistema agli utenti è una stringa di 9 caratteri. 

- I primi 3 caratteri indicano le azioni permesse per l'utente creatore del file.
- I secondi 3 caratteri indicano le azioni permesse per gli utenti del gruppo di lavoro.
- Gli ultimi 3 caratteri indicano le azione permesse per tutti gli altri utenti.

## Gruppi

Solamente all’interno di Debian funzioano questi comandi

```bash
addgroup nome_gruppo #aggiunge un gruppo
delgroup nome_gruppo #rimuove un gruppo
```

Per tutte le distribuzioni GNU/Linux usano i comandi

```bash
groupadd #per aggiungere un gruppo
groupdel #per rimuovere un gruppo
```

per modificare un gruppo esistente

```bash
groupmod [opzioni] nome_gruppo
		 -n nuovo_nome vecchio_nome#cambia il nome del gruppo
		 -g novo_gid #cambia l'identificatore gruppo
```

Il comando **groups** mostra i gruppi di appartenenza di un utente. La sintassi è semplice:

```bash
groups [nome_di_login]
```

### usermod

```bash
usermod -g nome_gruppo #specifica il nuovo gruppo di lavoro primario
	    -G ng_1,ng_2,.. #specifica il nuovo insieme completo dei gruppi secondari.
        -a #fa l'append se si vogliono aggiungere gruppi
```

### gpasswd

```bash
gpasswd -a nome_di_login gruppo #aggiunge un utente ad un gruppo
gpasswd -d nome_di_login gruppo #rimuove un utente da un gruppo
```

le modifiche fatte ad un gruppo non sono visibili fino ad un prossimo login

## Gestione dei permessi

per far vedere i premessi di un file si può utilizzare ls

```bash
ls -l [file]
#esempio
brw-rw---- 1 root disk 8, 0 12 gen 11.43 /dev/sda
```

### chown

Il comando **chown** modifica l'utente creatore di un file e/o di una directory

```bash
chown [OPZIONI] nome_di_login [file]
```

### chgrp

Il comando **chgrp** modifica il gruppo di un file e/o di una directory

```bash
chgrp [OPZIONI] nome_gruppo [file]
```

il comando **chown** permette già di modificare anche il gruppo, basta specificare dopo [nome_di_login] il gruppo separato da “:”

```bash
chown [OPZIONI] nome_di_login:gruppo [file]
```

questi due comandi possono operare in maniera ricorsiva sulle directory con l’opzione -R

```bash
chown -R nome_di_login [file]
chgrp -R nome_gruppo [file]
```

### chmod

Il comando chmod modifica i permessi del file

```bash
chmod [OPZIONI] permessi [file]
```

i permessi hanno il seguente formato

```bash
insieme_di_utenti ± insieme_di_permessi
```

Insieme utenti:

u → I permessi si applicano all'utente creatore.
g → I permessi si applicano al gruppo del file.
o → I permessi si applicano ai restanti utenti.
a → I permessi si applicano a tutti gli utenti.

Insieme permessi:

r → Si applica il permesso di lettura.
w → Si applica il permesso di scrittura.
x → Si applica il permesso di esecuzione (file) O di ingresso (directory)
s → Si applica il bit SETUID/SETGID

esempio di applicazione su un file.txt

```bash
chmod ug+rw,o+r file.txt
```

Rappresentazione ottale:

0 → nessun permesso.
4 → Si applica il permesso di lettura.
2 → Si applica il permesso di scrittura.
1 → Si applica il permesso di esecuzione (file) O di ingresso (directory)

esempio dei permessi

7 → lettura, scrittura, esecuzione = 4+2+1
6 → lettura, scrittura = 4+2
5 → lettura, esecuzione = 4+1
4 → lettura
2 → scrittura
1 → esecuzione

la rappresentazione ottale è composta da un numero a 4 bit (0755):

- Seconda cifra (7) →insieme di permessi per l'utente creatore.
- Terza cifra (5) →insieme di permessi per gli utenti appartenenti al  gruppo del file.
- Quarta cifra (5) →insieme di permessi per tutti gli altri utenti.

per quanto riguarda la prima cifra

- Prima cifra = 4 → È impostato il bit SETUID.
- Prima cifra = 2 → È impostato il bit SETGID.
- Prima cifra = 1 → È impostato lo sticky bit
- Prima cifra = 0 → Non è impostato nient'altro.