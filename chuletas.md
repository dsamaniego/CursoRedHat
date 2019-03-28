Aquí meteré comandos útiles de cara a los exámenes.

- [Comandos básicos](#comandos-básicos)
  - [Crear ficheros sin nesidad de editor](#crear-ficheros-sin-nesidad-de-editor)
- [Operativas con systemd](#operativas-con-systemd)
  - [Hacer permanentes los logs de journalctl](#hacer-permanentes-los-logs-de-journalctl)

# Comandos básicos

* `tr`: sustituye un carácter por otro
* `cut`: Extrae campos  
  -d 'char' = delimitador  
  f n = campo
* `awk`: Que contarte
* `sort`: Ordenar
* `sed`: Operaciones con cadenas
	- Sustituir en el mismo fichero: `set -i -o 's/<patron>/<sustitucion>/' fichero`
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
