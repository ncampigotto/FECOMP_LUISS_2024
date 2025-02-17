////////////////////////////////////////////////////////////////////////////////
/////////////// FONDAMENTI DI ECONOMIA COMPORTAMENTALE (CANALE A) ///////////
//////////////////////// LEZIONI STATA 23-27 SETTEMBRE 2024 ////////////////////////
///////////// ******Emma Manneschi e Maria Paola Pagliarulo******* ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


***Scaricate questo do file e salvatelo in una nuova cartella chiamata "Stata". Poi, aprite il file direttamente da quella cartella.

*********************************
* PREPARARE L'AMBIENTE IN STATA *
*********************************

*Comandi utili: clear, set, use, webuse, sysuse, import, describe, browse

**Prepara l'ambiente in Stata
clear all  // Questo comando rimuove tutto dalla memoria. Fallo SEMPRE all'inizio del tuo do-file.
set more off   // Questo comando assicura che non ci si fermi per i messaggi "--more--" (messaggi di Stata che ti informano che ha qualcosa di più da mostrarti, ma che mostrandotelo farà scorrere via le informazioni sullo schermo)


**Carica il dataset (in questo caso con il comando "sysuse",; se invece è salvato nella tua directory di lavoro si usa il comando "use")
sysuse auto2                 // Questo dataset contiene informazioni sulle automobili vintage del 1978 vendute negli Stati Uniti


*************************
* COMPRENSIONE DEI DATI *
*************************

