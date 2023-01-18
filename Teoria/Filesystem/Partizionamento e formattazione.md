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

## Layout
Il layout di ogni filesystem dipende dalla sua versione ed implementazione. In generale sono sempre presenti 3 elementi comuni ad ogni fs moderno:
- albero: mantiene la gerarchia che sussiste tra file e directory
- area metadati: contiene le strutture di controllo (inodes - index nodes)
- area dati: memorizza concretamente il contenuto dei file

## Limitazioni
### Massima dimensione di file
- FAT32 -> 4 GB
- EXT4 -> 16 TB
### Massimo numero di partizioni primarie
Dipendentemente dalla partition table scelta, si può avere una limitazione più o meno stretta:
- MBR (old school Master Boot Record) -> massimo 4 partizioni primarie. Solitamente 3 primarie + 1 estesa, ulteriormente suddivisa in più partizioni logiche
- GPT (GUID Partition Table) -> massimo 128 partizioni primarie