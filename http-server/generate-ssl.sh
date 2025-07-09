#!/bin/bash

# Script para generar certificados SSL autofirmados para Apache en Raspberry Pi
# Este script debe ejecutarse desde el directorio http-server

set -e

echo "🔒 Generando certificados SSL para Apache en Raspberry Pi..."

# Crear directorio ssl si no existe
mkdir -p apache/ssl

# Generar clave privada RSA de 2048 bits
echo "📝 Generando clave privada..."
openssl genrsa -out apache/ssl/raspberry.key 2048

# Crear archivo de configuración OpenSSL con SAN
echo "🌐 Creando configuración con Subject Alternative Names..."
cat > apache/ssl/openssl.conf << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CL
ST = Santiago
L = Santiago
O = Raspberry Pi
OU = IT Department
CN = raspberry.local
emailAddress = admin@raspberry.local

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = raspberry.local
DNS.2 = www.raspberry.local
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = 192.168.1.100
IP.3 = 10.0.0.100
EOF

# Generar CSR con la configuración personalizada
echo "📜 Generando Certificate Signing Request..."
openssl req -new -key apache/ssl/raspberry.key -out apache/ssl/raspberry.csr -config apache/ssl/openssl.conf

# Generar certificado autofirmado con SAN válido por 365 días
echo "🔐 Generando certificado autofirmado..."
openssl x509 -req -in apache/ssl/raspberry.csr -signkey apache/ssl/raspberry.key -out apache/ssl/raspberry.crt -days 365 -extensions v3_req -extfile apache/ssl/openssl.conf

# Establecer permisos apropiados
echo "🔒 Estableciendo permisos de seguridad..."
chmod 600 apache/ssl/raspberry.key
chmod 644 apache/ssl/raspberry.crt

# Limpiar archivos temporales
rm apache/ssl/raspberry.csr apache/ssl/openssl.conf

echo "✅ Certificados SSL generados exitosamente!"
echo ""
echo "📋 Archivos generados:"
echo "   - apache/ssl/raspberry.key (clave privada)"
echo "   - apache/ssl/raspberry.crt (certificado)"
echo ""
echo "🔧 Configuración completada para:"
echo "   - raspberry.local"
echo "   - www.raspberry.local" 
echo "   - localhost"
echo "   - 127.0.0.1, 192.168.1.100, 10.0.0.100"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   1. Estos son certificados autofirmados"
echo "   2. El navegador mostrará una advertencia de seguridad"
echo "   3. Puedes aceptar la excepción de seguridad para continuar"
echo "   4. Para producción, considera usar Let's Encrypt"
echo ""
echo "🚀 Para iniciar el servidor:"
echo "   docker-compose up -d"
echo ""
echo "🌐 Acceso HTTPS:"
echo "   https://raspberry.local"
echo "   https://localhost (si estás en la misma máquina)"
echo "   https://[IP_DE_TU_RASPBERRY]"