*Comandi utili: browse, describe, summarize, count, tabulate
**Visualizzare il dataset (puoi farlo anche tramite l'icona della tabella con la lente di ingrandimento in alto a sx)
browse
**Descrivi il dataset
describe

**Il comando "summarize" mostra una varietà di statistiche riassuntive. L'opzione "detail" mostra ulteriori statistiche (come i percentili).
summarize price
sum price, detail

/* Esploriamo come usare la condizione "if". L'"if" alla fine di un comando significa che il comando deve usare SOLO i dati specificati.
Se hai OPZIONI specificate dopo la virgola (come l'opzione "d" in questo caso) ricordati di mettere l'"if" PRIMA della virgola.
*/

sum price if price<5000 // Voglio conoscere le statistiche riassuntive del prezzo per le auto con prezzo inferiore a 5000
sum price if price<=5000 // L'output è identico a quello precedente perché NON ci sono osservazioni con prezzo esattamente pari a 5000
sum price if price<=5079 // In questo caso l'output è diverso perché c'è UNA macchina che ha un prezzo di 5079
sum price if rep78==2 // Ricorda, l'if con una condizione di uguaglianza richiede un doppio segno di uguale

**Esploriamo il comando count
// Conta il numero di automobili straniere
count if foreign==1
// Conta il numero di automobili domestiche
count if foreign==0
// Conta il numero di auto almeno "sufficienti"
count if rep78>=2

**Giochiamo con gli operatori logici "AND" e "OR". Usiamo "sum" come comando principale (ma questa logica si applica a qualsiasi comando)
sum price if price<5000 & rep78==2 // "economiche" E "sufficienti"
sum price if price<5000 | rep78==2 // "economiche" O "sufficienti"
sum price if price<5000 | rep78>=3 // "economiche" O "almeno medie"
sum price if price<5000 & foreign==1 | rep78>=3 & foreign==1 // "economiche E straniere" O "almeno medie E straniere"
sum price if price<5000 & rep78==1 | price<5000 & rep78==2 // "economiche E scarse" O "economiche E sufficienti"
sum price if price<5000 & (rep78==1 | rep78==2) // Questo è un modo equivalente PIÙ COMPATTO per scrivere quanto sopra!!!

**Tabulate: si usa principalmente per variabili categoriali e mostra, per ogni modalità di una variabile, la sua frequenza assoluta, relativa e cumulata.
tab rep78
tab foreign
by foreign: tab rep78 // Questo ti dà DUE output: uno per le auto straniere (foreign = 1) e uno per le auto domestiche (foreign = 0)

*********************
* GESTIONE DEI DATI *
*********************

*Comandi utili: order, sort, gsort, bysort, rename, gen, replace, label var/define/values, drop, keep, save

****

/*order viene utilizzato per riorganizzare le variabili del dataset senza alterarne i dati. Se non viene specificato nulla, la variabile indicata sarà spostata alla prima posizione. Con le opzioni before e after, si può posizionare una variabile prima o dopo un'altra nel dataset.*/

order foreign // Senza specificare le opzioni "before" o "after", order mette la variabile come PRIMA colonna nel dataset.
order foreign, after(rep78) // Puoi usare l'opzione "after"
order rep78 foreign, before(price) // Puoi usare l'opzione "before". Inoltre, puoi sempre specificare più variabili da ricollocare

/***sort riordina le osservazioni del dataset in base ai valori crescenti di una o più variabili. Se si specificano più variabili, il dataset viene ordinato prima rispetto alla prima variabile, e in caso di parità, rispetto alla seconda, e così via. 
*/

**Ordinare le variabili
sort price // Dispone le osservazioni in ordine crescente in base ai valori del prezzo
sort make // Dalla A alla Z
sort make rep78 // Dalla A alla Z "E" dalla condizione peggiore alla migliore... Che è diverso da...
sort rep78 make // Quindi: l'ordine conta!

/*A differenza di sort, gsort permette di indicare se ogni variabile deve essere ordinata in modo crescente (+) o decrescente (-). È utile per ordinamenti complessi e per le variabili stringa.*/
gsort -price // Dispone le osservazioni in ordine decrescente in base ai valori del prezzo
gsort -make // Funziona anche per variabili "stringhe". Questo dispone le osservazioni dalla Z alla A

**Bysort: esegue il comando (in questo caso "summarize") per ciascun gruppo specificato separatamente (in questo caso "auto straniere" e "auto domestiche")
bysort foreign: summarize(mpg)

**Rinominare le variabili
rename rep78 rep // Rinomina la variabile "rep78" in "rep"
rename headroom space_above_head // NON USARE SPAZI NEI NOMI DELLE TUE VARIABILI. Se una variabile è composta da più parole, collegale con "_"
rename turn turn_circle

**Generare nuove variabili e sostituire valori
gen domestic=. // Genera una nuova variabile numerica chiamata "domestic"
replace domestic=1 if foreign==0 // "domestic" assume valore "1" quando "foreign" assume valore "0"
replace domestic=0 if foreign==1 // domestic = 0 solo per quelle osservazioni la cui variabile "foreign" è uguale a 1

**Generare nuove etichette
label var domestic "L'origine dell'auto è USA" // Assegna un'etichetta a una variabile
label define domestic_lab 0 "Non USA" 1 "USA" // Crea un set di valori numerici e le loro etichette corrispondenti
label values domestic domestic_lab // Assegna le etichette definite in "domestic_lab" ai valori della variabile "domestic"

**Eliminare variabili
gen pippo=.
drop pippo 


**Ma puoi anche eliminare OSSERVAZIONI. ATTENTO A COSA ELIMINI! Tornare al dataset originale ogni volta è costoso.
**Eliminiamo le osservazioni delle auto super costose. Forse possiamo affermare che sono outlier e per un tipo specifico di analisi che stiamo facendo, non ne abbiamo bisogno.
drop if price>14000

**Puoi anche usare "keep"
keep if price <14000 // Questa riga di comando otterrebbe lo stesso risultato di prima. Ora abbiamo già eliminato le 2 osservazioni, quindi non si verifica alcuna eliminazione effettiva.


**Salva il nuovo dataset attualmente in memoria su disco.
save auto_new.dta, replace //Se non specifichi il formato, l'estensione predefinita utilizzata è ".dta". Usa l'opzione replace per sovrascrivere i tuoi dati.

********************
*DESCRIVERE I DATI *
********************

/*
Il comando "Tabstat" mostra le statistiche riassuntive per una serie di variabili numeriche in una tabella.
Ti permette di specificare l'elenco delle statistiche da mostrare con l'opzione "statistics" (abbreviata in "s").
*/

tabstat price, s(mean) // Questo mostra la media della variabile price
tabstat price, s(mean sd p50 min max N) // Questo mostra la media, la deviazione standard, la mediana, i valori minimo e massimo, e il numero di osservazioni della variabile price
tabstat price mpg rep weight, s(mean sd p50 min max N) // Puoi chiedere a tabstat di mostrare statistiche per PIÙ variabili
tabstat price mpg rep weight, s(mean sd p50 min max N) by(foreign) // Usa l'opzione BY per visualizzare statistiche per ogni variabile di gruppo. In questo caso avremo due tabelle: una per le auto straniere e una per le auto domestiche.

***********************
* VISUALIZZARE I DATI *
***********************

**Gli istogrammi vengono utilizzati per visualizzare la distribuzione di una variabile continua: ogni barra rappresenta il numero (o la frequenza) di osservazioni che rientrano in un certo intervallo
hist price, frequency //L'istogramma mostra il numero effettivo di osservazioni (frequenza assoluta) in ogni intervallo di prezzo
hist price, frequency kdensity //Aggiunge una curva di densità kernel sopra l'istogramma. La curva di densità è una rappresentazione liscia della distribuzione dei dati, utile per visualizzare la forma della distribuzione in modo più fluido
hist price, frequency kdensity color(stc1%70) lcolor(navy) kdenopts(lc(stc2)) title("Distribuzione del prezzo") name(hist_1, replace) 
graph save hist_1.gph, replace
/*Opzioni: 
color(stc1%70): Imposta il colore delle barre dell'istogramma su un colore predefinito (stc1) con il 70% di trasparenza.
lcolor(navy): Imposta il colore del contorno delle barre su blu scuro (navy).
kdenopts(lc(stc2)): Cambia il colore della curva di densità (kernel density) in un colore predefinito (stc2).
title("Distribuzione del prezzo"): Aggiunge il titolo "Distribuzione del prezzo" al grafico.
name(hist_1, replace): Assegna il nome hist_1 al grafico salvato in memoria. 
replace consente di sovrascrivere un grafico con lo stesso nome esistente.
Salviamo il nostro istogramma in formato ".gph" (il formato Stata per i grafici)
*/

// Il comando twoway permette di combinare più grafici all'interno di uno solo. In questo caso, vengono creati due istogrammi sovrapposti: uno per le auto domestiche (origine USA) e uno per le auto straniere
twoway (hist price if foreign==0, frequency fcolor(none) lcolor(stc1)) (hist price if foreign==1, frequency fcolor(none) lcolor(stc2)), title("Distribuzione del prezzo") legend(lab(1 "Origine USA") lab(2 "Origine straniera"))

// Salviamo il nostro istogramma in formato ".gph" (il formato Stata per i grafici)
graph save hist_2.gph, replace

**Grafici a dispersione. Sono utili per indagare la relazione tra due variabili.
scatter mpg weight // Esploriamo la relazione tra il consumo di carburante e il peso di un'auto
scatter mpg weight, title("Consumo di Carburante vs. Peso del Veicolo") name(scatter_1, replace)

// Mettiamo le auto straniere e domestiche nello stesso grafico
twoway (scatter mpg weight if foreign==0)(scatter mpg weight if foreign==1), title("Consumo di Carburante vs. Peso del Veicolo" "per auto straniere e domestiche") legend(lab(1 "Origine USA") lab(2 "Origine straniera"))

// Salviamo questo grafico a dispersione!
graph save scatter_2.gph, replace

/* Vediamo qual è la correlazione tra queste due variabili. Questo non è un grafico, ma un'analisi statistica che ci fornirà un numero.
Possiamo usare questo numero, cioè il coefficiente di correlazione, per quantificare la relazione lineare tra due variabili su una scala tra -1 e 1.
Possiamo usare queste informazioni per commentare il nostro precedente grafico a dispersione.
*/
corr mpg weight
pwcorr mpg weight, sig star(0.05) //Se hai bisogno di p-value per le correlazioni e asterischi SOLO per le correlazioni statisticamente significative. Il coefficiente di correlazione è -0.8177. Questo valore è negativo, il che indica che c'è una relazione inversa tra mpg e weight: man mano che il peso dell'auto aumenta, l'efficienza del carburante (mpg) tende a diminuire.

// Possiamo usare lo stesso comando con più variabili. L'output sarà una matrice di correlazione che mostra la correlazione tra ciascuna coppia di variabili.
pwcorr mpg weight length space_above_head displacement price, sig star(0.05)

**Grafici a barre: Usali per visualizzare i valori medi di una variabile rispetto a un'altra variabile. Ad esempio, i prezzi medi rispetto agli stati di riparazione.
graph bar (mean) price, over(rep, relabel(1 "Una riparazione" 2 "Due riparazioni" 3 "Tre riparazioni" 4 "Quattro riparazioni" 5 "Cinque riparazioni")) ytitle("Prezzo Medio ($)") title("Prezzo medio per numero di riparazioni nel 1978")

// Salviamo il nostro grafico, come al solito
graph save graphbar_1.gph, replace

******************
* TEST D'IPOTESI *
******************

**Ora resettiamo le modifiche, in modo da riavere il dataset originale

clear all
sysuse auto2

//1) Test t con un singolo campione (confronta la media di un campione con un valore specifico).

ttest mpg == 30
/*
2) Paired t-test (testa l'uguaglianza tra la media di due variabili).

Confrontiamo due variabili. Ad esempio, immaginiamo di avere valori storici del prezzo: price_1 è il prezzo nell'anno 2022 e price_2 è il prezzo nell'anno 2023.
Genererò due nuove variabili per creare questo esempio. NON hanno un significato reale in termini di prezzo effettivo.
PUOI IGNORARE I COMANDI "SET SEED" E "RUNIFORM" PER IL TUO ASSIGNMENT. Sono utili per me solo per creare l'esempio.
Dovresti solo preoccuparti del test t
*/
set seed 54321
gen price_1 = runiform()

set seed 12345
gen price_2 = runiform()


ttest price_1 == price_2

/*
3) Test t per due campioni (una variabile uguale tra gruppi diversi).

Confrontiamo una variabile tra due gruppi
(ad esempio tra auto domestiche e straniere).
*/

ttest mpg, by(foreign)

/* DOMANDE DI COMPRENSIONE:
1) Adesso fai una correlazione tra le variabili "weight" e "length", che relazione hanno le due variabili? è significativa almeno al 10%?
2) Fai un t-test per verificare che la media della variabile "gear ratio" sia significativamente uguale tra le auto domestiche e le auto straniere. Poi interpreta il risultato.
*/

/*
***********************************************************
Questa è la fine del do-file!!! 
Se non l'hai ancora fatto, salvalo cliccando sull'icona del "floppy-disk"!
***********************************************************
*/