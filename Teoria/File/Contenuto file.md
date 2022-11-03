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

## Archivi testuali
> Archivio testuale: file contenente record testuali.
> Record: elenco di campi separati da un separatore (carattere di separazione). Il record finisce a fine riga.
> Campo: singola informazione riguardante un attore del sottosistema.

Sono esempi di archivi testuali `/etc/passwd` e `/etc/group`. In `passwd` il carattere di separazione sono i due punti.

### Cut
```bash
cut [options] F1 F2 ... Fn
```
Estra gli elementi selezionati da una serie di file. Gli elementi possono essere intervalli di campi, bytes o caratteri. Permette operazioni sulle colonne di un flusso di testo.

Attezione: carattere diverso da byte. Le codifiche moderne sono multi-byte.

| Opzione | descrizione                                                                       |
| ------- | --------------------------------------------------------------------------------- |
| -f N    | N-mo campo                                                                        |
| -f N-   | N-mo campo fino a fine riga                                                       |
| -f N-M  | Intervallo di campi tra N ed M                                                    |
| -f N, M | Campo N ed M                                                                      |
| -f -M   | Dal primo campo all'M-esimo                                                       |
| -c      | Permette di specificare un intervallo di caratteri, con la stessa semantica di -f |
| -d S    | Specifica il carattere separatore S                                               |
| -b      | Specifica intervalli di bytes, con la stessa semantica di -f e -c                 |

Come si comporta `cut` con più separatori insieme?
Se ripeto 2 volte il separatore, specificandolo correttamente con `-d`, il field in mezzo ai due separatori viene considerato nullo (NULL):
```txt
r1c1  r1c2
r2c1   r2c2
```
Viene visto come:
```txt
r1c1 NULL r1c2
r2c1 NULL NULL r2c2
```
Quindi 
```bash
cut -f 2 -d " " file.txt
```
Ritorna il nulla totale.

Soluzioni:
1. Usare il translator `tr` con `tr -s " "` che fa lo squeezing dei caratteri spazio: dò in pasto a `cut` il risultato di `tr`
2. Uso `awk`: `awk '{print $2}'`

### Paste
Operazione contraria di `cut`: crea un archivio testuale a partire da più **file colonnari** che contengono un singolo field per record, quindi raggruppa più field in un unico record.

```bash
paste F1 F2 ... Fn
```

Con `-d` specifico il separatore.

Lunghezza file: `cat -n file` o `wc -l file`

Notiamo un problema: se il contenuto di una colonna è troppo lunga, rovina l'allineamento di tutte le altre sulla stessa riga.
Soluzione: `paste c1.txt c2.txt c3.txt | column -t`

### Sort
```bash
sort [opzioni] filename
```

L'ordinamento di defualt è quello alfabetico (non numerico).

| Opzione | Descrizione                             |
| ------- | --------------------------------------- |
| -n      | ordinamento numerico                    |
| -d      | ordinamento alfanumerico                |
| -h      | ordinamento numerico umano (K, G, etc.) |
| -M      | ordinamento del mese                    |
| -k      | specifica la KEY dell'ordinamento       |
| -t      | specifica il separatore delle colonne   |

KEY è in formato Backus-Naur: `POS1[,POS2]`
Dove ogni POS è: `F[.C][OPTS]` in cui:
- F è il numero di campo
- C  posizione del carattere nel campo
- OPTS è una lettera che corrisponde al tipo di ordinamento

Vedi [[../../Esercizi/key/inventario.txt]]
Ordinabile con:
```bash
sort -k 1.4,1.6n inventario.txt
```
Ordina secondo il primo campo considerando i caratteri dal quarto al sesto, con ordinamento numerico.

# Ricerca file
## Find
Cerca file a partire dai suoi metadati.
```bash
find [opzioni] [percorso] [metadati]
```

`find` (senza argomenti) stampa il nome di tutti i file nella directory corrente.
`find /etc` stampa tutti i file nella directory `/etc`.
`find /etc -name *.conf` specializza il criterio di ricerca (non più "tutti i file").

> Attenzione: quando usi le wildcard (come '\*') bash esegue l'espansione prima di chiamare `find`. Se il pattern che si cerca matcha un file nella directory corrente, il comando termina perchè bash espande il pattern con il nome specifico di quel file.
> Se esistono due file che matchano il pattern, l'espasione passa a `find` due argomenti, che generano un errore di sintassi.

Usa il quoting del pattern per inibire l'espansione: `find / -name "*.log"`

Oltre alle wildcard tipiche della shell `find` accetta anche un pattern specificato come regex:
```bash
find / -regex "REGEX"
```

