# Forking
I processi in UNIX si creano per clonazione (**forking**).
Il processo clonante è il padre; il processo clonato è il figlio.

Quando creo un fork, le aree di memoria del figlio sono uguali a quelle del padre, ma private. Il Kernel concretizza questo con il copy-on-write. Padre e figlio non condividono le aree di memoria, ma sono isolate tra loro.

I due processi condividono gli stessi file descriptor aperti.

In C quando si forka un processo, si riparte dall'istruzione immediatamente successiva. `fork()` nel processo padre ritorna 0, mentre nei figli un PID > 0.

# Exec
Con la procedura di fork viene creato un processo figlio che esegue lo stesso codice del padre. Questo da solo non basta, serve un **meccanismo di sostiuzione** che carichi dinamicamente il contenuto di un file eseguibile in memoria al posto del codice corrente.

Su UNIX si usa `exec()` -> anche in questo caso si usa un lazy loading. Il codice viene caricato per areee di memoria di 4Kb.

Vedi: **Michael Larabel** autore scheduler Linux

# Albero dei processi
Quando il kernel non ha nulla da schedulare, entra nello stato di risparmio energetico, in cui si riposa forzatamente -> C-state

Il processo con PID=0 è *swapper*, che entra in gioco quando la CPU non ha nulla da fare.
Il processo con PID=1 è `systemd` o `init`, in base al SO in cui ci troviamo.

Il processore gestisce le periferiche attendendo delle interruzioni (interrupt). Se la periferica lo consente, mette in memoria il dato direttamente con il DMA - Directo Memory Access.
Quando la CPU va in stato di riposo, attende solo interrupt.

A livello 2 dell'albero si trovano:
- i processi `getty` impostano i terminali testuali di login, accessibili con Alt-FnX.
- da `getty` parte `login` e, se ci autentichiamo, `bash`
- `gdm` per autenticazione grafica

Chi crea `init`? all'avvio il BIOS esegue il POST - Power On Self Test - (si possono trovare le prime tracce nei computer IBM-compatibili): viene cercata tastiera, inizializzazione scheda video (mode-line), check ram faulty.

Successivamente si salta ad una partizione marchiata come **bootable**, con **bootloader** presente. Altrimenti il BIOS invia una richiesta broadcast in rete di bootloader -> sistemi **diskless**, in cui il kernel viene ottenuto dalla rete.

> **Bootstrapping**: il disco è suddiviso in settori da 512 bytes. 2 stadi:
> 1. nei primi 446 byte del disco bootable si trova del codice assembly, caricato dal bios, utile a caricare l'effettivo bootloader (come GRUB), che ovviamente non starebbe in 512b
> 2. si carica ed esegue il primo blocco della partizione */*

Il bootloader può caricare diversi kernel. Usa la partizione `boot` di ogni disco.
GRUB può avviare si Linux che Win:
- Linux semplice: si carica ed esegue il file `vmlinuz_version` dove `z` sta per compresso. Kernel compattato -> caricato in memoria -> scompattato -> esecuzione di `start_kernel()`. Questa funzione inizializza le periferiche e strutture dati usate dal Kernel. Cosa fa `start_kernel()`? *
- Win: complicato. Misura protettiva. Windows deve essere avviato in un solo stadio. Non vorrebbe essere installato a fianco di altri SO. Swap della partizione in cui partirebbe UNIX con swap partizione in cui partirebbe Windows (**chain laoding** = caricamento a catena). Metodo fittizio per fingere che Win sia avviato dal MBR - Master Boot Record - di Win. Il problema sta nel fatto che Win non vorrebbe essere bootato da GRUB, ma dal suo bootloader.o dei campi contenuti nel descrittore di processo è l'identificatore di processo (Process IDentifier, PID).Uno dei campi contenuti nel descrittore di thread è l'identificatore di thread (Thread IDentifier, TID

\* Il kernel ha bisogno di avere tutti i driver delle periferiche collegate: *device drivers*. Se il blob di kernel+driver venisse compilato tutto assieme, peserebbe sui 60Mb. Problema: efficienza, le istruzioni più usate non stanno in una linea di cache.
Soluzione: `ramdisk` -> fs piccolo che contiene qualche script di boot e tutti i driver necessari per un avvio minimale. Tutti questo viene impacchettato in `initrd_version` dove version coincide con kernel version. La ramdisk viene caricata in memoria, spacchettata, GRUB esegue gli script di ramdisk, viene montato il fs di ramdisk, che contiene tutti i moduli necessari (device driver), caricati e scaricati alla bisogna. Questo serve a inizializzare le periferiche. Ora che posso accedere al disk, monto la partizione di root, eseguo `/sbin/init` a partire dal processo del kernel con `execve()`. A questo punto ho due entità in esecuzione:
- `init` -> l'unico compito è quello di espandere l'albero dei processi (boot tree).
- `kernel`

# Distruzione
I processi diventano **orfani** quando il padre muore, ma i figlio devono rimanere in vita. Non possono rimanere pending e irraggiungibili nell'albero dei processi. Il kernel esegue il **reparenting** -> il padre diventa **init**
Init viene chiamato anche **child reaper** per questa sua caratteristica.