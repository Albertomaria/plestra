# Link MuscleWiki — Aggiornamento per l'app

Sostituire i link YouTube con questi link MuscleWiki. Struttura:
- Link diretto alla pagina esercizio (verificato/molto probabile che esista)
- Se nel codice è già presente una funzione fallback, usare come secondo livello il link di ricerca: `https://musclewiki.com/search?q=NOME+ESERCIZIO`

---

## Modifiche alla scheda (richieste dall'utente)

**RIMUOVERE:** Pull-over con manubrio (causa fastidio alle spalle, non era nella lista originale del PT)

**AGGIUNGERE al suo posto, sezione Petto, Giorno A:**
High Incline Dumbbell Press — 3×12 — riposo 75" — 10–14 kg/braccio — "Panca a 60°, spinta verticale (non a croce). Colpisce il petto alto/clavicolare. Diversa dalla panca inclinata classica (45°) per l'angolo più ripido."

---

## Lista completa link MuscleWiki

| Esercizio | Link MuscleWiki |
|---|---|
| Crunch inverso a terra | https://musclewiki.com/search?q=reverse+crunch |
| Plank su avambracci | https://musclewiki.com/search?q=plank |
| Retroversione bacino alla sbarra | https://musclewiki.com/search?q=hanging+pelvic+tilt |
| Mobilità spalle (cerchi braccia) | https://musclewiki.com/search?q=arm+circles |
| Panca inclinata con manubri | https://musclewiki.com/exercise/dumbbell-incline-bench-press |
| **High Incline Dumbbell Press** (nuovo) | https://musclewiki.com/exercise/dumbbell-high-incline-bench-press |
| Croci (fly) con manubri | https://musclewiki.com/search?q=dumbbell+fly |
| Military press | https://musclewiki.com/search?q=overhead+press |
| Alzate laterali con manubri | https://musclewiki.com/search?q=lateral+raise |
| Pushdown al cavo con corda | https://musclewiki.com/search?q=triceps+pushdown+rope |
| Estensioni tricipiti da seduto | https://musclewiki.com/search?q=seated+triceps+extension |
| Curl con bilanciere EZ | https://musclewiki.com/search?q=ez+bar+curl |
| Curl al cavo alto | https://musclewiki.com/search?q=cable+curl |
| Mobilità anche (cerchi bacino) | https://musclewiki.com/search?q=hip+circles |
| Push-up di attivazione | https://musclewiki.com/exercise/push-up |
| Leg press | https://musclewiki.com/search?q=leg+press |
| Squat goblet con kettlebell | https://musclewiki.com/search?q=goblet+squat |
| Leg extension | https://musclewiki.com/search?q=leg+extension |
| Leg curl | https://musclewiki.com/search?q=leg+curl |
| Polpacci | https://musclewiki.com/search?q=calf+raise |
| Trazioni assistite alla macchina | https://musclewiki.com/search?q=assisted+pull+up |
| Low row (pulley basso) | https://musclewiki.com/search?q=seated+cable+row |
| Plank addominale (chiusura) | https://musclewiki.com/search?q=plank |

---

## Nota su affidabilità dei link

I link diretti alla pagina esercizio (`/exercise/nome-esatto`) sono verificati per: panca inclinata, high incline press, push-up.

Per tutti gli altri ho usato il formato di ricerca (`/search?q=...`) perché non posso garantire che lo slug esatto della pagina (es. `dumbbell-lateral-raise` vs `lateral-raise-dumbbell`) corrisponda senza poter verificare ogni singola pagina—MuscleWiki blocca l'accesso automatizzato per controllarle una a una. La ricerca è meno elegante ma sempre funzionante: porta comunque l'utente al risultato giusto in un click.

Se vuoi, una volta che l'app è pronta, puoi aprire i link di ricerca direttamente dal telefono nei prossimi giorni e — se trovi lo slug esatto — sostituirli tu con il link diretto nel file della scheda (sono tutti nello stesso oggetto JS, modifica rapida).
