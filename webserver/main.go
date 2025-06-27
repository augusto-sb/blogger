package main

import (
	"io/fs"
	"net/http"
	"os"
	"strconv"
	"strings"
)

type File struct {
	content     []byte
	contentType string
}

type Files map[string]File

var files Files = Files{}
var replaceEnvs bool = false;
var mimeMap map[string]string = map[string]string{
	".css": "text/css",
};

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
			if(replaceEnvs){
				fileByteArr = []byte(strings.ReplaceAll(string(fileByteArr), "/context/path", os.Getenv("CONTEXT_PATH")))
			}
			files["/"+path] = File{content: fileByteArr, contentType: http.DetectContentType(fileByteArr)}
		}
	}
	return err1
}

func handleReq(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Cache-Control", "max-age=86400")
	value, exists := files[r.URL.Path]
	if !exists {
		value, exists = files["/index.html"]
	}
	if !exists {
		w.WriteHeader(http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", value.contentType)
	w.Header().Set("Content-Length", strconv.Itoa(len(value.content)))
	w.Write(value.content)
}

func main() {
	var err error
	//load map
	if(os.Getenv("REPLACE_ENVS")=="true"){
		replaceEnvs = true;
	}
	fileSystem := os.DirFS("/html/")
	err = fs.WalkDir(fileSystem, ".", walkDirFunc)
	handleError(err)
	//start server
	http.HandleFunc("/", handleReq)
	err = http.ListenAndServe(":8080", nil)
	handleError(err)
}
