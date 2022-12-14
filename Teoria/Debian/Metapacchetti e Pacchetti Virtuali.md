# Metapacchetti
>Un **metapacchetto** è un pacchetto semplicissimo che contiene solotipicamente solo la documentazione. Il suo scopo è portarsi appresso le dipendenze del pacchetto. Serve a forzare l'installazione delle dipendenze.

Es: posso installare tutto l'ecosistema di Gnome o Kde con, rispettivamente, il comando:
```bash
apt install gnome
apt install kde-gnome
```

Posso capirlo con:
```bash
apt-file list -x '^kde-full$'  # Pochissimi file
apt depends kde-full  # Ho una marea di dipendeze, che installano tutot 
```

# Pacchetto virtuale
È un modello di pacchetto che fornisce una certa funzionalità.
È solamente un'astrazione, non può essere installato. Fornisce una lista di pacchetti candidabili per questa categoria.

Sono esempi di pacchetti virtuali:
- `browser`
- `editor`
- ecc.

Esempio:
```bash
apt show editor  # State: non un vero pacchetto (virtuale)
apt install editor  # Ritorna lista di pacchetti concreti della famiglia editor
```

Se faccio:
```bash
apt show vim emacs-gtk | less -Mr
```
Trovo che questi due comandi appartengono alla famiglia `editor`. Vedi campo **provides**.

## update-alternatives
```bash
update-alternatives --get-selections
# Oppure
update-alternatives --list editor  # Mi lista tutti gli editor che possono diventare editor di default
```

Con l'opzione `--config` posso configurare la catena di link. W: necessita di permessi di root, perchè deve modificare un link in `/bin`

Ogni opzione ha uno stato associato:
- manuale
- automatica -> 1 solo pacchetto alla volta può essere etichettato in questo modo

Può essere selezionato l'alternativa di default -> modalità manuale. Quando scelgo la modalità automatica, il SO sceglie il pacchetto etichettato come `modalità automatica`

A cosa serve questa roba? da programmatori si può usare un'astrazione che garantisca la presentza di un editor/browser/ecc.

Viene usato in programmi con `visudo`

Posso vedere i link con `ls -l /bin/editor` o `readlink /bin/editor`
Se uso `dpkg -S /bin/editor` vedo che non è un pacchetto concreto