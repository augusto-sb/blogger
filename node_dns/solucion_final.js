const dns = require('node:dns');
const http = require('node:http');

const cache = {};
const CACHE_DURATION_MS = 3600000; //1H
let callsToMyLookup = 0;
let callsToDnsLookup = 0;
const iterations=1024*4*2;
const tmp = dns.lookup;
dns.lookup = function(){
  callsToDnsLookup++;
  return tmp(...arguments);
}

function myLookup(hostname, options /*optional*/, callback) {
  callsToMyLookup++;
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

const agent = new http.Agent({keepAlive: false});

async function test(){
  const server = await createServer()
  for(const opt of [{agent}, {agent, lookup: myLookup}]){
    console.time(opt.lookup ? 'con' : 'sin');
    for(let i=0 ; i<iterations ; i++){
      await request(opt);
    }
    console.timeEnd(opt.lookup ? 'con' : 'sin');
  }
  server.close();
  console.log({callsToMyLookup, callsToDnsLookup});
}

function request(opt){
  return new Promise((resolve, reject) => {
    const req = http.get(`http://localhost:8000`, opt, res=>{
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