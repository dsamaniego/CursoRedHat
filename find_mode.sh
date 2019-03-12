#!/bin/bash

RUTA="/tmp/mode.dir"
mkdir $RUTA

for i in {0..7}
do
touch $RUTA/mode${i}00
chmod ${i}00 $RUTA/mode${i}00
done

for i in {0..7}
do
ls -latr $RUTA
echo
echo "find $RUTA -perm ${i}00"
find $RUTA -type f -perm ${i}00 | sort
echo
echo "find $RUTA -perm -${i}00"
find $RUTA -type f -perm -${i}00 | sort
echo
echo "find $RUTA -perm /${i}00"
find $RUTA -type f -perm /${i}00 | sort
echo Press enter to continue; read dummy;
done
