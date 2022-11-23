Douglas McIlroy -> invertore del meccanismo di pipe e dell'idea di composizione dei programmi UNIX. Ha scritto la maggior parte delle utility di elaborazione dei testi.

Come fa il sistema operativo a trasformare un eseguibile scritto sul disco in un processo in avvio.

Conteggio processori presenti sulla macchina:
```bash
lscpu | less -Mr
cat /proc/cpuinfo
```

## Programmi e processi
>**processo**: astrazione di un programma in esecuzione. Il kernel, attraverso una serie di strutture dati (PCB - Processo Control Block) tiene traccia dello stato del processo.

**Programma eseguibile**: file memorizzato su un supporto secondario. Contiene codice macchina, tabella dei simboli, ecc.
**Processo**: programma eseguibile in esecuzione.

Anche la CPU viene astratta.
Poche CPU, tanti processi -> time sharing, con un timer sul limite superiore all'applicazione (sui 20ms)

I processi muoiono di fame: **starvation**. Quando a un processo non viene dato tempo macchina a sufficienza.

**Esecuzione interlacciata** -> la CPU ad ogni istante sta eseguendo qualcosa. Voglio una pipeline sempre piena, dando una priorità più alta ai processi interattivi.

>Il **descrittore di processo** viene mantenuto in memoria dal kernel. Viene creato un PCB ad ogni nuovo processo.

Il SO legge e aggiorna i PCB tramite funzioni interne. Svolge le seguenti funzioni:
- context switching
- rimozione di un processo dalla CPU
- scelta del prossimo processo
- aggiornamento contatori uso risorse

## Isolamento
I processi sono isolati fra loro. Ogni processo ha un proprio **spazio degli indirizzi**.
Si può decidere di condividere l'area di memoria di un processo con gli altri.

### Vantaggi
Sicurezza: lo stato di un processo non può alterare lo stato di un altro processo

### Svantaggi
Ridondanza: più istanze di uno stesso programma vengono duplicate in memoria per garantirne l'isolamento

Il kernel adotta delle tecniche di ottimizzazione per evitare la ridondanza dei processi (minore consumo di RAM) -> **condivisione della memoria** in sola lettura

**Allocazione della memoria postiticipata**: quando alloco la memoria, il kernel prenota la memoria, ma non la alloca fisicamente finchè non inizio ad usarla.

**Lazy loading**: carico il programma man mano che mi serve il codice per eseguirlo.

## Thread
Problema: voglio parallelizzare il codice, condividendo le risorse del processo.
Un processo fa partire più thread (entità di calcolo) che vengono parallelizzate.

Sia il thread che i processi sono **task** (terminologia Intel), la differenza sta nella condivisione della memoria e dell'IPC.

Vantaggi dei thread: prestazioni -> accesso alla memoria condivisa. A differenza della IPC, non devo usare costosissimi (in termini di tempo) meccanismi di messaggistica.
Svantaggi:
- il calcolo non è deterministico, dipende da come i thread sono schedulati dal SO
- devo usare dei meccanismi di sync per accedere alle risorse in modo consistente: semafori (verde vai, rosso fermo). Questo rellenta il sistema, perchè i thread, che potrebbero eseguire in parallelo, devono attendere il rilascio della risorsa.

Vedi: locking e unlocking

TCB - Thread Control Block
PCB - Process Control Blocko dei campi contenuti nel descrittore di processo è l'identificatore di processo (Process IDentifier, PID).Uno dei campi contenuti nel descrittore di thread è l'identificatore di thread (Thread IDentifier, TID