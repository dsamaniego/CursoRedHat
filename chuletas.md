Aquí meteré comandos útiles de cara a los exámenes.

- [Comandos básicos](#comandos-básicos)
- [Redes](#redes)
- [Cron y at](#cron-y-at)
- [ACLs](#acls)
- [SELinux](#selinux)
	- [Poner contexto a un directorio y todos sus hijos:](#poner-contexto-a-un-directorio-y-todos-sus-hijos)
- [FileSystems](#filesystems)
	- [Directorio NFS de root de usuarios LDAP.](#directorio-nfs-de-root-de-usuarios-ldap)
- [Operativas con systemd](#operativas-con-systemd)
	- [Journalctl](#journalctl)
		- [Hacer permanentes los logs de journalctl](#hacer-permanentes-los-logs-de-journalctl)
- [Firewall](#firewall)
	- [Flags de _firewall-cmd_](#flags-de-_firewall-cmd_)

# Comandos básicos

* `tr`: sustituye un carácter por otro
* `cut`: Extrae campos  
  -d 'char' = delimitador entre campos
  -f n = campo
	- Ejemplo: `cut -d ":" -f 3 fichero.csv` extrae el tercer campo de un fichero csv que separa por ":" los campos
* `awk`: Normalmente se usa con un pipe para tratar la salida.
	- `awk -F"<delim>" 'programa_awk'`
* `sort`: Ordenar
	- Ordenar salida de un du usando tamaños: `du -smh *|sort -h`
* `sed`: Operaciones con cadenas
	- Sustituir en el mismo fichero: `sed -i -o 's/busqueda/sustitucion/' fichero`
	- Usando expresiones regulares: `sed -i -o -r 's/expr_r/sustitucion/' fichero`
* `uniq`: Elimina registros duplicados (se suele aplicar después de un sort)
* `wget`: trae recurso de internet:`wget -O <fich_salida> http://<ruta_fichero_a_descargar>`
* `find`: Buscar algo
	- Ejecutar sobre los ficheros encontrados: `find <ruta> -name "patron" -exec <comando> {} \;`
* Crear ficheros sin nesidad de editor
	```bash
	$ cat > fichero << EOF
	> ...
	> ...
	> 
	```
* Usar echo para crear ficheros de varias líneas:  
  `echo -en "username=pepe\npassword=perez\ndomain=MYGROUP" > /root/samba.smb`
* Ver los ficheros de configuración de un paquete: 
  ```bash
  yum provides programa_en_cuestion
  rpm -qc paquete
  ```

Vamos metiendo línea a línea hasta que hayamos terminado, para salir **Ctrl+D**.

# Redes

* **nmcli**: Cliente de NetworkManager para gestionar las redes.
	- `nmcli dev status`: Muestra interfaces de red
	- `nmcli con status`: Muestra conexiones
	- `nmcli con add <con_name> type <tipo>`: Añadir una conexión configurada por DHCP
	- `nmcli con add <con_name> type <tipo> ipv4 "W.X.Y.Z" gw4 "w.x.y.z"`: Añadir conexión con configuración estática
	- `nmcli con mod <con_name> {parámetros_a_modificar}`: Modificar una conexión
* **hostname**: ver y modificar en runtime el nombre de host del sistema.  
  Durante el proceso de arranque del sistema operativo, se establece el nombre del sistema con la ejecución del comando hostname sin parámetros. Si existe el archivo `/etc/hostname` se lee de aquí, y esto significa que se configuró de forma estática. Si no existe el archivo, se consulta el `/etc/hosts` y si ahí no lo encuentra, se hará una consulta al DNS por el hostname del sistema dando la IP (resolución inversa).  
  Si al comando hostname le pasamos un nombre, se modifica el hostname del sistema pero no es persistente, en el siguiente arranque de la máquina se ha perdido. Para hacerlo persistente, podemos modificar a mano el archivo `/etc/hostname` o usar el comando `hostnamectl`.
* **hostnamectl**: ver y establecer de forma persistente el nombre de host y otros datos del sistema.  
  Subcomandos relevantes:
  - `status`: hostname del sistema y su información relevante.
  - `set-hostname nombre`: cambiamos el hostname del sistema y se escribe en `/etc/hostname`. Si le pasamos “” en el nombre, reseteamos el hostname.
  - `set-location texto`: añadimos un texto con indicaciones de donde está ubicado el sistema que será luego visible con hostnamectl status.
* **ip**: ver y modificar rutas, dispositivos, etc. del sistema. Sus subcomandos más relevantes:
  - `addr list`, `addr show`, `a`: muestra todos los interfaces de red del sistema y su configuración. Para ver sólo la información de uno en concreto, le pasaremos el nombre de la interfaz.
  - `addr add <dir_ip> dev <interfaz>`, `addr del <dir_ip> dev <interfaz>`: añadir o eliminar una IP de una interfaz de forma no persistente (para que lo sea, usar nmcli).
  - `link set <interfaz> down`, `link set <interfaz> up`: desactiva o activa una interfaz dado.
    - Mejor hacerlo con nmcli.
  - `route show`: ver la tabla de enrutamiento del sistema.
  - `route add <ip_destino>`, `route del <ip_destino>`, `append <ip_destino>`, `change <ip_destino>`: pone, borra, añade y modifica una ruta estática a la tabla de enrutamiento del sistema. La ip de destino puede ser una dirección de red, donde si no se indica prefix, se presupone. Se puede añadir dev <interfaz> para que sólo añada la ruta a esa interfaz.
* **ping**: envía paquetes ICMP a otros hosts dando su dirección IP o su hostname. Por defecto, sigue enviando de forma indefinida hasta que lo detengamos con CTL+C. Que un host no conteste a un comando ping, no significa que esté inaccesible, se puede configurar un sistema de forma que no conteste a los paquetes ICMP. Opciones relevantes:
	- `-c <numero_paquetes>`: envía el número de paquetes dado y se detiene.
	- `-4`, `-6`: hago un ping con IPv4 o IPv6. Por defecto si no se indica esta opción, es IPv4.
	- `-i <segundos>`: segundos que deben transcurrir entre paquetes. Por defecto si no se indica nada es 0.2 segundos.
	- `-I <interfaz>`: usa la interfaz dada para enviar los paquetes.
* **traceroute** o **tracepath**: muestran la ruta que siguen los paquetes desde el origen hasta el destino. Cada línea en la salida representa un salto entre subredes.
	- Su sintaxis es `traceroute <opciones> <host_destino>`. Opciones importantes:
	- `-i <interfaz>`: interfaz por donde se enviarán los paquetes.
	- `-m <numero>`: número máximo de saltos que se darán para intentar llegar al destino.
	- `-n`: mostrar las direcciones IP en lugar de los hostnames.
	- `-T`, `-I`: envía paquetes TCP o ICMP. Por defecto si no se indica ninguna de estas dos opciones, los paquetes son UDP.
* **ss**: ver estadísticas de red. Reemplaza al comando **netstat**.
	- Sintaxis: `ss <opciones>`.
	- `-n`: muestra números en lugar de nombres para los interfaces y puertos.
	- `-t`, `-u`: muestra sockets TCP y UDP respectivamente.
	- `-l`: sólo muestra sockets a la escucha (listening).
	- `-a`: muestra todos los sockets, los que están a la escucha y los establecidos.
	- `-p`: muestra el proceso que está usando el socket.  
		**NOTA**: Reglas mnemotécnicas para ss,
		- usar con las opciones “del tulipan”: `ss -tulpn`
		- usar con las opciones “del atún”: `ss -atun`
* **host**: pasando como argumento un hostname o ip, hace una consulta al servidor DNS del sistema.

# Cron y at

* `at TIMESPEC`: Nos abre un subsell donde definiremos lo que se ejecutará en _TIMESPEC_
  - `at -q x TIMESPEC`: Nos programa un job en la cola x
* `atq`: Muestra la cola de AT
  - `at -c <job_id>`: Nos muestra lo que se ejecutará en el Job consultado.
* `atrm <job_id>`: Borra el job especificado
* `crontab -e`: edita el crontab del usuario actual
* `crontab -r`: borra el crontab del usuario actual
* `crontab -l`: muestra el crontab del usuario actual
* `crontab fichero`: sustituye el crontab del usuario por el fichero proporcionado

# ACLs

* Dar permisos de lectura a un usuario: `setfacl -m u:lisa:r file`
* Quitar permisos a todo el mundo (usando mask): `setfacl -m m::rx file`
* Quitar permisos a un grupo: `setfacl -x g:staff file`
* Copiar las ACLs de un fichero en otro: `getfacl file1 | setfacl --set-file=- file2`
  - Lo mismo recursivo: `getfacl -R file1 > fichero_acls && setfacl --set-file=fichero_acl`
* Copiar las ACLs de acceso a la ACL por defecto: `getfacl --access dir | setfacl -d -M- dir`

# SELinux

* Para ver las políticas de algo: `semanage fcontext -l | grep <lo_que_sea>`
* Para ver los booleanos: `semanage boolean -l` ó `getsebool -a`
* Para ver políticas en procesos `ps -axZ` (p.ej: `ps -ZC httpd` nos muestra las etiquetas de Apache).
* Para ver lo que hay aplicado de SELinux sobre un archivo/directorio: `ls -lZ <fichero>`
* Obtener el modo de funcionamiento de SELinux: `getenforce`
* Cambiar el modo de funcionamiento: `setenforce n` donde:
  - 0 --> _Permissive_: Escribe en el log, pero no deniega accesos.
  - 1 --> _Enforcing_: Escribe en el log y niega accesos
    - Los cambios de funcionamiento con setenforce son temporales (en runtime). Para hacerlos permanentes, hay que editar el fichero `/etc/selinux/config` y reiniciar.
    - En un arranque, podemos cambiar el modo de selinux en el modo de kernel con el parámetro extra en las líneas de kernel.
      - enforcing=1 (enforce)
      - enforcing=0 (permisibe)
      - selinux=0 (disabled)
* `chcon -t <tipo_conexto> fichero`: cambia el contexto de un fichero de forma permanente.
* `restorecon -FvvR <fich/dir>`: Restaura el contexto del fichero según las reglas de SELinux, es decir, va consultando el `semanage fcontext -l` para ir restaurando los permisos.
* Cuando movemos o compiamos con el flag -a, nos estamos llevando el contexto de SELinux del origen al destino, esto puede causar problemas

## Poner contexto a un directorio y todos sus hijos:

Hay que crear la regla de SELinux y luego ponérle el contexto a directorio:
```bash
mkdir /docroot
semanage fcontext -a -t public_content_t '/docroot(/.*)?'
restorecon -RvF /docroot
restorecon reset /docroot context unconfined_u:object_r:default_t:s0->system_u:object_r:public_content_t:s0
```

# FileSystems

## Directorio NFS de root de usuarios LDAP.

Suponemos que ya tenemos configurado el LDAP (importante, marcar que no se creen los home de usuario) en el primer login:
```bash
yum install -y autofs
echo -ne "/home/guests\t/etc/auto.guests\n" > /etc/auto.master.d/guests.autofs
echo -ne "* -rw,sync srvnfs:/home/guests/&\n" > /etc/auto.guests
sudo systemctl enable autofs.service
sudo systemctl start autofs.service
```
Para chequear que esto ha quedado bien: `ssh <usuarioldap>@hostname`, y nos tendrá que dejar dentro del directorio `/home/guests/<usuarioldap>/`

# Operativas con systemd

* `systemctl list-dependencies modo.target |grep target`: Nos muestra los targets de los que depende uno concreto (sin el grep, nos muestra todas las dependencias).
* `systemctl list-units --type=target --all` Nos muestra todos los targets disponibles.
* `systemctl list-unit-files --type=target --all`: todos los targets disponibles
* `systemctl isolate <target>.target`: Para cambiarnos a un target, parará todos los servicios no necesarios para ese target.
	- En _/etc/systemd/system_ podemos añadir una unidad.target.
* `systemctl get-default` Nos devuelve cual es el target por defecto
* `systemctl set-default <target>.target` establece es default target, que lo que hace es cambiar el log simbólico.

## Journalctl

* `journalctl -o verbose`: El mallor nivel de información que nos puede dar journalctl
  - Aquí nos saldrán un montón de parámetros (_XXXXXX) que podremos invocar en el journalctl
  - en este modo con _SYSTEMD_UNIT=<nombre>.servicio podré ver logs detallados del servicio.
### Hacer permanentes los logs de journalctl

```bash
# mkdir /var/log/journal
# systemd-tmpfiles --create --prefix /var/log/journal
# echo "SystemMaxUse=50M" >> /etc/systemd/journald.conf 
# systemctl restart systemd-journald
```

**NOTA:** Con el _SystemMaxUse_ limitamos el tamaño que ocupará el log del journalctl

Forma alternativa:
```bash
# mkdir -p -m 2755 /var/log/journal
# chown :systemd-journalctl /var/log/journal
# sysemctl restart systemd-journald
```

# Firewall

## Flags de _firewall-cmd_

* `--get-default-zone`: consulta la zona por defecto
* `--set-default-zone=<ZONE>`: Poner zona por defecto
* `--get-zones`: Obtener todas las zonas definidas
* `--get-active-zones`: Obtener zonas activas
* `--add-source=<CIDR> [--zone=<ZONE>]`: Enruta todo el tráfico que viene de la red CIDR especificada al la zona especificada (si no se especifa, a la zona _default_)
* `--remove-source=<CIDR> [--zone=<ZONE>]`: Lo contrario de la anterior
* `--add-interface=<INTERFACE> [--zone=<ZONE>]`: Enruta todo el tráfico que viene por la interfaz indicada a la zona especificada (si no se especifa, a la zona _default_)
* `--change-interface=<INTERFACE> [--zone=<ZONE>]`: Cambia de zona la interfaz indicada (si no se especifa zona, a la zona _default_)
* `--list-all [--zone=<ZONE>]`: lista todas las configuraciones de la zona especificada (si no se especifa, a la zona _default_)
* `--list-all-zones`: Lista todas las configuraciones de todas las zonas.
* `--add-service=<SERVICE> [--zone=<ZONE>]`: Permite el tráfico hacia el servicio indicado en la zona especificada (si no se especifa, a la zona _default_)
* `--remove-service=<SERVICE> [--zone=<ZONE>]`: Borra el servicio de la zona especificada (si no se especifa, a la zona _default_)
* `--add-port=<PORT/PROTOCOL> [--zone=<ZONE>]`: Permite el tráfico al puerto y protocolo indicado y lo asigna a la zona especificada (si no se especifa, a la zona _default_)
* `--remove-port=<PORT/PROTOCOL> [--zone=<ZONE>]`: Borra el puerto y protocolo indicado de la zona especificada (si no se especifa, a la zona _default_)
* `--permanent`: junto con cualquiera de los anteriores que hacen cambios en la configuración, se quedará almacenado y se cargará cuando haga un reinicio del sistema o haga `--reload`.
* `--reload`: Quita la configuración _runtime_ y deja la _persistent_
* `--runtime-to-permanent`: pasa cualquier configuración que tengamos en _runtime_ a _permanent_

Para pasar de runtime a permanent, usar el flag `--runtime-to-permanent`

