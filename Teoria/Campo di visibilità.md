# Campo di visibilità
Variabile globale: ho scope pari a tutto il programma. In BASH il campo di visibilità di default è GLOBALE.

## Scope statico e dinamico
Se la variabile è contenuta in un blocco di codice B, lo scope può essere determinato in due modi:
- **scope statico**: il campo di visibilità della variabile dipende solo dal codice sorgente del programma. La variabile può vivere solo all'interno del blocco di codice dove viene utilizzata. Spazio.
- **scope dinamico**: il campo di visibilità viene determinato a tempo di esecuzione, dipende dalla sequenza di invocazioni che permettono di arrivare al blocco di codic in cui si trova il riferimento alla variabile.Tempo.

### Esempio
```bash
MAIN
dichiarazione X
	SUB1
	dichiarazione X
	...
	call SUB2
	...
	SUB2
	riferimento a X
```

Con scoping statico il riferimento a X si riferisce alla dichiarazione di MAIN (scope padre).
Con scoping dinamico il riferimento a X si riferisce alla dichiarazione di SUB1 (scope fratello, invocazione padre).

## Keyword local
Con lo statement `local` è possibile forzare il campo di visibilità di una variabile a locale. Questo statement è utilizzabile alla definizione o assegnazione della variabile.

Come ad esempio:
```bash
my_function() {
	local a=1
}

echo $a  # a non esiste
```

Senza sarebbe avvenuto questo:
```bash
my_function() {
	a=1
}

echo $a  # stampa a perchè scope globale di default
```

### Esempi
> In BASH lo scope è **dinamico**

Dichiarare una variabile locale significa avere una variabile che vive per il solo tempo di vita del blocco di codice. Se questa funzione ne invoca un'altra, la funzione invocata vede la variable dichiarata nello scope della funzione invocante.

```bash
f() {
	echo $x;
}

g() {
	local x=2;
	f;
}

X=1
g
```

Viene stampato *2*.

```bash
g() {
	echo $x;
	x=2;  # si riferisce allo scope di f
}

f() {
	local x=3;
	g;
}

X=1
f
echo $x
```

Viene stampato 3 e 1.

