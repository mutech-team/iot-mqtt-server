FROM ubuntu

#----install all apt packages----#
RUN apt-get -y update 
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get update && apt-get -y install cmake protobuf-compiler
RUN apt-get -y install apt-utils
RUN apt-get -y install git
RUN apt-get -y install build-essential
RUN apt-get -y install libc-ares-dev
RUN apt-get -y install uuid-dev
RUN apt-get -y install libssl-dev
RUN apt-get -y install libwebsockets-dev
RUN apt-get -y install libc-ares2
RUN apt-get -y install libc-ares-dev
RUN apt-get -y install openssl
RUN apt-get -y install uuid
RUN apt-get -y install uuid-dev
RUN apt-get -y install golang-go
RUN apt-get -y install golang
RUN apt-get -y install go-dep

#----install all go packages----#
RUN go get github.com/go-redis/redis
RUN go get github.com/go-sql-driver/mysql
RUN go get github.com/dgrijalva/jwt-go
RUN go get github.com/golang/protobuf/proto
RUN go get github.com/jmoiron/sqlx
RUN go get github.com/lib/pq
RUN go get github.com/mattn/go-sqlite3
RUN go get github.com/pkg/errors
RUN go get github.com/sirupsen/logrus
RUN go get go.mongodb.org/mongo-driver/bson
RUN go get github.com/grpc-ecosystem/go-grpc-middleware/logging/logrus
RUN go get golang.org/x/crypto/pbkdf2
RUN go get google.golang.org/grpc
RUN go get google.golang.org/grpc/codes
RUN go get google.golang.org/grpc/credentials
RUN go get google.golang.org/grpc/status

COPY mqtt mqtt
COPY mosquitto.conf /mqtt/mosquitto/mosquitto.conf
COPY build.sh .
RUN ./build.sh
CMD  ./mqtt/mosquitto/src/mosquitto -c mosquitto.conf && tail -f /dev/null

