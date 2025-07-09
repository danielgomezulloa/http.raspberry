#!/bin/bash

# Crear directorio para certificados SSL si no existe
mkdir -p apache/ssl

# Generar una clave privada
openssl genrsa -out apache/ssl/server.key 2048

# Generar un CSR (Certificate Signing Request)
openssl req -new -key apache/ssl/server.key -out apache/ssl/server.csr -subj "/C=CL/ST=Santiago/L=Santiago/O=Raspberry/OU=Server/CN=raspberry.local"

# Crear un certificado autofirmado válido por 365 días
openssl x509 -req -days 365 -in apache/ssl/server.csr -signkey apache/ssl/server.key -out apache/ssl/server.crt

# Establecer permisos adecuados
chmod 600 apache/ssl/server.key
chmod 644 apache/ssl/server.crt

echo "Certificados SSL generados correctamente"
