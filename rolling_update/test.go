package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

var endpoint string
var client string

func makeReq() {
	res, err := http.Get(endpoint)
	if err != nil {
		fmt.Println(client, "request error 1", err)
		return
	}
	body, err := io.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		fmt.Println(client, "request error 2", err)
		return
	}
	fmt.Println(client, "request result: ", res.StatusCode, string(body))
}

func init(){
	endpoint = "http://"+os.Getenv("IP")+":30000"
	client = os.Getenv("CLIENT")
}

func main(){
	for {
		makeReq();
		time.Sleep(1000 * time.Millisecond)
	}
}