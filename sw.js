const CACHE = 'palestra-v6';
const FILES = ['./', './index.html', './manifest.json', './scheda_v2.json', './esercizi_info.json', './Icona_finale.jpg'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)));
  self.skipWaiting();
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
  ));
  self.clients.claim();
});

// Network-first: prova sempre a scaricare la versione fresca da internet.
// Se non c'è connessione, usa la copia salvata in cache (così l'app funziona offline).
// Le chiamate a Supabase (e qualsiasi POST) passano dirette: mai in cache.
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  if (new URL(req.url).hostname.endsWith('.supabase.co')) return;
  e.respondWith(
    fetch(req)
      .then(resp => {
        if (resp.ok || resp.type === 'opaque') {
          const copy = resp.clone();
          caches.open(CACHE).then(c => c.put(req, copy));
        }
        return resp;
      })
      .catch(() => caches.match(req))
  );
});
