1. [Automatización de la instalación](#kickstart)
2. [Expresiones regulares y grep](#regular_expressions)
3. [Vim avanzado](#advanced_vim)
4. [Programación de tareas](#task_sched)
5. [Prioridades](#priority)
6. [Control de acceso a ficheros (ACLs)](#acls)
7. [Manejo de SELinux](#selinux)
8. [Conexión de usuarios con LDAP e IPA](#redes)
9. [Añadir discos, particiones y sistemas de ficheros](#discos)
10. [Adminsitrar Logical Volume Management (LVM)](#lvm)
11. [Network Storage NFS](#nfs)
12. [Network Storage SMB](#smb)
13. [Firewall: limitar comunicaciones de red](#firewalld)
14. [Troubleshooting del arranque](#troubleshooting)
15. [Apéndice: Comandos útiles](#apendix)

***

# Automatización de la instalación <a name="kickstart"></a>

**Anaconda** es el instalador que usa RHEL, necesita que el que está haciendo la instalación le responda a una serie de preguntas acerca de la configuracion del sistema.

**Kickstart** es el sistema para hacer instalaciones desatendidas del sistema (coge un fichero de texto con las respuestas). Se basa en un fichero dividido en secciones, con el siguiente formato:

~~~text
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
~~~

Los comentarios van en líneas precedidas por #

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
* **volgroup,logvol** Crea grupos de volúmenes y volúmenes lógicos de LVM.
* **zerombr** Se usa con sistemas a los que queremos forzar el borrado del MBR.

### Comandos de networking

* **network** Configuración de red
* **firewall** Habilita firewall en el arranque

### Comandos de configuración del OS

* **lang** Especifica el idioma
* **keyboard** Especifica el tipo de teclado
* **timezone** Definie tz, NTP y reloj HW.
* **auth** Especificar las opciones de autenticación. **OBLIGATORIO**
* **rootpw** Contraseña de root (podemos ponerla en texto plano o cifrada)
* **selinux** habilitar o no SELinux
* **services** Indica que servicios estarán habilitados en el arranque
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

También podemos modificar un fichero ya existente, luego podremos validar la sintaxis con **ksvalidator** por si hemos metido la pata. En nuestro sistema siempre habrá un fichero de configuración: `/root/anaconda-ks.cfg` que contiene lo que se hizo en nuestro sistema en la instalación, puede ser un buen punto de partida para generar un fichero de kickstart. Además, nos servirá si queremos hacer instalaciones clonicas.

### Pasos

1. Crear un fichero de configuración kickstart (**system-config-kickstart**).
2. Usar un editor de texto para añadir montajes al fichero de kickstart.
3. Chequear la correción del fichero (**kasvalidator**).
4. Publicar el fichero para el instalador: 
  * `ks=<medio>` indica dónde está el fichero (nfs, http, https, cd-rom, hd).
5. Arrancar Anaconda y apuntar al fichero de configuración.  
  Normalmente se lo diremos en la línea de arranque del kernel, pero hay virtualizadores donde podemos pasarle este parámetro. 

***

# Expresiones regulares y grep <a name="regular_expressions"></a>

## Expresiones regulares

Una expresión regular es un conjunto de metacaracteres que nos permite definir cadenas. Se difierencia de _fileglobbing_ en que esta última sólo se usa para buscar ficheros.

Podemos usarlas para buscar en vim, less, grep.

Una palabra es una expresión regular que engloba a todas las palabras que contienen la palabra.

### Anclas de línea.

* Comienzo de línea: `^{exp_reg}`
* Final de línea: `{exp_reg}$`

### Limitación de palabras

* Comienzo de palabra: `'\<{exp_reg}'`
* Fin de palabra: `'{exp_reg}\>'`

**NOTA:** la coma simple la usaríamos para buscar palabras: `'\<perr'` ó `'os\>'`, para busar la palabra exacta: `'\<perros\>'`

### Comodines y multiplicadores.

* `.` --> Cualquier caracter
* `[abc]` --> Cualquiera de a, b o c (sólo 1).
* `*` --> El carácter anterior 0 o más veces repetido (ej: `.*` ==> cualquier carácter, 0 o más veces repetidos)
* `+` --> El caracter anterior 1 o más veces repetido.
* `\{n\}` --> repetir _n_ veces la expresión anterior (ej: `c.\{2\}t` ==> c seguida de dos cacracteres cualesquiera y seguido de t).

**NOTA:** si no queremos que nos hagan sustituciones el shell, envolver la expresión regular con comillas simples.

Ayuda: **regex(7)**

## grep

Busca cadenas de caracteres usando expresiones regulares.
* Podemos usarlo en línea de comandos actuando sobre un fichero: `grep <flags> <expr_reg> <fichero>`
* Podemos usarlo tras un pipe para hacer la búsqueda en la salida del comando: `<comando> | grep <flags> <expr_reg>`
* Flags:
  - -i -- ignore case
  - -v -- saca las líneas que no coincidan
  - -r -- Recursivo
  - -A <n> -- Número de líneas después de la coincidencia que tenemos (after)
  - -B <n> -- núnero de lineas antes de la coincidenccia (before)
  - -w -- líneas que conitnen la palabra exacta
  - -e -- múltiples OR
  - -E -- Expresiones regulares complejas
  
Excluir comentarios : `grep -v '^[#;]'`

Ya sabemos... **man grep**

***

# Vim avanzado <a name="advanced_vim"></a>

3 modos: 
* comando: para meter comandos de manipulación del fichero.
* insert: Manipular texto
* execution: hacer transformaciones

## Paquetes de vim.

* vim-minimal: el incluido en la instalación mínima
* vim-enhanced: Nos da algunos complementos como plugins
  - Formatos
  - Autocompletado
  - Revisón de sintaxis
* vim-X11: gvim

### Modo ejecución:

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

***

# Programación de tareas <a name="task_sched"></a>

## at

Cuando queramos que algo se ejecute en un determinado momento, pero no siempre, usaremos este programa.

**Demonio:** atd
**Paquete:** at

Incluye una serie de colas [a-z] ordenadas por prioridad, con lo que podemos separar los trabajos y organizarlos según su importancia/prioridad.

¿para que es útil? Normalmente, todo lo que hacemos con at, lo podemos hacer con cron, nos puede ayudar para desactivar algún servicio con el que estamos trabajando y que nos puede dejar fritos, así recuperamos el control.

root puede ver todos los trabajos, el usuario sólo los que ha lanzado el.

Al final de la ejecución, nos manda un mail.  
**NOTA:** Si en vez de un mail, queremos ver la salida por pantalla, redirigir la salida. (para eso, podemos ver el terminal en el que estamos con `w -f` y luego hacer `echo $(comando) > /dev/pts/*`

### Comandos

* `at <TIMESPEC>`: Nos abrirá un subshell para crear los comandos que queremos lanzar. Le podemos pasar por stdin el script que queremos que ejecute.
* `atq` ~ `at -l`: Nos muestra información de las colas de at:
  - Número de trabajo
  - Fecha y hora programada
  - cola del trabajo
  - usuario
* `at -c <num_job>`: Muestra la tarea y su entorno
* `atrm <num_job>`: Borra la tarea
* `at -q <cola> <time_spec>`: Manda el trabajo a la cola indicada.

### TIMESPEC

Referencia: `/usr/share/doc/at-*/timespec`

Tiempo absoluto: 5 pm August 3 2019
Tiempos relativos:
* teatime tomorrow (teatime son las 16:00)
* noon + 4 days
* midnight + 1 weekSYSTEM CONFIGURATION AND MANAGEMENT

## cron

Si queremos ejecutar algo varias veces de forma periodica, es mejor usar cron.

* Paquete: cronie
* demonio: crond

crontab -e --> para editar el crontab
crontab -r --> Borra el crontab del usuario
crontab -l --> Muestra el crontab del usuario
crontab <fichero> --> sustituye el crontab por el fichero proporcionado
  
### Formato del fichero.

* Permite líneas vacías
* Permite comentarios (#)
* Permite definir variables de entorno (afectarán a todas las líneas que tengas debajo), especialmente interesantes son:

* Formato de las líneas:
minuto hora dia-mes mes dia-semana comando
* Valores:
  - * --> comodín
  - números
  - Dias de la semana (0 -> SUNDAY, ... 7 -> SUNDAY)
  - Puedo marcar intervalos x-y, , listas x,y, combinaciones: x-y,z, periódicas \*/5 (cada 5 unidades)
  - **OJO**, los días no los parsea, es decir no podemos decir el día de la semana que caiga en cierto núemro.
  - **OJO**, Si el comando tiene un singo `%`sin escapar, se trata como un salto de línea y todo lo que va detrás se pasa al comando como _stdin_
crontab -u <user> --> (sólo root) usa el crontab de usuario

## Cron del sistema

No están definidos como los cron de los usuarios del sistema, tiene un campo más, que es el usuario en nombre del que se lanzan los comandos del cron.

Ficheros relacionados:
* `/etc/crontab`: Este es el fichero principal del sistema relacionado con el cron
* `/etc/cron.d/*`: personalizaciones del sistema, y los paquetes que añaden cosas en el cron, se meten aquí
  - Tenrá ejecuciones del sistema programadas.
* `/etc/anacrontab`: Aquí se configuran todos los scrips que se pueden correr cada día, semana o mes:
  - `/etc/cron.hourly`
  - `/etc/cron.daily`
  - `/etc/cron.weekly`
  - `/etc/cron.montly`
  - En todos esos sule faltar el primero, pero está en `/etc/cron.d/0hourly`, que es para los que se ejecutan cada hora.
  - Los scripts que dejemos en estas rutas tendrán que tener permisos de ejecución.
  
El parámetro: job-idenfier, se usa para identificar el job, pero esta forma asegura que el sistema se lanza con la periodiciad indicada.

### Variables
* **SHELL**: Especifica el shell por defecto
* **MAILTO**: Especifica un mail al que enviar correo cuando salta el cron
* **RANDOM_DELAY**: en los daily, weekly y monthly, definen el rango de horas en el que se va a ejecutar.

## Ficheros temporales

**systemd-tmpfiles**

Systemd nos arranca el sistema y de loprimero que arranca es _systemd-tmpfiles-setup_ que ejecuta `systemd-tmpfilse --create --remove`

Lee los ficheros de configuración que tiene la unidad:
* `/usr/lib/tmpfiles.d/*.conf`: (RPMS)
* `/run/tmpfiles.d/*.conf`: Donde meterán algunos programas sus ficheros temporales. (daemons y procesos), volátil.
* `/etc/tmpfiles.d/*.conf`: la ruta de adminsitrador (adminstrador)
  - Lee los ficheros que tiene definidos como temporales y los crea.
  - Cada cierto tiempo según una unidad *systemd_tmpfiles-clean.timer* define cada cuanto tiene que purgar los ficheros termporales (más información en _/usr/lib/systemd/system/systemd-tmpfiles-clean.timer_).  
    La definiciń es algo así:
    ~~~bash
    [Timer]
    OnBootSec=15min
    OnUnitActiveSec=1d
    ~~~
    Si arranca borra a los 15 minutos y si está arrancado, limpia cada día.
    (Internamente hace un `stat fichero`, consulta los mtime, ctime, atime, y si alguno de estos valores superan 1 día, el sistema los purga).
  - siempre podremos hacer un purgado manual con `systemd-tmpfiles --clean`
  
Orden de prioridad de abajo a arriba.

### Configuración de los fichreos.

**man 5 tmpfiles.d**

Sintaxis del fichero:
_tipo path permisos uid gid antigüedad argumento_  
Donde:
  * tipo: d- directoro, L- link simbólico, D- crea el directorio y si ya existe lo vacía
  * path: la ruta
  * modo: los permisos que daríamos con chroot
  * uid y gid que tendrá el fichero
  * antigüedad: al alcanzar dicha antigüedad, se purga, si no tiene valor no se purga.
  * argumento (si es necesario)

***

# Prioridades <a name="priority"></a>

Dado que hay más procesos que cores en los procesadores, para que un sistema multitarea de la sensación de tal, tiene que recurrir a alguna estrategia de reparto de los cores entre los procesos. Linux y otros sistemas operativos resuelven esto con el _time-slicing_. El _process scheduler_ del sistema rápidamente alterna entre procesos en un core dando al usuario la impresión de que hay varios procesos corriendo al mismo tiempo.

## Prioridades relativas

Como no todos los procesos son iguales, tiene que haber alguna manera de decirl al _process scheduler_ que un proceso es más importante que otro, esto se consigue con las prioridades.

**SCHED_OTHER (SCHED_NORMAL)** La política que se aplica a la mayoría de los procesos, pero hay otra políticas. Los procesos con esta política tiene una prioridad relativa, que está asociada al nivel de nice de los procesos, cuanto mayor sea el número nice, menos prioritario es y mas tarda en coger tiempo de CPU.

Hay 40 niveles nice que van de -20 a 19, los negativos sólo los puede gestionar root, y los positivos todos los usuarios.

Todos los shell nacen con nice=0, y el usuario propietario lo único que puede hacer es cambiar su prioridad subiendo el nivel nice (es decir lo único que pueden hacer los usuarios normales es bajar la prioridad).

Dado que procesos que cogen mucha CPU pueden impactar negativamente al rendimiento del sistema, sólo el usuario **root** (más, precisamente, todos los usuarios que tengan la capacidad **CAP_SYS_NICE**) está capacitado para poner valores negativos de nice y bajar el nivel de nice de los procesos.

## Manejo del nice

* Ver los niveles nice:
  - `top`: Nos muestra dos columnas de interes: **NI** con el nivel nice actual y **PR** que muestra en nivel nice en una escala más grande de prioridades en que nice=-20 == pr=0 y nice=19 == pr=39. Los niveles por debajo corresponden a prioridades del sistema.
  - `ps axo pid,comm,nice,cls --sort=-nice` Muestra los procesos ordenados por nice.
    + se pueden ver procesos con nice "-" que indica que no tienen nice, con el campo _cls_ vemos la política de schedule, donde **TS** corresponde con *SCHED_NORMAL*
* `nice -n <nice> <comando> &`: Lanzar un proceso con otro nivel de nice. Recordar que usuarios sin privilegios pueden lanzar sólo procesos con nice entre 0 y 19 y sólo root (y sus amigos) con nice entreo -20 y -1
* `renice -n <nice> <PID>`: Cambiar nivel de nice
  - También podemos usar el **top** para cambiar el nivel de nice (pulstar **r**, el PID y nos pedirá el nuevo nivel de nice)

***

# Control de acceso a ficheros (ACLs) <a name="acls"></a>

Nos permiten granularizar permisos.

En RHEL7, tanto ext4 como xfs admiten ACLs y las tienen configuradas por defecto como activas (en versiones anteriores había que activarlas).

¿Qué permiten? Granularizar permisos

¿Cómo se ve qeu algo tiene ACLs?

`ls -l`, la salida tiene algo así como -rwxr-x-r--+ ..., el + nos indica que tiene ACLs aplicadas.

p.ej.: -rwxrwxrwx+ root root fichero, los permisos de grupo, ya no son los permisos del grupo propietario, sino la máscara de las ACLs.

Para saber en este caso los permisos del grupo, necesito sacar más información con las ACLs.

**getfacl _fichero_** Nos da la información del fichero.
~~~bash
# file: fichero
# owner: root
# group: root
user::rw-
group::r--
other::r--
~~~
Fijarse que tenemos un "::", por lo demás son los permisos normales. Pues bien, lo que hay entre esos dos puntos, son las ACLs.

Nomenclatura:
* Nominal: tiene un nombre puesto entre los dos puntos, y los permisos se aplicarán a eso, puede haber usuarios y grupos.
  - u:<usuario ó uid>:<permisos>
  - m:<grupo ó uid>:<permisos>
* Genérico: se aplican los permisos al usuario y grupo propietarios.
* Máscara: Es un limitador, determina los máximos permisos efectivos que pueden tener usuarios nominales, grupos nominales y grupo propietario, a los que no afecta es al usuario propietario y a others.
  - La máscara se recalcula cada vez que se cambia alguno de los permisos... así que hay que verificarla cada vez que cambiemos alguno de los permisos.
  - **OJO** Buena costumbre, revisar la máscara cada vez que hay un cambio en la ACL por si hay que meterla a capón.
  - La máscara es el OR entre los permisos afectados.
* Esto se puede aplicar a directorios, con lo que va a permitir a usuarios distintos del propieratio y del grupo propietario crear y borrar ficheros.
* Ojo, cambiar los permisos del grupo con chmod, no cambia los permisos del grupo propietario, cambia la máscara.
* Si hay permisos especiales, paraece una cuarta fila al principio de las ACLs, `#flags: sst`

Resolución de permisos de acceso.  
Usuario propietario --> usuarios nominales --> grupo propietario --> grupos nosminales ---> others
### Defaults ACL

Sólo se aplican a los directorios, funcionan con herencia, las ACLs de un directorio pasan a sus hijos.
* Los ficheros hijos heredan las standar definidas de las defaults del padre.
* los directorios hijos heredan las defaults del padre como sus standar y sus defaults.
* Las propagaciones no se llevan el permiso de ejecución **para ficheros**.

La diferencia en nomenclatura es que las defaults llevan delante un _d:_ (o un _default:_)

## Manejo de ACLs

* **getfact** --> Obtiene acls
  - R recursiva, puedes obtener de forma recursiva las acls de una ruta para plancharlas en otro arbol igual.
* **setfact _flags_ _fich_** --> setea acls
  - -m modificar
  - -R recursivo
  - -x borrar (hay que especificar lo que hay queborar).
  - -k Borrar defaults
  - -b borrar todas
  - -d establece acls defautl (mejor hacerlo con los parámetros)
  
### Ejemplos

* Plancha acl de un fichero a otro: `getfactl file1 |setfactl --set-file=- file2`
* Lo mismo recursivo: `getfactl -R file1 > fichero_acls && setfacl --set-file=fichero_acl`
* Modificar usuario propietario: `setfacl -m u::rX file`: aplica permisos x de forma recursiva a directoros pero no a ficheros. **OJO:** en cuanto sea ejecutable para alguien, le aplicará la X al fichero.
* Modficar propietarios (idem para grupos, other y mascaras): `setfacl -m u::rws fich/dir`
* Modificar nominales: (idem para grupos): `u:1005:rwx file/dir`
* Modificar defaults: (simplemente poner delante d:): `d:u:1005:rx file/idr`
  - Al meter una de las defaults, me mete las de todo el mundo.
  
***

# Manejo de SELinux <a name="selinux"></a>

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
* TYPE (\_t) En este contexto se basa la política basada en etiquetas (que es la políica por defecto)
* SENSITIVITY (\_s)

**Políticas**: Acciones que va a tomar SELinux respecto a las etiquetas. Por defecto la política no permite ninguna interacción a no ser que una regla explicita permita el acceso. Si no hay regla, no hay acceso.
* targeted: Es la política por defecto. Se pueden ver en `/etc/selinux/config`
* minimun
* mls

**Modos** de SELinux:
* enforcing: Obliga que se cumplan las reglas.
* permisive: Avisa cuando no se cumplen las reglas, pero deja.
* disabled: deja pasar todo.

Cuando se pone a disabled, se necesita un reinicio y se borran todas las etiquetas. Lo malo, es que si luego se quiere meter de nuevo en enforcing, hay que reiniciar y tiene que reetiquetarse el sistema -y esto tarda un huevo.

### Comandos últiles.

* Para ver las políticas de algo: `semanage fcontext -l | grep <lo_que_sea>`
* Para ver los booleanos: `semanage boolean -l` ó `getsebool -a`
* Para ver prolíticas en procesos `ps -axZ` (p.ej: `ps -ZC httpd` nos muestra las etiquetas de Apache).
* Para ver lo que hay aplicado de SELinux sobre un archivo/directorio: `ls -lZ <fichero>`

## Modos de SELinux

Con fines de troubleshooting, se puede desactivar temporalmente SELinux usando los modos de SELinux
* Obtener el modo de funcionamiento de SELinux: `getenforce`
* Cambiar el modo de funionamiento: `setenforce n` donde:
  - 0 --> _Permissive_: Escribe en el log, pero no deniega accesos.
  - 1 --> _Enforcing_: Escribe en el log y niega accesos
  - Los cambios de funcionamiento con setenforce son temporales (en runtime). Para hacerlos permanentes, hay que editar el fichero `/etc/selinux/config` y reiniciar.

En un arranque, podemos cambiar el modo de selinux en el modo de kernel con el parámetro extra en las líneas de kernel.
  - enforcing=1 (enforce)
  - enforcing=0 (permisibe)
  - selinux=0 (disabled)

## Contextos SELinux

SELinux es un conjunto de reglas de seguridad que determina qué proceso puede acceder a qué ficheros, directorios y puertos. Cada fichero, proces, directory y puerto tiene una etiqueta de seguridad especial llamada **contexto SELinux**.

Un **contexto** es un nombre que es usado por la politica de SELinux para determinar que proceso puede acceder a qué fichero, directorio o puerto. 

Los contextos se ven con `ls -Z`.

Cuando creamos un fichero/directorio, hereda el contexto del padre. Cuando copiamos manteniendo todo (`cp -a <fichero>`) o movemos, nos llevamos el contexto, así que hay que ser muy consciente de ello, y habrá que hacer una restauración de contexto:

* `chcon -t <tipo_conexto> fichero`: cambia el contexto de un fichero de forma permanente.
* `restorecon -FvvR <fich/dir>`: Restaura el contexto del fichero según las reglas de SELinux, es decir, va consultando el `semanage fcontext -l` para ir restaurando los permisos.

Si añadimos nuevas rutas y luego nos lo queremos llevar a otros sistemas, tendremos que llevarnos las rutas nueva customizadas.

### Añadir reglas.

`semanage fcontext` consulta o modifica las reglas que `restorecon` usa restaura. Suele ser habitual no tener instalado semanage, con lo que hay que instalarlo.
* semanage: policycoreutils-Pythondminsitrar Logical Volume Management
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
2. Contexto erróneo (revisar que fichero está dando el problema y restaurarlo si es necesario).
3. Somos demasiado restrictivos con el acceso (solución manipulando los booleanos).
4. Hay un bug en SELinux (poco probable) --> reportar a soporte.

Paquete necesario: **setroubleshoot-server** (rpm). Lee mensajes de `/var/log/audit/audit.log` y los pasa resumidos a `/var/log/messages`. Si _auditd_ no está corriendo habrá que habilitarlo y arrancarlo.

Una vez hecho esto, con el comando `sealert -l <UUID>` podremos explorarlo ó `sealert -a /var/log/audit/audit.log` lo cual es mucho más extenso.

****OJO DE CARA AL EXAMEN**** 
No siempre la solución que nos da el sealert es la válida para el exámen, normalmente lo que que buscan es que apliquemos contextos a rutas, así que mejor investigar un poco mas.
dminsitrar Logical Volume Management
***

# Conexión de usuarios con LDAP e IPA<a name="redes"></a>

## Usar LDAP y Kerberos

Para configurar RHEL7 para que use servicios de administración centralizada de identidad se necesitan varios demonios y ficheros:
* `/etc/openldap/ldap.conf`: Información acerca del servidor LDAP.
* `/etc/krb5.conf`: Información sobre la infraestructura de Kerberos
* `/etc/sssd/sssd.conf`: Configuración del _System Security Services Daemon_ que es responshttps://start.fedoraproject.org/able de recabar y cachear la información de usuario y de autenticación.  
  El demonio sssd tiene que estar habilitado y corriendo antes de que el sistema pueda usar cualquier servicio de los otros.
* `/etc/nsswitch.conf`: Indica al sistema qué servicios de información y autenticación usar.
* `/etc/pam.d/*`: Configura cómo los servicios tienen que usar la autenticación.
* `/etc/openlap/cacerts`: Almacen de las CAs (_Certificate Authorities_) contra las que se tienen que validar los certificados SSL que identifican los servidores LDAP.

Dado que es facil equivocarse, hay una utilidad **authconfig** que engloba tres herramientas para hacer la configuración:
* **authconfig**: Se instala con el paquete _authconfig_. Herramienta por línea de comandos con comandos largos y complicados.
* **authconfig-tui**: Versión interactiva de la anterior, guiada por menús, se puede usar vía ssh.
* **authconfig-gtk**: Versión con interfáz gráfica.

### Parámetros mínimos de LDAP

* Host name de los servidores LDAP.
* Base DN (_distinguished name_) de la parte del arbos de LDAP en el que el sistema tiene que buscar a los usuarios. Esta información nos la tiene que proporcionar el administrador de LDAP.
* Si se usa SSL/TLS para encriptar las comunicaciones, nos tienen que proporcionar el certificado raíz.

### Parámetros mínimos de Kerberos

Si el sistema usa un systema centralizado Kerberos para autenticación:
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

Se puede usar **authconfig** para configurar todo, pero hay una herramdminsitrar Logical Volume Managementienta especializada: **ipa-client-install**, provisto por el paquete **ipa-client**.

Cuando se lanza, busca a través del DNS provisto por el sistema un servidor IPA del que obtener la configuración, en caso de no encontrarlo, preguntará la configuración (nombre de dominio y un realm). También necesitará un nombre de usuario y la contraseña.

## Unirse a un Active Directory
https://start.fedoraproject.org/
Se pueden hacer de dos formas:
* Instalar _samba-winbind_ y configurar **windbind** a través de **authcofig**
* Instalar los paquetes **sssd** y **realm** y usarlos para unierse al AD.

### Ejemplo.

~~~bash
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
~~~

Por defecto los usuarios deberá unsar FQN (ipauser@ipa.example.com) para usuarios IPA, o DOMAIN\user para usuarios del AD., para deshabilitarlo, cambiar **use_fully_qualified_names** en `/etc/sssd/sssd.conf` a _False_ o borrar la línea, luego reiniciar el servicio.

***

# Añadir discos, particiones y sistemas de ficheros <a name="discos"></a>

El particionado permite dividir el disco duro en múltiples áreas lógicas de almacenamiento llamadas particiones. Separando los discos en particiones, los administradores pueden usar las diferentes particiones para diferentes funciones.

Tener siempre presente los difrentes [múltiplos del byte](https://physics.nist.gov/cuu/Units/binary.html).

## Particionado del disco

### MBR

_Master Boot Record_ indican cómo se particiona el disco en sistema que corren firmware BIOS.
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
* Usa CRC checksum (_Cyclic Redundacy Check_) para detectar errores y corruncione en la cabecera GPT y la tabla de particiones.

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

Una vez que tengamos hechas las particiones, todavía no las podemos usar en el sistema, primero hay que darlas el formato adecuado y después montarlas.

La aplicación **mkfs** es la encargada de dar formato a la partición. Si no se especifica otra cosa, el tipo de file system por defecto es _ext2_, RH admite muchos formatos, los mas usados son _xfs_ que es el tipo por defecto que aplica anaconda durante la instalación y _ext4_.

~~~bash
root@system# mkfs -t {ext4|xfs|...} /dev/<particion>
~~~

## Montar el FileSystem

Una vez formateado, para que se pueda usar, la partición tiene que montarse en algún sitio, para esto se tiene que crear un directorio vacio donde se montará llamado **punto de montaje**

Para ver lo que hay montado en el sistema: `mount -a`

### Montaje manual

Simplemente se dice que se monte y donde.

~~~bash
root@system# mount /dev/<particion> <punto_montaje>
~~~

Esta es la mejor forma de ver si el particionado que se ha hecho funciona, pero hay que tener en cuenta que una vez reiniciado el sistema, el montaje se pierde.

### Montaje automático

Para que no se pierdan los montajes, hay que hacerlos automáticos. Para ello, habrá que añadir una líena en el fichero `/etc/fstab` con un formato determinado, valores separados por espacios. Cada campo tiene un significado.

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
~~~text
UUID=<uuid> swap swap defaults 0 0
~~~

***

# Administrar Logical Volume Management (LVM) <a name="lvm"></a>

## Conceptos

* **Physical Device (PD)**: Tanto un disco como una partición.
* **Physical Volume (PV)**: Agrupación de PD
* **Physical Extension (PE)**: BLoque de almacenamiento más pequeño asociado a un PV. (partición física)
* **Volume Group (VG)**: Agrupación de PE. Al crear el VG, decidimos el tamaño de las PE.
* **Logical Volume (LV)**: Particiones lógicas de un VG. (para estas es transparente el VG).
* **Logical Extension (LE)**: Cada LE se corresponde (no mirror, con una PE), (en mirror, con 2 PE). Las LE, serán múltiplos de PE.

## Manejo

### Creación

Al crear la partición física (PD), RH recomienda usar particiones tipo MBR (0x8e)
1. Crear la partición física: `fdisk /dev/vdb` (ó `gdisk /dev/vdb`)
2. Crear volumenes físico: `pvcreate /dev/vdb1 /dev/vdb2`
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
4. Comprobamos que la operación haaya sido correcta

### Reducir VG

1. Si tiene datos hay que liberar la PV: `pvmove /dev/dvx`
2. Reducirmos el VG: `vgreduce vgdatos /dev/vdx`
3. Comporobamos que la operación ha sido correcta.

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

* Cramos un sanpshot de lvdata, del tamaño iniical de 1 G.  
  `lvcreate -s -L 1G -n lvdata_snap /dev/vgdata/lvdata`
* Restaurar snapshot:   
  `lvconvert --merge <snapshot>`

***

# Network Storage NFS <a name="nfs"></a>

NFS (_Network File System_): Protocolo estandar usado por sistemas tipo -nix como el protocolo nativo de FS en red.

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
* **none**: Acceso anónimo en a los archivos de NFS (usando el usuario _nfsnobody_)
* **sys**: Acceso con los estándares de Linux usuario:grupo
* **krb5**: Los clientes tienen que autenticarse con Kerberos y luego los permisos estándar de Linux.
* **krb5i**: Agrega criptografía a los datos de ida y vuelta para asegurar que los datos no han sido alterados.
* **krb5p**: Añade cifrado en todas las peticiones entre cliente y servidor (esto tiene un impacto en el rendimiento).

Necesitaremos:
* Un fichero `/etc/krb5.keytab` que nos proveerá nuestro administrador de seguridad. La mayoría de los problemas viene de descargar este fichero (tiene que ser binario y tener los contextos de SELinux).
* Un servicio **nfs-secure** proporcionado por el paqeute _nfs-utils_ y lo tenemos que tener started y enabled. Esto también puede ser una posible fuente de errores.

## Montajes

### Montaje estándar

1. Identificar las exportaciones del servidor NFS:
  * En nfsv2 y nfsv3 está el comando `showmount -e <NFSserver>`
  * En nfsv4 (comor root)
    - mkdir /pto/montaje
    - mount server:/ /pto/montaje
    - cd /pto/montaje
    - ls --> muestra las exportaciones.
2. Creamos un punto de montaje dfinitivo: mkdir /destino
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

~~~text
/shares  /etc/auto.indirecto  # montajes indirectos
/-       /etc/auto.directo    # montajes directos
/compart /etc/auto.comodines  # montajes con comodines
~~~

Supongamos que tenemos un montaje `/shares/work` y un `/shares/prueba`

~~~text
cat /etc/auto.indirecto
work    -rw,sync  serverX:/export/work
prueba  -rw,sync  serverY:/nfsexport/test
~~~
 
##### Montajes directos

Pongo un anclaje sobre el que pivoto.

~~~text
cat /etc/auto.directo
/mnt/novedad  -rw   serverX:/directo/novedades
/mnt/pruebas  -rw   serverY:/directo/novedades
~~~

##### Montajes con comodines

~~~ text
cat /etc/auto.comodines
* -rw,sync  serverX:/compartido/&
~~~

Si hago un cd a un directorio que coincida con /compartido/PEPE, como tengo en el _autofs_ una entrada que comienza con "/compartido", si se exporta algo en serverX:/compartido/PEPE, me lo montará en /compartido/PEPE.

Caso típico de uso, en el autofs tenemos definido:  
`/home/guests  /etc/auto.comodines`  
y en /etc/auto.comodines:  
`* -rw,sync  serverX:/home/&`

Así cuando hagamos `cd /home/guests/ldapuserX`, nos montará directamente `serverX:/home/ldapuserX`

***

# Network Storage SMB <a name="smb"></a>

**SMB**: Server Message Block.
**CIFS**: Common Internet File System, es un dialecto de SMB.

En NFS todos los montajes se pueden hacer con un usuario, si este tenía los permisos adecuados. Ahora vamos a ver que aquí no es así. Sin embargo, para montar un **SMB share** o **recurso SMB** necesitamos acceder como un usuario que  tenga permisos para montar ese sistema (usuario, passwd, dominio).

Paquetes: cifs-utils, samba-client (este no es obligatorio, pero sí recomendable).

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

El usuario/password son independiente de lo que tenga el sistema, de hecho, los usuarios asociados a SAMBA se les da el shell **/bin/nologin**

`mount -t cifs -o username:<usuario> //server/recurso /pto/montaje`, nos pedirá el passwd.

Podemos tenerlo en un fichero de credenciales de root, con permisos 600, normalmente en `/secure/sherlock` con el siguiene formato:
~~~text
username="nombre"
password="pass"
domain="dominio"
~~~

En este caso, invocaremos: `mount -t cifs -o credentials=/secure/sherlock //server/recurso /pto/montaje`

## Automontaje

Samba también se automonta. El procedimiento es prácticamente igual.

Fichero maestro de asignación y luego su fichero de mapeo (auto.*).
~~~text
cat /etc/auto.master.d/*.autofs
/bakerst  /etc/auto.baker

cat /etc/auto.baker
cases -fstype=cifs,credential=/server/sherlock  ://server/recurso
~~~

Esto requiere dos cosas:
* autofs
* cifs-utils


***

# Firewall: limitar comunicaciones de red <a name="firewalld"></a>

***

# Troubleshooting <a name="troubleshooting"></a>

***

# Apéndice: Comandos útiles <a name="apendix"></<>
  
* __tr__: sustituye un carácter por otro 
* __cut__: Extrae campos
  - -d 'char' = delimitador
  - f n = campo
* __awk__: Que contarte
* __sort__: Ordenar
* __sed__: Operaciones con cadenas
* __uniq__: Elimina registros duplicados (se suele aplicar después de un sort)
* __wget__: trae recurso de internet:`wget -O <fich_salida> http://<ruta_fichero_a_descargar>`
