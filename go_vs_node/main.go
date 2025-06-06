package main

import(
	//"io"
	"net/http"
	"net"
	//"fmt"
	//"strconv"
	"bufio"
)

//var msg2 []byte = []byte("{\"data\":\"Hello World!\"}")
//var asdasd string = strconv.Itoa(len(msg2))
/*
https://groups.google.com/g/golang-nuts/c/RPpiuF_DxF0
https://www.reddit.com/r/golang/comments/17alhmk/nodejs_3x_faster_than_go_what_am_i_doing_wrong/
*/
func h1(w http.ResponseWriter, _ *http.Request) {
	//io.WriteString(w, "Hello from a HandleFunc #1!\n")
	//w.Write([]byte("{\"data\":\"Hello World!\"}"))
	/*w.Header().Set("Content-Length", asdasd)
	w.Write(msg2);*/
    buf := bufio.NewWriter(w)
    buf.WriteString("{\"data\":\"Hello World!\"}")
    buf.Flush()
}

func handleError(err error, msg string){
	if(err != nil && err != http.ErrServerClosed){
		panic(msg)
	}
}

func main(){
	sm := http.NewServeMux();
	sm.HandleFunc("/", h1)
	srv := &http.Server{
		Handler: sm,
	}
	//http.HandleFunc("/", h1)
	listener, err := net.Listen("tcp", "127.0.0.1:8080")
	handleError(err, "Listen")
	go func(){
		//err := http.Serve(listener, nil) // DefaultServeMux
		err := srv.Serve(listener)
		handleError(err, "Serve")
		//err := http.ListenAndServe("127.0.0.1:8080", nil)
		//handleError(err, "ListenAndServe")
	}()
	//go srv.Serve(listener)
	//j := 0
	lim := 4096*4
	for j := 0; j < lim; j++ {
		/*req, err := http.NewRequest("GET", "http://127.0.0.1:8080", nil)
		handleError(err, "request 1")
		resp, err := http.DefaultClient.Do(req)
		handleError(err, "request 2")*/
		_, err := http.Get("http://127.0.0.1:8080")
		handleError(err, "request")
	}
	//fmt.Println(j)
	srv.Close();
}