## Gestione delle repository
Il file **/etc/apt/sources.list** contiene la definizione dei repository usabili dal SO Debian installato
il formato generico di una riga è il seguente: ```deb[-src] <URI> <distrib.> [componenti]...```

## Installazione e rimozione dei pacchetti binari

Per installare pacchetti, si utilizza il seguente comando (da amministratore)
```bash
apt install PACCHETTO1 PACCHETTO2 ...
```
Se apt install decide di installare più di un pacchetto, il comando opera in questo modo: 
- recupera tutti i pacchetti; 
- pre-configura tutti i pacchetti; 
- spacchetta tutti i pacchetti; 
- configura tutti i pacchetti; 
- post-configura tutti i pacchetti.
Lavora a "strati", prima fa un procedimento alla volta per tutti i pacchetti
Per rimuovere i pacchetti si utilizza
```bash
apt remove PACCHETTO1 PACCHETTO2 ...
```
L'opzione **--purge** di apt remove:
- effettua tutte le operazioni di apt remove
- cancella tutti i file di configurazione generati dagli script eseguiti dal pacchetto binario durante l'installazione
```bash
apt remove --purge PACCHETTO1 ...
apt purge PACCHETTO1 PACCHETTO2 ...
```
In seguito alla cancellazione di un pacchetto, APT cerca di capire se esistono pacchetti che non servono più a niente.
```bash
apt autoremove
```
Il comando ```apt clean``` rimuove i file * .deb dalla directory cache del sistema APT

## Ricerca e analisi dei pacchetti


```bash
apt search REGEX1 REGEX2 ...
```
stampa: 
- nome; 
- descrizione breve (una riga); 
di ciascun pacchetto che verifica le espressioni regolari
L’opzione ```--names-only``` esclude la descrizione breve del pacchetto dal parco stringhe da controllare.
Una volta identificato il nome esatto di un pacchetto, è possibile stampare i suoi metadati con il comando
```bash 
apt show PACCHETTO1 PACCHETTO2 ...
```
Le dipendenze dirette di un pacchetto possono essere stampate con il comando
```bash
apt depends PACCHETTO1 PACCHETTO2 ...
```
- I caratteri <> delimitano il nome di un pacchetto virtuale
- Il carattere | introduce l’OR di più pacchetti
Le dipendenze inverse di un pacchetto possono essere stampate con il comando
```bash
apt rdepends PACCHETTO1 PACCHETTO2 ...
```

Per calcolare il grafo delle dipendenze di un pacchetto (è consigliabile redirezionare l'output in un file .dot)
```bash
debtree --no-recommends --no-conflicts [pacchetto] > nome_file.dot
```
Per produrre un'immagine del grafo delle dipendenze
```bash
dot -Tsvg nome_file.dot > nome_file.svg
```

l comando apt-file permette di effettuare ricerche più sofisticate sui pacchetti
Per poter operare, apt-file usa un indice locale che associa un file al nome del pacchetto che lo contiene. L'utente deve aggiornare periodicamente l'indice con il comando seguente (lanciato da amministratore) ```apt-file update```
Per capire quali file sono forniti da un pacchetto software potete usare l'argomento list con l'opzione -x (ricerca di espressione regolare):
```bash
apt-file list -x '^libc6$'
```
Per capire quale pacchetto fornisce un file specifico potete usare l'argomento search con l'opzione -x
```bash
apt-file search -x '^/usr/bin/top$'
```

## Pacchetti binari speciali

- Un **metapacchetto** è un pacchetto che installa pochi file (tipicamente, documentazione) e dipende direttamente da un gruppo di pacchetti. Il suo scopo primario è quello di installare il gruppo di pacchetti.
- Un **pacchetto virtuale** è un pacchetto fantasma che, di per sé, non fornisce file, bensì una lista di pacchetti che possono soddisfarlo.
Il comando `update-alternatives` permetti di
- elencare tutti i pacchetti virtuali e l'alternativa di default corrispondente;
- elencare tutte le alternative di un pacchetto virtuale;
Il comando seguente elenca i nomi di tutti i pacchetti virtuali disponibili sul SO Debian
```bash
update-alternatives --get-selections
```
comando seguente elenca tutte i pacchetti alternativi già installati per un dato pacchetto virtuale sul SO Debian (ad esempio editor)
```bash
update-alternatives --list editor
```
Ad esempio, per cambiare l'alternativa di default dell'editor
```bash
update-alternatives --config editor
```
