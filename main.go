package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Helm demo running in >>>>>>>> %s environment <<<<<<<<<<<\n", os.Getenv("DEMO_ENV"))
		fmt.Fprintf(w, "Jenkins build id >>>>>>>> %s <<<<<<<<<<<\n", os.Getenv("JENKINS_BUILD_ID"))
	})
	fmt.Println("Straring server on http://localhost:9090")
	log.Fatal(http.ListenAndServe(":9090", nil))
}
