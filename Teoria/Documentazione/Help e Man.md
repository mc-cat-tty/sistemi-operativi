Bash mette a disposizione una serie di comandi per ottenere la documentazione dei comandi.

# Comando help
`help` fornisce una descrizione dei comandi builtin. Lanciato senza comandi lista la sinossi di tutti i comandi builtin.

`help CMD` fornisce informazioni sul comando *CMD* con la seguente struttura:
- sinossi in forma Back-MNaur
- descrizione breve
- descrizione estesa
- opzioni
- argomenti
- exit status

È possibile usarlo con un pattern: `help PATTERN` come, ad esempio, `help "b*"` che ritorna l'help di tutti i comandi che iniziano per b.

# Comando man
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

