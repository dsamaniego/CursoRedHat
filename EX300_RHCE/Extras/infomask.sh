#!/bin/bash

if [ $# -ne 1 ]
then
	echo "ERROR: No se ha introducido el número de parametros correcto."	
	exit 2
fi

ORIGINAL=$(umask) 

umask $1 2>/dev/null 

if [ $? -eq 0 ]
then		
	echo
	echo "La máscara usada es $(umask)"
	touch fichero
	mkdir directorio
	echo
	echo "Los permisos del fichero son: $(stat -c "%a %n" fichero)"
	ls -l fichero
	echo
	echo "Los permisos del directorio son: $(stat -c "%a %n" directorio)"
	ls -ld directorio
	echo
	rm -f fichero
	rmdir directorio
	umask $ORIGINAL
	exit 0
else
	echo "ERROR: la máscara introducida es incorrecta"
	exit 1
fi
