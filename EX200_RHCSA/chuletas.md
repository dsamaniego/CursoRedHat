Aquí meteré comandos útiles de cara a los exámenes.

- [Comandos básicos](#comandos-básicos)
  - [Crear ficheros sin nesidad de editor](#crear-ficheros-sin-nesidad-de-editor)
- [Operativas con systemd](#operativas-con-systemd)
  - [Hacer permanentes los logs de journalctl](#hacer-permanentes-los-logs-de-journalctl)

# Comandos básicos


* __tr__: sustituye un carácter por otro
* __cut__: Extrae campos
  - -d 'char' = delimitador
  - f n = campo
* __awk__: Que contarte
* __sort__: Ordenar
* __sed__: Operaciones con cadenas
	- Hace una sustutución y la guarda en el mismo fichero: `sed -i -e 's/esto/aquello/' fichero`
* __uniq__: Elimina registros duplicados (se suele aplicar después de un sort)
* __wget__: trae recurso de internet:`wget -O <fich_salida> http://<ruta_fichero_a_descargar>`

## Crear ficheros sin nesidad de editor

```bash
$ cat > fichero << EOF
> ...
> ...
> 
```

Vamos metiendo línea a línea hasta que hayamos terminado, para salir **Ctrl+D**.

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
