package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	cuerr "cuelang.org/go/cue/errors"
	"cuelang.org/go/cue/load"
)

func loadConfig(moduleRoot string) (cue.Value, error) {
	cueCtx := cuecontext.New()
	files := []string{
		filepath.Join(moduleRoot, "config", "tenant", "config.cue"),
		filepath.Join(moduleRoot, "config", "tenant", "formats", "flux.cue"),
	}

	bis := load.Instances(files, &load.Config{
		ModuleRoot: moduleRoot,
	})
	bi := bis[0]
	mergedConfig := cueCtx.BuildInstance(bi)
	if err := mergedConfig.Err(); err != nil {
		fmt.Println(cuerr.Details(err, nil))
		return cue.Value{}, err
	}

	return mergedConfig, nil
}

func main() {
	pwd, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}
	config, err := loadConfig(pwd)
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Println(config)
}
