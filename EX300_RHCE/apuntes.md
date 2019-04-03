# Control de servicios y demonios

## Servicios y demonios.

* **systemd** administra el arranque del sistema y los procesos y servicios del servidor (tiene el ID=1). En versiones anteriores, lo gestionaba **init** (tenía por debajo _xinetd_ y _initd_).
  - Puede paralelizar y aumentar velocidad del arranque.
  - Inicio bajo demanda de los servicios.
  - Administración automática de las dependencias de los servicios.
  - Podemos saber las dependencias del servicio -por arriba y por abajo.
  - Podemos hacer seguimiento de los servicios a través de los _linux control groups_, que se usan para agrupar servicios destinados al mismo fin.
* **daemon** proceso que ejecutan tareas que esperan y se ejecutan en segundo plano (convención, terminan su nombre por "d").
* Para comunicarse con los procesos usan **sockets**.

La _units_ son difentes tipos de "servicios", hay de diferentes tipos.

* Lista de tipos de unidades disponibles: `systemctl -t help`
  - _service_: servicios
  - _socket_: comunicaciones interprocesos, podemos usarlos para levantar servicios
  - _busname_
  - _target_
  - _snapshot_
  - _device_
  - _mount_
  - _automount_
  - _swap_
  - _timer_
  - _path:_ rutas del sistema que marcan un disparador (si dejamos algo, hará que algo se levante).
  - _slice_
  - _scope_
* Ver el fichero de configuración de una unit: `systemctl cat nombre`
* Ver todas las propiedades del la unit: `systemctl show nombre`
* Ver toda la información de una unit: `systemctl show nombre`
* Arrancar, parar, ...: `systemctl {start|stop|restart|reload} nombre`
* Ver estado: `systemctl status nombre` ("-l" más información)
  - Puede tener estos estados:
    - **loaded**: Se ha procesado el fichero de configuración
    - **active (running)**: Corriendo con uno o más procesos
    - **active (exited)**: Completada la configración OK
    - **active (waiting)**: Corriendo pero esperando un evento.
    - **inactive**: Parado
    - **enabled**: Arrancará en tiempo de boot
    - **disabled**: No arrancará en tiempo de boot
    - **static**: No puede ser habilitado, pero puede ser arrancado por otra unit de forma automática, no lo podemos tocar nosotros.
* Ver si está habilitado: `systemctl is-enabled servicio`
* Ver si está activo: `systemctl is-active servicio`
* Ver dependencias de nuestro servicio:
  - De quien depende nuestra unidad: `systemctl list-dependencies unidad`
  - Quien necesita mi unidad: `systemctl list-dependencies unidad --reverse`
* Listado de _unit files_
  - Verificar en el arranque: `systemctl`
  - Verificar el estado de los servicios: `systemctl --type=service`
  - Ver las units: `systemctl lsit-units [--all] --type=service` (muestra los activos, con "--all", todos).
  - Estado de las unidades en el arranque: `systemctl lsit-unit-files` (admite "--type")
  - Estado de las unidades que han fallado: `systemctl --failed --type=service`

### Máscaras

RH dice que no son compatibles ***NetworkManager** y **network** y de hecho indican que el que manda el _NetworkManager_ y se apoya para ciertas cosas en _network_ y en caso de caída del primero, el segundo tomaría el control.

