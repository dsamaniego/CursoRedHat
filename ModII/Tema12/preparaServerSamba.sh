#!/bin/bash
# Last update: 12-jun-2017

echo "Preparando server para ejercicio extra Samba..."
yum install samba samba-common samba-client -y
systemctl start smb nmb
systemctl enable smb nmb
firewall-cmd --add-service=samba --permanent
firewall-cmd --reload
mkdir -p /samba/getafe
cat > /samba/getafe/file_getafe.txt << EOF
Puedo acceder!!!
EOF

chmod 777 /samba/getafe/file_getafe.txt
semanage fcontext -a -t samba_share_t '/samba/getafe(/.*)?' 
restorecon -FRvv /samba
cat >> /etc/samba/smb.conf << EOF
[practica]
  comment = dir para la practica
  path = /samba/getafe
  writable = yes
  valid users = pepe
EOF

useradd pepe
echo -en "perez\nperez\n" | smbpasswd -a  pepe # se le da la password perez
systemctl restart smb nmb

echo "Terminado"
