Development wildcard certificates generated via:

```
$ openssl genrsa -out wildcard-dev.key 2048
$ openssl req -nodes -newkey rsa:2048 -keyout  wildcard-dev.key -out  wildcard-dev.csr -subj "/C=US/ST=Wisconsin/L=Middleon/O=US Geological Survey/OU=WMA/CN=*"
$ openssl x509 -req -days 9999 -in wildcard-dev.csr -signkey wildcard-dev.key  -out wildcard-dev.crt