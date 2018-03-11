FROM golang:1.9-alpine as builder

RUN apk update &&  apk upgrade
RUN apk add --no-cache git make gcc musl-dev linux-headers

RUN git clone https://github.com/ethereum/go-ethereum.git

ARG GETH_VER=master
RUN cd  go-ethereum && git checkout $GETH_VER && make geth
RUN cp go-ethereum/build/bin/geth /usr/local/bin/

RUN mkdir -p /var/lib/geth/config
ADD ./config/genesis.json /var/lib/geth/config/
ADD ./config/bootnode.id /var/lib/geth/config/
ADD ./config/etherbase.key /var/lib/geth/config/

RUN mkdir -p /var/lib/geth/data/keystore
COPY ./config/keystore/*  /var/lib/geth/data/keystore/

ADD ./bin/launch-geth.sh ./

CMD ./launch-geth.sh

EXPOSE 8545 8546 30303 30303/udp 30304/udp

