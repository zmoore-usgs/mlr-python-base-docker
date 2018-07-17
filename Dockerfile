FROM alpine:3.8

RUN apk update && apk upgrade && mkdir /local
RUN apk add --update --no-cache \
  python3 \
  python3-dev \
  build-base \
  ca-certificates \
  libffi-dev \
  openssl-dev \
  openssl \
  curl && \
  rm -rf /var/cache/apk/* && \
  export PIP_CERT="/etc/ssl/certs/ca-certificates.crt" && \
  pip3 install --upgrade pip
ENV bind_ip 0.0.0.0
ENV requireSsl=true
ENV serverPort=443
ENV serverContextPath=/

ENV oauthResourceTokenKeyUri=https://example.gov/oauth/token_key
ENV jwt_algorithm=HS256
ENV jwt_decode_audience=default
ENV ssl_cert_path=/wildcard-ssl.crt
ENV ssl_key_path=/wildcard-ssl.key