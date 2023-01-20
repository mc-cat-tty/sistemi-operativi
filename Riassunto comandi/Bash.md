# BASH

## manipolazione di variabili

### dichiarazioni di variabili

```bash
var=val #creazione di una variabile var con valore stringa val
declare -i var #setting di tipo intero della variabile 
declare -i var=5
```

per rimuovere il valore della variabile

```bash
unset var
```

per il valore di default

```bash
${var:-val} #var non viene modificata, se non è settata imposta val
${var:=val} #lo imposta
```

per sapere la lunghezza della variabile var

```bash
${#var}
```

### sottostringhe

per  estrarre una sottostringa

```bash
${var:start:len}
```

rimozione di una sottostringa con pattern partendo dall’inizio della stringa

```bash
${var#pattern} #non greedy, rimuove il piu piccolo match
${var##pattern} #greedy, rimuove il match più grande
```

per rappresentare sottostringhe in maniera efficiente si può sostituire con: abc → (a*c, a?c) dove

- \* sostituisce con un carattere qualsiasi anche il nulla
- ? matcha un singolo qualunque carattere

 Analogamente la rimozione di una sottostringa partendo dalla fine di essa si fa con

```bash
${var%pattern} #non greedy
${var%%pattern} #greedy
```

> Questi due metodi non alterano la stringa in nessun modo, restituiscono il valore modificato e basta
> 

### operazioni matematiche

per interpretare l’espressione matematica EXPR si utilizza un operatore specifico

```bash
$((EXPR))
#per esempio
echo $((1+2))
```

si possono passare variabile che non sono dichiarate come intere e funzionerà ugualmente

```bash
a=1
b=2
echo $((a+b))
```

> Si possono concatenare più espressioni
> 

esiste un modo più bello di assegnare a una variabile il risultato di una espressione

```bash
var=$((1+2))
let var=1+2
```

## Ambiente

esistono diversi tipi di variabili di ambiente

- PATH: elenco di percorsi di ricerca degli eseguibili
- PS1: prompt dei comandi.
- PWD: directory corrente
- SHELL: il percorso dell’interprete corrente
- USERNAME: lo username dell’utente corrente
- HOSTNAME: il nome dell’host corrente
- HOME: il percorso della home directory dell’utente
- LANG: nazionalità delle impostazioni locali

> in generale per accederle si utilizza normalmente l’operatore “$”
> 

```bash
echo $PATH
```

## operatori condizionali e logici

per il confronto aritmetico

```bash
ARG1 -eq ARG2 #VERO se ARG1=ARG2
ARG1 -ne ARG2 #VERO se ARG1 diverso ARG2
ARG1 -lt ARG2 #VERO se ARG1<ARG2
ARG1 -gt ARG2 #VERO se ARG1>ARG2
ARG1 -le ARG2 #VERO se ARG1 minore o uguale ARG2
ARG1 -ge ARG2 #VERO se ARG1 maggiore o uguale ARG2
```

per il confronto tra stringhe

```bash
-z STR       #VERO se STR ha lunghezza zero
-n STR       #VERO se STR è non nulla
STR          #VERO se STR non ha lunghezza zero
STR1 == STR2 #VERO se STR1 e STR2 sono uguali
STR1 != STR2 #VERO se STR1 è diversa da STR2
STR1 \< STR2 #VERO se STR1<STR2
STR1 \> STR2 #VERO se STR1>STR2
```

per il confronto logico (booleano)

```bash
EXPR           #ritorna il valore logico di EXPR
! EXPR         #VERO se EXPR ha valore FALSO
EXPR1 -a EXPR2 #VERO se EXPR1 e EXPR2 lo sono
EXPR1 -o EXPR2 #VERO se EXPR1 o EXPR2 lo sono
```

bash permette di effettuare un test dell’operazione logica tramite il comando “test”

```bash
test [1 -le 2]
```

> notare che si possono mettere le parentesi quadre
> 

in questo caso il risultato viene messo nella variabile “$?”

## costrutti

### if

```bash
if COND_TEST1; then
STATEMENTS1
elif COND_TEST2; then
STATEMENTS2
else
STATEMENTS3
fi
```

dove le COND_TEST sono le espressioni viste prima

```bash
if [var1 -eq var2]; then
echo "$var1"
else
echo "$var2"
fi 
```

### case

analogo allo switch case di altri linguaggi

```bash
case $var in
VAL1)
STATEMENTS1
;;
VAL2)
STATEMENTS2
;;
VAL3)
STATEMENTS3
;;
esac
```

se var == VAL1 allora esegue lo statement

### while

```bash
while COND_TEST1;
do
STATEMENTS1
done
```

```bash
while [ $a -le 10 ];
do
	echo $a
	let a=++a
done
```

ci vuole il pre-incremento, se no prima assegna “a” a se stessa e poi incrementa il nulla

### until

```bash
until COND_TEST1;
do
STATEMENTS1
done
```

### for

```bash
for var in LIST;
do
STATEMENTS1
done
```

dove LIST è una lista di “cose” iterabili e var ne assumerà ad ogni giro il valore

Per generare tutti i valori di numeri in un determinato range, con un determinato passo si usa

```bash
S1{S2,S3}S4 → S1S2S4 S1S3S4
{0..N} → 0 1 2 ... N
{0..N..M} → 0 0+M 0+2M ... N
#esempi di espansione
echo {0..100} #numeri da 0 a 100
echo {1..100..2} #numeri dispari da 1 a 100
```

