# Apropos
Riceve in ingresso N stringhe (chiavi di ricerca) ed effettua una ricerca, mettendo in OR le N chiavi, sulle voci e sulle descrizioni brevi delle pagine del manuale.
```bash
apropos KEY1 KEY2 ... KEYn
```

Per effettuare una ricerca in AND basta aggiungere l'opzione `-a`:
```bash
apropos -a KEY1 KEY2 ... KEYn
```

`apropos` fornisce una funzionalità simile a `man -S`, ovvero permette la ricerca delle chiavi in sezioni specifiche del manuale:
```bash
apropos -s S1, S2, ..., Sn KEY1 KEY2 ... KEYn
```

Ricerca con pattern matching:
```bash
apropos -r '.*create.*process.*'
```

