REM export the private key:
"c:\Program Files\OpenSSL-Win64\bin\openssl.exe" pkcs12 -in jira.pfx -nocerts -out key.pem -nodes

REM export the certificate:
"c:\Program Files\OpenSSL-Win64\bin\openssl.exe" pkcs12 -in jira.pfx -nokeys -out cert.pem

REM remove the passphrase from the private key:
"c:\Program Files\OpenSSL-Win64\bin\openssl.exe" rsa -in key.pem -out private.key

REM convert cert to human readable fromat
"c:\Program Files\OpenSSL-Win64\bin\openssl.exe"  base64 -in intermediate.crt -out inter.crt
