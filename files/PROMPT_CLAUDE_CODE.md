# Prompt per Claude Code — App Scheda Palestra Alberto

---

Crea un'**app web mobile-first** (HTML + CSS + JavaScript, file singolo `index.html`) per gestire la scheda di allenamento in palestra di Alberto. L'app deve funzionare offline una volta aperta nel browser, senza framework esterni (no React, no Vue, no Node).

---

## ⚠️ AGGIORNAMENTO — modifiche da applicare all'app già esistente

Questo prompt descrive la scheda completa, ma se stai aggiornando un'app già funzionante, applica solo queste modifiche puntuali:

1. **Sostituisci tutti i link YouTube con link MuscleWiki** — vedi file `LINK_MUSCLEWIKI.md` per la lista completa esercizio per esercizio. Dove esiste un link diretto alla pagina usalo, altrimenti usa il link di ricerca `musclewiki.com/search?q=...`
2. **Rimuovi "Pull-over con manubrio"** dal Giorno A (causa fastidio alle spalle, non era nella scheda originale del PT)
3. **Aggiungi al suo posto "High Incline Dumbbell Press"** nella sezione Petto del Giorno A — 3×12, riposo 75", 10–14 kg/braccio, nota: "Panca a 60°, spinta verticale (non a croce), colpisce il petto alto/clavicolare"
4. **Push-up di attivazione** vanno nel riscaldamento del Giorno B (punto 4, prima della mobilità anche), NON nella chiusura sessione

---

## Contesto

Alberto ha 41 anni, 184 cm, 84 kg, e soffre di **iperlordosi lombare**. Va in palestra 2 volte a settimana con un PT di nome Vlad. La sessione dura al massimo 60 minuti. Ha bisogno di un'app che lo guidi esercizio per esercizio, gli conti i tempi di riposo, le serie e le ripetizioni, e gli permetta di vedere un video di riferimento per ogni esercizio.

---

## Struttura della scheda

### GIORNO A — Petto, Spalle, Tricipiti, Bicipiti (~60 min, es. martedì)

**Riscaldamento (8 min)**
1. Crunch inverso a terra — 2×15 — "Attiva core basso senza caricare lombari" — 🔶 LORDOSI
2. Plank su avambracci — 2×30" — "Bacino neutro, no affossamento" — 🔶 LORDOSI
3. Retroversione bacino alla sbarra — 2×10 rip. lente — "Appeso, spingi bacino in avanti/sotto" — 🔶 LORDOSI
4. Mobilità spalle (cerchi braccia) — 1×30" — "Scioglie la cuffia dei rotatori"

**Petto**
5. Panca inclinata con manubri — 4×10–12 — riposo 90" — 10–14 kg/braccio — "Sostituisce la piana, protegge spalle"
6. Croci (fly) con manubri — 3×12 — riposo 75" — 6–10 kg/braccio — "Gomiti fissi leggermente piegati"
7. High Incline Dumbbell Press — 3×12 — riposo 75" — 10–14 kg/braccio — "Panca a 60°, spinta verticale, colpisce il petto alto/clavicolare"

**Spalle**
8. Military press — 3×10 — riposo 90" — 20–30 kg — "Core contratto, protegge lordosi" — 🔶 LORDOSI
9. Alzate laterali — 3×12 — riposo 60" — 6–10 kg/braccio — "Gomiti leggermente piegati, no oltre spalle"

**Tricipiti**
10. Pushdown al cavo con corda — 3×12 — riposo 60" — 15–25 kg — "Gomiti stretti ai fianchi"
11. Estensioni tricipiti da seduto — 3×12 — riposo 60" — 10–14 kg — "Un manubrio sopra la testa, gomiti fermi"

**Bicipiti (leggeri)**
12. Curl con bilanciere EZ — 2×12 — riposo 45" — 15–20 kg — "Gomiti fermi ai fianchi"
13. Curl al cavo alto — 2×12 — riposo 45" — 8–12 kg — "Tensione costante su tutto il ROM"

---

### GIORNO B — Gambe, Schiena, Core (~60 min, es. venerdì)

**Riscaldamento (8 min)** — stesso del Giorno A più:
4. Push-up di attivazione — 2×10–12 — "Corpo dritto, bacino neutro, come da video Vlad" — 🔶 LORDOSI
5. Mobilità anche (cerchi bacino) — 1×20" per lato

**Gambe**
5. Leg press — 4 serie piramidale 12/12/10/8 — riposo 90" — 60–100 kg — "Piedi alti e larghi, scarica la colonna" — 🔶 LORDOSI
6. Squat goblet con kettlebell — 3×12 — riposo 90" — 16 kg — "Busto verticale, no iperlordosi in basso" — 🔶 LORDOSI
7. Leg extension — 3×12 — riposo 60" — carico editabile — "No strattoni"
8. Leg curl — 3×12 — riposo 60" — carico editabile — "Pausa 1" al picco contrazione"
9. Polpacci — 3×15 — riposo 60" — carico editabile — "ROM completo, tallone basso poi punta alta"

**Schiena**
10. Trazioni assistite alla macchina — 4×8–10 — riposo 90" — assistenza editabile — "Gran dorsale, sicuro per schiena"
11. Low row (pulley basso) — 3×10 — riposo 90" — 30–45 kg — "Schiena dritta, tira verso ombelico, stringi scapole"

