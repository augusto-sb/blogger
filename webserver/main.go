package main

import (
	"io/fs"
	"net/http"
	"os"
	"strings"
)

type File struct {
	content     []byte
	contentType string
}

type Files map[string]File

var files Files = Files{}

func handleError(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func walkDirFunc(path string, d fs.DirEntry, err1 error) error {
	if !d.IsDir() {
		fileInfo, err2 := d.Info()
		if err2 != nil {
			return err2
		}
		if fileInfo.Mode().IsRegular() {
			fileByteArr, err3 := os.ReadFile("/html/" + path)
			if err3 != nil {
				return err3
			}
			//contentType := http.DetectContentType(fileByteArr)
			//files["/"+path] = File{content: fileByteArr, contentType: contentType}
			files["/"+path] = File{content: fileByteArr, contentType: "text/html"}
			if strings.HasSuffix(path, ".css") {
				files["/"+path] = File{content: fileByteArr, contentType: "text/css"}
			}
			if strings.HasSuffix(path, ".js") {
				files["/"+path] = File{content: fileByteArr, contentType: "text/javascript"}
			}
		}
	}
	return err1
}

func handleReq(w http.ResponseWriter, r *http.Request) {
	value, exists := files[r.URL.Path]
	if exists {
		w.Header().Set("Content-Type", value.contentType)
		w.Write(value.content)
	} else {
		w.Header().Set("Content-Type", files["/index.html"].contentType)
		w.Write(files["/index.html"].content)
	}
}

func main() {
	var err error
	//load map
	fileSystem := os.DirFS("/html/")
	err = fs.WalkDir(fileSystem, ".", walkDirFunc)
	handleError(err)
	//start server
	http.HandleFunc("/", handleReq)
	err = http.ListenAndServe(":8080", nil)
	handleError(err)
}
