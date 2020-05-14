#!/bin/bash

export CGO_CFLAGS="-I/usr/local/include -fPIC"
export CGO_LDFLAGS="-shared"
make

cd $PWD/mqtt/libwebsockets
make clean
cmake . -DLIB_SUFFIX=64
make
make install
cd ../mosquitto
make clean 
make 
make install 
cd ../mosquitto-go-auth
make 
cd
