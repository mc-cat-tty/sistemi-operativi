# id
```bash
id [OPZIONI] [USERS]
```

Stampa:
- uid
- gid -> id gruppo primario
- gruppi secondari
degli utenti passati come argomenti, oppure di quello correntemente attivo (che ha eseguito)

# su
`su` ovvero **Switch User** permette di cambiare l'utente. Bisogna conoscere la password dell'utente di arrivo.

Nella sua forma più semplice:
```bash
su
```

Si diventa root, poi viene eseguita una semplice shell Bash.

Problema: non si passa per la shell di login, quindi l'ambiente di *root* non viene caricato. Lo si può vedere con `export` dopo essere diventati `root`.

Soluzione:
```bash
su - [USERNAME]
```
Con l'opzione `-` viene caricato l'ambiente dell'utente destinazione

Oppure:
```bash
su -l [USERNAME]
```

In questo modo viene lanciata una shell di login, che esegue gli script per caricare l'ambiente.

La bash pura viene usata per eseguire gli script o altri comandi.

Esecuzione comando come altro utente:
```bash
su -c "CMD [OPTS] [ARGS]" -l [USERNAME]
```
Il quoting debole non è necessario se il comando non ha argomenti o opzioni.

Esempio - elencare solo file e dir nascoste nella home di root:
```bash
su -l -c "pwd; ls -lad .*" root
``` 

*Senza colpo ferire*: ottenere qualcosa senza bisogno di combattere/opporre resistenza
*Nocciolo duro*

Problema: con `su` bisogna chidere la password dell'utente di arrivo, ma non la si vuole distribuire a tutti gli utenti di una macchina.

# sudo
Tutti gli utenti del gruppo `sudores`, possono diventare root (o comunque utente di destinazione) senza conoscere la sua password: basta quella dell'utente di arrivo.

La configurazione di `sudo` è contenuta in `/etc/sudores`.

Se si sbaglia la configurazione, `sudo` smette di funzionare. Su distro come Ubuntu, dove la password di `root` è generata casualmente, mentre il primo utente configurato è sudoer, ci si traglierebbe fuori dal SO.

Per evitare questa eventualità esiste `visudo`, che non salva la configurazione finchè non è valida. In più usa un lock per regolare l'accesso al file di configurazione, utile nel caso in cui più utenti tentino di modificarla.