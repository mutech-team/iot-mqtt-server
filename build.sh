#!/bin/bash
export CGO_CFLAGS="-I/usr/local/include -fPIC"
export CGO_LDFLAGS="-shared"

cd $PWD/mqtt/mosquitto
make clean
make WITH_BUNDLED_DEPS=no WITH_TLS=yes WITH_WEBSOCKETS=yes WITH_DOCS=false
make install 
cd ../mosquitto-go-auth
go build -buildmode=c-archive go-auth.go
go build -buildmode=c-shared -o go-auth.so 
cd
