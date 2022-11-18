## Mounting
Un disco secondario, prima di poter essere utilizzato, deve essere montato ad un fs esistente, usando una directory come punto di attacco (*mountpoint*).

Quindi il fs root (montato in */*) esiste sempre. Deve contenere almeno `/sbin/init`, che esegue le procedure di inizializzazione all'avvio del sistema.

```bash
mount -o options -t fs_type file_speciale mount_point
```

La directory `lost+found` è una directory creata dal fs ext4 nella directory di primo livello di un disco, che contiene i frammenti (blocchi) di file corrotti e non recuperabili.

Esempio:
```bash
mount /dev/sdb1 /mnt
```
Monto la partizione associata al file speciale `/dev/sdb1` in `/mnt`, una directory che nei primi sistemi UNIX nasce proprio con lo scopo di essere un mountpoint per le partizioni da montare.

## Visualizzazione fs montati
### mount
Per elencare tutti i fs montati: `mount -l [-t tipo]` oppure `mount`

Se la prima riga inizia con il file speciale di dispositivo, il fs in questione è montato a partire da un disco concreto. Altrimenti il fs è virtuale, quindi si trova in memoria; il alternativa è montato con la semantica dei tunable, dove ogni file cambia un file di configurazione del kernel (senza quindi scrivere sul disco).

`tmpfs` è un file system scratch (temporaneo) in cui vengono salvati file temporanei molto velocemente, perchè tmpfs si trova in ram.

`DISCO_CONCRETO/TIPO_VIRTUALE on MOUNTPOINT type TIPO (OPZIONI)`

Se `errors=remount-ro` -> il SO rimonta il fs in readonly se rileva degli errori, per evitare la corruzione del disco

Memento:
- A-TIME -> Tempo di accesso
- M-TIME -> Tempo di modifica
- C-TIME -> Tempo di crezione

Se l'ATIME venisse aggiornato ogni volta che il file è acceduto, il disco sarebbe da buttare dopo 10k accessi. In ossequio alla legge d'oro dell'ingegneria, sincronizzo il metadato una tantum, per esempio quando cambia il giorno, oppure quando spengo il sistema.

Il flag `relatime` fa questo. Sincronizza l'atime una volta al giorno, solitamente sul fronte di cambio.

### lsblk
Mostra i dispositivi a blocchi montati sul sistema, come albero, incolonnato.

I fs di loopback permettono di montare come fs un file o un fs distribuito su più partizioni.
Viene usato per esempio quando si vuole montare un'ISO come fs ISO9660

Vedi: `user-mode Linux`

## mountpoint
```bash
mountpoint directory
```

Ritorna se una directory è un mountpoint.
Utile nello scripting.

# Unmount
O *sgancio* di un disco: possibile se le sue risorse non sono in uso da un processo.

```bash
umount [special_file] [mount_point]
```

