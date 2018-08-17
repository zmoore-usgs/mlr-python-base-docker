FROM alpine:3.8

LABEL maintainer="gs-w_eto_eb_federal_employees@usgs.gov"

ENV USER=python
ENV HOME=/home/$USER
ENV artifact_id=sample_app
ENV gunicorn_keep_alive=75
ENV gunicorn_silent_timeout=120
ENV gunicorn_graceful_timeout=120
ENV bind_ip 0.0.0.0
ENV protocol=https
ENV listening_port=8000
ENV oauth_server_token_key_url=https://example.gov/oauth/token_key
ENV jwt_algorithm=HS256
ENV jwt_decode_audience=default
ENV CERT_IMPORT_DIRECTORY=$HOME/certificates
ENV ssl_cert_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.crt
ENV ssl_key_path=$CERT_IMPORT_DIRECTORY/wildcard-ssl.key
ENV SSL_STORAGE_DIR=$HOME/ssl
ENV PATH="$PATH:$HOME/.local/bin"

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
  pip3 install --upgrade --no-cache-dir pip && \
  if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi

RUN adduser --disabled-password -u 1000 $USER

WORKDIR $HOME
RUN mkdir $HOME/local
COPY import_certs.sh import_certs.sh
COPY entrypoint.sh entrypoint.sh
COPY gunicorn_config.py local/gunicorn_config.py
RUN [ "chmod", "+x", "import_certs.sh", "entrypoint.sh" ]
RUN chown $USER:$USER import_certs.sh entrypoint.sh local/gunicorn_config.py
RUN chown -R $USER:$USER $HOME
USER $USER
ARG GUNICORN_VERSION=19.7.1
ARG GEVENT_VERSION=1.3.5
ARG CERTIFI_VERSION=2017.11.5
RUN pip3 install --user --quiet --no-cache-dir gunicorn==$GUNICORN_VERSION && \
    pip3 install --user --quiet --no-cache-dir gevent==$GEVENT_VERSION  && \
    pip3 install --user --quiet --no-cache-dir certifi==$CERTIFI_VERSION

COPY app.py $HOME/app.py

CMD ["./entrypoint.sh"]

HEALTHCHECK CMD curl -k ${protocol}://127.0.0.1:${listening_port}/version | grep -q "$artifact_id" || exit 1

ONBUILD RUN rm $HOME/app.py
