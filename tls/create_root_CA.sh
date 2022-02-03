#!/bin/bash
set -e
#################
HOST='localhost'
ROOT='root'
OPENSSL_CNF='/etc/pki/tls/openssl.cnf'
#################

# GENERATE CERTIFICATE REQUEST
openssl req -new -nodes -text -out $ROOT.pem -keyout $ROOT.key -subj "/CN=$ROOT.$HOST"

# SIGN THE REQUEST WITH THE KEY TO CREATE A ROOT CERTIFICATE AUTHORITY
openssl x509 -req -in $ROOT.pem -text -days 3650 -extfile $OPENSSL_CNF -extensions v3_ca -signkey $ROOT.key -out $ROOT.crt

chmod 600 root.key
chmod 664 root.crt root.pem
