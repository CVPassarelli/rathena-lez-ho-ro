FROM alpine:3.23
WORKDIR /validation
RUN apk add --no-cache bash ca-certificates gcc g++ git linux-headers make mariadb-client mariadb-dev pcre-dev python3 zlib-dev
ENTRYPOINT []
