# Cat
```bash
cat /etc/passwd
```
Stampa tutte le righe del file passato.

| Opzione | Descrizione                                                    |
| ------- | -------------------------------------------------------------- |
| -E      | Mostra il fine riga                                            |
| -T      | Mostra le tabulazioni come ^I                                  |
| -v      | Permette di rappresentare caratteri non stampabili (non ascii) |

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
Nei SO operativi moderni il tasto META è scomparso, ma sopravvive con <Alt>-<Tasto>, a volte chiamato <META>-<Tasto> o <M>-<Tasto>. Nelle pagine di manuale ci si riferisce a <Ctrl>-<Tasto> con <C>-<Tasto>