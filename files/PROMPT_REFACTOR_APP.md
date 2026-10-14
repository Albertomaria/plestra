# Prompt refactor — App Palestra Alberto V2

## Contesto
Refactor di un'app web PWA esistente (index.html + manifest.json + sw.js).
NON riscrivere da zero — il codice esistente è buono. Applica modifiche mirate.
I file allegati sono: `index.html` (app attuale), `scheda_v2.json` (nuova scheda), `esercizi_info.json` (step tecnici esercizi).

---

## Architettura target

### Struttura file
```
palestra/
├── index.html          ← app principale (modificata)
├── manifest.json       ← invariato
├── sw.js               ← aggiornato per cache v6
├── scheda_v2.json      ← nuova scheda dati (NON hardcoded nell'HTML)
├── esercizi_info.json  ← step tecnici per ogni esercizio
└── Icona_finale.jpg    ← invariata
```

### Principio chiave
La scheda dati vive in `scheda_v2.json`, NON nell'HTML. L'app la carica via `fetch('./scheda_v2.json')` all'avvio. Questo permette di modificare esercizi senza toccare il codice.

---

## Fix 1 — Timer che si blocca in background (PRIORITÀ MASSIMA)

**Problema:** `setInterval` si blocca quando l'app va in background su mobile.

**Soluzione:** usa timestamp assoluti invece di decrementare un contatore.

```javascript
// SBAGLIATO (attuale)
let t = 90;
const iv = setInterval(() => { t--; render(t); }, 1000);

// CORRETTO
const endTime = Date.now() + 90000; // timestamp assoluto
const iv = setInterval(() => {
  const remaining = Math.max(0, Math.ceil((endTime - Date.now()) / 1000));
  render(remaining);
  if (remaining <= 0) clearInterval(iv);
}, 250); // poll più frequente per compensare il jitter
```

Applica questa logica a TUTTI i timer dell'app: riposo tra serie, countdown esercizi a tempo, cronometro sessione.

---

## Fix 2 — Contatore serie separato dal countdown

**Problema:** la serie viene marcata come completata solo dopo il countdown di riposo.

**Soluzione:** due azioni distinte e separate.

Quando l'utente preme "Fine serie":
1. **Immediatamente:** incrementa il contatore serie, salva peso/rip, mostra toast "Serie X completata"
2. **Poi:** avvia il countdown di riposo come azione separata

Il countdown di riposo NON deve bloccare il contatore. Se l'utente salta il riposo, la serie è già stata marcata.

---

## Fix 3 — Countdown esercizi a tempo

**Problema:** quando finisce il countdown non si resetta e non segna automaticamente la serie.

**Soluzione:**
- Quando il countdown arriva a 0: suono/vibrazione + segna automaticamente la serie come completata + mostra pulsante "Inizia riposo" o "Prossima serie"
- Il countdown torna al valore iniziale pronto per la serie successiva
- L'utente può modificare il valore PRIMA di avviarlo (campo numerico editabile con `inputmode="numeric"`)
- Durante il countdown: pulsante **+15"** ben visibile che aggiunge 15 secondi ogni tap

---

## Fix 4 — Caricamento scheda da JSON esterno

Sostituisci l'oggetto `SCHEDA` hardcoded con caricamento dinamico:

```javascript
async function loadScheda() {
  const [scheda, info] = await Promise.all([
    fetch('./scheda_v2.json').then(r => r.json()),
    fetch('./esercizi_info.json').then(r => r.json())
  ]);
  SCHEDA = scheda;
  ESERCIZI_INFO = info;
  goHome();
}
```

Mostra uno schermo di caricamento mentre i JSON vengono fetchati. Se il fetch fallisce (offline), usa i dati in cache del service worker.

---

## Fix 5 — Integrazione Supabase per sync cloud

**Setup Supabase:**
- Crea un client Supabase con le credenziali che Alberto fornirà (placeholder nel codice)
- Usa la CDN: `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`

**Schema database Supabase (da creare manualmente su supabase.io):**

