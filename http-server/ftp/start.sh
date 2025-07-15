#!/bin/sh
# Detecta la IP automáticamente
export PASV_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
echo "Usando IP para PASV: $PASV_ADDRESS"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf