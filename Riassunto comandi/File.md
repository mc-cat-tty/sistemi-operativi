# FILE

Il comando **stat** visualizza i metadati di un file

```bash
stat [opzioni] nome_file
```

## ls

Il comando **ls** visualizza il contenuto di uno più file o
directory FD = file o directory

```bash
ls [opzioni] FD1 ... FDN
```

ha varie opzioni

```bash
ls -a #visualizzazione dei file nascosti
ls -l #visualizzazione estesa (metadati)
   -h #human readable output
   -t #ordina file per ordine decrescente secondo il tempo di accesso
   -S #ordina i file per dimensione decrescente
   -r #inverte l'ordine di -t o -S
ls -R #lancia ricorsivamente il comando ls
```

## file

Il comando file stampa la tipologia di uno o più file o
directory

```bash
file FD1 FD2 ... FDN
#esempio
file /etc/passwd
```

## touch

Il comando **touch** nasce per modificare i timestamp
associati ad un file.

```bash
touch F1 F2 ... FN
```

Lanciato così crea semplicemente un file con contenuto nullo

```bash
touch file_di_prova
```

crea il file “file_di_prova”

```bash
touch -a [file] #modifica timestemp di accesso
touch -m [file] #modifica timestamp di modifica
```

## Directory

### mkdir

Il comando **mkdir** crea directory vuote

```bash
mkdir D1 D2 ... DN
```

per creare sottocartelle o cartelle aventi lo stesso nome si può utilizzare l’opzione

```bash
mkdir -p dir1/dir2/dir3
```

### rm

per rimuovere una cartella vuota

```bash
rm -d [directory]
```

con l’opzione -r si abilita la cancellazione ricorsiva, quindi anche le sottocartelle verranno rimosse

```bash
rm -r dir1
```

verranno rimossi anche file interni alla cartella. Per rendere interattiva l’eliminazione basta aggiungere l’opzione -i

```bash
rm -r -i dir1
```

prima che venga eliminata ci chiede S/N

```bash
rm -f [file] #permette l'eliminazione forzata di un file
```

### rmdir

Esiste anche il comando **rmdir**, duale di mkdir

```bash
rmdir D1 D2 ... DN
```

> rmdir non cancella directory piene!
> 

```bash
rmdir -p dir1/dir2/dir3
```

Analogamente al comando mkdir, l’opzione -p di
**rmdir** consente di cancellare una gerarchia di
sottodirectory

## Copia e spostamento

### cp

il comando **cp** copia file e/o directory.

```bash
cp FSRC FDST #lanciato così copia FSRC in FDST
```

Se i primi N argomenti sono file F1, F2, … FN e l’ultimo
argomento è una directory D, cp copia tutti i file nella
directory:

```bash
cp F1 F2 … FN D
```

```bash
cp -a FD1 FD2 … FDN D #copia in maniera fedele (conserva metadati)
```

con questa opzione i metadati di accesso e modifica rimangono quelli del file originario

### mv

Il comando mv sposta file e/o directory.

```bash
mv FD_SRC FD_DST #sposta il file/directory FD_SRC nel file/directory FD_DST
```

È possibile cambiare il nome del file contestualmente al
suo spostamento. È sufficiente usare un nome diverso in
FD_DST.

```bash
mv nuovo_file /tmp/nuovo_file_spostato
```

## Visualizzazione contenuto

### cat

Il comando più immediato per la visualizzazione non
interattiva di un file è **cat**

```bash
cat F1 F2 ... FN # stampa il contenuto dei file in sequenza
```

```bash
cat -E [file] #stampa fine linea con $
cat -T [file] #stampa tabulazione come ^I
cat -v [file] #stampa caratteri non stampabili
cat -A [file] #elenca tutti i caratteri non stampabili -> -vET
cat -n [file] #mette un numero progressivo per ogni riga
```

### hexdump

Il comando hexdump stampa il contenuto di file in
diversi formati

