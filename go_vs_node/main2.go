package main

import(
	"net/http"
	"net"
	"sync"
	"time"
	"io"
	"io/ioutil"
	//"fmt"
)

var msg2 []byte = []byte("{\"data\":\"Hello World!\"}")

func h1(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
    w.Header().Set("Connection", "keep-alive")
    w.Header().Set("Keep-Alive", "timeout=5")
	w.Write(msg2);
}

func handleError(err error, msg string){
	if(err != nil && err != http.ErrServerClosed){
		panic(msg)
	}
}

var wgTest sync.WaitGroup
var wgServe sync.WaitGroup
var wgMain sync.WaitGroup
//var httpClient http.Client = http.Client{}

func test(){
	wgTest.Wait()
	for j := 0; j < 4096*4; j++ {
		//resp, err := httpClient.Get("http://127.0.0.1:8080")
		/*resp, err := http.Get("http://127.0.0.1:8080")
		handleError(err, "request")
		io.Copy(ioutil.Discard, resp.Body)
		resp.Body.Close()*/
		req, err := http.NewRequest("GET", "http://127.0.0.1:8080", nil)
		req.Header.Set("Connection", "keep-alive")
		/*if(j==0){
			fmt.Println(req)
		}*/
		handleError(err, "request")
		resp, err := http.DefaultClient.Do(req) // httpClient.Do(req)
		//https://paween-p.medium.com/how-to-enable-http-keep-alive-in-go-581868392bad
		io.Copy(ioutil.Discard, resp.Body)
		resp.Body.Close()
		handleError(err, "response")
	}
	wgServe.Done()
}

func serve(){
	var mux *http.ServeMux = http.NewServeMux()
	mux.HandleFunc("/", h1)
	var srv http.Server = http.Server{
		Handler: mux,
		IdleTimeout: 5 * time.Second,
	}
	srv.SetKeepAlivesEnabled(true)
	listener, err := net.Listen("tcp", "127.0.0.1:8080")
	handleError(err, "Listen")
	go func() {
		wgServe.Wait()
		err := srv.Shutdown(nil)
		handleError(err, "Shutdown")
		wgMain.Done()
	}()
	wgTest.Done()
	err = srv.Serve(listener)
	handleError(err, "Serve")
}

func main() {
	wgServe.Add(1)
	wgTest.Add(1)
	wgMain.Add(1)
	go serve()
	go test()
	wgMain.Wait()
}
/*
* Host localhost:8080 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8080...
* connect to ::1 port 8080 from ::1 port 56306 failed: Conexión rehusada
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/8.5.0
> Accept: *\/*
> 
< HTTP/1.1 200 OK
< Date: Fri, 06 Jun 2025 16:03:25 GMT
< Content-Length: 23
< Content-Type: text/plain; charset=utf-8
< 
* Connection #0 to host localhost left intact
{"data":"Hello World!"}
*/