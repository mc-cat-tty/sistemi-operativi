# Operatori unari su file
Utilizzabili con il costrutto test o dentro un blocco di valutazione di un'espressione.
La falsità è espressa dal valore di ritorno 1 (errore).

Lista operatori:
- -r esiste ed è leggibile
- -w esiste ed è scrivibile
- -x esiste ed è eseguibile
- -h eiste ed è un link simbolico
- -f esiste ed è un file regolare
- -e esiste
- -d esiste ed è una dir

```bash
test -r /etc/shadow; echo $?
```

# Canali di I/O
Ogni applicazione ha associati 3 canali di I/O:
- stdin
- stdout
- stderr

Questo è stato pensato in ottemperanza alla *legge del silenzio*.
> **Legge del silenzio**: uno dei cardini dei sistemi UNIX. Il silenzio è d'oro, ovvero meno un'applicazione stampa su riga di comando output diagnostico, meglio è. Non mischiare output diagnostico con output del programma.

Di norma tutti e 3 i canali sono assegnati al termianle corrente:
- pseudoterminale (in ambiente grafico) /dev/pts/X -> con X tra 1 e 255
- dispositivo terminale /dev/ttyY -> con Y tra 1 e 6

I tre file */dev/stdin*, */dev/stdout*, */dev/stderr* puntano, istante per istante, al terminale su cui è presente il focus.

```bash
readlink /dev/stdX
```
Ritorna (in, out, err) rispettivamente */proc/self/fd/Y* con Y=0, 1, 2
Questi tre file sono link al terminale su cui leggere e scrivere.

Con `tty` si ottiene il terminale corrente. Per vedere la directory proc del processo corrente si fa:
```bash
ls /proc/$$
```
All'interno troviamo la sottocartella *fd* che contiene tutti i file descriptor aperti dal processo corrente.

*/proc/self* è un link simbolico che punta al processo attualmente in esecuzione.

Lo stdout ha la priorità su stderr, a meno che non si scriva in modo interlacciato.

## Operatori di redirezione
Servono per trasformare un'applicazione interattiva in applicazione batch. Dove lettura e scrittura avvengono su file.

### Redirezione stdin
L'operatre `0< FILENAME` associa il canale stdin a FILENAME. Una sintassi alternativa è `< FILENAME`.

```bash
cat < /etc/passwd
```
Cat viene invocato senza argomenti (fa l'echo di quello che riceve in input, per chiudere il canale uso Ctrl-D che simula l'EOF su stdin).

Applicazioni come `cat` sono chiamate applicazioni **filtro**, perchè possono essere composte in pipe. Tutte le utilità di sistema sono componibili in pipe, di conseguenza sono filtri.

### Redirezione output
Con operatore `1> FILENAME` o in alternativa `> FILENAME`
Con `2> FILENAME` redireziono il canale di errore su *FILENAME*

Prova:
```bash
ls . nonesistente > ls.out 2> ls.err
```

Le applicazioni riescono a capire su quale canale stanno scrivendo interrogando il sistema operativo sul tipo di file descriptor associato a 0, 1, 2. Ad esempio: `ls` disabilita le sequenze di escaping per colorare l'output se stdout è associato ad un file, anche se l'output viene dato in pipe ad less o simili.
```bash
ls --color=yes | less -r  # Forzo ls a creare i colori e less ad interpretarli
```

## /dev/null
È un driver di dispositivo del kernel implementato come `return 0`, che quindi scarta tutto quello datogli in pasto.

## Append
La redirezione di base viene fatta troncando il file se già esiste. Con l'operatore `1>>` e `2>>` agisco in append.

## Operatore copia descrittori
L'operatore `N>&M` copia il contenuto del canale N nel canale con fd M.
Esempio: `2>&1` redireziona anche lo STDERR su STDOUT; in alternativa `>&` redireziona sia lo STDERR che lo STDOUT sullo stesso file.

## Tunable
I tunable del kernel sono file tipo `/proc/sys/vm/drop_caches`, ovvero file che fungono da interfaccia con il kernel e servono per personalizzarne il comportamento.

Il comando:
```bash
sudo echo 2 > /proc/sys/vm/drop_caches  # Provoca la cancellazione dei buffer di memoria del Kernel per motivi di efficienza
```
Solleva un permission denied perchè la redirezione viene fatta dalla shell, dove sono loggato come utente ordinario.

Alternativa:
```bash
echo 2 | sudo tee /proc/sys/vm/drop_caches
```
Che scrive lo stesso valore anche su stdout oltre che sul file.

## Trappola mortale
Il `2>&1` ha un significato diverso in base a dove viene posizionato:
```bash
ls . nonesiste 2>&1 > FILENAME
```
Associa allo stderr lo stdout, poi associa allo stdout filename. Quindi gli errori finiscono su stdout.

```bash
ls . nonesiste > FILENAME 2>&1
```
Fa quello che ci aspetteremmo: associa a stdout FILENAME, poi associa a STDERR STDOUT, quindi FILENAME.

## Fine opzioni
`--` indica che sono finite le opzioni

## Apertura fd su terminale
`exec 3< /etc/passwd` crea il descrittore con id 3 (in lettura) associato al file */etc/passwd*.
Posso leggere la riga di un file a partire dal file descriptor con `read -u 3 line`, stampandola con `echo $line`

Per aprirlo in scirttura `exec 4> output.txt`
Per redirezionarlo faccio `echo "str" >&4`

Chiusura fd:
```bash
exec 3<&-
exec 4>&-
```

## Filtri
I comandi UNIX sono filtri, ovvero applicazioni che applicano trasformazioni su un inputstream restituendo un outputstream.

2 possibili modalità:
- standalone: uso file di appoggio
- combinata: pipe

## Espansione
BASH fornisce la **pathname expansion** attraverso **widlcards**. I modelli di pattern sono:
- ? qualunque carattere
- * qualunque sequenza di caratteri
- 