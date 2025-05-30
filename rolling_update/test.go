package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

var endpoint string

func makeReq() {
	res, err := http.Get(endpoint)
	if err != nil {
		fmt.Println("request error", err)
		return
	}
	body, err := io.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		fmt.Println("request error", err)
		return
	}
	fmt.Println("request result: ", res.StatusCode, string(body))
}

func init(){
	endpoint = "http://"+os.Getenv("IP")+":30000"
}

func main(){
	for {
		makeReq();
		time.Sleep(10 * time.Millisecond)
	}
}