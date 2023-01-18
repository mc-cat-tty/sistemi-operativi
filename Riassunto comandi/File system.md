# File system

## Dischi

per formattare e partizionare un disco inserito si utilizza il comando

```bash
fdisk /dev/[disco]
```

per creare un file system nel disco invece si utilizza il seguente comando

```bash
mkfs -t tipo_fs file_speciale_dispositivo
```

i file system vengono salvati in un formato del tipo mkfs.tipo_fs

## Montaggio dei dischi

### mount

Il comando mount permette di associare un supporto (file speciale, file contenente un file system) ad un mount point.

```bash
mount -o options -t fs_type special_file mount_point
#per esempio
mount -o ro -t ext3 /dev/sda2 /mnt
```

### lsblk

Il comando **lsblk** visualizza i file system memorizzati su supporti fisici o file, con annessi mount point.

```bash
lsblk
```

### mountpoint

Il comando esterno mountpoint controlla se una data directory sia un punto di aggancio oppure no

```bash
mountpoint /
```

### umount

```bash
umount [special_file | mount_point]
```

## Controllo dei dischi

In GNU/Linux, consistenza e riparazione di un file system sono gestite dal comando **fsck**.

```bash
fsck /dev/sdb1
```

il dispositivo deve essere sganciato prima di lanciare questo comando o si rischia il danneggiamento.