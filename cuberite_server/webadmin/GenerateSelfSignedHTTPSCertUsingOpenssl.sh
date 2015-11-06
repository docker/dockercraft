#!/bin/bash

echo "This script generates the certificate and private key for the https webadmin"
echo "Note that the generated certificate is self-signed, and therefore not trusted by browsers"
echo "Note that this script requires openssl to be installed and in PATH"
echo ""
echo "When OpenSSL asks you for Common Name, you need to enter the fully qualified domain name of the server, that is, e. g. gallery.xoft.cz"
echo ""

openssl req -x509 -newkey rsa:2048 -keyout httpskey.pem -out httpscert.crt -days 3650 -nodes
