package main

import (

    "fmt"

    "net/http"

    "os"

)

func handler(w http.ResponseWriter, r *http.Request) {

    h, _ := os.Hostname()

    fmt.Fprintf(w, "Hi there, This is served from %s!", h)

}

func main() {

    http.HandleFunc("<%= @web_root %>", handler)

    http.ListenAndServe(":<%= @listen_port %>", nil)

}
