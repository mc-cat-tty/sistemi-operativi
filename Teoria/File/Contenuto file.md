# Cat
```bash
cat /etc/passwd
```
Stampa tutte le righe del file passato.

| Opzione | Descrizione                                                                      |
| ------- | -------------------------------------------------------------------------------- |
| -E      | Mostra il fine riga                                                              |
| -T      | Mostra le tabulazioni come ^I                                                    |
| -v      | Permette di rappresentare caratteri non stampabili (non ascii)                   |
| -A      | Lista i caratteri non stampabili presenti nel file, con $ alla fine di ogni riga |
| -n      | Stampa il numero di riga                                                         | 

`/etc/skel` contiene gli *skeleton* (ovvero i modelli) di file da copiare in una directory home appena creata.

## Storia LISP
Negli anni **'70** si sono diffuse le **LISP machine**, parallelamente ai mainframe.
Vedi: LISP in Java (JS), AutoLISP, ...
LISP era un linguaggio nato per programmare IA (attività di ragionamento in dimostrazione dei teoremi).
**Knight** è stata la prima LISP machine, progettata da **Greenblat**.
Vedi: Alan Kay, vincitore premio Turing

Sulle LISP machine erano presenti tastiere meccaniche con simboli matematici e lettere greche.
CTRL spegneva i due bit più significativi (da 0 a 31) -> premuto in combinazione con un carattere generava un carattere di controllo.
META selezionava caratteri ASCII tra 128 e 255.
Nei SO operativi moderni il tasto META è scomparso, ma sopravvive con \<Alt\>-\<Tasto\>, a volte chiamato <META>-\<Tasto\> o \<M\>-\<Tasto\>. Nelle pagine di manuale ci si riferisce a \<Ctrl\>-\<Tasto\> con \<C\>-\<Tasto\>


Vedi: [[https://weblab.ing.unimore.it/people/andreoli/didattica/sistemi-operativi/2022-23/7-file/cat-v-table.txt]]
3 range di caratteri ASCII:
- 0-31 -> cappelletto-carattere
- 31-127 -> caratteri rappresentabili
- 128-255 -> M-dash-carattere

Prova a scrivere lettere accentate in file di testo e stamparle con `cat -v`.
Si vede che "è" è rappresentato con `M-CM-(` ovvero 0xa8c3. Perchè servono 2 byte?
Nei SO moderni si usa l'encoding UTF-8, una delle possibili codifiche UNICODE.

Il tasto _Meta_ accendeva l'ottavo bit del carattere -> mettere in OR con 128

L'UTF-8 è una codifica multi-byte, a dimensione variabile. La codifica definisce come memorizzare la chiave di accesso alla tabella.
Vedi con [[https://www.fileformat.info/info/unicode/char/search.htm]] ad ogni lettera quale id univoco (codepoint) esiste.

Sul terminale si possono immettere codici unicode con:
1. Ctrl-shift-u
2. codepoint (eg: e8)
3. invio

# Hexdump
```bash
hexdump F1 F2 ... Fn
```
Si usa per stampare file binari come dump esadecimale nel formato: offset - bytes

Prova: `hexdump /etc/hostname`
Si vede che hexdump stampa parole di 16 bit, esattamente come sono rappresentate in memoria. Poichè i processori Intel sono little-endian, vedremo l'ordine dei byte al contrario.

| Opzione | Descrizione                                                   |
| ------- | ------------------------------------------------------------- |
| -C      | Stampa in forma canonica, senza tenere conto della endianness |
| -v      | Inibisce l'utilizzo di asterischo (squeezing)                 | 

Per motivi di compattezza, `hexdump` non stampa righe ripetute più volte, ma le sostituisce con il carattere `*`. 

Prova a confrontare i magic bytes di:
- /usr/bin/ls
- /usr/bin/which

# Operazioni su un flusso di testo
## Head
`head F1 F2 ... Fn`
Stampa le prime 10 righe dei file passati.

| Opzione  | Descrizione                                                             |
| -------- | ----------------------------------------------------------------------- |
| -n NUM   | Stampa le prime NUM righe se NUM>0; taglia le ultime NUM righe se NUM<0 |
| -c CHARS | Stampa i primi CHARS caratteri se CHARS>0;                              |

## Tail
`tail F1 F2 ... Fn`
È il duale di `head`. Stampa gli ultimi byte o righe di un file.
Supporta `-n` e `-c`, ovviamente da interpretare al contrario (no numeri negativi).

L'opzione `-F` è stata pensata per visionare un file di log, che continua a cercare di aprire il file fino a quando non viene creato (se non esiste), permette di visualizzare il contenuto del file anche se cresce nel tempo.

Prova `tail -F /var/log/auth.log`