**Core / chiusura**
12. Plank addominale — 2×max — riposo 60" — "Aumenta tempo ogni settimana" — 🔶 LORDOSI

---

## Funzionalità richieste

### 1. Navigazione
- Schermata iniziale con scelta **Giorno A** / **Giorno B**
- Dentro ogni giorno, lista di tutti gli esercizi in ordine
- Possibilità di tornare alla lista in qualsiasi momento

### 2. Schermata esercizio (quella principale)
Per ogni esercizio mostra:
- **Nome** dell'esercizio (grande, leggibile)
- **Badge arancione "⚠ LORDOSI"** se l'esercizio è marcato come tale
- **Note tecniche** (breve testo grigio sotto il nome)
- **Contatore serie** — es. "Serie 2 di 4" con bottoni + e −
- **Ripetizioni** target — es. "12 rip." o "30 secondi"
- **Carico** — mostra il valore suggerito; se il carico è "editabile" mostra un campo input numerico dove Alberto può inserire il suo
- **Timer riposo** — quando Alberto finisce una serie, preme "Fine serie" e parte un conto alla rovescia (es. 90") con suono/vibrazione alla fine. Deve essere ben visibile, grande, e ci deve essere un bottone per saltarlo
- **Bottone "📹 Video"** — apre il link YouTube dell'esercizio in una nuova scheda (non embed, solo link). I link YouTube sono questi (cerca tu i migliori in italiano, o usa questi termini di ricerca):
  - Panca inclinata manubri → cerca "panca inclinata manubri esecuzione"
  - Croci fly manubri → cerca "croci fly manubri esecuzione"
  - High Incline Dumbbell Press → link diretto MuscleWiki: https://musclewiki.com/exercise/dumbbell-high-incline-bench-press
  - Military press → cerca "military press esecuzione corretta"
  - Alzate laterali → cerca "alzate laterali manubri esecuzione"
  - Pushdown cavo corda → cerca "pushdown cavo corda tricipiti"
  - Estensioni tricipiti seduto → cerca "french press seduto manubrio tricipiti"
  - Curl bilanciere EZ → cerca "curl bilanciere ez bicipiti esecuzione"
  - Curl cavo alto → cerca "curl cavo alto bicipiti"
  - Crunch inverso → cerca "crunch inverso core esecuzione"
  - Plank avambracci → cerca "plank avambracci esecuzione corretta"
  - Retroversione bacino sbarra → cerca "retroversione bacino sbarra core"
  - Leg press → cerca "leg press esecuzione corretta"
  - Squat goblet kettlebell → cerca "squat goblet kettlebell esecuzione"
  - Leg extension → cerca "leg extension macchina esecuzione"
  - Leg curl → cerca "leg curl macchina esecuzione"
  - Polpacci macchina → cerca "polpacci macchina esecuzione"
  - Trazioni assistite → cerca "trazioni assistite macchina esecuzione"
  - Low row pulley → cerca "low row pulley basso schiena esecuzione"
  - Push-up tecnica → cerca "push-up esecuzione corretta tecnica"

### 3. Navigazione tra esercizi
- Bottone **"Esercizio successivo →"** che avanza alla schermata del prossimo
- Bottone **"← Precedente"** per tornare indietro
- Quando l'utente completa tutte le serie di un esercizio, evidenziarlo come completato nella lista

### 4. Salvataggio carichi
- I carichi inseriti dall'utente (quelli "editabili") devono essere salvati in **localStorage** in modo che al prossimo allenamento i valori vengano ricordati
- Anche i carichi fissi devono essere sovrascrivibili e salvati

### 5. Cronometro sessione
- In alto, un piccolo timer che conta il tempo totale della sessione dall'apertura del giorno
- Se supera i 60 minuti, cambia colore (es. diventa rosso)

### 6. Design
- **Mobile-first**, ottimizzato per schermo da 6"
- Sfondo scuro (dark mode) — si usa in palestra con poca luce
- Font grande, leggibile, buon contrasto
- Bottoni grandi, facili da toccare con i guanti o le mani sudate
- Il timer del riposo deve essere la cosa più visibile nella schermata quando sta girando
- Colori suggeriti: sfondo #111, testo bianco, accento blu #0A84FF, LORDOSI badge arancione #FF9F0A, completato verde #30D158

### 7. Struttura del codice
- Tutto in un singolo file `index.html` (HTML + CSS inline + JS inline)
- Nessuna dipendenza esterna (no CDN, no librerie)
- Dati della scheda in un oggetto JavaScript `const SCHEDA = {...}` all'inizio del file, facile da modificare
- Commenti chiari in italiano per ogni sezione principale

---

## Output atteso
Un singolo file `index.html` che:
1. Si apre nel browser del telefono
2. Funziona offline
3. Guida Alberto attraverso tutta la sessione
4. Ricorda i carichi tra una sessione e l'altra (localStorage)
5. Ha un timer visibile e funzionante per i riposi

---

## Note finali
- Non usare framework (no React, no Vue, no Svelte)
- Non usare CDN esterni
- Non cercare di embeddare i video — solo link che aprono YouTube
- Il file deve essere consegnabile direttamente ad Alberto che lo salva sul telefono
- Testa mentalmente il flusso: Alberto apre l'app → sceglie Giorno A → vede il riscaldamento → fa crunch inverso → preme "Fine serie" → parte il timer 60" → finisce → preme "Esercizio successivo" → e così via
