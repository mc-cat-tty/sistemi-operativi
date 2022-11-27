# Streaming server dei poveri
Useremo i pacchetti:
- `wget`
- `mpv` multimedia player
- `mkfifo`

1. Creazione di una UNIX FIFO (named pipe) da usare come buffer per la comunicazione tra processi: `mkfifo buffer` nella cartella corrente
2. `wget -q -O buffer http://risorsa` scrivo sul buffer in maniera bloccante. Finchè il buffer non viene pulito dal lettore 
3. Consumiamo i byte scritti nel buffer con `mpv`: `mpv buffer`

`wget` scrive sul buffer 64Kb alla volta, `mpv` li consuma man mano.
Se proviamo a chiudere la `wget`, `mpv` termina appena prova a leggere da una pipe su cui nessuno sta scrivendo, dato che il kernel invia un SIGPIPE. Quello che succede in realtà è che la riproduzione continua perchè `mpv` ha fatto buffering.

## Tracing di wget
Usiamo `strace` per tracciare tutte le chiamate di sistema di un processo. Ovviamente dobbiamo essere root per farlo.

```bash
strace -Ttttf -p PID
```

- `ttt` serve per stampare i timestamp delle syscalls
- `f` segue i fork (just in case) per non perdersi figli che potrebbero fare lavoro importante

`openat()` nuova funzione che sostituisce `open()` e accetta in ingresso descrittori di file.

Notiamo che `wget` è bloccato all'apertura del buffer finchè la pipe non viene aperta il lettura. È inutile scrivere sul buffer ne nessuno sta leggendo.

Esercizio (sort 30 file più grandi di root):
```bash

```