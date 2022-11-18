Problema: si vuole controllare lo stato di un filesystem. Ci sono blocchi pending? Blocchi allocati ma non referenziati? inode che puntano ad aree corrotte?

```bash
fsck.fs_type /dev/specialfile
```


Il controllo avviene automaticamente al boot se il fs non è stato smontato correttamente, manualmente dall'amministratore.

Attenzione: il fs deve essere smontato
Attenzione: bisogna essere nel gruppo disk o amministratori

Controllo funzionamento disco hw: fsck scrive sul blocco, calcola checksum, verifica che il checksum sia coerente. I blocchi che non funzionano vengono marchiati con **bad blocks**

`fsck` è un wrappper che chiama `fsck.fs_type` dove `fs_type` è dedotto in automatico.

Solo controllo bad blocks: opzione `-c`

## Risorse in uso
Risorse in uso da un utente: `lsof -u studente`
Risorse tcp in uso: `lsof -t`
