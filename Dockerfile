FROM alpine:3.8

LABEL maintainer="gs-w_eto_eb_federal_employees@usgs.gov"

ENV USER=python
ENV HOME=/home/$USER
ENV bind_ip 0.0.0.0
ENV listening_port=8443
ENV oauth_server_token_key_url=https://example.gov/oauth/token_key
# Blank value here means the SSL connection to the above URL is not verified
ENV oauth_server_cert_path=
ENV jwt_algorithm=HS256
ENV jwt_decode_audience=default
ENV CERT_IMPORT_DIRECTORY=$HOME/certificates
ENV ssl_cert_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.crt
ENV ssl_key_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.key

RUN apk update && apk add --update --no-cache \
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

RUN pip3 install gunicorn==19.7.1

RUN adduser --disabled-password -u 1000 $USER
# The python user needs to own the following two directories to be able to write
# to them as part of the update-ca-certificates command in the import_certs.sh
# script
RUN chown -R $USER /usr/local/share/ca-certificates
RUN chown -R $USER /etc/ssl/certs

WORKDIR $HOME
RUN mkdir $HOME/local
COPY import_certs.sh import_certs.sh
COPY entrypoint.sh entrypoint.sh
COPY gunicorn_config.py local/gunicorn_config.py
RUN [ "chmod", "+x", "import_certs.sh", "entrypoint.sh" ]
RUN chown $USER:$USER import_certs.sh entrypoint.sh local/gunicorn_config.py
USER $USER

CMD ["./entrypoint.sh"]