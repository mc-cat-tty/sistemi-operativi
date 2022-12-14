# Repos
```
https://ftp.COUNTRYCODE.debian.org/debian
```

Sono tutti **mirror** del server FTP originale americano (con COUNTRYCODE = us)

## Struttura
- *dists*: 
- *pool* - raccoglitore di software, divisi in sottodir:
	- *main* -> pacchetti principali compliant con DFSG
	- *non-free* -> non-compliant con DFSG
	- *contrib* -> codice compliant che dipende da codice non-free
- ...

Esistono 60M pacchetti -> folle metterli tutti in una directory.
Viene usato l'hashing per organizzare i pacchetti.
All'interno di ogni cartella si trova:
- pacchetti binari **.deb**
- sorgenti

## Caricamento
Periodicamente vengono votati i pacchetti che possono essere ammessi. Lo sviluppatore deve caricare il pacchetto in *incoming* tramite SFTP. Viene applicato un filtro che elimina pacchetti malformati o non firmati digitalmente. 

Experimental: unstable di unstable

**IceCat**: Firefox non usava software free, quindi è stato strippato da tutta la telemetria proprietaria.

### Passaggio da unstable a testing
Il passaggio non è automatico.

1. il pacchetto rimane in unstable per almeno 5 giorni, in modo che gli utenti più esperti possano provarlo e creare dei bug report
2. il pacchetto non deve avere un numero di **release-critical bug** maggiore di quello che il pacchetto in testing ha al momento.
	**release-critical bug**: bug che impedisce il rilascio della successiva versione di Debian
3. il pacchetto deve essere compatibile e sicuro su ogni architettura
4. tutte le dipendenze del pacchetto (ovvero tutti gli altri software necessari per la sua esecuzione) deve soddisfare i requisiti per **testing**
5. l'installazione del pacchetto non deve corrompere l'installazione di altri pacchetti. Es: il mio pacchetto non deve sovrascrivere `/etc/profile` -> avrei un sistema non deterministico

## Freeze
Nel periodo immediatamente precedente al rilascio di una nuova versione **stable**
La distro passa da testing a **freeze** -> sono permessi solo aggiornamenti di tipo correttivo.

W: mai installare Debian unstable il giorno immediatamente successivo alla pubblicazione della versione stable. Il repo è pieno di mer\*a.

## Rilascio distribuzione stable
Il **Release Manager**, capo del **Release Team**, pubblica periodicamente le linee guida per il rilascio della nuova versione **stable**.

Vedi: frattura dei debianisti quando si cercò di introdurre GNOME3 -> venne creata una versione classica. Da cui poi si evolsero MATE e altri window manager tradizionali.

Vedi: https://bugs.debian.org e https://bugs.debian.org/release-critical/

Andamento a dente di sega, con trend che decresce. Il dente di sega si alza man mano che vengono inseriti pacchetti pieni di bug. Con una periodicità di 2 anni il *bug count* torna a zero (appena prima del rilascio di una versione stable).

# Pacchettizzazione
Un pacchetto Debian ha il formato `.deb`, formato di archiviazione antesignano di tar, una sorta di immagine del filesystem

Gestione:
- DPKG - scritta nel 1993 da Ian Jackson
	non gestisce le dipendenze, vanno installate a mano
- APT - Advanced Packaging Toolking, riscritta da Brian White nel 1998
	fa tuttto quello che non faceva DPKG

Configurazione nel file */etc/apt/sources.list*
È un elenco di righe, dove ogni riga rappresenta un repository.
Formato generico di una riga: `deb[-src] <URI> <distrib> [componenti] ...`

## Primo campo
Stringa, può assumere due valori:
- `deb` -> pacchetto già pronto
- `deb-src` -> sorgente applicazione, modifiche di Debian. Genera la codebase, si compila e si installa

## Secondo campo
URI - Uniform Resource Indicator -> generalizzazione di un URL di una pagina web.
Formato: `protocollo:sorgente`

## Terzo campo
Definisce la distribuzione da usare:
- **stable**
- **sid** -> uguale ad **unstable**; il nome deriva da Toy Story
- **testing**

Oppure è possibile fissare il sistema sua una distribuzione specifica come **jessie** o **wheezy**.

Negli altri 3 casi il sistema evolve in modo dinamico.

## Quarto campo
Componenti della distribuzione da abilitare.
Valori:
- **main**
- **non-free**
- **contrib**

Nota: il repo *ftp* normale e il repo *secuurity* con priorità degli aggiornamenti più alta (ci vuole meno tempo )

