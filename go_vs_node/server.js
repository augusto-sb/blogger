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
    'Content-Type': 'application/json',
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
}

test();

/*
* Host localhost:8080 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8080...
* connect to ::1 port 8080 from ::1 port 58680 failed: Conexión rehusada
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/8.5.0
> Accept: *\/*
> 
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 23
< Date: Fri, 06 Jun 2025 16:04:35 GMT
< Connection: keep-alive
< Keep-Alive: timeout=5
< 
* Connection #0 to host localhost left intact
{"data":"Hello World!"}
*/