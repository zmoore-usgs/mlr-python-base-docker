#!/bin/ash
# shellcheck shell=dash

echo "Importing ca certificates..."

# Ensure certificate import directory exists
if [ -n "${CERT_IMPORT_DIRECTORY}" ] && [ -d "${CERT_IMPORT_DIRECTORY}" ]; then
  CERT_COUNT=$(find $CERT_IMPORT_DIRECTORY -name "*.crt" -type f | wc -l)
  if [ $CERT_COUNT -gt 0 ]; then
    for c in ${CERT_IMPORT_DIRECTORY}/*.crt; do
      FILENAME=`basename ${c%.*}` # get just file name, not extension
      #openssl x509 -in $CERT_IMPORT_DIRECTORY/$FILENAME.crt -out $CERT_IMPORT_DIRECTORY/$FILENAME.pem -outform PEM
      cp $CERT_IMPORT_DIRECTORY/$FILENAME.crt /usr/local/share/ca-certificates/$FILENAME.crt
    done
    update-ca-certificates
  else
    echo "No certificates found in $CERT_IMPORT_DIRECTORY"
  fi
else
    echo "Could not find or access cert import directory: $CERT_IMPORT_DIRECTORY"
fi
