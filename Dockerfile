FROM alpine:3.8

LABEL maintainer="gs-w_eto_eb_federal_employees@usgs.gov"

ENV USER=python
ENV HOME=/home/$USER
ENV bind_ip 0.0.0.0
ENV requireSsl=true
ENV serverPort=443
ENV serverContextPath=/
ENV oauthResourceTokenKeyUri=https://example.gov/oauth/token_key
ENV jwt_algorithm=HS256
ENV jwt_decode_audience=default
ENV CERT_IMPORT_DIRECTORY=$HOME/certificates
ENV ssl_cert_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.crt
ENV ssl_key_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.key

RUN apk update && apk upgrade && apk add --update --no-cache \
  python3 \
  python3-dev \
  build-base \
  ca-certificates \
  libffi-dev \
  openssl-dev \
  openssl \
  curl && \
  rm -rf /var/cache/apk/*

RUN export PIP_CERT="/etc/ssl/certs/ca-certificates.crt" && \
  python3 -m ensurepip && \
  rm -r /usr/lib/python*/ensurepip && \
  pip3 install --upgrade pip && \
  if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi

RUN adduser -D -u 1000 $USER
# The python user needs to own the following two directories to be able to write
# to them as part of the update-ca-certificates command in the import_certs.sh
# script
RUN chown -R $USER /usr/local/share/ca-certificates
RUN chown -R $USER /etc/ssl/certs

COPY import_certs.sh $HOME/import_certs.sh
RUN chmod +x $HOME/import_certs.sh
RUN chown $USER:$USER $HOME/import_certs.sh

USER $USER
RUN mkdir $HOME/local
WORKDIR $HOME