```bash
hexdump F1 F2 ... FN #stampa il contenuto in esadecimale
```

```bash
hexdump -C [file] #visualizzazione canonica
	-v [file] #visualizzazione verbosa
```

### head

Il comando **head** visualizza la parte iniziale di un file

```bash
head F1 F2 ... FN #stampa le prime 10 righe di ogni file
```

```bash
head -n N [file] #stampa n righe
head -c C [file] #stampa C bytes
```

similmente N e C se sono positivi stampano le prime N righe e i primi C byte, se sono negativi stampano fino alle ultime N righe o agli ultimi C byte

### tail

Il comando **tail** visualizza la parte finale di un file; esso
è concettualmente duale a **head**

```bash
tail -n N  #stampa le ultime N righe.
     -n +N #stampa a partire dalla riga N.
     -c C  #stampa gli ultimi C byte.
     -c +C # stampa a partire dal byte C.
```

Il comando tail ha un’ulteriore opzione (**-F**) per la
visione di file di log.

```bash
tail -F log.txt
```

## Manipolazione di testi

### cut

Il comando **cut** estrae elementi selezionati da uno o più
file esistenti

```bash
cut [opzioni] F1 F2 … FN
```

L’opzione -f  (--fields) di **cut** permette di selezionare i campi da
un file

```bash
cut	  -f N   #l’N-mo campo
	  -f N-  #dall’N-mo campo a fine riga
	  -f N-M #dall’N-mo campo all’M-mo campo
	  -f N,M #l’N-mo campo e l’M-mo campo
	  -f -M  #dal primo campo all’M-mo campo
```

Il carattere di delimitazione di default è TAB; si può
cambiare con l’opzione -d.

L’opzione -c di **cut** permette di specificare un intervallo
di caratteri. L’argomento è una specifica sintetica
dell’intervallo dei caratteri

```bash
cut -c N   #N-mo carattere
    -c N-  #dall’N-mo carattere a fine riga
    -c N-M #dall’N-mo carattere all’M-mo carattere
    -c N,M #l’N-mo carattere e l’M-mo carattere
    -c -M  #dal primo carattere all’M-mo carattere
```

Analogo all’opzione **-c**  e **-f** esiste l’opzione **-b **che permette di specificare un intervallo
di byte (con tutte le sue modalità d’uso descritte come sopra)

```bash
cut -b N   #N-mo byte
    -b N-  #dall’N-mo byte a fine riga
    -b N-M #dall’N-mo byte all’M-mo byte
    -b N,M #l’N-mo byte e l’M-mo byte
    -b -M  #dal primo byte all’M-mo byte
```

## paste

Il comando paste fonde uno o più file esistenti

```bash
paste F1 F2 .. FN
```

## sort

Il comando sort ordina file secondo specifici criteri

```bash
sort F1 F2 … FN
```

senza opzioni concatena i file F1, F2, … FN; considera l’intera riga come una singola chiave di ordinamento; ordina tutte le chiavi alfabeticamente.

```bash
sort -n #ordinamento numerico
     -d #ordinamento alfanumerico (dizionario)
     -h #ordinamento numerico “umano” (confronta numeri leggibili dagli umani, ad es. 2G e 1K)
     -M #ordinamento del mese (confronta JAN, FEB, …)
```

È possibile ordinare le righe di un file in base ad una
chiave di ordinamento in esse contenuta

Il formato della chiave di ricerca ha una forma BackusNaur del tipo **POS1[,POS2]**, ovvero POS1 (obbligatorio) specifica la posizione iniziale e POS2 (facoltativo) specifica la posizione finale. **POS1** e **POS2** hanno una forma Backus-Naur del tipo
**F[.C][OPTS]**, in cui:

- F (obbligatorio) è il numero di campo desiderato;
- C (facoltativo) è la posizione del carattere nel campo;
- OPTS (facoltativo) è una lettera che corrisponde ad una
opzione di ordinamento.

