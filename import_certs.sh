#!/bin/ash
# shellcheck shell=dash

if [ -n "${CERT_IMPORT_DIRECTORY}" ] && [ -d "${CERT_IMPORT_DIRECTORY}" ]; then
  for c in $CERT_IMPORT_DIRECTORY/*.crt; do
    FILENAME="${c%.*}" # get just file name, not extension

    cp $FILENAME.crt /tmp/$FILENAME.crt
    openssl x509 -in /tmp/$FILENAME.crt -out $HOME/local/$FILENAME.pem -outform PEM
    chown $USER:$USER $HOME/local/$FILENAME.pem
    mv /tmp/$FILENAME.crt /usr/local/share/ca-certificates/$FILENAME.crt

	done
fi
update-ca-certificates