Vedi: https://en.wikipedia.org/wiki/Log4Shell

## Update
Esempio:
```bash
deb http://ftp.it.debian.org/debian bullseye main non-free contrib
deb-src http://ftp.it.debian.org/debian bullseye main non-free contrib

deb http://security.it.debian.org/debian bullseye-security main non-free contrib
deb-src ...

... // bullseye-updates
```

Tra tutti e 3 i repo, viene installata di default la versione più nuova.

W: 401 se non si è loggati sul proxy. 404 file not found.

Con `apt update` si sincronizzano i metadati di ogni componente del repository. Sotto le pezze usa `curl` per scaricare tramite protocollo HTTP i pacchetti.

I repo scaricati vengono memorizzati in `/var/lib/apt/lists/`
Ogni repo contiene diversi file, con prefisso *NOME_PACKAGE*:
- *packages* descrizione di ogni pacchetto in binario
- *sources* descrizione del sorgente di ogni pacchetto
- *translation* traduzione delle descrizioni nelle lingue abilitate
- *release* contiene l'hash MD5 o SHA256 di ogni file del repository
- *release.gpg* contiene la firma digitale del mantainer del repository, per garantire integrità e autenticità

Vedi: `strace -e openat apt update` -> viene aperto 

Ogni sviluppatore ha in mano una chiave privata segreta; gli utenti posseggono la chiave pubblica di ogni sviluppatore del progetto. Il developer calcola l'hash della repo, firma l'hash con la sua chiave privata; l'utente scarica la repo, si salva l'hash, decifra quello dello sviluppatore, poi li confronta.

## keyring
In Debian la gestione delle firme degli sviluppatori è un incubo. Vengono messi a disposizione degli script per scaricarle.

Vedi: `debian-keyring`

## install
```bash
apt install PKG1 PKG2 ... PKGn
```

Funziona per *livelli orizzontali*:
1. risolvo le dipendenze e le scarico
2. pre-configurazion (script)
3. installazione
	1. spacchettamento
	2. configurazione
4. post-configurazione (script)

Nota:
- installazione **orizzontale** -> preconfig di tutte le dipendenze, installazione di tutti, postconfig di tutti
- installazione **verticale** -> tutte le dipendeze vengono risolte (preconfig, intsallazione, postconfig) una per volta; avviene l'installazione del pacchetto corrente; poi la sua post-configurazione

Utilizzo:
- update
- install -> scarica i keyring dello sviluppatore, ma non verifica che la chiave sia rispettata
- update -> questo update serve per verificare le chiavi sul pacchetto appena installato

## remove
```bash
apt remove PKG1 PKG2 ... PKGn
```

Rimuove solo il pacchetto, ma non i file di configurazione.

Con l'opzione `--purge` vengono rimossi anche i file di configurazione.
Alternativa:
```bash
apt purge PKG1 PKG2 ... PKGn
```

### Esempio di purga
Vedi: runlevel UNIX
```bash
ls -ld /etc/rc*  // trova dir come /etc/rcN.d doe N va da 0 a 6
```

UNIX definisce diversi livelli di esecuzione -> ad ognuno è associata una serie di servizi

All'interno di queste directory ci sono diversi script con le azioni da eseguire per ogni comando. Solitamente è organizzato in:
```bash
case $1:
	start)
	;;
	stop)
	;;
	reload)
	;;
```
Ovvero i verbi di `service`

Vedi: UNIX System 5 -> `service` (ora rimpiazzato da `systemd`)

S maiusolo sta per start, mentre K sta per killed.

Demo:
1. installo `lm-sensors`
2. trovo `/etc/rcS.d/S01lm-sensors`
3. `apt remove lm-sensors`
4. trovo ancora il file di prima
5. `apt install lm-sensors && apt purge lm-sensors`
6. non trovo più il file

## Autoremove
Può ancora capitare che rimangano installati sul sistema alcuni pacchetti, non più necessari perchè dipendenze di pacchetti non più disponibili. Pacchetti a *broccoli*.

```bash
apt autoremove
```

Oppure

```bash
apt autoremove --purge PKG
```

Come visualizzre i pacchetti che mettono sotto *controllo di revisione* una directory:
```bash
dpkg -S /etc/apache2/mods-available/
```
L'accesso a risorse condivise da più pacchetti viene gestito con la strategia del **reference-counting**

## Archives
Dove sono i pacchetti scaricati?
In `/var/cache/apt/archives` -> directory cache in cui vengono scaricati i pacchetti. Installazione offline.

