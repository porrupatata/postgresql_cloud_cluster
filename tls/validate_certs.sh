#!/bin/bash
set -e
# check: private key
for u in $(ls *.key)
do
 echo -e "\n==== PRIVATE KEY: $u ====\n"
 openssl rsa -in $u -check
done

# check: certificate request
for u in $(ls *.pem)
do
 echo -e "\n==== CERTIFICATE REQUEST: $u ====\n"
 openssl req -text -noout -verify -in $u
done

# check: signed certificate
for u in $(ls *.crt)
do
 echo -e "\n==== SIGNED CERTIFICATE: $u ====\n"
 openssl req -text -noout -verify -in $u
done
