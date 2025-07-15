# Servidor FTP para Raspberry Pi

Este documento describe cómo utilizar el servidor FTP configurado en tu Raspberry Pi.

## 🚀 Características

- Servidor FTP ligero basado en vsftpd
- Comparte el mismo directorio que tu servidor web Apache
- Soporte para modo pasivo (compatible con la mayoría de clientes FTP)
- Logs detallados para monitoreo
- Reinicio automático en caso de fallo

## 📋 Credenciales por defecto

- **Usuario:** `ftpuser`
- **Contraseña:** `ftppassword`
- **Directorio raíz:** `/ftp/upload` (mapeado a `./html` en el host)

## 🔧 Configuración de puertos

- **Puerto de control:** 21
- **Puertos de datos (modo pasivo):** 21000-21010

## 🌐 Cómo conectarse

### Desde un cliente FTP (FileZilla, WinSCP, etc.)

- **Host:** IP de tu Raspberry Pi (ej. 192.168.1.100)
- **Puerto:** 21
- **Usuario:** ftpuser
- **Contraseña:** ftppassword
- **Protocolo:** FTP - File Transfer Protocol (no SFTP)

### Desde el Explorador de Windows

En la barra de direcciones:
```
ftp://ftpuser:ftppassword@IP_DE_TU_RASPBERRY
```

### Desde el terminal (Linux/Mac)

```bash
ftp -p IP_DE_TU_RASPBERRY
# Cuando te pida usuario: ftpuser
# Cuando te pida contraseña: ftppassword
```

## 🔒 Consideraciones de seguridad

⚠️ **IMPORTANTE:** Por razones de seguridad, se recomienda:

1. Cambiar el usuario y contraseña predeterminados
2. No exponer el puerto FTP a Internet (solo usar en red local)
3. Considerar el uso de SFTP a través de SSH para mayor seguridad

## 📝 Cambiar usuario y contraseña

Edita el archivo `docker-compose.yml` y modifica la siguiente línea:

```yaml
- USERS="ftpuser|ftppassword|/ftp/upload"
```

Puedes añadir más usuarios separados por comas:
```yaml
- USERS="usuario1|contraseña1|/ftp/upload,usuario2|contraseña2|/ftp/upload"
```

Después de editar, reinicia el contenedor:
```bash
docker-compose restart ftp
```

## 📊 Logs y depuración

Los logs del servidor FTP se almacenan en:
```
./ftp/logs/
```

Para ver los logs en tiempo real:
```bash
docker-compose logs -f ftp
```

## 📁 Estructura de archivos

- Todos los archivos subidos por FTP estarán disponibles en la carpeta `html/`
- Estos archivos serán automáticamente accesibles vía web en: `http://IP_RASPBERRY/nombredelarchivo`
- Ideal para subir imágenes y archivos para tu sitio web

## 💡 Consejos

- Para grandes transferencias de archivos, considera usar SFTP que es más fiable
- Si tienes problemas de conexión en modo pasivo, verifica que los puertos 21000-21010 estén abiertos en tu router/firewall
- El directorio de upload está compartido con Apache, así que cualquier archivo subido por FTP estará inmediatamente disponible en tu servidor web
