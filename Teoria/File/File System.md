La terminologia dei filesystem deriva dai termini relativi all'archiviazione concreta:
- file = fasciolo
- cartella = directory
# Introduzione ai fs dei S.O. moderni
La rappresentazione del fs è un albero, oppure un grafo orientato.
Le cartelle fondamentali sono:
- /bin comandi testuali non di amministrazione
- /sbin comandi testuali di amministrazione (in SO Linux standard)
- /boot configurazioni avvio e bootloader
- /dev contiene file dispositivo speciali (device special file). Il fs gestisce in modo trasparente il mapping tra file e periferiche. Ogni file in questa directory rappresenta un punto di accesso (in scrittura o lettura) verso le periferiche.
```bash
ls -l /dev
```
La prima differenza visibile tra un file normale e uno speciale è la prima lettera. Nei file normali è un trattino. Nei file speciali può essere una **c** o una **d**:
- **c** -> periferica a caratteri: lento, pochi dati alla volta. Come la tastiera.
- **b** -> periferica a blocchi: veloce, in cui si accede per blocchi e, volendo, anche in maniera casuale. Come il disco.

Ogni file speciale ha associati 2 numeri, detti Major number e Minor number, che insieme creano una chiave primaria (quindi univoca):
- **Major number** -> tipo di dispositivo
- **Minor number** -> identificatore dispositivo

Anche i terminali (dispositivi *tty* - teletype) sono listati in `/dev`. Vengono numerati da 0 a N.

- /etc directory che contiene configurazioni di sistema valide per tutti gli utenti. Le configurazioni sono in formato testaule e human-readable
- /home contiene gli spazi di lavoro degli utenti normali: /home/user1, /home/user2, etc.
- /lib contiene le librerie di sistema (sia dinamiche - .so - che statiche - .a -)
- /mnt è usata per contenere i filesystem esterni (associati a periferiche esterne). È obsoleta, ora si usa /media
- /opt contiene software binario non free. Spesso è organizzata come
	- /opt/software/bin
	- /opt/software/share
	- etc.
- /proc contiene le statistiche sulle riestorse hw-sw. Viene montato su questa directory un fs speciale, in cui ogni file è mappato ad una funzione. Chiamando queste funzioni (leggendo/scrivendo i file) il kernel genera al volo una risposta che soddisfi la richiesta.
- /sys è una versione moderna di /proc/sys. Meglio organizzata. Più human-readable.
- /root directory utente amministratore.
- /run anche questo fs non è materializzato su disco, ma è contenuto in RAM. Contiene file volatili associati all'esecuzione di un servizio. Non sarebbe conveniente scrivere su disco ogni volta che un'applicazione fa un accesso a questi file volatili.

Ad esempio, avviando Apache2, voglio sapere qual'è il suo PID (capire se è attivo, terminarlo nel caso in cui lo sia, ecc.). Il file contenente il PID dell'applicazione è contenuto in `/run/http/httpd.pin`

- /tmp è un fs che un tempo veninva montato su disco, mentre ora viene montato in RAM. È la versione legacy di /run. Contiene file temporanei usati dalle applicazioni. Non è garantita la sopravvivenza ad un reboot. Si tiene per retrocompatibilità. *Zona franca di memoria*.
- /usr contiene un fs completo (bin, sbin, lib, etc.)  destinato al software non vitale per il funzionamento della macchina, come ad esempio applicazioni con gui, ecc.
	- /usr/bin nelle distro moderne tutti i binari sono contenuti in /usr/bin
	- /usr/local conteine un fs completo destinato al sw non necessario all'avvio della macchina, ovvero tutto quel software che estende le funzionalità di un sistema UNIX.
- /var contiene file il cui contenuto crescerà nel tempo, come ad esempio i file di log delle applicazioni.

## Esercizio
Trovare i file che descrivono dispositivi SATA:
```bash
apropos -s 4 disk
```

Trovo 2 file speciali che rappresentano un disco:
- sd -> SCSI
- hd -> MFM/IDE

Dal comando `man 4 sd` evinco che la lettera dopo `sd` è il disco, mentre il numero successivo la partizione.

Vedi: controller IDE, EIDE, MBR
