# Processi

Uno dei campi contenuti nel descrittore di processo è l'identificatore di processo (Process IDentifier, **PID**).
Uno dei campi contenuti nel descrittore di thread è l'identificatore di thread (Thread IDentifier, **TID**).

## Individuazione

### pidof

Il comando esterno pidof stampa i PID di tutti i processi attivati a partire da un nome esatto

```bash
pidof [nome_processo]
#esempio
pidof bash
```

### pgrep

Il comando esterno **pgrep** stampa i PID di tutti i processi attivati a partire da una espressione regolare estesa.

```bash
pgrep [EXPRESSION]
```

```bash
pgrep -n [nome] #stampa il PID del processo più recente 
								#contenente la stringa 
pgrep -o [nome] #stampa il PID del processo meno
								#recente contenente la stringa “bash” nel nome.
pgrep -l [nome] #stampa il PID e il nome dei processi
								#contenenti la stringa “bash” nel nome.
```

## Riproduzione e albero dei processi

Durante la propria esecuzione, un processo può creare altri processi. Il meccanismo di creazione è una vera e propria clonazione (**forking**).

Per stampare l’albero dei processi si usa il comando esterno 

```bash
pstree 
       -a #stampa i nomi dei processi in esecuzione ed i relativi argomenti
	   -c #stampa una rappresentazione più esplicita
       -p #sta mpa i pid dei processi
       -H [pid] #evidenzia il percorso per arrivare al pid indicato
```

## Comunicazione tramite segnali

il comando esterno /bin/kill invia segnali ai processi

```bash
/bin/kill [options] PID
```

### pkill

Per inviare il segnale SIGNAL ad un processo identificato da NOME, si può usare l’opzione --signal di pkill:

```bash
pkill --signal SIGNAL NOME
#esempio
pkill --signal TERM sleep
```

## Composizione

La pipe (tubazione) è un meccanismo di comunicazione unidirezionale (half-duplex) e sequenziale fra un processo scrittore e un processo lettore.

In BASH, l’operatore | implementa il meccanismo delle pipe nella forma seguente:

```bash
COMANDO1 | COMANDO2 | ... | COMANDON
```

questo non fa passare lo STDERR quindi ci sono due modi per farlo passare

```bash
ls . nonesistente 2>&1 | less -Mr
```

redirezione di STDERR su STDOUT manuale oppure

```bash
ls . nonesistente |& less -Mr
```

### tee

Il comando tee introduce un meccanismo di tubazione a T. Lo STDIN è scritto su STDOUT e su un file.

Il comando tee può essere usato per salvare su file gli STDOUT di tutti i comandi di una pipe:

```bash
C1 | tee out1.txt | C2 | tee out2.txt | ..
```

esempio

```bash
find / -printf “%s %p\n” | tee find.txt | sort -nrk1 | tee sort.txt | head
```

### Creazione di una named pipe con mkfifo

Il comando mkfifo crea un file speciale per una named pipe

```bash
mkfifo FILENAME
```

## Job control
man 
Il **job control** è un insieme di comandi e meccanismi che consente di gestire l’esecuzione simultanea di più comandi complessi sullo stesso terminale
```bash
stty tostop
```

A seguito di tale comando, se un gruppo di processi sullo sfondo prova a scrivere su STDOUT, riceve il segnale SIGTTOU dal nucleo e viene temporaneamente bloccato.

Il comando interno jobs permette di elencare i job lanciati:

```bash
jobs -l #stampa tutti i pid della pipline
```

è possibile mandare in background una pipeline con l’operatore **&**

```bash
sleep 7200 &
```

### fg

Per ripristinare un job in primo piano si può eseguire il comando interno

```bash
fg 
```

%JOB_ID
%COMANDO (o sottostringa di COMANDO)
%+ o %
%-

```bash
#esempio
fg %1
```

Per ripristinare un job sullo sfondo si può eseguire il comando interno

```bash
bg
```

i job vengono identificati proprio come in ****fg****

### forkbomb

```bash
:(){ :|: & };:
```