`systemctl {mask|umask} servicio`, lo que hace es un link a `/dev/null` de las unidades. (/etc/systemd/system/nombre.service` ó `/usr/lib/systemd/target`)

El enmascaramiento nos permite que nadie arranque de forma manual o automática el servicio.

## El proceso de arranque

### Targets

Estos son los targets del sistema:
* **graphical.target**: Sistema con múltiples usuarios, logins basados en texto y gráficos.
* **multi-user.target**: Sistema con múltiples usuarios y login basado en texto.
* **rescue.target**: _suloging_ prompt, inicialización básica del sistema
* **emergency.target**: _sulogin_ prompt y pivote _initramfs_ completo con / montado en modo sólo lectura.

* Dependencias entre targets: `systemctl list-dependencies nombre.target|grep target`
* Targets del sistema: `systemctl list-units --type=target --all`
  ```bash
  UNIT                   LOAD   ACTIVE   SUB    DESCRIPTION
  basic.target           loaded active   active Basic System
  cryptsetup.target      loaded active   active Encrypted Volumes
  emergency.target       loaded inactive dead   Emergency Mode
  final.target           loaded inactive dead   Final Step
  getty.target           loaded active   active Login Prompts
  graphical.target       loaded active   active Graphical Interface
  local-fs-pre.target    loaded active   active Local File Systems (Pre)
  local-fs.target        loaded active   active Local File Systems
  multi-user.target      loaded active   active Multi-User System
  network-online.target  loaded inactive dead   Network is Online
  network.target         loaded active   active Network
  nfs.target             loaded active   active Network File System Server
  nss-lookup.target      loaded inactive dead   Host and Network Name Lookups
  nss-user-lookup.target loaded inactive dead   User and Group Name Lookups
  paths.target           loaded active   active Paths
  remote-fs-pre.target   loaded inactive dead   Remote File Systems (Pre)
  remote-fs.target       loaded active   active Remote File Systems
  rescue.target          loaded inactive dead   Rescue Mode
  shutdown.target        loaded inactive dead   Shutdown
  slices.target          loaded active   active Slices
  sockets.target         loaded active   active Sockets
  swap.target            loaded active   active Swap
  sysinit.target         loaded active   active System Initialization
  syslog.target          not-found inactive dead   syslog.target
  time-sync.target       loaded inactive dead   System Time Synchronized
  timers.target          loaded active   active Timers
  umount.target          loaded inactive dead   Unmount All Filesystems

  LOAD   = Reflects whether the unit definition was properly loaded.
  ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
  SUB    = The low-level unit activation state, values depend on unit type.

  27 loaded units listed.
  To show all installed unit files use 'systemctl list-unit-files'.
  ```
* Cambiar a un target: `systemctl isolate nombre.target`
  - sólo los que tengan _AllowIsolate=yes_ pueden ser objeto de este cambio
* Obtener el target por defecto: `systemctl get-default`
* Cambiar el target por defecto: `systemctl set-default nombre`
  ```bash
  > ls -l /usr/lib/systemd/system/default.target
  lrwxrwxrwx. 1 root root 16 Mar  8 16:24 /usr/lib/systemd/system/default.target -> graphical.target
  ```
* Podemos cambiar el target en el arranque cambiando la línea de kernel, poniendo: `systemd.unit=new_target.target` (normalmente ponemos _emergency.target_), después **Ctrl+X**
  - Recordar que una vez arreglado lo que se arregle, `systemctl daemon-reload` para que coja los nuevos fichreros de configuración que hayamos arreglado.

### Recuperación de la passwd de root

Ya visto en el curso de SA:
1. Reiniciar el sistema
2. Interrumpir el _boot loader_ presionando una tecla
3. Pulsar "e" para entrar en la edición del arranque.
4. Editar la línea del kernel (_linux16_) y poner `console=tty0 rd.break`
5. Ctrl+x para arrancar con los cambios (aquí tenemos montado /sysroot con ro).
6. Montar en modo lectura/escritura: `mount -o remount,rw /sysroot`
7. Montamos la jaula chroot: `chroot /sysroot`
8. Cambiamos la password de root: `passwd root`
9. Indicamos que se restauren los contextos selinux en el siguiente arranque: `touch /.autorelabel`
10. Salimos dos veces (`exit; exit;`), la primera nos saca de la jaula y la segunda del _initramfs_

### Consola de depuración

`systemctl enable debug-shell.service`, nos hablitará la consola de depuración que no necesita meter la contraseña de root (nos metemos en ella con **Ctrl+Alt+F9**).
`systemctl start debug-shell.service`

### Stuck jobs

`systemctl list-jobs`, los servicios que estén en espera no arrancarán hasta que no arranquen los servicios de los que dependen. Así que si en el arranque tenemos algún problema tendremos que ver de que dependen los que están en waiting y ver por qué los otros no ceden el control.


