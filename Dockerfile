FROM python:3.6-alpine

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
ENV PROJ_DIR=/usr
ENV PATH="$PATH:$HOME/.local/bin"
ENV PIP_CERT=/etc/ssl/certs/ca-certificates.crt

RUN apk update && apk add --update --no-cache \
  build-base \
  ca-certificates \
  libffi-dev \
  openssl-dev \
  openssl \
  netcat-openbsd \
  proj \
  proj-util \
  proj-dev \
  curl && \
  rm -rf /var/cache/apk/*

RUN if getent ahosts "sslhelp.doi.net" > /dev/null 2>&1; then \
                wget 'https://s3-us-west-2.amazonaws.com/prod-owi-resources/resources/InstallFiles/SSL/DOIRootCA.cer' -O /usr/local/share/ca-certificates/DOIRootCA2.crt && \
                update-ca-certificates; \
        fi

RUN python3 -m ensurepip && \
  rm -rf /usr/lib/python*/ensurepip && \
  pip3 install --upgrade --no-cache-dir pip==20.0.2 && \
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
ARG GUNICORN_VERSION=20.0.4
ARG GEVENT_VERSION=1.4.0
ARG CERTIFI_VERSION=2019.11.28
RUN pip3 install --user --quiet --no-cache-dir gunicorn==$GUNICORN_VERSION && \
    pip3 install --user --quiet --no-cache-dir gevent==$GEVENT_VERSION  && \
    pip3 install --user --quiet --no-cache-dir certifi==$CERTIFI_VERSION

# This is used for downstream containers that may need this scripting in order to
# orchestrate container startups.
# See: https://github.com/eficode/wait-for
RUN curl -o ./wait-for.sh https://raw.githubusercontent.com/eficode/wait-for/f71f8199a0dd95953752fb5d3f76f79ced16d47d/wait-for && \
  chmod +x ./wait-for.sh

COPY app.py $HOME/app.py

CMD ["./entrypoint.sh"]

HEALTHCHECK CMD curl -k ${protocol}://127.0.0.1:${listening_port}/version | grep -q "\"artifact\": \"${artifact_id}\"" || exit 1

ONBUILD RUN rm $HOME/app.py