```sql
-- Tabella sessioni allenamento
create table sessioni (
  id uuid default gen_random_uuid() primary key,
  user_id text not null default 'alberto',
  data date not null,
  giorno char(1) not null, -- 'A' o 'B'
  durata_min integer,
  creato_at timestamptz default now()
);

-- Tabella serie registrate
create table serie_log (
  id uuid default gen_random_uuid() primary key,
  sessione_id uuid references sessioni(id),
  esercizio_id text not null,
  esercizio_nome text not null,
  serie_num integer not null,
  peso_kg numeric,
  rip_effettive integer,
  note text,
  creato_at timestamptz default now()
);

-- Tabella esercizi saltati
create table salti_log (
  id uuid default gen_random_uuid() primary key,
  user_id text not null default 'alberto',
  data date not null,
  giorno char(1) not null,
  esercizio_id text not null,
  esercizio_nome text not null,
  nota text,
  creato_at timestamptz default now()
);
```

**Logica sync:**
- **Online:** scrivi direttamente su Supabase + aggiorna localStorage come cache locale
- **Offline:** scrivi solo su localStorage, marca come "da sincronizzare"
- **Alla riconnessione:** sync automatico dei dati locali non ancora inviati
- **Progressi:** leggi da Supabase se online, da localStorage se offline

**Placeholder credenziali** (Alberto le inserirà dopo aver creato il progetto su supabase.io):
```javascript
const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
```

---

## Fix 6 — Aggiornamento service worker

Aggiorna la versione cache a `palestra-v6` e aggiungi i nuovi file alla lista:
```javascript
const FILES = ['./', './index.html', './manifest.json', './scheda_v2.json', './esercizi_info.json'];
```

---

## Nuova scheda dati (scheda_v2.json)

La scheda V2 ha questa struttura per ogni giorno:
- **Riscaldamento** (10 min): esercizi di mobilità e attivazione, senza riposo tra loro
- **Allenamento principale**: esercizi con serie/rip/riposo, alcuni in superset
- **Core** (5 min a fine sessione): 2 esercizi core funzionale

**Superset:** alcuni esercizi hanno `"superset_con": "ID_ALTRO"`. L'app deve:
- Mostrare un badge "SUPERSET" sull'esercizio
- Nella schermata esercizio indicare "Fai subito dopo: [nome esercizio]"
- Il riposo parte solo dopo aver completato entrambi gli esercizi del superset

**Badge disponibili:** `lordosi` (arancione), `spalla` (blu), `golf` (verde)

**Sezione riscaldamento:** riposo tra esercizi = 0, nessun countdown di riposo. Mostra solo un timer generale di sessione.

---

## UI — modifiche rispetto all'attuale

### Schermata esercizio
Aggiungi in fondo (sempre visibile, anche durante il countdown):
```
┌─────────────────────────────┐
│ PROSSIMO                    │
│ Low row al cavo             │
│ Schiena · 4×8-12            │
└─────────────────────────────┘
```
Se è l'ultimo esercizio: "🏁 Fine sessione"

### Countdown esercizi a tempo
```
┌─────────────────────────────┐
│  PLANK A BRACCIA TESE       │
│                             │
│  [  45  ]  ← editabile      │  ← prima di avviare
│  secondi                    │
│                             │
│  [  Avvia timer  ]          │
└─────────────────────────────┘

┌─────────────────────────────┐
│  00:32                      │  ← durante
│  ████████░░░░░░░░░░         │
│  [+15"]        [Salta]      │
└─────────────────────────────┘
```

### Progressi
Mantieni i grafici SVG sparkline e bar chart esistenti — sono buoni.
Aggiungi filtro per data (ultima settimana / ultimo mese / tutto).

---

## Modulo Health Connect (preparazione futura)

Aggiungi una funzione stub pronta per l'integrazione, ma disabilitata di default:

```javascript
// HEALTH CONNECT — da abilitare quando Alberto avrà uno smartwatch
// Richiede app nativa Android o Trusted Web Activity
// Per ora: struttura dati pronta, UI nascosta

const HEALTH_CONNECT = {
  enabled: false,
  
  async readHeartRate(startTime, endTime) {
    // TODO: window.HealthConnect.readRecords('HeartRate', {startTime, endTime})
    return null;
  },
  
  async readWorkout(sessionId) {
    // TODO: leggi dati allenamento da Health Connect
    return null;
  }
};

// Nella schermata progressi: mostra sezione "Dati smartwatch" solo se HEALTH_CONNECT.enabled
```

