sudo apt update && sudo apt install apache2-utils -y

mkdir tls
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout tls/node_exporter.key -out tls/node_exporter.crt -subj "/C=AU/ST=Some-State/CN=localhost" -addext "subjectAltName = DNS:localhost"
chown -R 1000:1000 tls

password=`openssl rand -base64 32`
passwordHashed=`echo ${password} | htpasswd -inBC 10 "" | tr -d ':\n'`
sed -i "s,\(prometheus: \).*,\1$passwordHashed," configuration.yml
echo "Clear password to keep for Prometheus Server: ${password}"
