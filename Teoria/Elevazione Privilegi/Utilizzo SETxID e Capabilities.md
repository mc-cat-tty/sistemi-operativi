# chmod
```bash
# Aggiunta
chmod u+s
chmod g+s

# Rimozione
chmod u-s
chmod g-s
```

# Capabilities
Comandi:
```bash
getcap FILENAME  # Eseguibile da utente normale
setcap FILENAME
```

## getcap
Posso elencare tutte le capabilities (in Debian) con:
```bash
/sbin/getcap /bin/* /sbin/* /usr/bin/* /usr/sbin/*
```

Attenzione: bash esegue l'espansione se riesce

Con `-r` posso abilitare la ricorsione:
```bash
/sbin/getcap -r / 2> /dev/null
```

Vedi: *towel.blinkenlights.nl*

Vedo che `ping` usa le capabilities. `ping` manda un **pacchetto forgiato** "a mano" senza passare per lo stack TCP/IP. Nelle vecchie versioni di `ping` bisognava essere *root*: solo un amministratore poteva inviare pacchetti arbitrari al buffer della scheda di rete.
Ora: basta la cap `/bin/ping = cap_net_raw+ep`
Dal 2015 i pacchetti di diagnostica ICMP sono stati inseriti nella sottofamiglia protocollare di IPv4.

Sulle nuove distro come Arch o Fedora non sono più concesse le capabilities.

A `ping` sono aggiunge le capabilities *effective* e *permitted*.

Usato in attacchi XMas e simili.

Output `getcap`: `comando = clausola1,...,clausolaN`
Ogni clausola è: `<capability><azione><insiemi>`
`<capability>` supporta la wildcard `all`
Le azioni sono:
- `+`
- `-`
- `=` caps pulite prima di assegnare quelle nuove
Gli insiemi sono:
- e Effettive
- i Inherited
- p Permitted

## setcap
```bash
setcap [OPZIONI] CAPABILITY FILE
```

Dove `CAPABILITY` ha il formato visto sopra.