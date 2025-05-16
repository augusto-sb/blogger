const dns = require('node:dns');
const http = require('node:http');

const cache = {};
const CACHE_DURATION_MS = 3600000;

//console.log(dns.lookup.toString())
//console.log(dns.lookup('localhost', {}, (err, hostname, matchedFamily)=>{console.log(err, hostname, matchedFamily);}))

function myLookup(hostname, options /*optional*/, callback) {
  if (typeof options === 'function') {
    callback = options;
    options = {};
  }
  const now = Date.now();
  if (cache[hostname] && now - cache[hostname].timestamp < CACHE_DURATION_MS) {
    if (callback.length === 2) {
      callback(null, cache[hostname].addresses);
    } else {
      callback(
        null,
        cache[hostname].addresses[0].address,
        cache[hostname].addresses[0].family,
      );
    }
    return;
  }
  dns.lookup(hostname, options, (err, address, family) => {
    if (!err) {
      cache[hostname] = {
        timestamp: now,
        addresses: Array.isArray(address) ? address : [{ address, family }],
      };
    }
    callback(err, address, family);
  });
}

async function test(){
  const server = await createServer()
  for(const t of ['127.0.0.1', 'localhost']){
    for(const opt of [{}, {lookup: myLookup}]){
      console.time(t);
      for(let i=0 ; i<1024*4 ; i++){
        await request(t, opt);
      }
      console.log(Object.keys(opt));
      console.timeEnd(t);
    }
  }
  server.close();
}

function request(host, opt){
  return new Promise((resolve, reject) => {
    const req = http.get(`http://${host}:8000`, opt, res=>{
      res.on('data',(c)=>{}) //must consume the data
      res.on('end', resolve);
    });
    req.on('error', reject);
    req.end();
  });
}

function createServer(){
  return new Promise((resolve, reject) => {
    const server = http.createServer((req, res) => {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        data: 'Hello World!',
      }));
    });
    server.listen(8000, ()=>{resolve(server)});
  });
}

test();