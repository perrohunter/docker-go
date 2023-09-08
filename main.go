package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", helloWorldHandler)

	fmt.Println("Servidor iniciado en :8080")
	http.ListenAndServe(":8080", nil)
}

func helloWorldHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hello world")
}
