const http = require('node:http');
const dns = require('node:dns');

async function test(){
  const resolver = new dns.Resolver()
  const server = await createServer();
  for(const t of ['127.0.0.53', '192.168.0.1']){
    console.time(t);
    resolver.setServers([t]); // dns.setServers no afecta a dns.lookup...
    for(let i=0 ; i<4096*4*4 ; i++){
      await request({lookup: resolver.resolve});
    }
    console.timeEnd(t);
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