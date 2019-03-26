#!/bin/bash


# INTRO: Este script instala un servidor IPA en un rhel/centos 7 . Está testeado sobre una instalación minimal de Centos 7 , a la que se le ha configurado la ip de manera estática, con los servicios NetworkManager y firewalld activos y enabled

# BEST PRACTICE: Actualizar el sistema y reboot, antes de configurar nada.

# Variables que tengo rellenar antes de ejecutar el script:

MIRED=""   # Red en la que tengo las máquinas virtuales
h=""       # Hostname que me quiero dar, p.e. server.example.com
MYIP=""    # Ip que tengo, SIN PREFIJO

U1=""      # Usuario que quiero añadir al servidor IPA
U2=""      # Otro usuario para el servidor IPA

MYDNS=""   # servidor dns que usa este sistema operativo 

# Otras variables

H=$(echo $h | tr 'a-z' 'A-Z')

# Configuro mi hostname

hostnamectl set-hostname $h


# Para la resolución

echo "${MYIP}      ${h}"  >> /etc/hosts

# Instalación software

yum -y install ipa-server ipa-server-dns bind bind-dyndb-ldap

# Configuración firewall

firewall-cmd --permanent --add-service=http --add-service=https --add-service=ntp --add-service=ldap --add-service=ldaps --add-service=kerberos --add-service=kpasswd  --add-service=dns 
firewall-cmd --reload 

# CONFIGURACIÓN SERVIDOR IPA

# Para la sincronización NTP

yum install chrony -y
 
echo "allow ${MIRED}" >> /etc/chrony.conf
systemctl restart chronyd

# Script de instalación del servidor IPA


ipa-server-install -N -a redhat123 -p redhat123 --hostname $h -n $h -r $H --idstart 2000 --idmax 4000 --no-ui-redirect -U 


# Publico el certificado del servidor IPA 

cp /etc/ipa/ca.crt /var/www/html/


# Añadir  usuarios

echo redhat123 | kinit admin

ipa config-mod --homedirectory=/home/guests

echo -en "redhat\nredhat\n" | ipa user-add $U1 --first IPA --last User --password 
echo -en "redhat\nredhat\n" | ipa user-add $U2 --first IPA --last User --password 

ipa user-find admin

if [ $? -eq 0 ]
then
    echo Parece que todo correcto, lee la NOTA IMPORTANTE que hay en el script.
else
    echo Parece que hay algun error, lee la NOTA IMPORTANTE que hay en el script.
fi

sleep 10

echo SE VA A HACER UN REBOOT DEL SISTEMA

systemctl reboot

			#########################
			#### NOTA IMPORTANTE ####
			#########################
		
#### Si has tenido algún error a la hora de instalar el servido IPA SIGUIENDO LOS PASOS haz lo siguiente:
#   1. verifica que has puesto bien el valor de las variables 
#   2. ejecuta el comando "systemctl restart dbus"
#   3. ejecuta el comando "ipa-server-install --uninstall"
#   4. vuelve a ejecutar el script 
 
#### Si no tienes servidor DNS y quieres usar el integrado que hay en el servidor IPA ejecuta lo siguiente:
#   1. firewall-cmd --permanent --add-service=dns 
#      firewall-cmd --reload
#   2. ipa-dns-install --forwarder=$MYDNS

#### Una vez ejecutado el script correctamente, te puedes loguear en la consola web de administración del servidor IPA en
#                                        https://${h}/ipa/ui/
#     login: admin 
#     password: redhat123 
# si no resuelve escribe la ip con al lado el fqdm en el /etc/hosts

#### Puedes verificar el estado del servidor IPA en cualquier momento con el comando:
#       ipactl status
