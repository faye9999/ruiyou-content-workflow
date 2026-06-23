const CACHE = 'cwf-v2';
const FILES = ['manifest.json','icon-192.png','icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(clients.claim());
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))));
});

self.addEventListener('fetch', e => {
  // Network-first for index.html: always fetch latest when online
  if (e.request.url.endsWith('/') || e.request.url.endsWith('/index.html')) {
    e.respondWith(
      fetch(e.request)
        .then(r => {
          const clone = r.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
          return r;
        })
        .catch(() => caches.match(e.request).then(r => r || new Response('离线',{status:503})))
    );
    return;
  }
  // Cache-first for other assets
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request).catch(() => new Response('离线',{status:503})))
  );
});
