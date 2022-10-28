I open a note in a new pane but not when I open it# Stat
Con `stat` si ottengono i metadati di un qualunque file (speciale, dir, link, ecc.)
```bash
stat [options] filename
```

Output di `stat`:
- Dim -> dimensione del file in bytes
- Blocchi -> blocchi allocati sul fs
- Blocco IO -> dim in byte di un blocco del fs
- Tipo di file
- Device -> identificatore del file: major number, minor number
- Inode -> identificatore che punta alla struttura di controllo del file, che dice dove sul disco sono materializzati i file. Anche i metadati sono memorizzati in questa struttura.
- Coll -> collegamenti fisici (hard link) al file. Aumenta creando hard link con `ln`.
- Uid -> User ID
- Gid -> Group ID
- Timestamp di creazione e modifica del file. Ext4 non memorizza i metadati relativi alla crezione del file (ultima voce in basso)

# Ls
Il comando `ls` visualizza il contenuto di una directory.

| Opzione | Descrizione                                                                       |
| ------- | --------------------------------------------------------------------------------- |
| -a      | Visualizza i file nascosti                                                        |
| -l      | Visualizzazione lunga: metadati mostrati                                          |
| -h      | Formato delle dimensioni in formato human-readable. Ha senso solo se usata con -l |
| -t      | Ordine di accesso decrescente. Gli ultimi acceduti sono in alto                   |
| -S      | Ordine dimensione decrescente. Più grandi in alto.                                |
| -r      | Reverse order. Da usare con -S o -t                                               |
| -R      | Stampa ricorsiva delle sottodirectory.                                            |
| -d      | Visualizza i metadati di una dir e non il suo contenuto                           | 

`tree` stampa in modo ricorsivo in contenuto di una directory, con una struttura ad albero.

# Associazione
## Associazione diretta
Tipocamente un OS decide con quale applicazione aprire un file interpretando l'estensione di esso. È il meccanismo più semplice di riconoscimento del tipo di un file regolare.
L'associazione tra estensione e applicazione è cablato nel SO (eg: MS-DOS, Unix, ecc.)
`lesspipe` è un esempio di associazione diretta.
## Lista di estensioni
Ogni applicazione dichiara di essere in grado di aprire una lista di estensioni. Più applicazioni possono essere in grado di aprere la stessa estensione.
Per disambiguare si può scegliere una politica di priorità o una politica FIFO/LIFO (uso l'ultima scelta dall'utente).
## Magic numbers
Assomiglia all'approccio usato dagli antivirus. Ogni file di un certo tipo ha al suo interno delle sequenze tipo dette **magic numbers**. 
Prova: `ls -Mr /usr/bin/ls`
Vedo: `^?ELF...`
Il primo byte è `0x7F` per tutti i binary.
I magic numbers sono sparpagliati in modo deterministico all'interno dei file.
Tutte queste possibili sequenze sono contenute nel **magic file**, con nome *magic*. Il sistema operativo scorre tutte queste sequenze alla ricerca di una hit con risultato 100%.
### file
Il comando `file` è l'interfaccia con il database magic.
Sintassi: `file filename`
Es: con un file ASCII viene individuata la stragrande maggioranza di char, che hanno un valore compreso tra 32 e 127.

# Creazione
## Touch
`touch F1 F2 ... Fn` cambia il tempo di accesso alla lista di file datagli in pasto.
Se uno dei file non esiste viene creato con tempo di accesso, creazione e modifica attuale.

| Opzione | Descrizione                                                           |
| ------- | --------------------------------------------------------------------- |
| -a      | Cambia il timestamp di ultimo accesso. Viene aggioranto anche cambio. |
| -m      | Cambia il timestamp di modifica. Simula una scrittura.                                                                      |

Timestamp associati ad un file:
- accesso
- modifica
- cambio -> cambio metadati
- creazione

1/1/1970 ore 00:00 è l'inizio dell'epoca UNIX.

## Mkdir
`mkdir directory` fallisce se la directory esiste; fallisce anche se si cerca di creare una sottodirectory senza aver creato le directory superiori.

L'opzione `-p` crea una gerarchia di directory, anche se comprende dir mancanti nel mezzo.

```bash
mkdir -p a/b/c
```

# Rimozione
## Rm
```bash
rm file
```
Il file viene cancellato se è un file; nessuna directory.

```bash
rm -d arg
```
arg viene cancellato se è un file o una directory vuota.

```bash
rm -r dir
```
Rimuove in modo ricorsivo file e directory vuote.

| Opzione | Descrizione                                       |
| ------- | ------------------------------------------------- |
| -i      | Modalità interattiva. Chiede prima di cancellare. |
| -f      | Modalità forzata. Disabilita -i.                  | 

### Rmdir
`rmdir directory` rimuove una directory

Con `-p`, analocamente a `mkdir` viene cancellata una gerarchia di directory.

# Copia e postamento
## Cp
```bash
cp Fsrc Fdst
```
Copia il file copia Fdst con contenuto uguale a Fsrc.
Se la destinazione è una dir, Fsrc viene spostato lì dentro.

| Opzione | Descrizione                                                                                          |
| ------- | ---------------------------------------------------------------------------------------------------- |
| -a      | Copia archiviale dei file. Cerca di preservare gli stessi medatadi dei file che si cerca di copiare. |

### Mv
Simile a `cp`: rinomina un file se src e dst sono file; se dst è una dir, la src viene spostata.

`-b` crea un backup del file di dest se si cerca di muovere src in dst, con dst, già esistente