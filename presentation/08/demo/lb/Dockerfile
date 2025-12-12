FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Генерируем самоподписанный сертификат
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
      -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/selfsigned.key \
      -out /etc/nginx/ssl/selfsigned.crt \
      -subj "/C=RU/ST=NA/L=NA/O=Demo/OU=Dev/CN=localhost" \
      -addext "subjectAltName=DNS:localhost,DNS:lb"

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]