Traccia esecuzione con `strace -e openat apt install tmux`

Spazio utilizzato `du -sh DIR`  (summary human readable)

## Clean
```bash
apt clean
```
Rimuove i file `.deb` dalla directory cache `/var/cache/apt/archives/`

Confronta il prima e il dopo di questa cartella con `du -sh`

## Upgrade
Aggiorna tutti i pacchetti alla versione più nuova.

```bash
apt upgrade
```

Per aggionare alla nuova distribuzione (solo se nel file `sources.list` si usa il nome esatto di una distribuzione):
```bash
apt full-upgrade
apt dist-upgrade  # per ragioni di compatibilità
```

Vedi: `apt moo`

## Ricerca
```bash
apt search REGEX1 REGEX2 ... REGEXn
```

Esempio:
```bash
apt search '^tmux.*$'
```

Cerca nei nomi dei pacchetti e nelle loro descrizioni. con `--names-only` ricerco solo all'interno dei nomi.

## Show
```bash
apt show PKG
```

Mostra i metadati del pacchetto

Un campo notevole è **depends** (visibile anche con `apt depends PKG`) -> dipendenze

Il modello di installazione orizzontale di `apt` può comporatre problemi.
Es: voglio installare `bash`, ma prima i 
Per rompere il modello orizzontale e utilizzare un approccio verticale sono state introdotte le **pre-dipendeze**.
Analisi dipendenze dirette di un'applicazione (necessarie per utilizzo, non compilazione):
- pre-dipendenza -> la predipendenza serve già per la fase di installazione, non solo per quella di esecuzione
- diepnde -> dipendenze per la fase di esecuzione
- conflitti -> pacchetti che non possono essere installati (solitamente da/fino ad una certa versoin) contemporaneamente al pacchetto corrente. Può succedere ad esempio che un pacchetto sovrascriva il file di configurazione di un'altro
- raccomanda -> versione alternativa per risolvere i conflitti
- consiglia -> solitamente è il pacchetto `PKG-doc` che mette a disposizione le pagine di manuale di un comando
- sostituisce -> mitiga il  "va in conflitto"

### Caratteri speciali
- `|` retaggio dal LISP, mette i pacchetti in OR. Es: `libreoffice-avmedia-gstreamer` OR `libreoffice-avmedia-vlc` -> backend
- `<>` dipendenze virtuali (pacchetti binari speciali)

## rdepends
```bash
apt rdepends PKG1 ... PKGn
```

Mostra le dipendenze inverse di un pacchetto, ovvero tutti quei pacchetti che hanno bisogno di esso per funzionare. Visualizzo le frecce uscenti dal grafo.

## Visualizzazione dipendenze
```bash
apt install debtree graphviz
```

```bash
debtree --no-reccomends --no-conflits bash
```
Stampa un grafo in formato `.dot`

`graphviz` può rappresentare grafi a partire dal formato `.dot`
Usiamo il comando `dot` all'interno del suo pacchetto.

```bahs
dot -Tsvg bash.dot > bash.svg
```


# Naming pacchetti
## Librerie
- Offrono librerire dinamiche (`.so`) i pacchetti che iniziano con `lib` e non terminano con:
	- `dev`
	- `dbg`
	- `doc`
- `libXXX-dev` offrono la versione statica della libreria `.a` -> per chi vuole compilare staticamente il proprio eseguibile
- `libXXX-doc` documentazione di librerie
- `libXXX-dbg` tabella dei simboli in formato Dwarf (per facilitare debugging)
Es: `libc6-dbg` offre la tabella dei simboli della libreria standard del C, interpretabile da debugger come GDBs

W: libreoffice non è una libreria dinamica

Vedi: `ddd` e `gdb`

# apt-file
Pacchetto esterno. Motore di ricerca che contiene tutte le associazioni nome di pacchetto e file che contengono quel nome. Non solamente tra i pacchetti installati.

```bash
apt install apt-file
apt-file update  # inizializzazione dell'indice (database) di apt-file
```

## Ricerca File con Regex
Cerco file a partire dal pacchetto:
```bash
apt-file list -x '^libc6$'
```

## Ricerca Pacchetti con Regex
Cerco pacchetti a partire dai file:
```bash
apt-file search -x '^/usr/bin/top$'
```

Cerco quali pacchetti mettono a disposizione un certo file.

Esempio:
```bash
type -a dd
apt-file search -x '^/bin/dd$'
```
Risultato: `coreutils: /bin/dd` -> il comando dd è contenuto in coretuils
