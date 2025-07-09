#!/bin/bash

# Script para verificar los certificados SSL generados

echo "🔍 Verificando certificados SSL..."
echo ""

# Verificar que los archivos existen
if [ -f "apache/ssl/raspberry.key" ] && [ -f "apache/ssl/raspberry.crt" ]; then
    echo "✅ Archivos de certificado encontrados"
else
    echo "❌ Archivos de certificado no encontrados"
    echo "   Ejecuta: ./generate-ssl.sh"
    exit 1
fi

# Verificar permisos
echo ""
echo "📋 Permisos de archivos:"
ls -la apache/ssl/

# Mostrar información del certificado
echo ""
echo "📜 Información del certificado:"
openssl x509 -in apache/ssl/raspberry.crt -text -noout | grep -A 2 "Subject:"
openssl x509 -in apache/ssl/raspberry.crt -text -noout | grep -A 10 "Subject Alternative Name"

# Verificar fechas de validez
echo ""
echo "📅 Validez del certificado:"
openssl x509 -in apache/ssl/raspberry.crt -dates -noout

# Verificar que la clave privada coincide con el certificado
echo ""
echo "🔐 Verificando coincidencia clave-certificado..."
key_md5=$(openssl rsa -noout -modulus -in apache/ssl/raspberry.key | openssl md5)
cert_md5=$(openssl x509 -noout -modulus -in apache/ssl/raspberry.crt | openssl md5)

if [ "$key_md5" = "$cert_md5" ]; then
    echo "✅ La clave privada coincide con el certificado"
else
    echo "❌ La clave privada NO coincide con el certificado"
    exit 1
fi

echo ""
echo "🎉 Verificación completada. Los certificados están listos para usar."
