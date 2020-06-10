# openssl save remote crt to file
openssl x509 -in <(openssl s_client -connect company.com:443 -prexit 2>/dev/null) > ca.crt
