#!/bin/bash

# Este script necesita como parámetro un comando, al ejecutar este script:
#      - dirá que está ejecutando el comando, como el user que ejecuta el script
#      - mandará un mail a root con el output del comando

 
echo Mando un mail a root con el output del comando $1 ejecutado como el usuario $USER
echo 
echo Report generado por $USER con el output del comando $1 : $(${1})| mailx -s "Output del comando $1" root@localhost 
