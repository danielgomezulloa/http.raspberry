# Configuración HTTP para Apache en Raspberry Pi

Este proyecto incluye una configuración de servidor web Apache en HTTP para Raspberry Pi.

## 📋 Características

- Servidor HTTP en el puerto 80
- Configuración optimizada para Raspberry Pi
- Soporte para múltiples hosts virtuales
- Acceso mediante nombre de host o IP

## 🚀 Inicio rápido

### 1. Clonar este repositorio en tu Raspberry Pi

```bash
git clone https://github.com/tu-usuario/http.server.apache.raspberry.git
cd http.server.apache.raspberry/http-server
```

### 2. Iniciar el servidor

```bash
docker-compose up -d
```

### 3. Verificar que el servidor está funcionando

```bash
docker-compose ps
```

### 4. Acceder al servidor

- Desde el navegador: `http://raspberry.local` o `http://IP_DE_TU_RASPBERRY`

## ⚙️ Configuración

### Estructura del proyecto

```
http-server/
  ├── docker-compose.yml      # Configuración de Docker
  ├── apache/
  │   ├── httpd.conf          # Configuración principal de Apache
  │   └── extra/
  │       └── httpd-ssl.conf  # Archivo con configuraciones de virtual hosts
  └── html/
      └── index.html          # Página web de ejemplo
```

### Archivos de configuración

- **docker-compose.yml**: Define el contenedor Docker y los volúmenes.
- **apache/httpd.conf**: Configuración principal de Apache.
- **apache/extra/httpd-ssl.conf**: Contiene las configuraciones de virtual hosts para HTTP.

### Virtual Hosts

Se han configurado dos virtual hosts:

1. **Host por nombre**: `raspberry.local` y `www.raspberry.local`
2. **Host por IP**: Cualquier dirección IP que apunte al servidor

## 🔧 Personalización

### Añadir contenido web

Coloca tus archivos HTML, CSS, JS, etc. en la carpeta `html/`:

```bash
cp -r mi_sitio/* html/
```

### Modificar la configuración de Apache

Si necesitas modificar la configuración de Apache:

1. Edita `apache/httpd.conf` o `apache/extra/httpd-ssl.conf`
2. Reinicia el contenedor:
   ```bash
   docker-compose restart
   ```

## 📊 Logs

### Ver logs de Apache

```bash
# Ver todos los logs
docker-compose logs apache

# Ver logs en tiempo real
docker-compose logs -f apache
```

### Ubicación de los logs dentro del contenedor

- **Logs de error**: `/usr/local/apache2/logs/error_log`
- **Logs de acceso**: `/usr/local/apache2/logs/access_log`

## 🛠️ Resolución de problemas

### Problema: No puedo acceder al servidor

1. Verifica que el contenedor está en ejecución:
   ```bash
   docker-compose ps
   ```

2. Comprueba que el puerto 80 está abierto:
   ```bash
   sudo netstat -tuln | grep 80
   ```

3. Verifica el firewall:
   ```bash
   sudo ufw status
   # Si está activo, permite el puerto 80:
   sudo ufw allow 80/tcp
   ```

### Problema: El contenedor no se inicia

Verifica los logs para identificar el error:
```bash
docker-compose logs apache
```

## 📌 Notas importantes

- Esta configuración está optimizada para HTTP en el puerto 80.
- La configuración HTTPS está comentada y deshabilitada.
- Para habilitar HTTPS, consulta la documentación en SSL-README.md.
