const http = require('node:http');

const msg = JSON.stringify({
	data: 'Hello World!',
});
const options = {
  hostname: '127.0.0.1',
  port: 8080,
  path: '/',
  method: 'GET',
  headers: {
    //'Content-Type': 'application/json',
    //'Content-Length': Buffer.byteLength(msg),
  },
};

async function test(){
	//console.log(process.memoryUsage());
	const server = await new Promise((resolve, reject) => {
		const s = new http.Server();
		s.on('request', (request, response)=>{
			let reqBody = '';
			request.on('data', (chunk) => {
				reqBody += chunk;
			});
			request.on('end', (chunk) => {
				//console.log('eaa',reqBody);
			});
			response.writeHead(200, {...options.headers,'Content-Length': Buffer.byteLength(msg)});
			response.end(msg);
		});
		s.listen(options.port, options.hostname, () => {
			resolve(s);
		});
	});
	for(let i=0 ; i<4096*4 ; i++){
		await new Promise((resolve, reject) => {
			const req = http.request(options, (res) => {
				res.setEncoding('utf8');
				let respBody = '';
				res.on('data', (chunk) => {
					respBody += chunk;
				});
				res.on('end', () => {
					//if(i=== 2000){console.log('1');}
	//				console.log(respBody)
					//console.log(i)
					resolve(respBody);
				});
			});
			/*if(i===0){
				console.log(req)
			}*/
			req.on('error', (e) => {
				//console.log('ea')
				reject(e);
			});
			//req.write(msg);
			req.end();
		});
		//if(i=== 2000){console.log('12');}
		//console.log(i);
	}
	await new Promise((resolve, reject) => {
		server.close(()=>{
			resolve();
		});
	});
	//console.log(process.memoryUsage());
}

test();