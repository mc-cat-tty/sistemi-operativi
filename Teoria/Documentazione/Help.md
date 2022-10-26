Bash mette a disposizione una serie di comandi per ottenere la documentazione dei comandi.

# Help
`help` fornisce una descrizione dei comandi builtin. Lanciato senza comandi lista la sinossi di tutti i comandi builtin.

`help CMD` fornisce informazioni sul comando *CMD* con la seguente struttura:
- sinossi in forma Back-Naur
- descrizione breve
- descrizione estesa
- opzioni
- argomenti
- exit status

È possibile usarlo con un pattern: `help PATTERN` come, ad esempio, `help "b*"` che ritorna l'help di tutti i comandi che iniziano per b.