Nella schermata progressi aggiungi un toggle disabilitato "🏃 Connetti smartwatch" con testo: "Disponibile con smartwatch Android compatibile con Health Connect (Pixel Watch, Galaxy Watch, Garmin con Android)."

---

## Cosa NON cambiare

- UI dark mode esistente (colori, font, card style) — è già buona
- Logica skip esercizio con note
- Grafici SVG sparkline e bar chart
- Struttura navigazione (home → lista → esercizio)
- Sistema badge lordosi/spalla (aggiungi solo badge "golf" verde e "spalla" blu)
- Manifest.json

---

## Ordine di implementazione consigliato

1. Fix timer (Fix 1) — sblocca tutto il resto
2. Caricamento JSON (Fix 4) — sostituisce la scheda hardcoded
3. Fix contatore serie (Fix 2) e countdown (Fix 3)
4. Supabase (Fix 5) — prima il salvataggio, poi la lettura progressi
5. Service worker (Fix 6)
6. UI prossimo esercizio
7. Stub Health Connect

---

## Note finali

- L'app deve funzionare completamente offline con dati in cache (service worker)
- Supabase è opzionale — se non configurato, tutto funziona con localStorage
- Non usare framework (no React, no Vue) — vanilla JS come ora
- Testa il timer bloccando lo schermo del telefono per 30 secondi e verificando che continui correttamente

---

## AGGIORNAMENTO — Sezione Golf a casa + Superset + Fix descrizioni

### Nuova tab "Golf 🏌️" nella home

Aggiungi un terzo pulsante nella home accanto a Giorno A e Giorno B:

```
┌─────────────────────────────┐
│  ⛳ Golf a casa              │
│  7 esercizi · ~12 min       │
│  Sequenza cinetica e swing  │
└─────────────────────────────┘
```

La sezione golf carica da `scheda.golf_casa` nel JSON. Struttura analoga alle altre sessioni ma senza serie/riposo classici — ogni esercizio ha solo obiettivo, step e rip. Il pulsante ℹ️ Info è l'elemento principale (non c'è video per questi esercizi). Nessun countdown di riposo — solo un timer manuale opzionale.

### Superset — modo migliore per mostrarli

Il concetto di superset non è immediato. Invece di due esercizi separati in lista con una proprietà "superset_con", mostrali come un blocco unico:

```
┌─────────────────────────────────┐
│  🔄 SUPERSET                    │
│  ─────────────────────────────  │
│  A  Chest press alla macchina   │
│     4×8-12 · 90" riposo totale  │
│  ↕                              │
│  B  Low row al cavo             │
│     4×8-12                      │
│                                 │
│  Esegui A → poi B senza riposo  │
│  Il riposo parte dopo B         │
└─────────────────────────────────┘
```

Nella schermata esercizio, quando l'utente è sull'esercizio A del superset:
- Mostra in basso: "VAI SUBITO A → Low row al cavo"
- Dopo aver premuto "Fine serie" su A, avanza direttamente a B senza avviare il countdown
- Il countdown parte solo dopo aver completato anche B

### Descrizioni esercizi aggiornate

Il file `esercizi_info.json` è stato aggiornato con:
- **Push and pull al cavo** (A_W5): descrizione completamente riscritta — spiega posizione del corpo, del gomito, differenza tra pull e press
- **Retrazione scapolare** (A_W3): aggiunta spiegazione del "perché" e rimosso linguaggio tecnico
- **Bird dog** (A_W6): chiarito che "quattro zampe" = mani+ginocchia a terra, aggiunto controllo del bacino
- **Wall slide** (A_W4/B_W4): già aggiornata nella sessione precedente — posizione a "W" → "Y"
- **Golf a casa** (_golf_casa): 7 esercizi con step dettagliati, attrezzatura necessaria, sensazione da cercare

Leggi `esercizi_info.json` aggiornato per tutti i testi — non riscrivere le descrizioni, usale esattamente come sono nel file.
