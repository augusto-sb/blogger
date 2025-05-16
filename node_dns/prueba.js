const http = require('node:http');
const dns = require('node:dns');

console.log(dns.getServers());

async function test(){
  const server = await createServer();
  for(const t of ['localhost', '127.0.0.1']){
    console.time(t);
    for(let i=0 ; i<4096*4 ; i++){
      await request(t);
    }
    console.timeEnd(t);
  }
  server.close();
}

function request(host){
  return new Promise((resolve, reject) => {
    const req = http.get(`http://${host}:8000`, (res)=>{
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