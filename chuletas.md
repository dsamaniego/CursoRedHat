# Chuletas

Aquí meteré comandos útiles de cara a los exámenes.

## Comandos básicos

### Crear ficheros sin nesidad de editor

~~~bash
$ cat > fichero << EOF
> ...
> ...
> 
~~~

Vamos metiendo línea a línea hasta que hayamos terminado, para salir **Ctrl+D**.

## Operativas con systemd

### Hacer permanentes los logs de journalctl

~~~bash
# mkdir /var/log/journal
# systemd-tmpfiles --create --prefix /var/log/journal
# echo "SystemMaxUse=50M" >> /etc/systemd/journald.conf 
# systemctl restart systemd-journald
~~~

**NOTA:** Con el _SystemMaxUse_ limitamos el tamaño que ocupará el log del journalctl

Forma alternativa:
~~~bash
# mkdir -p -m 2755 /var/log/journal
# chown :systemd-journalctl /var/log/journal
# sysemctl restart systemd-journald
~~~
