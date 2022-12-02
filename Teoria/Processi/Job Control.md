Esiste un meccanismo per identificare un gruppo di più comandi complessi? Se volessi terminare tutti i processi costituenti un comando complesso come dovrei fare? Posso continuare ad usare il terminale anche se lancio un processo molto lungo?

>Il **job control** è un meccanismo usato nei primi sistemi UNIX, in cui si aveva un solo terminale per tutte le operazioni, pensato per riuscire ad usare più applicazioni su un solo terminale.

Questo è stato reso obsoleto da strategie più moderne, come la creazione di un WM che permette di aprire più finestre, oppure `tmux` e `screen` che permettono di multiplexare più comandi.

# Pipeline
## Definizione Formale
Sequenza di comandi C1, ..., Cn legati da operatore di pipe (stdout o stderr, ovvero `|` o `\&`) nella forma:
```bash
C1 [ | or |&] C2 [ | or |&] C3 ... [ | or |&] Cn
```

## Under the hood
Ogni volta che viene lanciata una pipeline, 

## Gruppo di processi
Un *process group* o *job* è l'insieme di processi che partecipano ad una pipeline. Vengono identificati da un **PGID** - Process Group ID - comune.
PGID = PID del process group leader (ovvero l'ultimo processo della pipeline, che determina lo stato di uscita del comando)
Fino a quando almeno un processo della pipeline è ancora in vita, il PGID il suo job è definito.

Per lanciare anche un solo comando serve creare un process group.

## Sessioni
>**Sessione**: insieme di gruppi di processi che condividono lo stesso terminale

Una sessione è creata nel caso di login grafico o testuale, avvio di un server o su richiesta di un'applicazione.

Il primo processo lanciato in una sessione è **session leader**. La sessione è identificata da un **Session ID** - **SID**

Un gruppo di processi può trovarsi in due stati:
- **foreground** (primo piano). Un solo job può trovarsi in foreground e leggeree da STDIN
- **background** (secondo piano). Più job possono trovarsi in background e scrivere sul terminale.

Se un processo cerda cerca di leggere da STDIN riceve dal kernel SIGTTIN.

# Comandi
## Stop
Con Ctrl-z si può terminare la pipeline inviando SIGTSTP. Il risultato ottenuto è:
```bash
[jobId]+ Fermato CMD
```

Dove `+` rappresenta che è stato interrotto il job corrente (più nuovo)

```bash
jobs -l
```
Elenca tutti i job del gruppo corrente.

Un processo fermato rimane in questo stato.

L'operatore `&` messo in coda a una pipeline, la manda in background. La pipeline rimane in esecuzione, ma non può leggere da STDIN, altrimenti riceve SIGTTIN
```bash
sleep 7200 &
```
Vedo che questo processo rimane in esecuzione ma in background. Carattere assegnato: `-`

Vedi `set_current_job()` in `job.c` dal sorgente di Bash

## Foreground
Con il comando `fg`. Accetta come argomenti:
- %JOB_ID
- %CMD (primo comando della pipeline)
- %+ e %- (shortcut della pipeline in background)
- % -> equivale a %+

Tutti questi argomenti possono essere lanciati anche senza `fg` davanti

`fg` senza argomenti ripristina la pipeline con il `+`

## Background
Si usa il comando  `bg` -> stessa sintassi di `fg`

`bg` e basta esegue, in background, la pipeline a cui è stato assegnato il `+`

## Trappola
```bash
read a &
```

# Sostituzione
Operatore `$(CMD)` introduce la **sostituzione di comando**:
1. viene eseguito CMD
2. il risultato viene sostituito a questo costrutto

Esempio:
```bash
for i in $(seq 100); do
	echo "num: $i";
done
```

## Sostituzione di processo
Operatori `<(CMD)` e `>(CMD)` introducono la **sostituzione di processo**.

Si possono usare nel modo seguente:
```bash
CMD <(file1) <(file2)
```

Generazione dinamica dei file:
```bash
CMD <(comando che produce il contenuto di file1) <(comando che produce il contenuto di file2)
```

file1 e file2 non sono mai creati. Bash crea due descrittori di file in `/dev/fd/N` e `/dev/fd/N+1`

Dove N parte da 63

Quando CMD cerca di aprire i due file vengono legati a fd1 e fd2 lo STDOUT di processo1 e processo2 generati dai due comandi.

Esempio:
```bash
paste <(seq 1 100) <(seq 101 200)
```

Il `<` indica che l'output dei comandi nelle tonde viene bindato allo stdin del comando principale. Mentre `>` passa l'output del comando principale a dei sottocomandi.

I comandi della sostituzione di processo vengono eseguiti contemporaneamente.

Con `>(COMANDO)` l'output del comando invocante viene scritto una unnamed pipe, aperta in lettura dal comando interno alle parentesi. Il file descriptor bindato in scrittura alla stessa pipe, viene passato al comando invocante.

```bash
echo "ciao" | tee >(cat -)

# OUTPUT
# ciao
# ciao
```

La sostituzione di processo consente di evitare l'uso di file intermedi.

# Exec
Il comando interno `exec` sostituisce l'istanza corrente di bash (necessariamente interattiva) con l'immagine di un nuovo processo:
```bash
exec sleep 5
```

Sostituisce al processo corrente il processo avviato dal comando `sleep 5`, ragione indi per cui anche l'emulatore terminale in cui è eseguito questo comando termina dopo 5 secondi.

In generale abbiamo:
```bash
exec [opzioni] COMANDO
```

# Fork bomb
Obiettivo: DoS - Denial of Service ad altri utenti di una stessa macchina
Mezzo: spawnare figli di un processo in maniera ricorsiva
Perchè: innanzitutto si ruba tempo macchina ad altri processi leggitimi; in più il kernel prima o poi esaurisce i PID (descrittori di processo) a sua disposizione, rendendo impossibile l'esecuzione di un nuovo processo.

Fork bomb:
```bash
:(){ :|: & };:
```

Analisi:
- `:()` dichiara una funzione chiamata `:`
- `:|: &` è il corpo della funzione -> lancia due processi in pipe. questi processi sono creati dalla funzione `:`, quindi la dichiarazione è ricorsiva. La pipeline viene lanciata in background. Se il processo padre termina, i figli non vengono distrutti se sono in background -> il padre finisce l'esecuzione, ma i figli restano attivi.
- `;` separatore di comandi
- `:` invocazione della funzione appena definita