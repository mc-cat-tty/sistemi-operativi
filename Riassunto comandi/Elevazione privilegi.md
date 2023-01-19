# Elevazione privilegi

Le azioni disponibili su un file non sono solo:
**r**: lettura
**w**: scrittura
**x**: esecuzione
Ve ne è un'altra, sostituta di x, applicabile alla prima terna nel caso di file.
**s**: esecuzione con i privilegi dell'utente creatore del file.

Il bit s prende il nome di set user ID (SETUID)

la situazione è uguale se il bit s è presente nella terna dei gruppi, semplicemente si chiamerà SETGID e eleverà i permessi al gruppo creatore

## Capability

```bash
man 7 capabilities
```

Siano:
P → un insieme di capability del processo prima del caricamento dell'immagine
P' → un insieme di capability del processo dopo il caricamento dell'immagine
F → un insieme di capability del file
M → una maschera di capability (inizialmente contenente tutte le capability) da cui il processo può depennare quelle che non vuole far ereditare ai suoi figli

> P'(permitted) = {(P(inheritable) & F(inheritable)) | (F(permitted) & M)}
> 

## Elevazione con SU

Il comando id stampa gli identificatori utente, di gruppo primario e dei gruppi secondari per uno specifico utente.

```bash
id [OPZIONI]... [UTENTE]
```

Il comando su esegue comandi generici con le credenziali di un altro utente

```bash
su
```

per caricare l’ambiente root è necessario però

```bash
su --login
su -l
su -
```

## SUDO

Prima di poter usare sudo, si rende necessaria la sua configurazione. La configurazione di sudo è contenuta nel file **/etc/sudoers**

```bash
sudo -l #specifica cosa può fare l'utente attuale
sudo -ll #uguale a -l ma con output prolisso
sudo -llU docente #specifica il nome di login dell'utente di cui 
#si vogliono ottenere i privilegi di lancio
```

si possono verificale le credenziali che otteniamo tramite il comando sudo con la seguente sinta

```bash
sudo id -r -u
sudo id -r -g
sudo id -r -G
```

L'opzione -u di sudo permette di specificare il nome di login dell'utente che eseguirà il comando

```bash
sudo -u prova id
```
L'opzione -g di sudo permette di specificare il nome del gruppo primario sotto cui si eseguirà il comando
```bash
sudo -u docente -g root id
```

##  Elevazione con SETUID/SETGID

Il comando chmod imposta anche i permessi SETUID e SETGID
```bash
chmod u+s #impostazione bit SETUID
chmod g+s: #impostazione bit SETGID 
chmod u-s #rimozione bit SETUID 
chmod g-s #rimozione bit SETGID
```

## Elevazione con Capability

GNU/Linux offre un ulteriore supporto per l'esecuzione con privilegi elevati: le capability. I due comandi usati per leggere ed impostare le capability sono **getcap** e **setcap**.

### getcap

```bash
getcap [OPZIONI] file
```
L'azione sulle capability è uno dei tre caratteri seguenti: 
- \+ → aggiunge le capability 
- \- → rimuove le capability 
- = → rimuove le capability considerate dagli insiemi effective, permitted ed inheritable, prima di impostarle.
Gli insiemi delle capability sono uno o più dei seguenti insiemi: 
- e → insieme delle capability effettive (effective) 
- p → insieme delle capability permesse (permitted) 
- i → insieme delle capability ereditate (inherited)

### setcap

comando setcap imposta le capability di un file
```bash
setcap [OPZIONI] CAPABILITY FILE
#esempio
setcap cap_net_raw+ep /path/to/ping
```
