La **pipe**, letteralmente **tubazione** è un meccanismo offerto dai sistemi UNIX che permette di combinare insieme più comandi semplici per formare uno complesso.
La pipe è unidirezionale e sequenziale (**FIFO**). Permette di far comunicare un processo scrittore e uno lettore.
(P1) write -> pipe -> (P2) read

La pipe è implementata dal kernel come un buffer, quindi potrebbe riempirsi. In caso di pipe vuota (quando P1 non ha scritto niente sullo stream) o pipe piena la lettura o la scrittura (rispettivamente) si **bloccano**.

La dimensione standard di un pipe buffer è di **64Kb**, a partire da Linux 2.6.11; ovvero la dimensione di 16 pagine da 4Kb l'una. Le scritture con dimensione maggiore di 4Kb sono suddivise in più scritture da massimo 4Kb.

Quando P1 o P2 chiudono STDOUT o STDIN (rispettivamente), la pipe si rompe. Fino a questo momento non succcede nulla. Ma appena il processo che non ha chiuso il fd prova a scriverci sopra, riceve un SIGPIPE.

## Pipe in Bash
In Bash il meccanismo della pipe è implementato dall'operatore `|`:
```bash
CMD1 | CMD2 | CMD3 | ... | CMDn
```

Quella riportata di sopra è di fatto una concatenazione di fd dove OUT(n) -> IN(n+1)

### Stderr piping
Questo operatore lascia passare solo  STDOUT ma non STDERR:
```bash
ls . nonesiste | less  # Non mostra gli errori
```

L'operatore `|&` inoltra contenuto dei canali di STDOUT e STDERR. È un sinonimo di:
```bash
P1 2>&1 | P2
```

## Tubazione a T
Il comando `tee` implementa una tubazione a T:
```bash
P1 | tee | P2
```
`
`tee` inoltra il contenuto di STOUT/STDERR come una pipe e in più mostra a schermo  lo STDOUT di P1

Si usa per salvare su file risultati intermedi di una pipeline:
```bash
P1 | tee out1.txt | P2 | tee2.txt | P3
```

# Named pipe
La **named pipe** o **FIFO** è simile ad una pipe, ma stdin e stdout di due processi leggono e scrivono da un file speciale esposto dal fs. Questo file ha lunghezza zero.
È riconoscibile nell'output di `ls` perchè il file è marcato con la lettera `p`.

## Creazione di named pipe
```bash
mkfifo FILENAME
```

## Streaming server dei poveri
Useremo i pacchetti:
- `wget`
- `mpv` multimedia player
- `mkfifo`

1. Creazione di una UNIX FIFO (named pipe) da usare come buffer per la comunicazione tra processi: `mkfifo buffer` nella cartella corrente
2. `wget -q -O buffer http://risorsa` scrivo sul buffer in maniera bloccante. Finchè il buffer non viene pulito dal lettore 
3. Consumiamo i byte scritti nel buffer con `mpv`: `mpv buffer`

`wget` scrive sul buffer 64Kb alla volta, `mpv` li consuma man mano.
Se proviamo a chiudere la `wget`, `mpv` termina appena prova a leggere da una pipe su cui nessuno sta scrivendo, dato che il kernel invia un SIGPIPE. Quello che succede in realtà è che la riproduzione continua perchè `mpv` ha fatto buffering.

### Tracing di wget
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
si
```