Per ottenere tutti i tipi di regex supportati: `find -regextype help`
Guarderemo il formato *emacs*:
https://www.gnu.org/software/findutils/manual/html_mono/find.html
[[https://www.gnu.org/software/findutils/manual/html_mono/find.html#Regular-Expressions]]

| Opzione      | Descrizione                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------- |
| -atime n     | Filtra i file che sono stati acceduti l'ultima volta n\*24 ore fa (n è il numero di giorni) |
| -perm mode   | Filtra i file che hanno il permesso *mode*                                                  |
| -size n[kMG] | Filtra i file con dimensione n;                                                                                            |

*n* può essere:
- n esattamente *n*
- +n più grande di *n*
- -n più piccolo di *n*

### Regex
| wildcard  | significato                                                                                         |
| --------- | --------------------------------------------------------------------------------------------------- |
| .         | carattere qualunque                                                                                 |
| +         | match della regex precedente 1 o più volte                                                          |
| ?         | match della regex precedente 0 o 1 volta                                                            |
| \\+       | Match letterale di "+"                                                                              |
| \\?       | Match letterale di \\?                                                                              |
| \[c1-c2\] | Match di un range                                                                                   |
| ^         | Inizio riga                                                                                         |
| $         | Fine riga                                                                                           |
| R1\|R2    | Due regex in OR                                                                                     |
| \(REGEX\) | REGEX viene associata a un blocco numerato riferibile in seguito                                    |
| \\N       | Riferimento al blocco 1, 2, etc.                                                                    |
| \\w       | Carattere alfanumerico dentro ad una parola                                                         |
| \\W       | Carattere non alfanumerico. Le wildcard in MAIUSC implementano la negazione di quelle in minuscolo. |
| \\<       | Inizio parola                                                                                       |
| \\>       | Fine parola                                                                                         |
| \\b       | "border". Inizio o fine parola.                                                                     |

Esercizio: boglio matchare tutti i file contenuti in /etc o sottocartelle, che terminano con `.bash`:
```regex
^/etc/.*/\.bash.*$
```
- Inizio la riga
- Contenente /etc/
- Seguito da un qualunque pattern
- Che termina con `.bash`
- Seguito da una qualunque sequenza
- Che arriva a fine riga

Le varianti **case insensitive** sono `-iname` e `-iregex`

Cercare tutti file html (HTML, htm, HTM) nel sistema: `find / -iregex "^.*\.html?$"`

### Specifica azioni
Di default è `-print`

L'azione `-printf` accetta una stringa di formato (specificatori che iniziano con "%").
Per stampare percorso e permesso per ogni file trovato si può fare:
```bash
find / -printf "%p %m\n"
```

Vedi la pagina di manuale di `find` per conoscere gli altri specificatori.

---
`-exec` accetta un comando UNIX da eseguire su ciascun file individuato. Il placeholder che rappresenta il file individuato è `{}`.

Sinossi:
```bash
find DIR EXPR -exec COMMAND '{}' \;
```

Attenzione: il comando deve essere terminato con `;`

Esempio:
```bash
find /etc -name "*.conf" -exec file "{}" \;
```

"Paginatore" -> come `less`

```bash
find / -iregex "^.*\(\.bak\|~\)$" -exec file "{}" \; 2> /dev/null
```

## Grep
Cerca i file in base ai contenuti.
```bash
grep root /etc/passwd
```

| Opzione       | Descrizione                                                                             |
| ------------- | --------------------------------------------------------------------------------------- |
| -n            | Stampa il numero di riga dei match. Ritorna un record composto da numero riga:contenuto |
| -H            | Stampa il nome del file in cui è avvenuto il match come filename:row:content            |
| -R SEARCH DIR | Ricerca ricorsiva a partire da una directory                                            |
| -i            | Ricerca case-insensitive                                                                |
| --color=yes   | Colora l'output di grep                                                                 |
| -E 'REGEX'    | Supporta 3 famiglie di REGEX: base, estese, Perl. `-E` accetta una regex estesa         |
| -v            | Inverte il match                                                                        |
| -o            | Stampa solo la porzione di riga che matcha                                                                                        |

Caratteri speciali delle Regex Estese:
- {N} match dell'espressione precedente N volte
- {N,} almeno N volte
- {N,M} da N a M volte
- {,M} fino a M volte
- \[\[:alnum:\]\] ma anche:
	- alpha
	- blank
	- digit
	- lower
	- upper
	- space

Ricerca indirizzi IP in `/etc/hosts`:
```bash
grep --color=yes -nE '([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' /etc/hosts
```

PCRE = Perl Compatible Regular Expressions

