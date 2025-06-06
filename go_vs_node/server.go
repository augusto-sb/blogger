package main

import(
	"net/http"
	"net"
	"os"
	"os/signal"
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

func main() {
	var mux *http.ServeMux = http.NewServeMux()
	mux.HandleFunc("/", h1)
	var srv http.Server = http.Server{
		Handler: mux,
		IdleTimeout: 5,
	}
	srv.SetKeepAlivesEnabled(true)
	listener, err := net.Listen("tcp", "127.0.0.1:8080")
	handleError(err, "Listen")
	idleConnsClosed := make(chan struct{})
	go func() {
		sigint := make(chan os.Signal, 1)
		signal.Notify(sigint, os.Interrupt)
		<-sigint
		err := srv.Shutdown(nil)
		handleError(err, "Shutdown")
		close(sigint)
		close(idleConnsClosed)
	}()
	err = srv.Serve(listener)
	handleError(err, "Serve")
	<-idleConnsClosed
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