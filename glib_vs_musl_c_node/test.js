console.time();
let version = 'aaa';
const rep = process.report.getReport();
require('node:child_process').exec('apk info musl', (error, stdout, stderr) => {
  if (error) {
    //console.error(`exec error: ${error}`);
    console.log('g libc: '+rep.header.glibcVersionRuntime);
    //return;
  }else{
  	console.log('musl libc: '+stdout.split(' ')[0]);
  }
  //console.log(`stdout: ${stdout}`);
  //console.error(`stderr: ${stderr}`);
});

const http = require('node:http');
const server = http.createServer({ keepAliveTimeout: 60000 }, (req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    data: 'Hello World!',
  }));
});
server.listen(8000, ()=>{
	let counterhttp = 0;
	const numberOfReq = 512*8;
	for(let i=0 ; i<numberOfReq ; i++){
		http.get('http://localhost:8000',()=>{
			counterhttp++;
			//console.log('a');
			if(counterhttp===numberOfReq){
			  server.close(() => {
			    console.log('server on port 8000 closed successfully');
			  });
			  // Closes all connections, ensuring the server closes successfully
			  server.closeAllConnections();
			}
		})
	}
});

function calcTimes(n){
	return n/2;
}
let counter = 0;
for(const a of 'askjdhbvfasdasdfasasdfasdasdasd'.split('')){
	for(const b of 'lk nasdv98h34qergvsdsdgsdfgsdf'.split('').reverse()){
		for(let i=0 ; i<4096*4 ; i++){
			for(let j=0 ; j<calcTimes(4096) ; j++){
				counter += ('a'+a === b+'b') ? 1 : 0;
				if(Number.MAX_SAFE_INTEGER === counter){
					counter = 0;
				}
			}
		}
	}
}
console.log(counter, rep.sharedObjects);
console.timeEnd();