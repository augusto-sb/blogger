package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"time"
)

var message []byte = []byte("ok")

func handler(w http.ResponseWriter, req *http.Request) {
	fmt.Println("handler: pre")
	time.Sleep(5000 * time.Millisecond) // simulate slow
	fmt.Println("handler: post")
	w.Write(message)
}

func init() {
	message = []byte(os.Getenv("MESSAGE"));
}

func main() {
	var mux *http.ServeMux = http.NewServeMux()
	mux.HandleFunc("/", handler)
	var srv http.Server = http.Server{
		Addr:    "0.0.0.0:8080",
		Handler: mux,
	}

	idleConnsClosed := make(chan struct{})
	go func() {
		sigint := make(chan os.Signal, 1) // buffered channel
		signal.Notify(sigint, os.Interrupt)
		<-sigint

		fmt.Println("closing gracefully")

		// We received an interrupt signal, shut down.
		err := srv.Shutdown(context.Background())
		if err != nil { // context.WithTimeout(context.Background(), time.Second*3)
			// Error from closing listeners, or context timeout:
			fmt.Printf("Error: HTTP server Shutdown: %v", err)
		}

		//no acepta mas conexiones, terminar las activas

		fmt.Println("requests finished")
		fmt.Println("end db conns - pre")
		time.Sleep(5000 * time.Millisecond)
		fmt.Println("end db conns - post")

		//cerrar dbs

		close(sigint) // necesario?
		close(idleConnsClosed)
	}()

	err := srv.ListenAndServe() // blocking
	if err != nil {
		// Error starting or closing listener:
		if errors.Is(err, http.ErrServerClosed) {
			// ignorable
		} else {
			fmt.Printf("Error: HTTP server ListenAndServe: %v", err)
		}
	}

	fmt.Println("main end reached")
	<-idleConnsClosed // esperar sino se cierra el main y cierra la go routine aunque no haya terminao
}
