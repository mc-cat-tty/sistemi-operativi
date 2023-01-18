# Documentazione

## HELP

```bash
help
```

In questo modo, help stampa la sinossi (synopsis) di
tutti i comandi interni forniti da BASH.

```bash
help COMANDO
```

restituisce la documentazione formattata nel seguente modo

**Sinossi**. Sintassi in forma Backus-Naur.
**Descrizione breve.** Descrizione del comando in una riga.
**Descrizione estesa**. Descrizione del comando in uno o più paragrafi.
**Opzioni**. Elenco delle opzioni disponibili.
**Argomenti**. Descrizione degli argomenti.
**Valori di uscita**. Discussione del significato dei vari valori di uscita.

```bash
help PATTERN1 PATTERN2 ..
# esempio
help ”a*” ”b*” cd
```

## MAN

Il comando esterno man permette di accedere al sistema delle pagine di manuale

```bash
man VOCE
#esempio
man ls
```

esistono diverse tipi di pagina di manuale e sono denominate secondo numeri:

1.    Programmi eseguibili e comandi della shell
2. Chiamate al sistema (funzioni fornite dal kernel)
3. Chiamate  alle  librerie  (funzioni  all'interno  delle librerie di sistema)
4. File speciali (di solito trovabili in /dev)
5. Formati dei file e convenzioni
6. Giochi
7. Pacchetti di macro e convenzioni
8. Comandi per l'amministrazione del  sistema (solitamente solo per root)
9. Routine del kernel [Non standard]

è possibile selezionare la sezione che si vuole vedere

```bash
man 3 printf
#equivalentemente
man -S 3 printf
man -s 3 printf
```

le opzioni -s e -S accettano anche un elenco di sezioni

```bash
man -S 1,3 printf
man -s 1:3 printf
```

L’opzione -a di man consente di stampare tutte le
pagine di manuale individuate a seguito di una ricerca.

```bash
man -a printf
man -a -S 2 --regex ’.*’
```

## Ricerca di informazioni

Il comando esterno apropos cerca i nomi esatti delle
voci di manuale a partire da chiavi di ricerca testuali.

```bash
apropos KEY1 KEY2 … KEYN
```

la ricerca di base è in termini di OR, si può cambiare con l’opzione -a e farla in termini di AND

```bash
apropos -a KEY1 KEY2 … KEYN
```

```bash
apropos -s S1,S2,…,SN KEY1 KEY2 … KEYN #ricerca in voci di manuale specifiche
```