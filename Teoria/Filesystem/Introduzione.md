Il disco non è altro che un contenitore di blocchi (settori circolari) da solitamente 512 bytes, presentati in modo contiguo al fs.
Il fs a sua volta definisce la dimensione di un blocco, per convenzione 4Kb. Questi blocchi sono rimappati trasparentemente in settori circolari o blocchi di diversa dimensione in base alla rappresentazione hw.

Il disco viene diviso in due aree:
- metadati -> rappresentazione del fs
- dati

L'area metadati contiene tutte le strutture di controllo, descrittive di file e directory, che puntano verso l'area dati.

Un disco nuovo non contiene tutto questo.
**Formattazione**: creazione delle strutture di controllo rappresentative del fs. Equivale all'atto di creare il grafo che lo rappresenterà.

Ogni partizione è gestita da un fs separato sul disco. Più partizioni non si intersecano.

Posso creare una partizione a cavallo di più dischi fisici:
Due soluzioni:
- RAID - Redoundant Array of Indipendent (Inexpensive) Disk
- LVM - Logic Volumes (volumi logici)

Contenuto fs:
- grandezza
- tabella blocchi in uso e blocchi liberi
- inode file e directory

## Partizionamento
Uno dei tool che permettono di scrivere la tabella delle partizioni è `fdisk`:
```bash
fdisk [opzioni] file_dispositivo
```

Senza opzioni lo si può utilizzare in maniera interattiva.
Il `file_dispositivo` si identifica con `ls /dev/`, ma ritorna molti file.

Cerco nella sezione 4 di manuale quali sono i file che rappresentano un disco:
```bash
apropos -s 4 -r '.*'
```

Trovo che:
- `hd` rappresenta dispositivi (MFM - Magnetic Force Microscopy) IDE
- `sd` per i dischi SCSI o SATA

In generale i dischi si rappresentano con `[tipo]d[id_disco]`. Dove L'id è un numero univoco associato al disco, a partire da 1.

Elenco dischi:
```bash
ls /dev/[hs]d*
```

Il FAT16 ha una dimensione file massima di 2Gb

## Tipo di partizioni
- partizione primaria: al massimo 4
- partiione estesa: partizione logica che può essere ulteriormente partizionata

Solitamente si fanno 3 partizioni primarie e 1 partizione estesa.

Creazione del fs (necessario per usare il disco): `mkfs.typefs file_speciale`

Elenco fs disponibili sul sistema: `ls -l /sbin/mkfs.*`

## Tipi di fs
- read-only: fs montato in sola lettura
- sync: scritture bloccanti eseguite una dietro l'altro
- async: scritture asincrone in blocchi
- exec: permette l'esecuzione dei programmi contenuti sul disco

> **Journaling**: proprietà di alcuni fs di mantenere un diario di bordo (**journal**), in cui sono registrate le operazioni di scrittura. Se il sistema crasha, le scritture non efettuate rimangono nel journal e sono applicate al boot successivo. Rendono di fatto le operazioni di scrittura e cancellazione su disco *atomiche*

> **Transaction log** (circular log): tiene traccia delle operazioni non committate verso una risorsa

Al boot della macchina viene agganciato a `/` il fs della partizione primaria. Poi vengono montati tutti gli altri fs. Il fs all'avvio serve perchè il primo processo ad essere chiamato è `/sbin/init`

## Mounting
Un disco secondario, prima di poter essere utilizzato, deve essere montato ad un fs esistente, usando una directory come punto di attacco (*mountpoint*).

Quindi il fs root (montato in */*) esiste sempre. Deve contenere almeno `/sbin/init`, che esegue le procedure di inizializzazione all'avvio del sistema.

```bash
mount -o options -t fs_type file_speciale mount_point
```

La directory `lost+found` è una directory creata dal fs ext4 nella directory di primo livello di un disco, che contiene i frammenti (blocchi) di file corrotti e non recuperabili.

Esempio:
```bash
mount /dev/sdb1 /mnt
```
Monto la partizione associata al file speciale `/dev/sdb1` in `/mnt`, una directory che nei primi sistemi UNIX nasce proprio con lo scopo di essere un mountpoint per le partizioni da montare.

## Visualizzazione fs montati
### mount
Per elencare tutti i fs montati: `mount -l [-t tipo]` oppure `mount`

Se la prima riga inizia con il file speciale di dispositivo, il fs in questione è montato a partire da un disco concreto. Altrimenti il fs è virtuale, quindi si trova in memoria; il alternativa è montato con la semantica dei tunable, dove ogni file cambia un file di configurazione del kernel (senza quindi scrivere sul disco).

`tmpfs` è un file system scratch (temporaneo) in cui vengono salvati file temporanei molto velocemente, perchè tmpfs si trova in ram.

`DISCO_CONCRETO/TIPO_VIRTUALE on MOUNTPOINT type TIPO (OPZIONI)`

Se `errors=remount-ro` -> il SO rimonta il fs in readonly se rileva degli errori, per evitare la corruzione del disco

Memento:
- A-TIME -> Tempo di accesso
- M-TIME -> Tempo di modifica
- C-TIME -> Tempo di crezione

Se l'ATIME venisse aggiornato ogni volta che il file è acceduto, il disco sarebbe da buttare dopo 10k accessi. In ossequio alla legge d'oro dell'ingegneria, sincronizzo il metadato una tantum, per esempio quando cambia il giorno, oppure quando spengo il sistema.

Il flag `relatime` fa questo. Sincronizza l'atime una volta al giorno, solitamente sul fronte di cambio.

### lsblk
Mostra i dispositivi a blocchi montati sul sistema, come albero, incolonnato.

I fs di loopback permettono di montare come fs un file o un fs distribuito su più partizioni.
Viene usato per esempio quando si vuole montare un'ISO come fs ISO9660

Vedi: `user-mode Linux`