ecco un esempio per chiarire 

```bash
ID-23 descrizione1 costo-a
ID-99 descrizione2 costo-b
ID-112 descrizione3 costo-c
```

questo è il contenuto di un file “inventario.txt”

```bash
sort -k 1.4,1.6n inventario.txt
```

## Individuazione e ricerca

### find

Il comando **find** individua file a partire dai suoi
metadati

```bash
find [opzioni] [percorso] [espressione]
#find lanciato nel modo più semplice possibile
find
#lanciato con una dir
find /etc
#lanciato con una opzione
find /etc -name *.conf
```

È possibile individuare file anche in base al match di una espressione regolare, usando l’opzione -**regex REGEX**

ecco alcune dritte sulle REGEX:

- . → un carattere qualunque
- \+ → il carattere o l’espressione regolare precedente, ripetuta almeno una volta
- ? → il carattere o l’espressione regolare precedente, ripetuta zero o una volta
- \\+ → il carattere letterale +
- \\? → il carattere letterale ?

[c1-c2] → un carattere nell’intervallo [c1, c2]
^ → inizio riga
$ → fine riga
R1\|R2 → espressione regolare R1 o R2
\(REGEX\)→ REGEX viene associata ad un blocco e
può essere riferita in seguito
\N → riferimento blocco N (N=1, 2, 3, …

\w → un carattere dentro una parola
\W → un carattere non dentro una parola
\< → inizio di una parola
\> → fine di una parola
\b → bordo (inizio o fine parola)
\B → interno (non inizio, non fine parola)

l’opzione **-iregex** o **-iname** sono uguali, semplicemente sono case insensitive

```bash
-atime n        #il file è stato acceduto l’ultima volta n*24 ore fa.
-perm mode      #il file ha permessi mode.
-size n[cwbkMG] #il file usa n unità di spazio su disco.
```

l’opzione di base di **find** è il -print, per  modificarlo si aggiunge l’opzione

```bash
find / -printf "%p %m\n" #fare man find per trovare le opzioni di printf
```

L’azione **-exec** accetta un comando di shell da eseguire su ciascun file individuato.

```bash
find DIR EXPR -exec COMMAND ’{}’ \;
```

esempio

```bash
find /etc -name ”*.conf” -exec file ”{}” \;
```

si può fare l’OR logico con le regex nel seguente modo

```bash
find / -regex ”^.*\(\.bak\|~\)$”
```

### grep

Il comando **grep** individua file a partire dal suo contenuto.

```bash
grep [opzioni] pattern [file]
```

```bash
grep -n #stampa il numero di riga in cui è avvenuto un match con il pattern
     -H #stampa il nome del file in cui è avvenuto un match con il pattern
     -R #effettua una ricerca ricorsiva nel sottoalbero specificato come argomento
     -i #effettua una ricerca case insensitive
     -E 'REGEX' 
```

Le regual expression sono molto simili a quelle emacs (studiate prima). Ecco le differenze;

{N} → il carattere o l’espressione regolare precedente, ripetuta esattamente N volte
{N,} → il carattere o l’espressione regolare precedente, ripetuta almeno N volte
{M,N} → il carattere o l’espressione regolare precedente, ripetuta da M a N volte

[c1-c2] → un carattere nell’intervallo [c1, c2]
\[[:alnum:]] → un carattere alfanumerico
\[[:alpha:]] → un carattere alfabetico
\[[:blank:]] → un carattere “blank” (spazio, tabulazione)
\[[:digit:]] → un carattere cifra
\[[:lower:]] → un carattere alfabetico minuscolo
\[[:space:]] → un carattere “space” (tab, newline, form, feed, vertical tab, carriage return, spazio)
\[[:upper:]] → un carattere alfabetico maiuscolo

R1|R2 → espressione regolare R1 o R2
(REGEX) → REGEX viene associata ad un blocco e
può essere riferita in seguito
\N → riferimento blocco N (N=1, 2, 3, …)

```bash
grep -o #stampa esclusivamente la porzione di riga che verifica il match
     -v #inverte il match impostato da linea di comando
```

## Collegamenti

Esistono due tipi di collegamento

- **Collegamento fisico (hard link)**. Il collegamento fisico è un nuovo elemento di directory che punta allo stesso contenuto del file originale. I due elementi di directory puntano allo stesso insieme di blocchi dati.
- **Collegamento simbolico (soft link)**. Il collegamento simbolico è un nuovo file, diverso da quello originale. Il contenuto del file è il percorso del file originale.

### ln

per creare collegamenti si utilizza il comando

```bash
ln [TARGET] [LINK_NAME] #Target è il percorso del file originale
                        #Link_name è il nome del collegamento fisico
ln -s [TARGET] [LINK_NAME] #crea un link simbolico

```

### readlink

Il comando readlink risolve collegamenti simbolici

```bash
readlink F1 F2 ... FN
```

```bash
readlink -f #consente di risolvere i collegamenti in maniera ricorsiva
```

## Archivi

### tar

l comando tar manipola archivi in formato TAR (detti anche tarball), opzionalmente compressi.

```bash
tar -f [NAME] #riceve un argomento NAME contenente il percorso del file archivio
tar -c -f [NAME] FD1 FD2 ... FDN #crea un archivio contenente i file/dir FDi
```

esempio di creazione archivio di etc

```bash
tar -c -f etc.tar /etc
```

```bash
tar -t -f [NAME] #per vedere l'elenco dei file/dir di un archivio
tar -x -f [NAME] #per estrarre il contenuto da un archivio
tar -v -f [NAME] #abilita la modalità verbosa, che stampa file e directory
#manipolati durante una operazione
tar -C DIR -f [NAME] #specifica la directory da cui tar preleva i file (creazione) o 
#in cui tar scrive i file (estrazione)
```

Esistono diversi tipi di compressione che mette a disposizione:

Opzione -z → Compressione GZIP (.gz)
Opzione -j → Compressione BZIP2 (.bz2)
Opzione -J → Compressione XZ (.xz)

### 7zip

```bash
7z COMANDO <OPZIONI> ARCHIVE_NAME FD1 ... FDN
```

```bash
7z a ARCHIVE_NAME FD1 FD2 ... FDN #crea un archivio
7z l ARCHIVE_NAME #vedere l'elenco dei file/dir di un archivio
7z x ARCHIVE_NAME #estrarre l'archivio
```

L’opzione -m abilita opzioni aggiuntive di 7z

per cifrare in fase di creazione con una chiave KEY si usa:

```bash
7z -mhe=on -pKEY a ARCHIVE_NAME FD1
```

## Bash e file

Operatori di verifica su file

```bash
-d FILE #VERO se FILE esiste ed è una directory
-e FILE #VERO se FILE esiste
-f FILE #VERO se FILE esiste ed è un file regolare
-h FILE #VERO se FILE esiste ed è un link simbolico
-r FILE #VERO se FILE esiste ed è leggibile
-w FILE #VERO se FILE esiste ed è scrivibile
-x FILE #VERO se FILE esiste ed è eseguibile
```

### STDIN, STDOUT e STDERR

**STDIN →** Usato per leggere gli input utente.
**STDOUT →** Usato per scrivere l’output.
**STDERR→** Usato per scrivere i messaggi di errore.

```bash
/dev/stdin
/dev/stdout
/dev/stderr
```

### Operatori di redirezione

L’operatore di redirezione 0< FILENAME associa il
canale STDIN ad un file

L’operatore di redirezione 1> FILENAME associa il
canale STDOUT ad un file

L’operatore di redirezione >> FILENAME appende
l’output di un canale ad un file.

L’operatore di redirezione N>&M copia il descrittore di file
N nel descrittore di file M. D’ora in avanti, il canale
puntato da N scrive sullo stesso file puntato da M.
