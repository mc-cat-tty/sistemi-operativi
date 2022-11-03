# UNIX Link
I sistemi UNIX moderni consentono di creare un **collegamento a file**, che costituisce un nome alternativo al file **puntato**. Il link è una sorta di **puntatore** ad un file.

Usi tipici:
- fornire un percorso più breve da scrivere
- fare puntare ad un file ("interfaccia") una tra le molteplici alternative che lo implementano. Es: */usr/bin/X* -> */usr/bin/Xorg*

Il nome canonico di un programma rimane lo stesso, mentre l'implementazione può cambiare nel tempo.

## Tipologie di collegamento
### Fisico
Il **collegamento fisico**, o **hard link** è un nuovo elemento del fs che punta allo stesso contenuto del file originale. I due elementi del fs puntano allo stesso blocco di dati.

Under the hood: solitamente il disco viene organizzato con una prima porzione di **metadati** e una seconda porzione di **dati**. Nella parte di metadati, all'interno di ogni blocco, vengono puntati tutti i blocchi della sezione dati che contengono il file desiderato. Quando si crea l'hard link vengono copiati i puntatori ai dati del blocco precedente.

Attenzione: i collegamenti fisisci sono riestretti ad un unico fs.
Attenzione: non si può creare un hard link verso una directory superiore. Utilità come `find` stallerebbero a causa di questo loop.

### Simbolico
Il **collegamento simbolico** o **soft link** è un *nuovo file*, il cui contenuto è il percorso del file a cui voglio puntare. Il **blocco di controllo** punta ad un blocco dati diverso, che contiene la directory a cui puntare.

Attenzione: in questo caso non ho il problema dei loop, perchè posso disambiguare tra i due entry-point
Attenzione: posso anche creare un link ad un fs diverso

## Ln
Il comando `ln` permette di creare collegamenti (link):
```bash
ln TARGET LINK_NAME
```

Con `ls`, seconda colonna, posso vedere il numero di hard link al file stesso. L'hard link count vine incrementato sia per il link che per il file target.

Con l'opzione `-s` creo un link simbolico:
```bash
ln -s TARGET LINK_NAME
```

I link simbolici sono accessibili a tutti (hanno tutti i permessi possibili), perchè è il file target a determinare permessi effettivi.

Il contenuto di un link simbolico è grande quanto il percorso memorizzato dal link stesso.
