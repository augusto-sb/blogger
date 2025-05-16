const http = require('node:http');
const dns = require('node:dns');

function intercepLookup(){
  console.log('dns query!')
  return dns.lookup(...arguments);
}

const agent = new http.Agent({keepAlive: false});

//defaut http.globalAgent // keepAlivehabilitado un tiempo de espera timeoutde 5 segundos.

async function test(){
  const server = await createServer();
  for(let i=0 ; i<16 ; i++){
    //await request({lookup: intercepLookup, agent: false});
    await request({lookup: intercepLookup});
    //await request({agent, lookup: intercepLookup});
    await new Promise(resolve => setTimeout(resolve, 6000))
  }
  server.close();
}

function request(opts){
  return new Promise((resolve, reject) => {
    const req = http.get(`http://localhost:8000`, opts, (res)=>{
      res.on('data', ()=>{}); //consumir data para que no quede en memoria!
      res.on('end', resolve);
    });
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