Il disco non è altro che un contenitore di blocchi (settori circolari) da solitamente 512 bytes, presentati in modo contiguo al fs.
Il fs a sua volta definisce la dimensione di un blocco, per convenzione 4Kb. Questi blocchi sono rimappati trasparentemente in settori circolari o blocchi di diversa dimensione in base alla rappresentazione hw.

Il disco viene diviso in due aree:
- metadati -> rappresentazione del fs
- dati

L'area metadati contiene tutte le strutture di controllo, descrittive di file e directory, che puntano verso l'area dati.

Un disco nuovo non contiene tutto questo.
**Formattazione**: creazione delle strutture di controllo rappresentative del fs. Equivale all'atto di creare il grafo che lo rappresenterà.

Ogni partizione è gestita da un fs separato sul disco. Più partizioni non si intersecano.

Posso creare una partizione a cavallo di più dischi fisici:
Due soluzioni:
- RAID - Redoundant Array of Indipendent (Inexpensive) Disk
- LVM - Logic Volumes (volumi logici)

Contenuto fs:
- grandezza
- tabella blocchi in uso e blocchi liberi
- inode file e directory

