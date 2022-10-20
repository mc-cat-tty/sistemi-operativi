# Alias
## Esercizio
```bash
strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo
alias gp="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
```
Restituisce una stringa random di 30 caratteri.

# Funzioni
