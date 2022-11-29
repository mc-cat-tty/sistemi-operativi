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

