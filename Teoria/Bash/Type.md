# Tipologie di comandi
- comando esterno: fornito da un eseguibile ricercabile nella lista PATH
- comando interno: fornito dalla shell (shell builtin)
- alias: abbreviano comandi più lunghi (solitamente)
- funzioni: blocchi di codice che contengono più comandi shell

Come faccio a identificarlo? Uso `type`:
```bash
type C1 C2 ... Cn
```
Dove ogni Cx è un comando. Esempio:
```bash
$ type ls help vim
ls is aliased to `ls --color=auto'  
help is a shell builtin  
vim is /usr/bin/vim
```
Discriminare tra i comandi in modo automatico:
- compare "alias" -> alias
- compare "builtin" -> comando interno
- non compare nessuna di queste sottostringhe -> comando esterno

## Omonimia dei comandi
È possibile che un comando interno ed esterno condividano lo stesso nome. Bash vuole fornire un ambiente completo, definendo tutti i comandi necessari; l'OS vuole fornire la sua implementazione del comando. Gran mischione.

Esempio:
```bash
/usr/bin/printf --help
printf --help
```

Lancio:
```bash
$ type printf /usr/bin/printf
printf is a shell builtin  
/usr/bin/printf is /usr/bin/printf
```

Posso disambiguare tra le omonimie con:
```bash
$ type -a printf
printf is a shell builtin  
printf is /usr/bin/printf  
printf is /bin/printf
```

Perchè printf è presente sia in */usr/bin* che in */bin*?
Prima i binari venivano memorizzati in:
- /bin binari di sistema
- /usr/bin binari non di sistema
- /sbin binari amministratore
- /usr/sbin binari utente non root

Problema: voglio condividere un binario tra più computer (filesystem condiviso) -> dovrei esportare 4 directory diverse

Sui sistemi operativi moderni hanno unificato i binari in /usr/bin

Posso verificare che in /usr/bin/printf e /bin/printf si trovano gli stessi binari con:
```bash
md5sum /usr/bin/printf /bin/printf
```

Possiamo definire un alias e una funzione con nome printf. L'esecuzione segue l'ordine che stampa `type -a` alias, funzione, builtin, esterno, ecc.

## Forzare comando

Si può "depennare" l'alias della lista con il quoting (debole o fort):
```bash
"printf"
```

Con `builtin` viene scelto il primo comando interno della lista:
```bash
builtin printf
```

Con `command` viene scelto il primo comando (sia interno che esterno della lista):
```bash
command printf
```

