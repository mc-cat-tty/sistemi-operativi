# History
Bash è dotato di un meccanismo per salvare la history dei comandi lanciati, in modo da evitare di riscrivere più volte comandi complessi.
Per recuperare tutta la history basta lanciare:
```bash
history
```

## Configurazione
Per diminuire il numero di scritture su disco, la command history della sessione corrente viene appena al file *.bash_history* (file di log della history) quando si esce dalla sessione Bash corrente.

La variabili di ambiente relative alla Bash history sono quelle che iniziano con la stringa *HIST*:
- HISTFILE: percorso del file di log
- HISTFILESIZE: nmero massimo di righe memorizzabili nel file di log
- HISTSIZE: numero massimo di comandi salvabili nel file di log alla fine di ogni sessione di lavoro
- HISTIGNORE: lista di pattern di comandi da ignorare

## Argomenti di history
- `history N` stampa gli ultimi N comandi contenuti nel buffer
- `history -c` cancella il buffer temporaneo della sessione corrente
- `history -w` commit del buffer sul file di log
- `history -a` appende il buffer sul file di log
- `history -r` comandi correnti appesi alla fine del buffer

## Fix Command
Con `fc` - fix command - permette modifica e salvataggio sul file dell'ultimo comando.
```bash
fc -e vim  # forza l'utilizzo di un editor
```

Posso recuperare un comando preciso presente nella history:
```bash
fc N   # Edit N-esimo comando
fc -N  # Conteggio comandi all'indietro
fc S   # Edito ultimo comando che inizia con la sottostringa S
fc N1 N2  # Edito i comandi da N1 a N2
fc S1 N2  # Edito i comandi dal primo match di S1 a N2
fc N1 S2  # Edito i comandi da N1 al primo match di S2
```

Uscendo senza errori dall'editor il comando viene eseguito e, di conseguenza, viene aggiunta una entry alla history. Posso uscire con errore per non eseguire il comando (`:cq` in vim)

`fc -l` accetta tutti gli argomenti visti fin'ora stampando i comandi, senza editarli.
`fc -s` esegue un comando (con tutti gli arg visti prima)

`fc -s [pattern=substitution] [S|N]`
- pattern in forma Backus-Naur
- Stringa o Numero di comando

Cosa fa?
1. individua il comando specificato dal secondo argomento
2. sostituisce pattern con substitution
3. esegue il comando risultante (e di conseguenza lo inserisce le buffer)

