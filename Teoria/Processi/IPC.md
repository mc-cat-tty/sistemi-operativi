Comunicazione interprocesso.
Due processi possono comunicare con il meccanismo dei **segnali**, attraverso il kernel. In inglese la generazione dei segnali è tradotta con il verbo **rise**.
Il processo ricevente usa un **signal handler** per gestirlo.

## Cause generazione dei sengali
Un segnale può essere inviato in maniera **asincrona**, perchè scatenato da un'interazione dell'utente:
- Ctrl-c invia SIGINT
- Ctrl-z invia SIGTSTP

Altri eventi sono sincroni a condizioni anomale dalla macchina:
- CPU esegue una divisione per zero
- SEGFAULT

## Rappresentazione
Ogni segnale è associato ad un numero intero, a partire da 1, e ha un nome: *SIGNOME* dove NOME è un nome breve.

Per info guarda:
```bash
man 7 signal
```

## Gestione
Il processo destinatario reagisce con un signal handler. Se l'evento viene gestito viene detto **caught** (passato di catch).

Il sistema operativo fornisce dei gestori standard di segnali, ma il programmatore può decidere di associare ad un evento un signal handler arbitrario (funzione arbitraria).

- IGNORE: il SO non consegna al processo ricevente alcun segnale ignorato
- TERMINATE: il processo viene terminato. Terminazione anomala, opposta alla terminazione normale che avviene con `exit()`
- STOPPED: con questa azione il processo viene sospeso alla ricezione del segnale
- CONTINUED: il processo viene ripristinato alla ricezione del sengale
- CORE DUMP: quando il segnale viene ricevuto, il processo scrive un'immagine della memoria (stato attuale della memoria del processo) su file. Questo core dump viene analizzato *post mortem* con un debugger (il *reverse debugger* permette di ricostruire gli ultimi attimi di vita).

Negli anni '60 e '70 la memoria RAM era basata su nuclei magnetici di ferrite (**magnetic core memory**).

Dalla pagina di manuale si possono vedere le azioni standard associate ai vari segnali:
- SIGTERM: uscita anomala con possibilità di cleanup (viene eseguito l'handler per fare pulizia, che fa checkpointing*, chiude i file, ecc.). L'azione di default è TERMINATE
- SIGKILL: uscita anomala non gestibile. Non è possibile associare un handler. L'azione di default è TERMINATE.
- SIGINT: interruzione definitiva gestibile con handler. Default TERMINATE.
- SIGCHLD: un processo figlio ha cambiato stato. Non gestibile con handler. Default: IGNORE
- SIGQUIT: terminazioen con core dump. Solitamente associato a Ctrl-\\. Esaminabile con `coredumpctl`

Checkpointing e resuming: salvataggio in memoria dello stato attuale dell'applicazione.
Pickling: serializzazione e deserializzazione
Vedi: serializzazione autenticata con HMAC

Esempio: Ctrl-S (suspend output) e Ctrl-Q (continue) -> un tempo veniva inviato sulla linea seriale, per sosprendere output di un processo remoto.

XOFF -> bit di spegnimento temporaneo per un processo connesso in seriale
XON -> ripristina le funzioni del terminale

Vedi:
```bash
gdb /bin/top -c core
```

# kill
Kill è un'altro programma che può essere usato per inviare i sengali (oltre alle shortcut).
Dovrebbe chiamarsi *sendsignal*.
```bash
/bin/kill [options] PID
```

Le opzioni sono solitamente: `-signalnum` o `-SIGNAME`

Per aggirare questa limitazione si può usare `pkill`:
```bash
/usr/bin/pkill PNAME
```

`/bin/kill` è un comando esterno. Attento perchè esiste anche una chiamata di sistema.

Lista segnali:
```bash
/bin/kill [-l|-L]  # in base al tipo di lista che voglio
```

`pkill` si comporta come `pgrep` rispetto a `pidof`. Infatti sono lo stesso comando:
```bash
ls -l /usr/bin/p{kill,grep}
```

Vediamo che `pkill -> pgrep`

Sono infatti lo stesso programma (unico binario) che si comporta diversamente in base al nome con cui viene invocato. Il binario unico rappresenta o una categoria di applicazioni oppure contiene più versioni della stessa applicazione, per garantirne la retrocompatibilità (bash e shell ad esempio)

Con l'opzione `-n` invia il segnale solo al processo più nuovo.
Bash per motivi di sicurezza ignora i segnali dei processi figli.

