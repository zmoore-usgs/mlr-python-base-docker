#!/bin/ash
# shellcheck shell=dash

echo "Importing ca certificates..."

#Create PEM Cert Storage Dir
mkdir -p $SSL_STORAGE_DIR

# Get Certifi cacert PEM path
CERTIFI_CACERT_PATH=$(python -c "import certifi; print(certifi.where())")

# Ensure certificate import directory exists
if [ -n "${CERT_IMPORT_DIRECTORY}" ] && [ -d "${CERT_IMPORT_DIRECTORY}" ]; then
  CERT_COUNT=$(find $CERT_IMPORT_DIRECTORY -name "*.crt" -type f | wc -l)
  if [ $CERT_COUNT -gt 0 ]; then
    for c in ${CERT_IMPORT_DIRECTORY}/*.crt; do
      FILENAME=`basename ${c%.*}` # get just file name, not extension
      echo "Importing $FILENAME.crt"
      #Convert CRT to PEM and append to certifi cacerts
      openssl x509 -in $CERT_IMPORT_DIRECTORY/$FILENAME.crt -out $SSL_STORAGE_DIR/$FILENAME.pem
      cat $SSL_STORAGE_DIR/$FILENAME.pem >> $CERTIFI_CACERT_PATH
    done
  else
    echo "No certificates found in $CERT_IMPORT_DIRECTORY"
  fi
else
    echo "Could not find or access cert import directory: $CERT_IMPORT_DIRECTORY"
fi
