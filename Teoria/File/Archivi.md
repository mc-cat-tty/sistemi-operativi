I SO UNIX mettono a disposizione strumenti per gentire gli archivi.
Sono presenti dalla notte dei tempi. Venivano inizialmente usati per memorizzare file oggetto in librerie statiche: file `.a` in formato *AR* -> venivano impacchettati più file oggetto `.o` con `ranlib`

L'evoluzione di questo formato è `tar` -> strumento principale per creare archivi sui SO UNIX
TAR viene sviluppato per memorizzare un archivio su più volumi.

> Un archivio è file che racchiude al suo interno una o più directory, preservandone la gerarchia originale e i permessi. Inoltre contiene una serie di checksum per rilevare e correggere errori (utile una volta per garantire l'integrità di archivi scritti su nastri ferromagnetici e suscettibili alla vicinanza di magneti). Ora servono per evitare il **tampering** di librerie distribuite dagli sviluppatori.

Gli archivi sono spesso compressi per risparmiare spazio; a volte criptati per preservare confidenzialità.

Gli archivi tar sono spesso chiamati *tarball*

## Tar
```bash
tar -f archivio.tar  # specifica archivio, ma non è ancora presente l'azione
```

Per la **creazione** di un archivio:
```bash
tar -c -f ARCHIVENAME FD1 FD2 ... FDn
```

| Opzione | Descrizione                                                                                              |
| ------- | -------------------------------------------------------------------------------------------------------- |
| -t      | Visualizza la tabella dei contenuti dell'archivio specificato con -f                                     |
| -x      | Spacchetta l'archivio specificato con -f                                                                 |
| -v      | Modalità verbosa: mostra i file manipolati durante estrazione o impacchettamento                         |
| -C DIR  | Cambia directory in DIR prima di procedere con le altre operazioni. Agisce solo sulle opzioni successive |

### Formati di compressione
In ordine di efficienza (dal più al meno comprimente):
| Opzione | Compressione            |
| ------- | ----------------------- |
| -J      | XZ - estensione .xz     |
| -j      | BZIP2 - estensione .bz2 |
| -z      | GZIP - estensione .gz   |

```bash
tar -z -f etc.tar.gz -c /etc
```

### Opzioni senza trattino
GNU Linux nasce  per essere retrocompatibile con tutti gli altri SO UNIX del passato.
>**Storia**
>Le due famiglie che nascono dalla diaspora UNIX sono **BSD** (minimalista, leggera) e **SYS-V** (barocca, completa di funzionalità)
>**GNU** ha ereditato le "stranezze" di entrambe le famiglie. Il kernel resta UNIX, mentre la *userland* è GNU.

È quindi valido anche:
```bash
tar zcvf tmp.tar.gz /tmp
```

Altri comandi del genere sono `ps` e `dd` (che non supporta opzioni con il trattino - formato BSD)

## 7z
È il coltellino svizzero per la gestione degli archivi: oltre agli archivi tar gestisce anche 7-zip, zip, rar, etc.

```bash
7z COMANDO <OPZIONI> ARCHIVENAME FD1 ... FD2
```

**Crezione**:
```bash
7z a ARCHIVE.7z DIRECTORY
```

| Opzione | Descrizione                                                               |
| ------- | ------------------------------------------------------------------------- |
| l       | Lista tabella contenuti                                                   |
| x       | Estrazione                                                                |
| -m      | Abilita opzioni aggiuntive come cifratura e algo di compressine specifici |

**Cifratura**:
```bash
7z -mhe=on -pKEY a ARCHIVE DIR1 ... DIRn
```
Dove KEY è una stringa tipo *password* (chiave simmetrica)