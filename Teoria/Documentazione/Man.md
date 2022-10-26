# Man
Il comando `man` - manual - fornisce la documentazione per i comandi esterni.

Si utilizza così: `man VOCE`
Esempio: `man ls`

L'output del comando viene paginato con il comando `less`. Per navigare tra le pagine si utilizza:
- Up/Down/Right/Left per un movimento in 2D
- /PATTERN o /SEARCH per la ricerca nel manuale
- n passa alla prossima occorrenza
- N passa all'occorrenza precedente
- Ng passa alla riga N-esima. Ad esempio 1g va alla riga 1
- G fine file
- g inizio file
- h help inline di less
- q quit

Esempio regex per identificare un'opzione: `/^\s+`
- `^` matcha inizio riga
- `\s` insieme degli spazi
- `+` più volte

## Struttura di una pagina man
- sinopsi - in forma Backus-Naur
- nome - descrizione breve
- descrizione
- bugs - di sicurezza e prestazionali
- conforming to

## Sezioni del manuale
Con `man man` si possono recuperare tutte le sezioni del manuale:
1. comandi esterni ed binari vari
2. chiamate di sitema, ovvero servizi del sistema operativo
3. chiamate alle librerie di sistema
4. file speciali in */dev*

## Voci multiple
Una voce del manuale potrebbe essere presente in più sezioni del manuale.
In caso di omonimia viene scelta la voce della sezione con idx più piccolo.

Ad esempio `printf` è presente sia nella sezione 1 che nella sezione 3. Per disambiguare si passa il numero di sezione:
```bash
man 3 printf
```

Ricerca in più sezioni:
```bash
man -S 1,3 printf  # In alternativa s minuscolo; ":" al posto di ","
```

```bash
man -a printf
```
Mostra tutte le pagine in cui compare `printf` 

È necessario pagare per standardizzarsi POSIX. GNU Linux non segue lo standard POSIX.
Le sezioni 1p, 3p ecc. indicano le pagine conformi allo standard POSIX.

Si possono stampare tutte le pagine di manuale di una data sezione:
```bash
man -a -S 2 --regex '.*'  # Stampa tutte le pagine della sez. 2
```
La regex `.*` matcha tutto.

```bash
man -a -S 2 --regex '.*fork.*'
```
Mostra tutte le pagine che contengono la sottostringa `fork`

## Bash builtins
Le pagine di manuale delle distro Debian-based mettono a disposizione `man bash-builtins` che contiene sinossi e descrizione di tutti i comandi interni Bash.