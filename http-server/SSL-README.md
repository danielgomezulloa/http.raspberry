# Configuración SSL para Apache en Raspberry Pi

Este proyecto incluye una configuración completa de SSL para Apache ejecutándose en Docker en una Raspberry Pi.

## 🔧 Configuración Incluida

### Archivos de Configuración SSL

1. **`apache/extra/httpd-ssl.conf`** - Configuración principal de SSL para Apache
2. **`apache/ssl/`** - Directorio para certificados SSL
3. **`generate-ssl.sh`** - Script para generar certificados autofirmados

### Características de Seguridad

- ✅ TLS 1.2 y 1.3 habilitados
- ✅ Protocolos inseguros deshabilitados (SSLv2, SSLv3, TLSv1, TLSv1.1)
- ✅ Cifrados seguros configurados
- ✅ Redirección automática de HTTP a HTTPS
- ✅ Subject Alternative Names (SAN) para múltiples dominios
- ✅ Permisos de archivos apropiados

## 🚀 Pasos para Configurar SSL

### 1. Generar Certificados SSL

Ejecuta el script desde el directorio `http-server`:

```bash
cd http-server
chmod +x generate-ssl.sh
./generate-ssl.sh
```

Este script genera:
- `apache/ssl/raspberry.key` - Clave privada
- `apache/ssl/raspberry.crt` - Certificado autofirmado

### 2. Verificar Docker Compose

El archivo `docker-compose.yml` ya está configurado para montar:
- Los certificados SSL (`./apache/ssl:/usr/local/apache2/ssl`)
- La configuración SSL (`./apache/extra:/usr/local/apache2/conf/extra`)

### 3. Iniciar el Servidor

```bash
docker-compose up -d
```

### 4. Verificar el Funcionamiento

El servidor estará disponible en:
- **HTTP**: http://raspberry.local (redirige automáticamente a HTTPS)
- **HTTPS**: https://raspberry.local
- **IP Local**: https://[IP_DE_TU_RASPBERRY]

## 🌐 Configuración de Red

### Hostnames Configurados

El certificado SSL incluye los siguientes nombres:
- `raspberry.local`
- `www.raspberry.local`
- `localhost`

### IPs Incluidas en el Certificado

- `127.0.0.1` (localhost)
- `192.168.1.100` (IP de ejemplo para red local)
- `10.0.0.100` (IP de ejemplo para red local)

**Nota**: Puedes modificar estas IPs en el script `generate-ssl.sh` antes de ejecutarlo.

## ⚠️ Consideraciones de Seguridad

### Certificados Autofirmados

- Los navegadores mostrarán una advertencia de seguridad
- Esto es normal para certificados autofirmados
- Puedes aceptar la excepción de seguridad para continuar

### Para Producción

Para un entorno de producción, considera:
1. **Let's Encrypt** - Certificados gratuitos y válidos
2. **Certificados comerciales** - De una Autoridad Certificadora reconocida
3. **Cloudflare** - Proxy SSL gratuito

## 🔍 Solución de Problemas

### Error: Certificados no encontrados

```bash
# Verifica que los archivos existen
ls -la apache/ssl/

# Regenera los certificados si es necesario
./generate-ssl.sh
```

### Error: Puerto 443 en uso

```bash
# Verifica qué está usando el puerto
sudo netstat -tulpn | grep :443

# Detén el contenedor si está ejecutándose
docker-compose down
```

### Problemas de Permisos

```bash
# Verifica los permisos de los certificados
ls -la apache/ssl/

# Los permisos deben ser:
# -rw------- raspberry.key (600)
# -rw-r--r-- raspberry.crt (644)
```

## 📝 Logs

### Logs de SSL

Los logs de SSL se guardan en:
- `/usr/local/apache2/logs/ssl_error_log` - Errores SSL
- `/usr/local/apache2/logs/ssl_access_log` - Accesos SSL
- `/usr/local/apache2/logs/ssl_request_log` - Requests SSL detallados

### Ver Logs en Docker

```bash
# Logs del contenedor
docker-compose logs apache

# Seguir logs en tiempo real
docker-compose logs -f apache
```

## 🔄 Renovación de Certificados

Los certificados autofirmados son válidos por 365 días. Para renovarlos:

```bash
# Regenerar certificados
./generate-ssl.sh

# Reiniciar Apache
docker-compose restart apache
```

## 📋 Configuración Avanzada

### Personalizar el Certificado

Edita el script `generate-ssl.sh` para modificar:
- Información del certificado (país, estado, organización)
- Dominios adicionales en Subject Alternative Names
- IPs adicionales
- Tiempo de validez

### Usar Certificados Existentes

Si tienes certificados existentes:

1. Copia tus archivos a `apache/ssl/`:
   - `raspberry.crt` (certificado)
   - `raspberry.key` (clave privada)

2. Establece los permisos correctos:
   ```bash
   chmod 600 apache/ssl/raspberry.key
   chmod 644 apache/ssl/raspberry.crt
   ```

3. Reinicia el contenedor:
   ```bash
   docker-compose restart apache
   ```
