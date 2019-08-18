FROM alpine:3.9

RUN apk add --update \
    musl-dev gcc ca-certificates curl unzip \
    luajit luajit-dev lua5.1 lua5.1-dev luarocks5.1

RUN USER=root luarocks-5.1 install busted
