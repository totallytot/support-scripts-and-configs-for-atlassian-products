# get cert and import it into jvm
openssl s_client -showcerts -connect jira.example.com:443 </dev/null 2>/dev/null | openssl x509 -outform PEM > /tmp/jira.pem
/opt/atlassian/jira/jre/bin/keytool -import -alias jira.example.com -keystore /opt/atlassian/jira/jre/lib/security/cacerts -file /tmp/jira.pem

REM Combine the private key and the certificate into a PKCS12 keystore
cd c:\OpenSSL-Win64\bin\
openssl.exe pkcs12 -export -in C:\certs\wildcard_cert.crt -inkey C:\certs\private.key -out C:\certs\conf.jks -name conf -CAfile C:\certs\gd_bundle-g2.crt -caname root

REM add cert to JVM trusted
cd C:\Program Files\Atlassian\Confluence\jre\bin
keytool -import -alias wikisb.example.com -keystore "C:\Program Files\Atlassian\Confluence\jre\lib\security\cacerts" -file "C:\certs\wildcard_cert.crt"

REM convert pem to key
openssl rsa -outform der -in C:\certs\jira.pem -out C:\certs\jira.key
openssl x509 -outform der -in C:\certs\jira.pem -out C:\certs\jira.key

REM Merge keystores
cd C:\Program Files\Atlassian\JIRA\jre\bin
keytool.exe -importkeystore -deststorepass PASSWORD -destkeypass PASSWORD -destkeystore "C:\certs\jira.jks" -srckeystore C:\certs\jirat.jks -srcstoretype PKCS12 -srcstorepass 1234.com -alias jira_new

REM list and delete trusted certs
keytool -list -keystore "C:\Program Files\Atlassian\JIRA\jre\lib\security\cacerts"
keytool -list -alias jira -keystore C:/certs/jira.jks
keytool -delete -alias jirast.example.com -keystore "C:\Program Files\Atlassian\JIRA\jre\lib\security\cacerts"

REM Generate the Java KeyStore:
keytool -genkey -alias jira -keyalg RSA -keystore C:/certs/jira.jks

REM Import the signed certificate
keytool -import -alias jira -keystore C:/certs/jira.jks -file C:/certs/certificate.crt
