Aquí meteré comandos útiles de cara a los exámenes.

- [Comandos básicos](#comandos-básicos)
- [Operativas con systemd](#operativas-con-systemd)
  - [Hacer permanentes los logs de journalctl](#hacer-permanentes-los-logs-de-journalctl)

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

# Cron y at.

* `at TIMESPEC`: Nos abre un subsell donde definiremos lo que se ejecutará en _TIMESPEC_
  - `at -q x TIMESPEC`: Nos programa un job en la cola x
* `atq`: Muestra la cola de AT
  - `at -c <job_id>`: Nos muestra lo que se ejecutará en el Job consultado.
* `atrm <job_id>`: Borra el job especificado

* `crontab -e`: edita el crontab del usuario actual
* `crontab -r`: borra el crontab del usuario actual
* `crontab -l`: muestra el crontab del usuario actual
* `crontab fichero`: sustituye el crontab del usuario por el fichero proporcionado

# SELinux

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
Para chequear que esto ha quedado bien: `ssh <usuarioldap>@hostname`, y nos tendrá que dejar dentro del directorio `/home/guests/<usuarioldap/`


# Operativas con systemd

## Hacer permanentes los logs de journalctl

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

