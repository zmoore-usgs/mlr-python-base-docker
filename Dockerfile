FROM alpine:3.6

RUN apk update && apk upgrade && mkdir /local
RUN apk add --update \
  python3 \
  python3-dev \
  build-base \
  ca-certificates \
  libffi-dev \
  openssl-dev \
  openssl \
  curl
RUN export PIP_CERT="/etc/ssl/certs/ca-certificates.crt" && \
    pip3 install --upgrade pip
ENV bind_ip 0.0.0.0
