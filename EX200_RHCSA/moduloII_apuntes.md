- [Automatización de la instalación](#automatización-de-la-instalación)
  - [Comandos](#comandos)
    - [Comandos de instalación](#comandos-de-instalación)
    - [Comandos de particionado](#comandos-de-particionado)
    - [Comandos de networking](#comandos-de-networking)
    - [Comandos de configuración del OS](#comandos-de-configuración-del-os)
    - [Otros comandos](#otros-comandos)
  - [Secciones](#secciones)
    - [Paquetería (_%packages_)](#paquetería-_packages_)
    - [Pre (_%pre_)](#pre-_pre_)
    - [Post (_%post_)](#post-_post_)
  - [Despliegue de un nuevo sistema virtual con Kickstart](#despliegue-de-un-nuevo-sistema-virtual-con-kickstart)
    - [Pasos](#pasos)
- [Expresiones regulares y grep](#expresiones-regulares-y-grep)
  - [Expresiones regulares](#expresiones-regulares)
  - [grep](#grep)
- [Vim avanzado](#vim-avanzado)
  - [Paquetes de vim](#paquetes-de-vim)
    - [Modo ejecución](#modo-ejecución)
    - [Registros.](#registros)
    - [Sustituciones.](#sustituciones)
- [Programación de tareas](#programación-de-tareas)
  - [at](#at)
    - [Comandos](#comandos-1)
        - [TIMESPEC](#timespec)
  - [cron](#cron)
    - [Comandos](#comandos-2)
    - [Formato del fichero.](#formato-del-fichero)
  - [Cron del sistema](#cron-del-sistema)
    - [Variables](#variables)
  - [Ficheros temporales](#ficheros-temporales)
    - [Configuración de los ficheros](#configuración-de-los-ficheros)
- [Prioridades](#prioridades)
  - [Prioridades relativas](#prioridades-relativas)
  - [Manejo del nice](#manejo-del-nice)
- [Control de acceso a ficheros (ACLs)](#control-de-acceso-a-ficheros-acls)
    - [Defaults ACL](#defaults-acl)
  - [Manejo de ACLs](#manejo-de-acls)
    - [Ejemplos](#ejemplos)
- [Manejo de SELinux](#manejo-de-selinux)
    - [Comandos últiles.](#comandos-últiles)
  - [Modos de SELinux](#modos-de-selinux)
  - [Contextos SELinux](#contextos-selinux)
    - [Añadir reglas.](#añadir-reglas)
      - [Comando `semanage {fcontext|boolean}`](#comando-semanage-fcontextboolean)
  - [Booleanos SELinux](#booleanos-selinux)
  - [Puertos](#puertos)
  - [Troubleshooting](#troubleshooting)
- [Conexión de usuarios con LDAP e IPA](#conexión-de-usuarios-con-ldap-e-ipa)
  - [Usar LDAP y Kerberos](#usar-ldap-y-kerberos)
    - [Parámetros mínimos de LDAP](#parámetros-mínimos-de-ldap)
    - [Parámetros mínimos de Kerberos](#parámetros-mínimos-de-kerberos)
    - [Configuración.](#configuración)
  - [Usar un IPA Server](#usar-un-ipa-server)
  - [Unirse a un Active Directory](#unirse-a-un-active-directory)
    - [Ejemplo.](#ejemplo)
- [Añadir discos, particiones y sistemas de ficheros](#añadir-discos-particiones-y-sistemas-de-ficheros)
  - [Particionado del disco](#particionado-del-disco)
    - [MBR](#mbr)
    - [GPT](#gpt)
    - [Pasos para crear una partición.](#pasos-para-crear-una-partición)
    - [Pasos para borrar una partición.](#pasos-para-borrar-una-partición)
  - [Crear sistemas de ficheros.](#crear-sistemas-de-ficheros)
  - [Montar el FileSystem](#montar-el-filesystem)
    - [Montaje manual](#montaje-manual)
    - [Montaje automático](#montaje-automático)
  - [Swap](#swap)
- [Administrar Logical Volume Management (LVM)](#administrar-logical-volume-management-lvm)
  - [Conceptos](#conceptos)
  - [Manejo](#manejo)
    - [Creación](#creación)
    - [Borrado](#borrado)
    - [Consulta](#consulta)
    - [Extender VG](#extender-vg)
    - [Reducir VG](#reducir-vg)
    - [Extender LV](#extender-lv)
    - [Snapshots](#snapshots)
      - [Operativa.](#operativa)
- [Network Storage NFS](#network-storage-nfs)
  - [Seguridad](#seguridad)
  - [Montajes](#montajes)
    - [Montaje estándar](#montaje-estándar)
    - [Montaje automático](#montaje-automático-1)
      - [Pasos para hacer un automontaje.](#pasos-para-hacer-un-automontaje)
        - [Montajes indirectos](#montajes-indirectos)
        - [Montajes directos](#montajes-directos)
        - [Montajes con comodines](#montajes-con-comodines)
- [Network Storage SMB](#network-storage-smb)
  - [Montajes](#montajes-1)
    - [Montaje manual](#montaje-manual-1)
    - [fstab](#fstab)
  - [Si no nos identificamos como guest](#si-no-nos-identificamos-como-guest)
  - [Automontaje](#automontaje)
- [Troubleshooting del arranque](#troubleshooting-del-arranque)
  - [El proceso de arranque en máquinas x86_64](#el-proceso-de-arranque-en-máquinas-x86_64)
  - [Targets](#targets)
    - [Comandos de systemctl relacionados.](#comandos-de-systemctl-relacionados)
  - [Troubleshooting](#troubleshooting-1)
    - [Recuperar password de root](#recuperar-password-de-root)
      - [Otra forma (mejor)](#otra-forma-mejor)
    - [Usar journalctl](#usar-journalctl)
    - [Shell de depuración temprana](#shell-de-depuración-temprana)
      - [Stuck jobs (trabajos colgados)](#stuck-jobs-trabajos-colgados)
  - [Reparar problemas de FS en el arranque](#reparar-problemas-de-fs-en-el-arranque)
  - [Problemas con el bootloader](#problemas-con-el-bootloader)
    - [Algunas directivas](#algunas-directivas)
    - [Reinstalar grub](#reinstalar-grub)
- [Firewall: limitar comunicaciones de red](#firewall-limitar-comunicaciones-de-red)
  - [Funcionamiento](#funcionamiento)
    - [Zonas predefinidas](#zonas-predefinidas)
    - [Servicios predefinidos](#servicios-predefinidos)
  - [Configurar el firewall](#configurar-el-firewall)
    - [Flags de _firewall-cmd_](#flags-de-_firewall-cmd_)

# Automatización de la instalación 

**Anaconda** es el instalador que usa RHEL, necesita que el que está haciendo la instalación le responda a una serie de preguntas acerca de la configuracion del sistema.

**Kickstart** es el sistema para hacer instalaciones desatendidas (coge un fichero de texto con las respuestas que daríamos en una instalación manual). Se basa en un fichero dividido en secciones, con el siguiente formato:

```text
comandos
...<software>
%packages
..
%end
%pre
...<scripts>
%end
%post
...<scripts>
%end
```

Los comentarios van en líneas precedidas por `#`

## Comandos

### Comandos de instalación

* **url** Especifica dónde está el medio de instalación
* **repo** Donde encontrar los paquetes para la instalación.
* **text** Sólo instala en modo texto
* **vnc** Habilita para ver la instalación remotamente.
* **askmethod** 

### Comandos de particionado

* **clearpart** limpia las particiones antes de la instalación
* **part** Especifica los parámetros para crear la partición.
* **ignoredisk** Se pueden especificar discos que se ignoran en la instalación.
* **bootloader** Especifica donde instalar el _bootloader_
* **volgroup, logvol** Crea grupos de volúmenes y volúmenes lógicos de LVM.
* **zerombr** Se usa con sistemas a los que queremos forzar el borrado del MBR.

### Comandos de networking

* **network** Configuración de red  
  ej: `network --device=eth0 --bootproto=dhcp`
* **firewall** Habilita firewall en el arranque.  
  ej: `firewall --enabled --service=ssh`

### Comandos de configuración del OS

* **lang** Especifica el idioma
* **keyboard** Especifica el tipo de teclado
* **timezone** Define tz, NTP y reloj HW.
* **auth** Especificar las opciones de autenticación. **OBLIGATORIO**  
  ej: `auth --usesshadow --enablemd5 --passalgo=sha512`
* **rootpw** Contraseña de root (podemos ponerla en texto plano o cifrada)  
  ej: `rootpw --iscrypted $6$sfseiiosK$dks332ñlkds3i....2993kad` para cifrarla, ver el script en el material extra.
* **selinux** habilitar o no SELinux  
  ej: `selinux --enforcing`
* **services** Indica qué servicios estarán habilitados en el arranque (`--disabled=... --enabled=...`)
* **group,user** Crea usuarios y grupos locales.

### Otros comandos

* **logging** Configura los logs de la instalación.
* **firstboot** Le dice si hay que lanzar el procedimiento de primer arranque en la instalación o no.
  - Si está habilitado, realiza la configuración de una serie de parámetros de la máquina en el primer arranque.
* **reboot, poweroff, halt** Le indicamos como se queda la máquina después de la instalación.

## Secciones

### Paquetería (_%packages_)

Se indica lo que se quiere instalar:
* paquetes
* @grupos
* @^grupos_entorno
* -paquete (paquetes que no queremos que se instalen... ojo, con las dependencias)

### Pre (_%pre_)

Scripts que se ejecutan antes del particionado.

### Post (_%post_)

Scripts que se ejecutan tras la instalación

## Despliegue de un nuevo sistema virtual con Kickstart

Hay una utilidad que ayuda a configurar el fichero de Kickstart: **system-config-kickstart**.

También podemos modificar un fichero ya existente, luego podremos validar la sintaxis con **ksvalidator** por si hemos metido la pata.

En nuestro sistema siempre habrá un fichero de configuración: `/root/anaconda-ks.cfg` que contiene lo que se hizo en la instalación, puede ser un buen punto de partida para generar un fichero de kickstart. Además, nos servirá si queremos hacer instalaciones clónicas.

### Pasos

1. Crear un fichero de configuración kickstart (**system-config-kickstart**).
2. Usar un editor de texto para añadir montajes al fichero de kickstart.
3. Chequear la correción del fichero (**ksvalidator**).
  * Si no disponemos de él habrá que instalarlo: `yum install pykickstart`
  * Tener en cuenta que lo que hace es una validación sintáctica, y no valida las direcivas _%pre_, _%post_ ni _%packages_.
4. Publicar el fichero para el instalador: 
  * `ks=http://server/dir/file`
  * `ks=ftp://server/dir/file`
  * `ks=nfs:server:/dir/file`
  * `ks=hd:device:/dir/file`
  * `ks=cdrom:/dir/file`
5. Arrancar Anaconda y apuntar al fichero de configuración.  
  Normalmente se lo diremos en la línea de arranque del kernel, pero hay virtualizadores donde podemos pasarle este parámetro. 
  - Sistemas con BIOS: `append initrd=initrd.img inst.ks=<ruta a ks.cfg>`
  - Sistemas con UEFI (grub2): `kernel vmlinuz inst.ks=<ruta a ks.cfg>`

Cuando instalemos en máquinas virtuales, usaremos el **virt-manager**, donde podremos especificar la URL del kickstart; en máquinas físicas, tendremos que interrumpir el proceso de arranque y pasarle una de las opciones de ks para indicarle donde está el instalador.



# Expresiones regulares y grep 

## Expresiones regulares

Una expresión regular es un conjunto de metacaracteres que nos permite definir cadenas. Se difierencia de _fileglobbing_ en que esta última sólo se usa para buscar ficheros.

Podemos usarlas para buscar en vim, less, grep.

Una palabra es una expresión regular que engloba a todas las palabras que contienen la palabra.


Metacaracteres: `\ . ^ $ [ ] ( ) | ? + * { }`

* `.` un caràcter cualquiera
* `?` 0 o 1 veces el caràcter anterior
* `*` 0 o más veces el caràcter anterior
* `+` 1 o más veces el caràcter anterior
* `[ ]` caràcter contenido en los corchetes (se pueden combinar rangos y caracteres ùnicos)
	- Ej: `[+*]`  busca un + o un *
	- Ej: `[\\x]` busca \ o una x (\ si hay que escaparlo)
* `[^ ]` caràcter no contenido en los corchetes
* `[x-y]` carácter contenido en el rango x-y
* `^`  principio de linea
* `$`  final de linea
* `.*` cualquier cadena
* `\` escapar un caràcter
* `\<` principio de palabra
* `\>` final de palabra (seguido por un signo de puntuación, un espacio o un salto) p.e. busqueda de lo que termine en on: /on\> 
	**NOTA:** la coma simple la usaríamos para buscar palabras: `'\<perr'` ó `'os\>'`, para busar la palabra exacta: `'\<perros\>'`
* `x|y` el carácter x o el y
* `x{m}`  m x's consecutivas 
* `x{m,}` m x's consecutivas o más p.e. grep -E 'o{1,}' file
* `x{m,n}`  entre m y n x's
* Caracteres:
	- `[[:alnum:]]` alfanuméricos (depende del idioma configurado)
	- `[[:alpha:]]` alfabéticos (depende del idioma configurado)
	- `[[:lower:]]` minúsculas (depende del idioma configurado)
	- `[[:upper:]]` mayúsculas (depende del idioma configurado)
	- `[[:digit:]]` dígitos
	- `[[:xdigit:]]` dígitos hexadecimales
	- `[[:blank:]]` espacio o tabulador
	- `[[:space:]]` blancos (espacio, tabuladores, cambio de línea, retorno de carro...)
	- `[[:graph:]]` no blancos
	- `[[:print:]]` como graph, pero incluye el espacio en blanco
	- `[[:punct:]]` de puntuación

**NOTA:** si no queremos que nos hagan sustituciones el shell, envolver la expresión regular con comillas simples.

Ayuda: **regex(7)**

## grep

Busca cadenas de caracteres usando expresiones regulares.
* Podemos usarlo en línea de comandos actuando sobre un fichero: `grep <flags> <expr_reg> <fichero>`
* Podemos usarlo tras un pipe para hacer la búsqueda en la salida del comando: `<comando> | grep <flags> <expr_reg>`
* Flags:
  - `-i` ignore case
  - `-v` saca las líneas que no coincidan
  - `-r` Recursivo
  - `-A n` Número de líneas después de la coincidencia que tenemos (after)
  - `-B n` núnero de lineas antes de la coincidencia (before)
  - `-w` líneas que conitnen la palabra exacta
  - `-e` múltiples OR
  - `-E` Expresiones regulares complejas
  
Excluir comentarios : `grep -v '^[#;]'`

Ya sabemos... **man grep**



# Vim avanzado

3 modos:
* comando: para meter comandos de manipulación del fichero.
* insert: Manipular texto
* execution: hacer transformaciones

## Paquetes de vim

* vim-minimal: el incluido en la instalación mínima
* vim-enhanced: Nos da algunos complementos como plugins
  - Formatos
  - Autocompletado
  - Revisón de sintaxis
* vim-X11: gvim

### Modo ejecución

* ! <comando> -- Ejecuta el comando
* r <file> -- Inserta el fichero
* r! <comando> -- Inserta salida del comando

### Registros.
Hay unos cuantos buffers [a-z][0-9]

Los especiales, del 0 al 9 van guardando las últimas 10 copias que hacemos.
Podemos guardar cosas en los otros registros con: `"<letra_reg><operación>`, p.ej. `"t3yy` guarda 3 líneas en el registro t, y `"tp`, pega lo que tenemos en el registro t.

Los registros con nombre se conservan entre sesiones.

Estos búffers se mantienen entre diferentes ficheros abiertos en la misma sesión de vi.

### Sustituciones.

`:rango s/patron/cadena/flags`

Rango puede ser:
* una línea.
* un intervalo de líneas (n,m)
* un fichero
* % todas las líneas del documento (pero solo sustituye la primera ocurrencia).
* en modo visual: '> ó '<
* Flags:
  - i: ignore case.
  - g: aplica en todas las apariciones



# Programación de tareas 

## at

Cuando queramos que algo se ejecute en un determinado momento, pero no siempre, usaremos este programa.

**Demonio:** atd -- **Paquete:** at

Incluye una serie de colas [a-z] ordenadas por prioridad, con lo que podemos separar los trabajos y organizarlos según su importancia/prioridad.

**¿Para que es útil?**  
Normalmente, todo lo que hacemos con `at`, lo podemos hacer con `cron`, nos puede ayudar para desactivar algún servicio con el que estamos trabajando y que nos puede dejar fritos, así recuperamos el control.

**root** puede ver todos los trabajos, el usuario sólo los que ha lanzado él.

Al final de la ejecución, nos manda un mail.

**NOTA:** Si en vez de un mail, queremos ver la salida por pantalla, redirigir la salida. (para eso, podemos ver el terminal en el que estamos con `w -f` y luego hacer `echo $(comando) > /dev/pts/*`).

### Comandos

* `at <TIMESPEC>`: Nos abrirá un subshell para crear los comandos que queremos lanzar.  
Le podemos pasar por stdin el script que queremos que ejecute.
* `atq` ~ `at -l`: Nos muestra información de las colas de at:
  - Número de trabajo
  - Fecha y hora programada
  - cola del trabajo
  - usuario
* `at -c <num_job>`: Muestra la tarea y su entorno
* `atrm <num_job>`: Borra la tarea
* `at -q <cola> <time_spec>`: Manda el trabajo a la cola indicada.

##### TIMESPEC

Referencia: `/usr/share/doc/at-*/timespec`

* Tiempo absoluto: 5 pm August 3 2019
* Tiempos relativos:
  - teatime tomorrow (teatime son las 16:00)
  - noon + 4 days
  - midnight + 1 week

## cron

Si queremos ejecutar algo varias veces de forma periodica, es mejor usar cron.

* Paquete: cronie
* demonio: crond

### Comandos

* `crontab -e`: para editar el crontab.  
  Si queremos cambiar el editor por defecto: `export EDITOR=vi`
* `crontab -r`: Borra el crontab del usuario
* `crontab -l`: Muestra el crontab del usuario
* `crontab <fichero>`: sustituye el crontab por el fichero proporcionado
* `crontab -u <user>`: (sólo root) usa el crontab de usuario especificado

  
### Formato del fichero.

* Permite líneas vacías
* Permite comentarios (#)
* Permite definir variables de entorno (afectarán a todas las líneas que tengas debajo), especialmente interesantes son: **SHELL**, **PATH**, **MAILTO**.
* Formato de las líneas:
minuto hora dia-mes mes dia-semana comando
* Valores:
  - `*`: comodín
  - números
  - Dias de la semana (0 -> SUNDAY, ... 7 -> SUNDAY)
  - Puedo marcar intervalos x-y, listas x,y, combinaciones: x-y,z, periódicas \*/5 (cada 5 unidades)
  - **OJO**: los días no los parsea, es decir no podemos decir el día de la semana que caiga en cierto número.
  - **OJO**: Si el comando tiene un singo `%` sin escapar, se trata como un salto de línea y todo lo que va detrás se pasa al comando como _stdin_

## Cron del sistema

No están definidos con los crontab como los de los usuarios, pero están definidos en una serie de ficheros de configuración. Estos ficheros tienen un campo más, que es el usuario en nombre del que se lanzan los comandos del cron.

Ficheros relacionados:
* `/etc/crontab`: Este es el fichero principal del sistema relacionado con el cron
* `/etc/cron.d/*`: personalizaciones del sistema, y los paquetes que añaden cosas en el cron, se meten aquí
  - Tendrá ejecuciones del sistema programadas.
* `/etc/anacrontab`: Aquí se configuran todos los scrips que se pueden correr cada día, semana o mes definidos respectiamente en:
  - `/etc/cron.daily`
  - `/etc/cron.weekly`
  - `/etc/cron.montly`
  - Ejemplo de fichero de configuración:
  ```bash
  # environment variables
  SHELL=/bin/sh
  PATH=/sbin:/bin:/usr/sbin:/usr/bin
  MAILTO=root
  RANDOM_DELAY=30
  # Anacron jobs will start between 6am and 8am.
  START_HOURS_RANGE=6-8
  # delay will be 5 minutes + RANDOM_DELAY for cron.daily
  1   5    cron.daily    nice run-parts /etc/cron.daily
  7   0    cron.weekly   nice run-parts /etc/cron.weekly
  @monthly  0    cron.monthly        nice run-parts /etc/cron.monthly
  ```
  - Además, tenemos el `/etc/cron.d/0hourly`, que es para los que se ejecutan cada hora.
  - Los scripts que dejemos en estas rutas tendrán que tener permisos de ejecución.
  
El parámetro: _job-idenfier_, se usa para identificar el job, pero esta forma asegura que el sistema se lanza con la periodiciad indicada.

### Variables
* **SHELL**: Especifica el shell por defecto
* **MAILTO**: Especifica un mail al que enviar correo cuando salta el cron
* **RANDOM_DELAY**: en los daily, weekly y monthly, definen el rango de horas en el que se va a ejecutar.

## Ficheros temporales

**systemd-tmpfiles**

Systemd nos arranca el sistema y de lo primero que arranca es _systemd-tmpfiles-setup_ que ejecuta es:
* Creación de ficheros temporales: `systemd-tmp files --create`
* Purgado de ficheros temporales: `systemd-tmp files --remove`

Lee los ficheros de configuración que tiene la unidad:
* `/usr/lib/tmpfiles.d/*.conf`:  Aquí configuran los paquetes que se instalan.
* `/run/tmpfiles.d/*.conf`: Donde meterán algunos programas sus ficheros temporales. (daemons y procesos), volátil.
* `/etc/tmpfiles.d/*.conf`: la ruta de administrador.
  - Lee los ficheros que tiene definidos como temporales y los crea.
  - Cada cierto tiempo salta una unidad -*systemd_tmpfiles-clean.timer*- donde se define cada cuanto tiene que purgar los ficheros termporales (más información en _/usr/lib/systemd/system/systemd-tmpfiles-clean.timer_).  
    La definición es algo así: 
    ```bash
    cat /usr/lib/systemd/system/systemd-tmpfiles-clean.timer
    ...
    [Timer]
    OnBootSec=15min
    OnUnitActiveSec=1d
    ```
    Si arranca borra a los 15 minutos y si está arrancado, limpia cada día.  
    Internamente hace un `stat fichero`, consulta los mtime, ctime, atime, y si alguno de estos valores superan 1 día, el sistema los purga.
  - Siempre podremos hacer un purgado manual con `systemd-tmpfiles --clean`
  
Orden de prioridad de abajo a arriba.

### Configuración de los ficheros

**man 5 tmpfiles.d**

Sintaxis del fichero:  
`tipo path permisos uid gid antigüedad argumento`  
Donde:
  * tipo:
    - d: directoro,
    - L: link simbólico
    - D: crea el directorio y si ya existe lo vacía
  * path: la ruta
  * modo: los permisos que daríamos con chroot
  * uid y gid que tendrá el fichero
  * antigüedad: al alcanzar dicha antigüedad, se purga, si no tiene valor no se purga.
  * argumento (si es necesario)



# Prioridades 

Dado que hay más procesos que cores en los procesadores, para que un sistema multitarea de la sensación de tal, tiene que recurrir a alguna estrategia de reparto de los cores entre los procesos. Linux y otros sistemas operativos resuelven esto con el _time-slicing_. El _process scheduler_ del sistema rápidamente alterna entre procesos en un core dando al usuario la impresión de que hay varios procesos corriendo al mismo tiempo.

## Prioridades relativas

Como no todos los procesos son iguales, tiene que haber alguna manera de decirle al _process scheduler_ que un proceso es más importante que otro, esto se consigue con las prioridades.

**SCHED_OTHER (SCHED_NORMAL)** La política que se aplica a la mayoría de los procesos, pero hay otras políticas. Los procesos con esta política tienen una prioridad relativa que está asociada al nivel de nice de los procesos, cuanto mayor sea el número nice, menos prioritario es y mas tarda en coger tiempo de CPU.

Hay 40 niveles nice que van de -20 a 19, los negativos sólo los puede gestionar root, y los positivos todos los usuarios.

Todos los shell nacen con nice=0, y el usuario propietario lo único que puede hacer es cambiar su prioridad subiendo el nivel nice (es decir lo único que pueden hacer los usuarios normales es bajar la prioridad).

Dado que procesos que cogen mucha CPU pueden impactar negativamente al rendimiento del sistema, sólo el usuario **root** (más, precisamente, todos los usuarios que tengan la capacidad **CAP_SYS_NICE**) está capacitado para poner valores negativos de nice y bajar el nivel de nice de los procesos.

## Manejo del nice

* Ver los niveles nice:
  - `top`: Nos muestra dos columnas de interes: **NI** con el nivel nice actual y **PR** que muestra en nivel nice en una escala más grande de prioridades en que nice=-20 == pr=0 y nice=19 == pr=39. Los niveles por debajo corresponden a prioridades del sistema.
  - `ps axo pid,comm,nice,cls --sort=nice` Muestra los procesos ordenados por nice.
    + se pueden ver procesos con nice "-" que indica que no tienen nice, con el campo _cls_ vemos la política de schedule, donde **TS** corresponde con *SCHED_NORMAL*
* `nice -n <nice> <comando> &`: Lanzar un proceso con otro nivel de nice. Recordar que usuarios sin privilegios pueden lanzar sólo procesos con nice entre 0 y 19 y sólo root (y sus amigos) con nice entre -20 y -1
* `renice -n <nice> <PID>`: Cambiar nivel de nice del proceso con PID
  - También podemos usar el **top** para cambiar el nivel de nice (pulsar **r**, el PID y nos pedirá el nuevo nivel de nice).



# Control de acceso a ficheros (ACLs) 

Nos permiten granularizar permisos.

En RHEL7, tanto ext4 como xfs admiten ACLs y las tienen configuradas por defecto como activas (en versiones anteriores había que activarlas).

¿Qué permiten? Granularizar permisos

¿Cómo se ve que algo tiene ACLs?

`ls -l`, la salida tiene algo así como -rwxr-x-r--+ ..., el + nos indica que tiene ACLs aplicadas.

p.ej.: `-rwxrwxrwx+ root root fichero`, los permisos de grupo, ya no son los permisos del grupo propietario, sino la máscara de las ACLs.

Para saber en este caso los permisos del grupo, necesito sacar más información con las ACLs.

**getfacl _fichero_** Nos da la información del fichero.
```bash
# file: fichero
# owner: root
# group: root
user::rw-
group::r--
other::r--
```
Fijarse que tenemos un "::", por lo demás son los permisos normales. Pues bien, lo que hay entre esos dos puntos, son las ACLs.

Nomenclatura:
* **Nominal**: tiene un nombre puesto entre los dos puntos, y los permisos se aplicarán a eso, puede haber usuarios y grupos.
  - `u:<usuario ó uid>:<permisos>`
  - `m:<grupo ó uid>:<permisos>`
* **Genérico**: se aplican los permisos al usuario y grupo propietarios.
* **Máscara**: Es un limitador, determina los máximos permisos efectivos que pueden tener usuarios nominales, grupos nominales y grupo propietario, a los que no afecta es al usuario propietario y a others.
  - La máscara se recalcula cada vez que se cambia alguno de los permisos... así que hay que verificarla cada vez que cambiemos alguno de los permisos.  
   **OJO** Es una buena costumbre, revisar la máscara cada vez que hay un cambio en la ACL por si hay que meterla a capón.
  - La máscara es el OR entre los permisos afectados.
* Esto se puede aplicar a directorios, con lo que va a permitir a usuarios distintos del propieratio y del grupo propietario crear y borrar ficheros.
* Ojo, cambiar los permisos del grupo con chmod, no cambia los permisos del grupo propietario, cambia la máscara.
* Si hay permisos especiales, aparece una cuarta fila al principio de las ACLs, `#flags: sst`

Resolución de permisos de acceso.  
Usuario propietario --> usuarios nominales --> grupo propietario --> grupos nominales ---> others
### Defaults ACL

Sólo se aplican a los directorios, funcionan con herencia, las ACLs de un directorio pasan a sus hijos.
* Los ficheros hijos heredan las estándar definidas de las defaults del padre.
* los directorios hijos heredan tanto las defaults del padre como sus estándar y sus defaults.
* Las propagaciones no se llevan el permiso de ejecución **para ficheros**.

La diferencia en nomenclatura es que las defaults llevan delante un _d:_ (o un _default:_)

## Manejo de ACLs

* **getfacl** --> Obtiene acls
  - R recursiva, puedes obtener de forma recursiva las acls de una ruta para plancharlas en otro arbol igual.
* **setfacl _flags_ _fich_** --> setea acls
  - -m modificar
  - -R recursivo
  - -x borrar (hay que especificar lo que hay que borrar).
  - -k Borrar defaults
  - -b borrar todas
  - -d establece acls defautl (mejor hacerlo con los parámetros)
  
### Ejemplos

* Plancha acl de un fichero a otro: `getfactl file1 |setfacl --set-file=-file2`
* Lo mismo recursivo: `getfacl -R file1 > fichero_acls && setfacl --set-file=fichero_acl`
* Modificar usuario propietario: `setfacl -m u::rX file`: aplica permisos x de forma recursiva a directoros pero no a ficheros.  
  **OJO:** en cuanto sea ejecutable para alguien, le aplicará la X al fichero.
* Modficar propietarios (idem para grupos, other y mascaras): `setfacl -m u::rws fich/dir`
* Modificar nominales: (idem para grupos): `u:1005:rwx file/dir`
* Modificar defaults: (simplemente poner delante d:): `d:u:1005:rx file/idr`
  - Al meter una de las defaults, me mete las de todo el mundo.
  


# Manejo de SELinux 

SELinux (_Security Enhanced Linux_) es una capa de seguridad para sistemas Linux creado por el NSA. Es una seguridad basada en objetos y con reglas más sofisticadas que las de permisos y ACLs. 

Es un conjunto de reglas de seguridad sobre objetos que nos permite definir niveles de seguridad que se aplicarán sobre:
* Archivos
* Directorios
* Puertos
* Procesos

Controla que los procesos puedan escribir sólo en su ruta "default". Con lo que en sistemas fuertemente customizados será un quebradero de cabeza.

**Etiquetas** de SELinux para diferentes contextos:
* USER (\_u)
* ROLE (\_r)
* TYPE (\_t) En este contexto se basa la política basada en etiquetas (que es la política por defecto)
* SENSITIVITY (\_s)

**Políticas**: Acciones que va a tomar SELinux respecto a las etiquetas. Por defecto la política no permite ninguna interacción a no ser que una regla explícita permita el acceso. Si no hay regla, no hay acceso.
* targeted: Es la política por defecto. Se pueden ver en `/etc/selinux/config`
* minimun
* mls (_Multi-Level Securtiy_)

**Modos** de SELinux:
* enforcing: Obliga que se cumplan las reglas.
* permisive: Avisa cuando no se cumplen las reglas, pero deja.
* disabled: deja pasar todo.

Cuando se pone a disabled, se necesita un reinicio y se borran todas las etiquetas. Lo malo, es que si luego se quiere meter de nuevo en enforcing, hay que reiniciar y tiene que reetiquetarse el sistema -y esto tarda un huevo.

### Comandos últiles.

* Para ver las políticas de algo: `semanage fcontext -l | grep <lo_que_sea>`
* Para ver los booleanos: `semanage boolean -l` ó `getsebool -a`
* Para ver políticas en procesos `ps -axZ` (p.ej: `ps -ZC httpd` nos muestra las etiquetas de Apache).
* Para ver lo que hay aplicado de SELinux sobre un archivo/directorio: `ls -lZ <fichero>`

## Modos de SELinux

Con fines de troubleshooting, se puede desactivar temporalmente SELinux usando los modos de SELinux
* Obtener el modo de funcionamiento de SELinux: `getenforce`
* Cambiar el modo de funcionamiento: `setenforce n` donde:
  - 0 --> _Permissive_: Escribe en el log, pero no deniega accesos.
  - 1 --> _Enforcing_: Escribe en el log y niega accesos
  - Los cambios de funcionamiento con setenforce son temporales (en runtime). Para hacerlos permanentes, hay que editar el fichero `/etc/selinux/config` y reiniciar.

En un arranque, podemos cambiar el modo de selinux en el modo de kernel con el parámetro extra en las líneas de kernel.
  - enforcing=1 (enforce)
  - enforcing=0 (permisibe)
  - selinux=0 (disabled)

## Contextos SELinux

SELinux es un conjunto de reglas de seguridad que determina qué proceso puede acceder a qué ficheros, directorios y puertos. Cada fichero, proceso, directorio y puerto tiene una etiqueta de seguridad especial llamada **contexto SELinux**.

Un **contexto** es un nombre que es usado por la politica de SELinux para determinar que proceso puede acceder a qué fichero, directorio o puerto. 

Los contextos se ven con `ls -Z`.

Cuando creamos un fichero/directorio, hereda el contexto del padre. Cuando copiamos manteniendo todo (`cp -a <fichero>`) o movemos, nos llevamos el contexto, así que hay que ser muy consciente de ello, y habrá que hacer una restauración de contexto:

* `chcon -t <tipo_conexto> fichero`: cambia el contexto de un fichero de forma permanente.
* `restorecon -FvvR <fich/dir>`: Restaura el contexto del fichero según las reglas de SELinux, es decir, va consultando el `semanage fcontext -l` para ir restaurando los permisos.

Si añadimos nuevas rutas y luego nos lo queremos llevar a otros sistemas, tendremos que llevarnos las rutas nueva customizadas.

### Añadir reglas.

`semanage fcontext` consulta o modifica las reglas que `restorecon` restaura. Suele ser habitual no tener instalado semanage, con lo que hay que instalarlo.
* semanage: policycoreutils-Python
* restorecon: policycoreutils

#### Comando `semanage {fcontext|boolean}`
Opciones:
* -l --> list
* -a --> añadir
* -d --> borrar
* -t <tipo_contexto_t>
* regla --> para ver ejemplos de reglas, nada mejor que hacer `semanage fcontext -l`

Con esto, definimos la regla, luego hay que plancharla (con `restorecon`).

## Booleanos SELinux

Para obtener información, necesitamos el paquete **selinux-policy-devel**, y sacamos: `man -k _selinux` (si no sale después de instalar el paquete, `mandb`)

Son switches que cambian el comportamiento de las reglas de SELinux, son políticas que pueden estar habilitadas o no. Se usan por los administradores de seguridad para tunear políticas.

* `getsebool <booleano>`: Muestra el valor actual del booleano SELinux (con el flag -a sin booleano, lista todos los booleanos).
* `semanage boolean -l`: Prácticamente hace lo mismo, pero muestra su valor actual, el valor por defecto y una descripción.
  - -C -> nos muestra los que hemos manipulado
* `setsebool <booleano> {on|off}`: para activar/desactivar el booleano que sea. El cambio no es permanente.
  - -P -> lo hacemos permanente

## Puertos

Ya los veremos en el curso de ingeniero... de todas formas.

Para ver los puertos controlados con SELinux: `semanage port -l` veremos los puertos y servicios asociados, además, tendremos que contrastar con lo que tengamos definidos en `/etc/services`.

## Troubleshooting

1. SELinux trabaja correctamente.
2. Contexto erróneo (revisar qué fichero está dando el problema y restaurarlo si es necesario).
3. Somos demasiado restrictivos con el acceso (solución manipulando los booleanos).
4. Hay un bug en SELinux (poco probable) --> reportar a soporte.

Paquete necesario: **setroubleshoot-server** (rpm). Lee mensajes de `/var/log/audit/audit.log` y los pasa resumidos a `/var/log/messages`. Si _auditd_ no está corriendo habrá que habilitarlo y arrancarlo.

Una vez hecho esto, con el comando `sealert -l <UUID>` podremos explorarlo ó `sealert -a /var/log/audit/audit.log` lo cual es mucho más extenso.

***OJO DE CARA AL EXAMEN*** 
No siempre la solución que nos da el sealert es la válida para el exámen, normalmente lo que que buscan es que apliquemos contextos a rutas, así que mejor investigar un poco mas.



# Conexión de usuarios con LDAP e IPA

## Usar LDAP y Kerberos

Para configurar RHEL7 para que use servicios de administración centralizada de identidad se necesitan varios demonios y ficheros:
* `/etc/openldap/ldap.conf`: Información acerca del servidor LDAP.
* `/etc/krb5.conf`: Información sobre la infraestructura de Kerberos
* `/etc/sssd/sssd.conf`: Configuración del _System Security Services Daemon_ que es responsable de recabar y cachear la información de usuario y de autenticación.  
  El demonio **sssd** tiene que estar habilitado y corriendo antes de que el sistema pueda usar cualquier servicio de los otros.
* `/etc/nsswitch.conf`: Indica al sistema qué servicios de información y autenticación usar.
* `/etc/pam.d/*`: Configura cómo los servicios tienen que usar la autenticación.
* `/etc/openlap/cacerts`: Almacen de las CAs (_Certificate Authorities_) contra las que se tienen que validar los certificados SSL que identifican los servidores LDAP.

Dado que es fácil equivocarse, hay una utilidad -**authconfig**- que engloba tres herramientas para hacer la configuración:
* **authconfig**: Se instala con el paquete _authconfig_. Herramienta por línea de comandos con comandos largos y complicados.
* **authconfig-tui**: Versión interactiva de la anterior, guiada por menús, se puede usar vía ssh.
* **authconfig-gtk**: Versión con interfaz gráfica.

### Parámetros mínimos de LDAP

* Host name de los servidores LDAP.
* Base DN (_distinguished name_) de la parte del arbol de LDAP en el que el sistema tiene que buscar a los usuarios.  
   Esta información nos la tiene que proporcionar el administrador de LDAP.
* Si se usa SSL/TLS para encriptar las comunicaciones, nos tienen que proporcionar el certificado raíz.

En la herramienta **authconfig-gtk** tenemos que rellenar lo siguiente:

![](./LDAP_config_KRB.png)

### Parámetros mínimos de Kerberos

Si se usa un sistema centralizado Kerberos para autenticación:
* Kerberos _realm_: Dominio de máquinas que usan el conjunto de servidores y usuarios de Kerberos para autenticación.
* Uno o más KDCs (_Key Distribution Center_): El hostname del servidor Kerberos.
* Host name de uno o mas _admin servers_: La máquina con la que los usuarios tienen que comunicarse cuando quieran hacer modificaciones. Suele ser el KDC, pero puede ser otra máquina distinta.

### Configuración.

Para configurar, usar el **authconfig-gtk**.

**OJO**: hay un bug en la versión _authconfig-6.2.8-8.el7_ que resulta en una '#' en `/etc/sssd/sssd.conf` en el campo _Realm_, simplemente hay que quitar el comentario. Si se usa **authconfig**, asegurarse de usar **--krb5realm=** y luego chequear `/etc/krb5.conf` y `/etc/sssd/sssd.conf`.
Una vez configurado todo, podemos chequear que todo ha ido bien con: `getent passwd <USERNAME>`

## Usar un IPA Server

**IPA** = Identity, Policy and Auditing

Un IPA Server provee LDAP y Kerberos combinados en una suite administrada con un conjunto de herramientas web.

Se puede usar **authconfig** para configurar todo, pero hay una herramienta especializada: **ipa-client-install**, provisto por el paquete **ipa-client**.

Cuando se lanza, busca a través del DNS provisto por el sistema un servidor IPA del que obtener la configuración, en caso de no encontrarlo, preguntará la configuración (nombre de dominio y un realm). También necesitará un nombre de usuario y la contraseña.

## Unirse a un Active Directory

Se pueden hacer de dos formas:
* Instalar _samba-winbind_ y configurar **windbind** a través de **authcofig**
* Instalar los paquetes **sssd** y **realm** y usarlos para unierse al AD.

### Ejemplo.

```bash
# Instalar paquete
$ sudo yum -y install realmd
# Descubrir la configuración
$ sudo realm discover domain.example.com
# Unirse al Active Directory (instalará los paquetes necesarios y configurará sssd, pam y /etc/nsswitch.conf
$ sudo realm join domain.example.com # habrá que meter la constraseña de Admin, si no usar el parámetro --user
# Habilitar el uso de AD.
# A todo el mundo
$ sudo realm permit --realm domain.example.com --all
# A cieros usuarios:
$ sudo realm permit --realm domain.example.com DOMAIN\\usuario1 DOMAIN\\usuario2 ...
```

Por defecto los usuarios deberán usar FQN (ipauser@ipa.example.com) para usuarios IPA, o DOMAIN\user para usuarios del AD., para deshabilitarlo, cambiar **use_fully_qualified_names** en `/etc/sssd/sssd.conf` a _False_ o borrar la línea, luego reiniciar el servicio.



# Añadir discos, particiones y sistemas de ficheros 

El particionado permite dividir el disco duro en múltiples áreas lógicas de almacenamiento llamadas particiones. Separando los discos en particiones, los administradores pueden usar las diferentes particiones para diferentes funciones.

Tener siempre presente los difrentes [múltiplos del byte](https://physics.nist.gov/cuu/Units/binary.html).

## Particionado del disco

### MBR

_Master Boot Record_ indican cómo se particiona el disco en sistemas que corren firmware BIOS.
* Soporta un máximo de 4 particiones primarias
* En sistemas Linux, con el uso de particiones extendidas y lógicas, un administrador puede crear hasta 15 particiones (3 primarias y 12 extendidas en la partición primaria restante).
* El tamaño máximo de la partición es de 2 TiB (dado que usa 32 bits para almacenar info de la partición).

Para manejar las particiones MBR se usa `fdisk /dev/<disco>`

**OJO** Hasta que no se escribe la tabla de particiones (opción **w**), no se guardan los cambios.

### GPT

_GUID Partition Table_ se usa en sistemas que usan UEFI (_Unified Extensible Firmware Inteface_).
* Por defecto soportan 128 particiones.
* Usa 64 bits para direcciones lógicas de bloque, por lo que admite particiones de hasta 8 ZiB (8 billones de TiB) si usuamos bloques de 512 bytes (si usamos bloques de 4.096 bytes, la capacidad aumenta en 8 veces hasta 64 ZiB).
* Tiene redundancia en la tabla de particiones, la primaria reside al inicio del disco y la secundaria al final.
* Usa CRC checksum (_Cyclic Redundacy Check_) para detectar errores y corrupciones en la cabecera GPT y la tabla de particiones.

Para manejar las particiones GPT se usa `gdisk /dev/<disco>`, fdisk se puede usar pero la parte que soporta GPT es experimental, por lo que no se recomienda su uso.

**OJO** Hasta que no se escribe la tabla de particiones (opción **w**), no se guardan los cambios.

### Pasos para crear una partición.

1. Como root, ejecutar fdisk o gdisk
2. Pedir una nueva partición **n**
3. Especificar el número de partición.
4. Especificar la localización en el disco donde empezará la nueva partición.
5. Especificar la última localización donde terminará la partición (también se pueden usar tamaños KiB, MiB, GiB, TiB, PiB).
6. Definir el tipo de partición.
7. Escribir la tabla de particiones y salir.
8. Indicar al kernel que relea la tabla de particiones del dispositivo: `partprobe <dispositivo>` ó `partprobe`.

### Pasos para borrar una partición.

1. Como root, ejecutar fdisk o gdisk
2. Identificar la partición a borrar (**p** imprime la tabla de particiones).
3. Borrar la partición: **d**, nos pedirá la partición a borrar, que hemos identificado en el paso anterior.
4. Escribimos la tabla de particiones **w** y salimos.
5. Indicamos al kernel que relea la tabla de particiones del dispositivo.

**NOTA:** Si nos añaden un disco SCSI, podemos ver la tarjeta y la posición: `lsscsi`, hay que instalar el paquete del mismo nombre.

## Crear sistemas de ficheros.

Una vez que tengamos hechas las particiones, todavía no las podemos usar en el sistema, primero hay que dar el formato adecuado y después montarlas.

La aplicación **mkfs** es la encargada de dar formato a la partición. Si no se especifica otra cosa, el tipo de file system por defecto es _ext2_, RH admite muchos formatos, los mas usados son _xfs_ que es el tipo por defecto que aplica anaconda durante la instalación y _ext4_.

```bash
root@system# mkfs -t {ext4|xfs|...} /dev/<particion>
```

## Montar el FileSystem

Una vez formateado, para que se pueda usar, la partición tiene que montarse en algún sitio, para esto se tiene que crear un directorio vacio donde se montará llamado **punto de montaje**

Para ver lo que hay montado en el sistema: `mount -a`

### Montaje manual

Simplemente se dice que se monte y donde.

```bash
root@system# mount /dev/<particion> <punto_montaje>
```

Esta es la mejor forma de ver si el particionado que se ha hecho funciona, pero hay que tener en cuenta que una vez reiniciado el sistema, el montaje se pierde.

### Montaje automático

Para que no se pierdan los montajes, hay que hacerlos automáticos. Para ello, habrá que añadir una línea en el fichero `/etc/fstab` con un formato determinado, valores separados por espacios. Cada campo tiene un significado.

1. Dispositivo: se puede dar el UUID obtenido mediante `blkid` ó el dispositivo.
2. Punto de montaje
3. Tipo de file system
4. Opciones de montado (ver `man mount`)
5. Flag dump: usado junto con el comando `dump` para hacer backup del contenido del dispositivo.
6. Flag fsck. Indica si se tiene que chequear el FS en el arranque y su orden.

## Swap

El spacio de swap es un area de disco que usa el kernel de Linux para paginar las páginas inactivas en memoria. La swap es mucho mas lenta que la RAM, ya que reside en disco, el uso de la swap debe mantenerse en el mínimo posible.

Para crear espacio de swap, hay que seguir estos  tres pasos:
1. Crear una partición.
2. Poner el tipo de partición a 82 (Linux Swap).
3. Formatear la signatura de swap al dispositivo.

Los puntos 1 y 2 se hacen como cualquier partición, en punto 3: `mkswap  <particion>`

Para disponibilizar la swap hay que activarlo. `swapon <particion>`, con `swapon -a` se activan todas las particiones de swap del `/etc/fstab`. Para quitarlo, `swapoff`, este comando sólo tendrá éxito si ningún dato swapeado está siendo escrito en ese momento.

Para que los cambios sean permanentes hay que ponerlo en `/etc/fstab`, la línea sería algo similar a la siguiente:
```text
UUID=<uuid> swap swap defaults 0 0
```



# Administrar Logical Volume Management (LVM) 

## Conceptos

* **Physical Device (PD)**: Tanto un disco como una partición.
* **Physical Volume (PV)**: Agrupación de PD
* **Physical Extension (PE)**: Bloque de almacenamiento más pequeño asociado a un PV. (partición física)
* **Volume Group (VG)**: Agrupación de PE. Al crear el VG, decidimos el tamaño de las PE.
* **Logical Volume (LV)**: Particiones lógicas de un VG. (para estas es transparente el VG).
* **Logical Extension (LE)**: Cada LE se corresponde (no mirror, con una PE), (en mirror, con 2 PE). Las LE, serán múltiplos de PE.

## Manejo

### Creación

Al crear la partición física (PD), RH recomienda usar particiones tipo MBR (0x8e)
1. Crear la partición física: `fdisk /dev/vdb` (ó `gdisk /dev/vdb`)
2. Crear volumenes físicos: `pvcreate /dev/vdb1 /dev/vdb2`
  - listarlos: `pvs`
3. Crear VG: (mirar en el man de qué tamaño crear las PEs): 
  - Sin especificar tamaño: `vgcreate vgdata /dev/vdb1 /dev/vdb2`
  - Especificando el tamaño del extent: `vgcreate -s 8M vgdata /dev/vdb1 /dev/vdb2`
  - listarlos: `vgs`
4. Crear LV: `lvcrate -n lvdata -L 2G vgdata` (G --> GiB)
  - Posibles valores de las Ls
    * -L 2G -- 2 GiB
    * -L +128M -- amplia 128M
  - Posibles valores de las l's (en unidades de PE).
    * -l 80 -- 80 PEs
    * -l +80 -- amplia 80 PEs
    * -l 50%FREE -- 50% de las PE libres
    * -l +50%FREE -- amplia con el 50% de las PE libres
  - Creará un dispositivo: 
    * Dispositivo: `/dev/vgdata/lvdata`
    * Mapeo del Kernel: `/dev/mapper/vgdata-lvdata`
5. Formateo el FS: `mkfs -t ext4 /dev/vgdata/lvdata`
6. Monto: `mount /dev/vgdata/lvdata /mnt`
  - si quiero automontaje, meterlo en el `/etc/fstab`.
  
### Borrado 

Si queremos remover completamente todo:
1. Desmonto: `umount`
2. Borrar el LV: `lvremove /dev/vgdata/lvdata`
3. Borrar el VG: `vgremove vgdata`
4. Borrar el PV: `pvremove /dev/vdb1 /dev/vdb2`

Nos quedarán dos particiones mondas y lirondas.

### Consulta
* Listar: pvs, vgs, lvs
* Ver información más concreta:
  - PV: `pvdisplay /dev/vdb1`
  - VG: `vgdisplay <name>`
  - LV: `lvdisplay /dev/vg-name/lv-name`
  
### Extender VG

1. Si necesitamos una partición habrá que usar fdisk ó gdisk
2. Cramos un nuevo PV: `pvcreate /dev/vdx`
3. Extendemos: `vgextend vgdatos /dev/vdx`
4. Comprobamos que la operación haya sido correcta

### Reducir VG

1. Si tiene datos hay que liberar la PV: `pvmove /dev/dvx`
2. Reducimos el VG: `vgreduce vgdatos /dev/vdx`
3. Comprobamos que la operación ha sido correcta.

### Extender LV

1. Comprobar que tenemos espacio para extender: `vgdisplay vgdatos`
2. Extendemos: `lvextend -{l|L} <valor> /dev/vgdatos/lvdatos`
3. Agrandamos el fileSystem:
  - **xfs** --> `xfs_growfs /pto/montaje` 
  - **ext4** --> `resize2fs /dev/vgdatos/lvdatos`
  - También tenemos el flag -r (--resize) del lvextend que hace esto sin necesidad de tener que redimensionar el FS.
4. Comprobamos.


### Snapshots

Dentro del mismo VG, son LV que apuntan a otro LV, de forma que ambos están sincronizados.  
En el snapshot están los inodos que apuntan a los del LV original, cuando se modifica un fichero, en el snapshot se van copiando los chunks que cambian. 

Si en un momento dado quiero recuperar, me llevo lo del snapshot al original . Se usa para extraer datos de la BD y luego hacer backup sin necesidad de parar la BB.DD.

#### Operativa.

* Creamos un snapshot de lvdata, del tamaño inicial de 1 G.  
  `lvcreate -s -L 1G -n lvdata_snap /dev/vgdata/lvdata`
* Restaurar snapshot:   
  `lvconvert --merge <snapshot>`



# Network Storage NFS 

NFS (_Network File System_): Protocolo estándar usado por sistemas tipo -nix como el protocolo nativo de FS en red.

En RHEL7 - nfsv4 (si no está disponible, pues las anteriores).
* v4 sólo usa TCP
* v3 y anteriores usa TCP/UDP

El mecanismo es una exportación (con un origen de red) que montamos en un punto de montaje. La nomenclatura suele ser `serverX:/ruta/nfs/exportado`

Cómo lo montamos:
* Montaje manual (mount)
* Montaje permanente (`/etc/fstab`)
* Automount

## Seguridad

Podemos usar uno o varios métodos de seguridad, añadiendo a la opción de montaje: **sec=metodo**. El servidor puede usar varios sistemas de seguridad, en cliente sólo uno:
* **none**: Acceso anónimo a los archivos de NFS (usando el usuario _nfsnobody_)
* **sys**: Acceso con los estándares de Linux usuario:grupo
* **krb5**: Los clientes tienen que autenticarse con Kerberos y luego los permisos estándar de Linux.
* **krb5i**: Agrega criptografía a los datos de ida y vuelta para asegurar que los datos no han sido alterados.
* **krb5p**: Añade cifrado en todas las peticiones entre cliente y servidor (esto tiene un impacto en el rendimiento).
  - Para esto habrá que bajarse el keytab.

Necesitaremos:
* Un fichero `/etc/krb5.keytab` que nos proveerá nuestro administrador de seguridad. La mayoría de los problemas vienen de descargar este fichero (tiene que ser binario y tener los contextos de SELinux).
  - `sudo wget -O /etc/krb5.keytab http://<ruta a keytab>`
* Un servicio **nfs-secure** proporcionado por el paqeute _nfs-utils_ y lo tenemos que tener started y enabled. Esto también puede ser una posible fuente de errores.

## Montajes

### Montaje estándar

1. Identificar las exportaciones del servidor NFS:
  * En nfsv2 y nfsv3 está el comando `showmount -e <NFSserver>`
  * En nfsv4 (como root)
  ```bash
  mkdir /pto/montaje
  mount server:/ /pto/montaje
  cd /pto/montaje
  ```
2. Creamos un punto de montaje definitivo: `mkdir /destino`
3. Montamos manualmente o añadimos a fstab
  * **Manual**: `mount -t nfs -o sync server:/<dir_compartido> /pto_montaje`
    - sync --> escribe inmediatamente los cambios
    - async --> no escribe inmediaitamente  
      por defecto, el método de seguridad es _sys_
  * **/etc/fstab**:
    `server:/<dir_compartido> /pto_montaje nfs  sec=krb5p,sync 0 0`

### Montaje automático

Servicio de automontaje (**autofs**), nos permitirá montar bajo demanda los NFSs que necesitemos, y los desmonta cuando dejan de usarse. Cuando el usuario haga un cd a ciertos directorios, automáticamente se montarán.

Ventajas:
* No se necesitan privilegios de root (hay que respetar los permisos del sistema).
* No tienen por qué aparecer en el fstab.
* Gestiona mejor las conexiones de red.
* Es de la parte cliente.
* Tiene las mismas opciones de montaje que si lo hiceramos manualmente.
* Añade flexibilidad con los puntos de montaje.

Tres tipos de automontaje
* Directo
* Indirecto
* Con comodines

Por defecto el montaje es asíncrono, por eso, antes de desmontar un USB se suelen mandar 2 o 3 `sync` para que escriba los datos en el USB antes de desmontar.

#### Pasos para hacer un automontaje.

1. Instalar el software necesario: `yum install -y autofs`.
2. Crear el fichero de asignación maestra en `/etc/auto.master.d/*.autofs`.
  - Identifica el directorio base usado para los puntos de montaje.
  - Asocia el directorio con los archivos de asignación para crear los automontajes.
  
Podemos definir el tipo de filesystem (--fstype), si queremos que sea estricto (-strict) y opción (--ghost).
    
##### Montajes indirectos

Definimos debajo de qué vamos a pivotar los montajes

```text
/shares  /etc/auto.indirecto  # montajes indirectos
/-       /etc/auto.directo    # montajes directos
/compart /etc/auto.comodines  # montajes con comodines
```

Supongamos que tenemos un montaje `/shares/work` y un `/shares/prueba`

```text
cat /etc/auto.indirecto
work    -rw,sync  serverX:/export/work
prueba  -rw,sync  serverY:/nfsexport/test
```
 
##### Montajes directos

Pongo un anclaje sobre el que pivoto (tendré que haber creado los directorios que voy a montar).

```text
cat /etc/auto.directo
/mnt/novedad  -rw   serverX:/directo/novedades
/mnt/pruebas  -rw   serverY:/directo/novedades
```

##### Montajes con comodines

``` text
cat /etc/auto.comodines
* -rw,sync  serverX:/compartido/&
```

Si hago un cd a un directorio que coincida con /compartido/PEPE, como tengo en el _autofs_ una entrada que comienza con "/compartido", si se exporta algo en serverX:/compartido/PEPE, me lo montará en /compartido/PEPE.

Caso típico de uso, en el autofs tenemos definido:  
`/home/guests  /etc/auto.comodines`  
y en /etc/auto.comodines:  
`* -rw,sync  serverX:/home/&`

Así cuando hagamos `cd /home/guests/ldapuserX`, nos montará directamente `serverX:/home/ldapuserX`



# Network Storage SMB 

* **SMB**: Server Message Block.
* **CIFS**: Common Internet File System, es un dialecto de SMB.

En NFS todos los montajes se pueden hacer con un usuario, si este tenía los permisos adecuados. Ahora vamos a ver que aquí no es así. Sin embargo, para montar un **SMB share** o **recurso SMB** necesitamos acceder como un usuario que  tenga permisos para montar ese sistema (usuario, passwd, dominio).

Paquetes: `cifs-utils`, `samba-client` (este no es obligatorio, pero sí recomendable).

## Montajes

1. Identificar: `smbclient -L //server`
2. Crear el punto de montaje: `mkdir -p /pto/montaje`
3. Montaje (fstab, automount, mount)

### Montaje manual

`mount -t cifs -o guest //server/recurso /pto/montaje`

### fstab

Meter la siguiente línea:  
`//server/recurso /pto/montaje  cifs  guest 0 0`

## Si no nos identificamos como guest

_usuario/password_ son independientes de lo que tenga el sistema, de hecho, los usuarios asociados a SAMBA se les suele dar el shell **/bin/nologin**

`mount -t cifs -o username:<usuario> //server/recurso /pto/montaje`, nos pedirá el passwd.

Podemos tenerlo en un fichero de credenciales de root, con permisos 600, normalmente lo dejaremos colgando de `/root/secure/` con el siguiene formato:
```text
username="nombre"
password="pass"
domain="dominio"
```

En este caso, invocaremos: `mount -t cifs -o credentials=/root/secure/creds //server/recurso /pto/montaje`

## Automontaje

Samba también se automonta. El procedimiento es prácticamente igual.

Fichero maestro de asignación (`/etc/auto.master.d/*.autofs`) y luego su fichero de mapeo (`/etc/auto.*`).
```text
cat /etc/auto.master.d/baker.autofs
/bakerst  /etc/auto.baker

cat /etc/auto.baker
cases -fstype=cifs,credential=/server/sherlock  ://server/recurso
```

Esto requiere dos cosas:
* autofs
* cifs-utils



# Troubleshooting del arranque 

Una web donde explica bien el [proceso](https://www.thegeekdiary.com/centos-rhel-7-booting-process/).

## El proceso de arranque en máquinas x86_64

Este mismo proceso es aplicable para máquinas virtualizadas (en este caso, el HW es el hipervisor el que se encarga de ello).
1. POST (_Power On Self Test_): Encendemos la máquina (BIOS o UEFI)
	- Test automático para ver si tiene energía suficiente para arrancar la máquina.
2. MBR: Con el firmware del sistema recién cargado, se selecciona el dispisitivo arrancable (podría también ser GPT).
  - Se busca la tabla de particiones
3. Bootloader: Busca de donde tiene que cargar el kernel (en RHEL7, por defecto es GRUB2).
  - Para configurarlo: `grub2-install`
  - Cada bloque que nos muestra, viene definido por un menú entry
  - Se hacen configuraciones
  - Se carga el kernel con los parámetros que hemos configurado (ahí es donde metemos mano para definir un kickstart, puntos de control, etc...)
  - Se carga el runlevel.
4. Kernel: Carga en memoria el _initram_ y el kernel **initramfs/kernel** con un archivo tipo gzip de un cpio con todos los módulos necesarios para que funcione el sistema.
  - El responsable de esto es el **dracut**, y su config en `/etc/dracut.conf`
  - Arranca el primer proceso del sistema (systemd con PID=1).
  - Aquí el bootloader le pasa el control a kernel
5. Systemd:
  - tira de ficheros de configuración situados a `/etc/systemd`
  - Intenta conectar los target `/etc/initrd.target`, para poner el sistema en el estado que necesitamos.
    - monta el `/` en `/sysroot`
  - Controla en qué target nos pone el sistema, definido en `/etc/systemd/system/default.target` (que es un link simbólico que apunta al target al que se tiene que arrancar).
6. Pivote de `/sysroot` a disco `/`

Para rebotar el sistema de forma ordenada:
  * `systemctl poweroff`: detiene todos los ficheros, demonta los archivos y apaga el sistema
  * `systemctl reboot`: restart
  * `systemctl halt`: Detiene todos los procesos, desmonta los FS y se queda a la espera del botonazo
  
## Targets

Un target de systemd es un conjunto de units de systemd que deben ser arrancadas para alcanzar cierto estado.

* **multiuser.target**: Varios usuarios pero sólo texto (init 3)
* **graphical.target**: Levanta gnome que permite varios inicios de sesión gráficos y basados en texto (init 5)
* **emergency.target**: Entra tras la carga del kernel, sólo tenemos montado el raíz en modo lectura (init 1)
* **rescue.target**: Muestra una consola de sulogin con la mayor parte del sistema levantado (los FS).

### Comandos de systemctl relacionados.

* `systemctl list-dependencies <modo>.target |grep target` Nos muestra los targets de los que depende uno concreto (sin el grep, nos muestra todas las dependencias).
* `systemctl list-units --type=target --all` Nos muestra todos los targets disponibles.
* `systemctl list-unit-files --type=target --all`: todos los targets disponibles
* `systemctl isolate <target>.target`: Para cambiarnos a un target, parará todos los servicios no necesarios para ese target.
  - En `/etc/systemd/system` podemos añadir una unidad.target.
* `systemctl get-default` Nos devuelve el target por defecto
* `systemctl set-default <target>.target` establece el _default target_, que lo que hace es cambiar el log simbólico.

También podemos cambiar el target en la línea de kernel del grub (es la que empieza con _linux16_), metiendo el siguiente parámetro: `systemd.unit=<target>.target` (recordar, cuando está el menú del grub, pulsamos "e" y podemos modificar la línea de arranque que hemos seleccionado y una vez modificado, **Ctrl+x** para iniciar con los cambios).  
En el modo edición podremos cambiar el mapa del teclado ya que por defecto viene en inglés.

## Troubleshooting

### Recuperar password de root

Supongamos que hemos perdido la password de root.

Una posible solución, es levantar con un live-cd, generar una password encriptada de root (ver el script de python) y meter esa cadena en el `/etc/shadow`. Luego reiniciar el sistema.

#### Otra forma (mejor)

Esto funcionará si no tenemos protegido el grub con la password de grub.

1. Interrumpimos el sistema y metemos en la línea del kernel el siguiente parámetro: `rd.break`.  
  Cuando arranque, nos dará una consola (la última consola definida en la línea de kernel es donde se mostrará el prompt).   
  **OJO** lo mejor es que terminemos la línea con `... console=tty0 rd.break`
2. Montamos el raíz en modo lectura/escritura: `mount -o rw,remount /sysroot`
3. Enjaulamos el sistema raíz: `chroot /sysroot`
4. Restablecemos la passwd de root: `passwd root`, el problema es que como SELinux no está corriendo, habremos perdido el contexto del `/etc/shadow`.
5. Decimos que en el próximo reinicio reetiquete con SELinux los ficheros sin etiquetar: `touch /.autorelabel`
6. Nos vamos: `exit;exit;`

Arrancará con la nueva password de root.

### Usar journalctl

Hacer persistentes los logs para poder examinar caídas entre reinicios:
```bash
mkdir -p -m 2755 /var/log/journal
chown :systemd-journal /var/log/journal
killall -USR1 systemctl-journald
```

El killall es equivalente a `journalctl --flush`

Para ver los logs de otros arranques: `journalctl -b-n -p err` vemos los errores del arranque -n antes del que estamos (lo normal, para ver lo que pasó antes del último arranque: **-b-1**).

### Shell de depuración temprana

Es una consola en la que se entra directamente como root, sin necesidad de meter contraseña. Para ir a ella, **Ctrl+Alt+F9**, en principio no está habilitada, hay que hablitarla con un servicio:  
`systemctl enable debug-shell.service`

Esto es un agujero de seguridad en el sistema así que una vez que hayamos terminado de necesitar la consola de depuración, volver a deshabilitarla.

En esta shell podremos ver en el arranque lo que está pasando.

#### Stuck jobs (trabajos colgados)

En el arranque **systemd** va arrancando servicios, si algunos de estos no arrancan, bloquean el arranque de otros. 

Para inspeccionar la lista de jobs actual: `journalctl list-jobs`, los jobs en estado _waiting_ no arrancarán hasta que los que están en _running_ no terminen.

## Reparar problemas de FS en el arranque

Los errores en el `/etc/fstab` y FS corruptos pueden parar el arranque de una máquina. Normalmente **systemd** continúa con el arranque tras un timeout y nos lleva a un shell de emergencia donde es necesario entrar como root.

Errores comunes:
* FS corrupto: hacer un fsck.
* Algo incorrecto en el **/etc/fstab**
  - Dispositivo inexistente.
  - Punto de montaje inexistente.
  - Opción de montaje incorrecta.

En cualquier caso, terminaremos en una shell de emergencia (si no, podríamos meternos en _emergency.target_).

Después de reparar, tendremos que lanzar `systemctl daemon-reload` para que **systemd** siga con las nuevas versiones de los ficheros que hayamos modificado.

Ayuda: systemd-fsck, systemd-fstab-generator, systemd-fstab-mount

## Problemas con el bootloader

**grub2 (_GRand Unified Bootloader v2_)** es el boot loader por defecto de RedHat, se usa para arrancar tanto desde sistemas con BIOS como con UEFI y soporta casi cualquier sistema operativo.

Fichero de configuración principal: `/boot/grub2/grub.cfg`. En principio no se debería editar este fichero, sino que editaremos variables de configuración y luego reconfigurar el arranque con la herramienta **grub2-mkconfig**, que mira en `/etc/default/grub` (aquí si que podemos meter mano) para buscar opciones y luego usa los scripts de `/etc/grub.d/` para generar el fichero de configuración.

Para hacer los cambios permamentes: `grub2-mkconfig > /boot/grub2/grub.cfg`

### Algunas directivas

* Entradas arrancables bajo bloques **menuentry**.
  - linux16 --> hace referencia al kernel
  - initrd16 --> hace referencia a initramfs
  - set root --> apuntan al filesystem desde donde grub2 cargará el kernel y el initramfs
    - Sintaxis: _harddrive,partition_, donde hd0 es el primer disco, hd1 el segundo, ...  
      Las particiones se indican como **msdos1** para la primera partición MBR ó **gpt1** para la primera partición GPT
    - Ejemplo: `set root="hd0,msdos1"` ó `set root="hd0,gpt1"`.

### Reinstalar grub

Para aquellos casos en que nada funciona, se puede reinstalar con **grub2-install**
* en sistemas BIOS, grub2 se instalará en el disco donde esté la MBR y hay que pasarlo como argumento
* en sistemas UEFI no son necesarios argumentos porque la partición EFI está montada en `/boot/efi`.



# Firewall: limitar comunicaciones de red 

En versiones anteriores **iptables** (e **ip6tables**), ahora es **firewalld**. Ambos trabajan con el subsistema **netfilter**. No es habitual que veamos los dos corriendo. Lo ideal es que uno de los dos esté enmascarado.

Firewalld permite administrar las reglas que permiten o no la conexion a través de un puerto, interfaz, etc...

Un firewall controla el tráfico entrante al sistema (parará todo lo que no tenga definido en sus reglas).

Trabaja con zonas, dependiendo de en qué zona estemos, permitirá una cosa u otra.

**firewall-cmd** y **firewall-config** dos herramientas para configurarlo, la segunda es gráfica.

Dos configuraciones posibles.
* Runtime
* Permanent

Normalmente lo que se tiene en runtime, hay que meterlo en permamente, las cosas que metamos en permanente, tendremos que pasarlas a runtime (con `systemctl reload firewalld`).

A través del DBus (bus de comunicaciones), las aplicaciones pueden comunicarse con el firewall. Admite IPv4 e IPv6.

El paquete que lo instala es **firewalld**, no forma parte de una instalacion _minimal_ y pero si de la _base_.

**firewalld** hará una clasificación del tráfico que le llega según unos criterios:
* ip fuente
* interfaz de entrada
* zona default

Cada zona tiene su propia configuración de firewall

## Funcionamiento

* Podemos asignar un rango de ips a cada zona, con lo que el trafico que entre por ahí irá por esa zona y, si no; pasa al siguiente control.
* Podemos asignar un interfaz a una zona, si no hay ninguna irá por la zona por defecto (PUBLIC).
* En portátiles se puede configurar el NetworkManager para que dependiendo de la red a la que se conecte, coja una zona de firewall u otra, y customizar esas zonas.
* Abriremos por sevicio o puerto. 
* Si entra un tráfico que no tiene match con servicio o puerto, se le deniega el acceso (deny - drop).        

### Zonas predefinidas

Estas zonas vienen así en la instalación, pero el administrador puede modificarlas. `man 5 firewalld.zones`

* **trusted**: Permite todo el tráfico entrante
	- El interfaz _/dev/lo_ se trata como si estuviera en esta zona.
* **home**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente o que esté relacionado con los servicios ssh, mdns, ipp-client, samba-client o dhcpv6-client
* **internal**: Como el _home_
* **work**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente o que esté relacionado con los servicios ssh, ipp-client o dhcpv6-client
* **public**: La usada por defecto
	- Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente o que esté relacionado con los servicios ssh o dhcpv6-client
	- Es la zona por defecto para las interfaces de red que se añaden.
* **external**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente o que esté relacionado con los servicios ssh.
	- El tráfico IPv4 que es redirigido a través de esta zona se enmascara como si saliera de interfaz de red saliente.
* **dmz**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente o que esté relacionado con los servicios ssh.
* **block**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente.
* **drop**: Rechaza el tráfico entrante a no ser que esté relacionado con el tráfico saliente, no responde con errores ICMP.

### Servicios predefinidos

Los sevicios predefinidos en la zona por defecto son:
* ssh: Servidor SSH local, puerto 22/tcp
* dhcpv6-client: Tráfico al puerto 546/udp en la red IPv6 fe80::/64
* ipp-client: Impresión IPP, puerto 631/udp
* samba-client: Ficheros locales Windows y cliente de impresión, tráfico en el puerto 137/udp o 138/udp
* mdns: MulticastDNS. Tráfico al puerto 5353/udp de 224.0.0.251 (IPv4) ó ff02::fb (IPv6)

Para ver todos los servicios, usar `firewall-cmd --get-services`

Los ficheros de configuración están en el directorio `/usr/lib/firewalld/services`.

## Configurar el firewall

Se puede tocar a mano los ficheros de configuración de `/etc/firewalld/` o usar las herramientas de configuracion **firewall-cmd** ó **firewall-config**.

**firewall-config** es una herramienta gráfica. Recordar que para que los cambios se hagan en la configuración _Permanent_ no se harán efectivos hasta un reinicio del servicio, y los cambios hechos en _Runtime_ no sobrevivirán a un reinicio del servicio.

### Flags de _firewall-cmd_

El tabulado autocompleta.

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
