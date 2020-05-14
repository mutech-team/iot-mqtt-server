#!/bin/bash

#----install all apt packages----#
apt-get -y update && apt-get upgrade
apt-get update && apt-get -y install cmake protobuf-compiler
apt-get -y install apt-utils
apt-get -y install git
apt-get -y install build-essential
apt-get -y install libc-ares-dev
apt-get -y install uuid-dev
apt-get -y install libssl-dev
apt-get -y install libwebsockets-dev libc-ares2 libc-ares-dev openssl uuid uuid-dev
apt-get -y install golang-go
apt-get -y install golang
apt-get -y install go-dep

go get github.com/go-redis/redis
go get github.com/go-sql-driver/mysql
go get github.com/dgrijalva/jwt-go
go get github.com/golang/protobuf/proto
go get github.com/jmoiron/sqlx
go get github.com/lib/pq
go get github.com/mattn/go-sqlite3
go get github.com/pkg/errors
go get github.com/sirupsen/logrus
go get go.mongodb.org/mongo-driver/bson
go get github.com/grpc-ecosystem/go-grpc-middleware/logging/logrus
go get golang.org/x/crypto/pbkdf2
go get google.golang.org/grpc
go get google.golang.org/grpc/codes
go get google.golang.org/grpc/credentials
go get google.golang.org/grpc/status