per la generazione delle stringhe invece

```bash
echo file-{esempio,vecchio,nuovo}.txt
```

genera tre file che si chiamano:

- file-esempio.txt, file-vecchio.txt, …

## esecuzione condizionata

per la concatenazione di comandi si utilizza l’operatore “;”, i comandi concatenati eseguono qualunque sia il risultato del comando precedente

```bash
CMD1 ; CMD2
#esempio
ls nonesistente; echo prova
#output
ls: impossibile accedere a 'nonesistente':File o directory non esistente
prova
```

Esecuzione condizionata con comando successivo solo se il precedente ha successo

```bash
CMD1 && CMD2
ls nonesistente && echo “Tutto OK”
```

CMD2 eseguirà solo se CMD1 andrà a buon fine

Esecuzione conediziona con comando successivo solo se il precedente esce con uno stato non nullo

```bash
CMD1 || CMD2
#esempio
ls nonesistente || echo “Errore”
#output
Errore
```

## Script

Si possono creare degli script bash: sono dei file avente estensione “.sh”

si eseguono tramite il comando

```bash
bash script.sh
./script.sh
```

### parametri posizionali

bash mette a disposizioni variabili interne per la gestione dei parametri posizionali

- $0: nome dello script.
- $1: primo argomento.
- $2: secondo argomento.
- $3: terzo argomento.

### comandi di uscita

lo script essendo un comando può restituire dei valori di uscita tramite il comando exit

```bash
exit 1 #si è verificato un errore
exit 0 #tutto ok
```

questo valore si controlla sempre nella variabile  “$?”

### opzioni comandi bash

```bash
bash -v script.sh #stampa ogni statement prima di eseguirlo
bash -x script.sh #abilita l’esplicitazione di ogni statement prima della sua esecuzione
```

## Alias e Funzioni

### alias

è una abbreviazione del comando, il comando “alias” è responsabile della gestione di questi

```bash
alias ls='ls -color=auto'
```

Uso corretto

```bash
ls → ls --color=auto
echo hi; ls → echo hi; ls --color=auto
ls -l → ls --color=auto -l
ls f → ls --color=auto f
```

> se si utilizza l’alias all’interno di comandi non funzionerà
> 

Creazione e cancellazione di un alias

```bash
alias NOME_ALIAS=’COMANDO’
unalias NOME_ALIAS
```

### funzioni

```bash
function FUNC_NAME() {
STATEMENTS
}
```

la coppia di parentesi è ornamentale, i parametri vengono passati come se fosse uno script

```bash
FUNC_NAME arg1 arg2 arg3 … argN
```

all’interno della funzione gli argomenti passati si accedono con le variabili “$1, $2, …”. Il valore di $0 rimane il nome dello script e non della funzione

```bash
return var
```

permette di mettere in $?=var così da avere un valore di ritorno

## Scoping

```bash
MAIN
	dichiarazione di x
	SUB1
		dichiarazione di x
		…
		call SUB2
		…
	SUB2
	…
	riferimento a x
	…
```

con lo scoping STATICO il riferimento a x dentro a SUB2 si riferisce al chiamante principale ovvero:

MAIN→SUB1→SUB2

quindi a MAIN

mentre con lo scoping DINAMICO il riferimento segue la chiamata a cascata, quindi il chiamante di SUB2 è SUB1 allora la “x” si riferirà a SUB1

### local

in bash è possibile forzare una variabile ad avere un campo di visibilità locale, visibile solo all’interno della funzione

```bash
my_function() {
local a=1
}
my_function
echo $a
#output nullo
```

## Storia dei comandi

```bash
history
```

elenca tutti i comandi nella storia

```bash
history N #elenca gli ultimi N comandi
history -c #cancella il buffer, ma non il file di log
history -w #scrive il buffer nel file
history -a #appende il buffer nel file log
history -r #rilettura del log nel buffer
```

per la manipolazione della history si usa il comando fc →fix command

```bash
fc
fc -e vim #lancia con l'editor vim
fc N #si modifica e esegue il comando N-esimo della history
fc -N #analogo a N ma si utilizza N-ultimo comando nella hystory
fc "stringa" #l'ultimo comando contente la stringa
fc -l N #elenca gli ultimi N comandi (default 16)
```

```bash
fc -s history=ls 29
```

sostituisce la parola history nel comando 29 con la parola ls

### operatori di espansione della history

```bash
!N  #espande nell’N-mo comando presente nel buffer della storia dei comandi
!-N #si espande nell’N-ultimo comando presente nel buffer della storia dei 
		#comandi
!!  #si espande nell’ultimo comando immesso
!S  #(dove S è una stringa) si espande nell'ultimo comando contenente S
^S1^S2^ #Se usato con due stringhe S1 e S2, sostituisce S1 con S2 
				#nell’ultimo comando.
```

## identificazione dei comandi

il comando type riceve in ingeresso uno o più argomenti, ciascuno rappresentate un nome di comando e ritorna la tipologia associata

```bash
type C1 C2 C3 .. CN
#esempio
type help ls vmstat
```

è possibile che esistano omonimie nei comandi, per scoprirle in modo comodo si utilizza

```bash
type -a COMANDO
#esempio
type -a printf
```

per forzare l’esecuzione del builtin si può eseguire

```bash
builtin printf
```

Per forzare l’esecuzione del primo comando disponibile si può eseguire il comando
