# Tabla de contenidos
[Introducción al curso](#introduccion)
1. [Acceso a la línea de comandos](#consola)
2. [Manejo de archivos con la línea de comandos](#manage_files)
3. [Obtener ayuda](#help)
4. [Ficheros de texto](#txt_files)
5. [Usuarios y grupos](#user_group_mngmt)
6. [Permisos](#perms)
7. [Monitorización y administración de procesos](#proc)
8. [Control de servicios y demonios](#systemctl)
9. [Configurando y asegurando el servicio SSH](#openssh)
10. [Manejo de logs](#logs)
11. [Networking](#network)
12. [Archivado y copia entre sistemas](#empaquetado)
13. [Manejo de paquetes de software](#packages)
14. [Sistemas de archivos](#filesystem)
15. [Virtualización](#virtualization)
   
# Introducción al curso <a name="introduccion"></a>

## Máquinas

* Máquina: **foundation12** (172.25.254.12 - 172.25.12.1), user: kiosk / lamia
* Máquinas virtuales:
  * **desktop12** (172.15.12.10): student/student - root/redhat
  * **server12** (172.15.12.11): student/student - root/redhat
* Máquina del profe: **classroom** (172.25.0.254)

### Controlar las máquinas virtuales

Programa `rht-vmctrl`, opciones:
* reset -- restaura la máquina hasta el último snapshot guardado
* view -- abre la consola
* start -- arranca la VM
* save -- hace el snapshot
* fullreset -- vuelve la VM al origen de los tiempos.

### Máquinas casa

Hemos creado 3 máquinas Centos con vagrant en amadablam, con el usuario _student_ (Pass:student) y el _root_ (Pass:vagrant)
* server: 10.0.100.101
* desktop1: 10.0.100.102
* desktop2: 10.0.100.103

Tenemos un snapshot inicial de cada una de ellas en las que ya está creado el suario _student_

## Internacionalización

Control de la configruación de gnome: `gnome-control-center`. Entre otras tiene las siguientes opciones.
* _region_: Establece las opciones de región y lenguaje (incluidos formatos).
* _datetime_: Establece opciones de fecha y hora.

### Opciones de lenguaje

La configuración del lenguaje de cada usuario en gnome se guarda en: `/var/lib/AccountService/users/${USER}`
Para establecer un lenguaje para un comando:
* `$ LANG=<codigo> <comando>`, con de código es uno de los admitidos 
* `localectl list-locales`, muestra todos los códigos

Si accedemos a la máquina por ssh: `loadkeys es` (se pierde cada vez que se reinicie la máquina).
* Podemos tocar a mano el fichero `/etc/vconsoles.conf`

La manera más cómoda es cambiarlo en el entorno gráfico.

***

# Acceso a la línea de comandos <a name="consola"></a>

## Entorno gráfico

El entorno gráfico por defecto en RHEL7 es Gnome3, que corre sobre XWindow. Tiene dos modos: _classic_ y _modern_.

Cuando se entra por primera vez, se hace un setup inicial al ejecutarse `/usr/libexec/gnome-initial-setup`, (en cualquier momento podemos volver a lanzarlo para reconfigurar el entorno), después arranca el _Gnome Help_, al que siempre se puede ir pulsando **F1** o, desde un terminal ejecutando `yelp`, o desde el menú: **Application --> Documentation --> Help**.

Incluso en el entorno gráfico tenemos consolas, para acceder a ellas hay que pulsar las combinaciones de teclas **Ctrl+Alt+[F2-F6]**, para volver al entorno gráfico: **Ctrl+Alt+F1**.

## Terminales y consolas

Aquí hay que poner los atajos de teclado etc...

# Manejo de archivos con la línea de comandos <a name="manage_files"></a>

## Jerarquía de directorios

Los directorios en RHEL (como en todos los sabores Linux) se organizan en forma de árbol invertido en el que arriba está el directorio root (**/**).

En una jerarquía LVM se encapsulan los directorios, como mínimo:
* raíz (**/**)
* arranque (**/boot**), será una partición separada con las imágenes estáticas de arranque.

## Conceptos

* **Persistencia**: Se refiere a la resistencia a "sobrevivir" a los reinicios, los ficheros persistentes guardan cambios que se conservan entre reinicios.  
   **IMPORTANTE:** En el exámen todo tiene que quedar persistente, ya que hay varios reinicios.

* **Runtime**: Cambios que se conservan mientras está encendida la máquina.

## Manejo de ficheros

* `touch`: Crea un fichero, si no existe, y le cambia el _timestamp_ si existe.
* `stat`: Da información relevante sobre el fichero

## File Globbing

Para negar expresiones complejas de _file globbing_, meter un signo de tilde **^** entre los corchetes de apertura, por ejemplo: Ningun caracter alfabético: **[^[:alpha:]]**

Ver anexos entregados en clase.

## Sustitución de comandos

Tenemos dos formas de invocar un comando en línea de comandos:
- `$(comando)`
- `\`comando\``

Las dos son equivalentes, pero la primera opción permite anidamiento, por ejemplo:

~~~bash
VARIABLE=$(echo $PATH)
~~~

### Protección de argumentos

Si en una cadena tenemos que pasar una expresión, hay que usar comillas dobles, ya que las comillas simples hacen que todo lo que va dentro de unas comillas simples se considera un literal, mientras que las dobles comillas **"** permten sustitución de comandos y variables, pero suprimen en _file globbing_.

***

# Obtener ayuda <a name="help"></a>

El comando `man` está organizado en diferentes secciones de la 1 a la 8, las que mas nos interesan son:

* 1 - Comandos de usuario
* 5 - Formato de ficheros
* 8 - Comandos de administración y privilegiados

`mandb` Es un comando para actualizar la base de datos de ayuda, es útil correrlo cuando se instala algún nuevo paquete.

## Comandos útiles

- `man -k <palabla>` Muestra todas las entradas de **man** en las que aparece esa palabra en el sumario. Es equivalente al comando `apropos <palabra>`.
- `man -K <palabra>` Como la anterior pero la búsqueda se extiende a todo el  artículo no solo al sumario.
- `man -t <termino_de_ayuda>` Prepara la página de man para imprimir en formato PostScript.
- `info` y `pinfo` Como **man** pero estructurado en nodos e hipervínculos, casi toda la ayuda del proyecto GNU está en este formato.
- `/usr/share/doc` Documentación de paquetes, hay algunos que se tienen que instalar explicitamente con un `yum install -y <paquete>-doc-xxx`, para verlo lo más sencillo es usar un navegador (por ejemplo: `firefox file:///usr/share/doc/yum`).

***

# Ficheros de texto <a name="txt_files"></a>

Vamos a ver cómo trabajar con entradas y salidas, redirecciones, etc...

Un proceso en ejecución tiene 4 flujos:
* entrada estándar (stdin) (canal 0)
* salida estándar (stdout) (canal 1)
* salida de error (stdout) (canal 2)
* salida a otros ficheros (canales, 3, 4, ...)

## Redirecciones

Operadores de redirección:
* **>** Escribe en un fichero, si existe, lo sobreescribe y si no existe lo crea
* **>>** Append, si existe, añade al fichero y si no lo crea.
* **<** 

Dispositivos especiales del sistema:
* `/dev/null`--> es un sumidero, todo lo que dirijamos a él se pierde.
* `/dev/zero`--> Si queremos meter ceros como entrada.

### Redirecciones de salida

Ojo, los operadores de fusión más modernos ( &>file &>>file) puede que no funcionen en shells antigüas.

### Entrada desde un fichero

Podemos redirigir la salida como entrada a otro programa (por ejemplo en un bucle for):
~~~ bash
while read line
do
  echo "$line"
done < "${1:-/dev/stdin}
~~~

## Tuberías

Otra forma de hacer que la salida de un fichero sea la entrada de otro comando es con un pipe **|**.

Para encadenar comandos, ya sabemos que hay que separar comandos por un **;**, para encadenar salidas de un proceso como entrada del siguiente, se usan las tuberías (enlazas las stdout).

### Comando _tee_

Comando **tee** copia su stdin a stdout y al fichero que le digamos.

Ejemplos:
* `ls -l | tee /tmp/saved-output | less` --> la salida de tee va a pantalla y a un fichero
* `ls -l | tee /dev/pts/0| mail student@desktop1.example.com` --> El tee envía su salida al terminal y, a la vez al programa de correo electrónico (para ver el teminal, podemos usar el comando `tty` para ver el dispositivo de salida).

***

# Usuarios y grupos <a name="user_group_mngmt"></a>

Cada proceso y fichero tiene un usuario propietario.
**
Para ver la cuenta de usuario: comando **id**, para ver los usuarios conectados **w -u**

Los usuarios se identifican en el sistema por su UID.

La configuración del usuario está en el fichero `/etc/passwd`, que contiene solo los usuarios locales. tiene 7 campos:
1. username
2. password (en desuso en ese fichero, la passwd está encriptada  en el fichero `/etc/shadow`, aquí tambien hay información de caducidades de contraseñas, etc...)
3. UID (el de root es 0)
4. GID, grupos del usuario, 1 principal y el resto secundarios.
   Cuando creamos el usuario se crea un grupo principal con el mismo nombre que el usuario
5. GECOS: String que usamos para identificar el usuario y poner comentarios
7. $HOME: directorio raíz del usuario
8. shell del usuario (podemos tener o `/sbin/nologin` -para evitar que el usuario haga login, por ejemplo, si va a usar servicios del sistema pero no necesita acceso a la shell de sistema ni manipular ficheros del sistema; o `/bin/false`, si no queremos que use nada de nuestro sistema).

Configuración de grupos, `/etc/group`:
1. nombre
2. Contraseña del grupo (normalmente no se pone).
3. GID
4. miembros del grupo

## Relación de usuarios y grupos.

Un usuario puede tener **exactamente** un grupo principal, que es el GID que viene en el `/etc/passwd` y se corresponderá con una entrada del `/etc/group`. De hecho a este grupo se le llama _grupo privado_.

Cuando creamos un fichero se le asigma un usuario y grupo acorde con los del usuario que los ha creado.

Si se quieren añadir nuevas capacidades a un usuario, mejor añadir grupos suplementarios -mejor no cambiar el grupo principal.

## Conseguir acceso de superusuario

El señor **root**, tiene todos los poderes sobre el sistema, sólo el puede administrar los dispositivos físicos del sistema.

Dado que tiene todos los privilegios, tiene una capacidad ilimitada de romper el sistema, es una cuenta que hay que tener **MUY** protegida.

**RECOMENDACIÓN:** Acceder como usuario normal y escalar privilegios. Ojo, los privilegios en consola no son lo mismo que los de GNOME.

¿Cómo escalamos privilegios?
* `su [-] <username>`:
   * el **-** indica que tomamos las variables de entorno del usuario al que escalamos.
   * si no ponemos usuario, escalamos a root.
   * Nos pedirá el passwd del usuario destino.
   * Problema... hay que conocer el passwd de root.
 * `sudo <username>`
   * Nos permite ejecutar lo que tengamos permitido en la configuración de sudo como usuario al que hemos escalado privilegios.
   * Nos pide el passwd del usuario que quiere escalar privilegios, con lo que no distribuimos la contraseña de root.
   * Con la opción **-i** nos permite abrir una shell con los privilegios del usuario con mayores privilegios que nos permitan nuestros permisos de su.
   * En RHEL7: Si tenemos un usuario que pertenece al grupo **wheel** también tendrá privilegios en el fichero `sudoers`  
      Si hacemos un `visudo`, vemos la entrada por el grupo:
      ~~~bash
      %wheel  ALL=(ALL) ALL
      ~~~
      Características:
      * Que indica que usuarios del grupo wheel puede hacer sudo desde todas las terminales a todos los usuarios del sistema y ejecutar cualquier comando.
      * en el último ALL, podemos sustituir por:
         - `NOPASSWD:NOEXEC:<comando>`, que significa que no nos pide el passwd para hacer sudo, pero no nos dejaría ejecutar con privilegios. 
         - En vi, si ejecutamos sudo vi, podremos ejecutar comandos como root ejecutando lo siguiente: `:r! <comando>`
   * Deja logs en `/var/log/secure` de todas las acciones hechas por los usuarios.
   * Los ficheros de configuración están en `/etc/sudoers.d/*`
   * El fichero principal es el `/etc/sudoers` (para editarlo hay que usar **visudo** que hace chequeos de formato y si la cagamos no nos deja guardar.
   * No podremos usar sudo si nuestro usuario o el grupo no está metido en el fichero sudoers
   * Los ficheros de configuración que hay colgando de `/etc/sudoers.d/*` tienen preferencia sobre el `/etc/sudoers` (en general, las que estén en `/etc/<srv>.d/*`, tienen preferencia sobre lo que viene en `/usr/lib`).
   * `sudo -l` nos lista los permisos que tiene el usuario
   
**_IMPORTANTE_**: si hacemos `sudo <comando> > fichero` y el usuario no tiene permisos para escribir el fichero, no podrá hacerlo, ya que por una parte se ejecuta el comando como el usuario destino, y luego se escribe el fichero como usuario origen.

Esto, no impide que cuando vayamos a trabajar con entornos gráficos, lo que nos restringe los permisos es el _Policy Kit_ de GNOME.

## Administración de usuarios

Crear usuarios `useradd <usuario>`, nos añadirá una línea en `/etc/passwd`. Una vez añadido el usuario, tendremos que configurarlo, ya que nos lo crea sin contraseña. 

Es mejor política poner la contraseña después con el comando `passwd` porque si lo hacemos con `useradd -p <passwd> <user>` mete la contraseña que hayamos metido en el fichero `/etc/shadow` en texto plano sin cifrar.

Fichero inportante: `/etc/login.defs`
* Reglas y vigencias de las contraseñas.
* rangos definidos en el sistema
* UIDs y GIDs por defecto
* si modificamos algo en este fichero, a los usuarios que ya existen en el sistema no los afecta, así que cuidadín con los conflictos.

Todos los comandos generados de forma automática con el **useradd** se pueden modificar con **usermod**, la mayoría de los flags definidos en **useradd** se pueden usar en **useradd**.

**TRUCO** Antes de modificar un usuario, hacer un **id** para tener un _backup_ del usuario por si la cagamos.

Borrar usuarios con **userdel** (con la opción -r borra el $HOME del usuario).

**OJO:** Si creamos un usuario, lo borramos sin (-r) y volvemos a crear otro, este nuevo usuario coge el primer UID libre que será el que acabamos de dejar libre, con lo que este nuevo usuario puede coger permisos sobre ficheros no deseados, así que la mejor política es no borrar usuarios, sino bloquealos con `usermod -L <usuario>`

Para prevenir esto, como root, ejecutar: `find / -nouser -o -nogroup 2>/dev/null` que nos devolverá todos los ficheros "huerfanos".

### Rangos de UIDs

* 0 --> root
* 1 - 200 --> de sistema usados por procesos
* 201-999 --> de sistema usados por procesos, sin acceso al sistema de ficheros
* > 1000 - Usuarios nominales

Todos estos rangos se pueden manipular en el `/etc/login.defs`

### Administración de grupos locales

**Añadir un grupo:** `groupadd [-g <GID>] <nombre_gr>`, si no le ponemos GID, nos da el siguiente GID de los grupos que no son del sistema.
**Renombrar un grupo:** `groupmod -n <nombre_nuevo> <nombre_antigüo>`  
**Cambiar el GID:** `groupmod -g <nuevo_GID> <nombre_gr>`, a partir de ahí todos los grupos que creemos se irán numerando a partir de este (aunque no especifiquemos), pero los grupos de usuarios seguirán creándose con los 1000..., esto se hace para que no colisionen los grupos de trabajo con los grupos de usuarios.  
**Borrar grupo:** `groupdel <grupo>`, lo que vale para el borrado de usuarios, vale para los grupos. Más ojo todavía porque puede haber varios usuarios 
**Cambiar el grupo principal a un usuario:** `usermod -g <grupo> <username>`  
**Añadir grupos secundarios:** `usermod -aG <lista_secundarios> <username>`, si no ponemos el -a, sustituiremos los grupos secundarios que tenga por los nuevos.  

### Contraseñas

`/etc/shadow` guarda las contraseñas cifradas y las características de vigencia y caducidad de la contraseña con el siguiente formato:  
`name:password:lastchange:minage:maxage:warning:inactive:expire:blank`, donde:
* **name**: nombre del usuario
* **password**: contraseña cifrada
* **lastchange**: fecha del último cambio (epoch)
* **minage**: Mínimo número de dias antes de poder cambiar la contraseña
* **maxage**: Máximo número de días de vigencia de una contraseña
* **warning**: dias de advertencia para cambiar la contraseña antes de que expire
* **inactive**: numero de días que la cuenta permance activa después de la expiración de la contraseña antes de que expire.
* **blank**: sin uso

#### Contraseña cifrada.

El hash de la contraseña almacena 3 datos separados por '$':_$N$semilla$passwdCifrada_ donde:
**$N$** -- Algoritmo de cifrado 1-6 (6 por defecto)  
**$semilla$** -- Semilla aleatoria para el cifrado  
**$cif_passwd$** -- Contraseña + uid cifrado

Cuando te logas e introduces el passwd, coge esa contraseña introducida y aplica el método de hash usado con la semilla y la compara con la almacenada, si coincide p'alante, y si no, caput.

Para cambiar el método de cifrado:
~~~bash
authconfig --passalgo=<Algoritmo_cifrado> --update
~~~

#### Vigencia de las contraseñas.

Se cambian con `chage -m m -M M -W w -I i username` donde:
* -m --> min days
* -M --> max days
* -W --> warn days
* -I --> inactive days
* -d --> días para cambiar la contraseña

Si queremos forzar al cambio de contraseña en el siguiente login: `chage -d 0 <username>`  

Si queremos forzar que una contraseña caduque un día concreto: `chage -E YYYY-MM-DD <username>`  
En casos típicos, tipo, "que la contraseña caduque de aquí a x días" se puede ver la fecha en que cae con
`date -d "+x days"`

Si queremos ver las configuraciones actuales de un usuario: `chage -l <username>`

Se puede cambiar los valores por defecto modificando el fichero `/etc/login.defs`

### Restricción de acceso

Podemos bloquear una cuenta con `usermod -L <usermod>` o con `usermod -L -e N <usermod>`, esta segunda opción dice que la cuenta se bloquee a los N días del 1-1-1970...

Importante, podemos tener un usuario sin bloquear pero que no puede acceder porque su constraseña ha caducado.

Podemos impedir que un usuario acceda a la shell cambiando su shell a `/sbin/nologin` o `/bin/false` (esta para que no pueda hacer nada de nada.
~~~ bash
usermod -s /sbin/nologin <username>
~~~

***

# Permisos <a name="perms"></a>

Si hacemos un ls -l, vemos las siguientes características:
~~~bash
kiosk@foundation12 ~]$ ls -l /etc/yum.conf
-rw-r--r--. 1 root root 813 Nov 26  2017 /etc/yum.conf
~~~

Vienen en 3 grupos USER - GROUP - OTHER y se aplican de izda a dcha, e.d. se aplican los permisos del primer grupo que cumpla.

En ficheros:  
r --> leer archivos  
w --> modificar archivos  
x --> ejecutar archivos

En directorios:  
r --> listar el contendio del directorio  
w --> borrar o añadir ficheros  
x --> puedo atravesar el directorio

**OJO** al crear estructuras de directorios, a ver si podemos atravesarlos y no se heredan los permisos como en el caso de Windows.

Si quiero ver los permisos de un directorio: `ls -ld <directorio>`

## Cambiar permisos

Se trabaja por grupos: `- rwx rwx rwx   student  student  <fichero>`, el propietario puede cambiar los permisos de todo.

**Notación simbólica:** `chmod who what which <file/dir>`
   * _who_: u, g, o, a (usuario, grupo, othos, todos).
   * _what_: =, +, - (poner explícitamente permisos, añadir, quitar)
   * _which_: r, w, x, X (lectura, escritura, ejecución, X se aplica x de forma recursiva a todos aquellos directorios que hay por el camino y a todos los ficheros en que alguien tiene permisos de ejecución).
      * la X se suele aplicar en directorios, se tiene que aplicar siempre con la opción **-R** de **chmod**.
**Notación octal:** `chmod sUGO <fichero>`

## Cambiar propietarios

Permite cambiar el propietario y el grupo, `chwon owner:group <file/dir>`, admite recursivo (**-R**).

Podemos cambiar el propietario (`chmod <user> <file/dir>`), el grupo (`chmod :<group> <file/dir>` / `chgrp <group> <file/dir>`) o los dos.

El propietario sólo lo puede cambiar root, el grupo lo puede cambiar el usuario.

## Permisos especiales

Se puede meter otro octeto de permisos, en la x, si la hay, s, si no la hay una S y en others... t si la hay y T si no la hay. Es decir, se enmascara la x (permiso de ejecución).
* Usuario y grupo: rwx --> rws, rw- --> rwS: Algo hay activo, si salen los standar, está inactivo.
* Otros: rwx --> rwt, rw- --> rwT: Algo hay activo, si salen los standar, está inactivo.

¿Qué es lo que se activa?
* Usuario: **setuid**
   * Carece de sentido en los directorios.
   * El proceso se ejecuta como el usuario propietario no como el que lo lanza.
   * ejemplo: passwd --> se ejecuta como usuario root.
* Grupo: **setgid**
   * Fichero: El archivo se ejecuta como el grupo propietario
   * Directorio: _Directorios colaborativos_, todos los ficheros y directorios que se creen dentro tienen como propietario el grupo propietario, no el del usuario que lo creó. Lo lógico en los directorios colaborativos es que sea root el propietario del directorio. Porque si es de otro usuario, ese usuario, al ser dueño del directorio, podría borrar cualquier fichero.
   * Los permisos que se les suele dar a los directorios colaborativos son 2770
* sticky-bit:
   * No tiene sentido en ficheros.
   * No permite al usuario eliminar ficheros de los que no son propietarios.
   * Ejempo: `/tmp` cualquier usuario puede escribir en él, pero no puede borrar nada de lo que no sea propietario
   
Para asignar estos permisos se hace con chmod:
   * usuario: u+s
   * grupo: g+s
   * other: o+t

En la notación octal, se añade otro dígito a la notación octal antes de los otros 3 dígitos.
 
## Máscaras

Cuando creamos un fichero, por defecto se nos crea con un grupo de permisos por defecto, que vienen definidos por una máscara.
Es una máscara en negativo, ed. 0027 --> Si pongo un 0, si se le da un 7, con la excepción de que no se le da ejecución si son ficheros.
* Genérico del sistema: `/etc/profile` ó `/etc/bashrc`  
* Para un usuario concreto: `~/.bash_profile` ó `~/.bashrc`  

Por seguridad no se dan permisos de ejecución por defecto a ningún fichero, hay que darle explícitamente el fichero de ejecución.

***

# Monitorización y administración de procesos <a name="proc"></a>

Un proceso es una instancia corriendo o lanzada de un programa ejecutable, consiste en:
* Espacio de direccines en memoria
* Propiedades de seguridad
* Uno o mas hilos de ejecución
* Estado del proceso.

El entorno de un proceso incluye:
* Variables locales y globales.
* Constexto actual almacenado.
* Recursos reservados.

## Comandos

**ps**: 3 formatos de variables y un montón de flags.
   * - UNIX POXIX `ps -aux`
   * -- Extendidas de GNU `ps --aux`
   * (sin guion) BSD `ps aux`
   
Cada uno hace una cosa distinta.

**job** Está asociado a un pipeline entrado por la shell. No confundir con un proceso... Un job siempre se lanza desde una shell.
* Podemos tener lo que está en primer plano
* Lo que está en segundo plano.

Si un proceso no tiene asociado un terminal, (se muestra en el campo TTY del ps el signo **?**)
* Lanzar un proceso en segundo plano: `comando &` - al mandarlo, nos dará: __[job_id] PID__
* pasar un proceso a segundo plano: `comando + Ctrl-z`
* pasar a primer plano: `fg %<job_id>`, para conocer el número de job: `jobs`

~~~bash
[kiosk@foundation12 ~]$ sleep 100000 &
[1] 4619
[kiosk@foundation12 ~]$ jobs
[1]+  Running                 sleep 100000 &
[kiosk@foundation12 ~]$ fg %1
sleep 100000
^Z
[1]+  Stopped                 sleep 100000
[kiosk@foundation12 ~]$ jobs
[1]+  Stopped                 sleep 100000
[kiosk@foundation12 ~]$ ps -j
  PID  PGID   SID TTY          TIME CMD
 4565  4565  4565 pts/2    00:00:00 bash
 4619  4619  4565 pts/2    00:00:00 sleep
 4648  4648  4565 pts/2    00:00:00 ps
~~~
Si nos salimos de la shell, mataremos todos los jobs que estén en la shell, para prevenir esto está el comando `nohup <comando> &`

**TRUCO:** A veces en vez de hacer un bucle `while true; do clear; <comando>; sleep 2; done` será mejor ejecutar `watch -n 2 <comando>`

## Señales

Son interrupciones de SW enviadas al proceso.
Principales señales (OJO, los números de las señales, varian según la plataforma, por lo que se suele usar el nombre de la señal).
* **1 - SIGHUP** - _hangup_ Informa de la finalización de un proceso de un terminal.
* **2 - SIGINT** - Interrupción del teclado. (CTRL-C)
* **3 - SIGQUIT** - Como SIGINT pero genera un dump para depurar el proceso. (CTRL-\)
* **9 - SIGKILL** - No se puede bloquear, provoca una finalización abrupta del programa.
* **15 - SIGTERM** - Termina de forma ordenada, es la señal predeterminada.
* **18 - SIGCONT** - Resume un proceso que está detenido (status Stop), y lo vuelve a lanzar.
* **19 - SIGSTOP** - Suspende el proceso, no puede ser bloqueada o manejada
* **20 - SIGTSTP** - Suspende el proceso, pero se puede bloquear (CTRL-z)

Para la lista completa `kill -l`

Para enviar una señal a un proceso: `kill -<signal> <PID>`
Para enviar a varios:
* `killall -<signal> <patrón_comando>` - usando expresiones regulares
* `killall -<signal> <user> <patron_comando>` - Manda la señal a todos los comandos que cumplan el patrón del usuario especificado
* `pkill` Permite usar criterios mas avanzados de selección
   * _-U UID_ - para usuario
   * _-G GUID_ - para grupo
   * _-P PPID_ - mata a los hijos del proceso padre
   * _-t terminal_ - mata los procesos del terminal
   
Si queremos ver los usuarios de un terminal:
* `who`
* `w` --> Nos da mas información. (ver la ayuda).
* `pstree [PID|user]` - muestra el arbol de procesos del usuario o del proceso
* `pgrep ` para mostar procesos con búsquedas más avanzadas.

## Monitorización de procesos

Comando `top` 
Comando `uptime` -- Número de procesos, tiempo levantado y carga
Comando `w`--> Informa de procesos de usuario

### Promedios de carga.

Nos los da el top o el uptime., si dividimos la carga por el número de cpus, y es >1, el sistema está sobrecargado.

Sistemas por debajo de 1 es raro que tengan esperas.

Por encima de 1, hay que analizar qué es lo que está pasando... si estoy paginando (las escrituras son caras en cuanto a la carga), si la red nos lastra, etc... 

Para entender la carga: (https://www.tecmint.com/understand-linux-load-averages-and-monitor-performance/)

### campos del TOP

* VIRT --> se corresponde con (VSZ del ps).
* RES --> Memoria física (RSS en ps)
* TIME --> Tiempo de CPU
* S --> Estado del proceso
* Ordenar el top:
   - Shift+p --> te lo ordena por consumo de procesador 
   - Shift+m --> te lo ordena por consumo de memoria

***

# Control de servicios y demonios <a name="systemctl"></a>

* **systemd** es el análogo al **init** de versiones anteriores.
   * controla los arranques de servicios y demonios del sistema.
   * su PID es 1 (tanto en systemd -RHEL7- y en init -RHEL6 y anteriores).
* **Demonio** procesos que realizan tareas y se ejecutan en segundo plano.
   * Suelen acabar con la letra _d_
   * Cuando quieren tener comunicación con otras partes del sistema, levanta un socket de systemd, o puede systemd levantar el socket y concederlo al demonio al que le toque, hasta que no tiene socket asignado, el daemon está aislado.
* Un **servicio** hace referencia a uno o varios procesos daemon corriendo en el sistema.

Todo esto no quita que haya cosas que se puedan contralar con **service** pero es un _legacy_.

Que nos proporcina systemd:
* Capacidades de paralelización en el arranque.
* Inicio bajo demanda de los servicios.
* Puede agrupar daemons relacionados.

## Comando _systemctl_

* Ayuda: `systemctl -t help`
* consulta de estado: `systemctl [-l] <daemon>`

Systemctl administra Unidades, 3 tipos:
* **.service** - hacen referencia a un servicio del sistema
* **.sockets** - comunicación interprocesos (IPC - semáforos)
   * desde el socket, podemos levantar el servicio bajo demanda y poner en escucha la unidad que le toque
   * como ejemplo _cups_
* **.path** - hacen referencia a la posibilidad de levantar/activar un servicio en función de si se ha dejado un fichero en una ruta.

**NOTA:** Cuidado con parar una unidad porque el path y el socket pueden activarlo.
Para ver el estado: `systemctl status name.type`  
Estados: 
   * loaded.
   * enabled, disabled, static (este no se puede inciar de forma manual).
   * active (runing, exited, waiting, inactive)

### Usos

* Comprobar si un servicio está activo: `systemctl is-active name.type`
* Comprobar si está preparado para ejecutarse en el inicio: `systemctl is-enabled name.type`
* Listar estado de los servicios `systemctl list-units --type=service` Nos muestra las activas, con _-all_ muestra todas, incluidas las inactivas.
* Ver las configuraciones: `systemctl list-unit-files --type=service`
* Servicios que han fallado: `systemctl --failed --type=service`
* Parar un servicio: `systemctl stop name.type`, pero ojo, si siguen activos el .socket y el .path, todavía estos pueden levantar el servicio, si no queremos que se levante, `systemctl disable name.type`
* **Controlar los servicios**:
   * status
   * start
   * stop
   * restart
   * reload (reinicio "gracefull")
   
 ### Dependencias de unidades
 
`systemctl list-dependencies unit` Muestra las dependencias de la unidad, es decir, las unidades que la unidad en cuestión necesita para levantar.
`systemctl list-dependencies unit --reverse` Lista las unidades que dependen de nuestra unidad.

### Enmascaramiento.

Para que ni el sistema ni un usuario levanten un servicio, se les enmascara, de forma que se borra el link simbólico que apunta al servicio, así nos aseguramos de que accidentalmente nadie arranca el servicio.

Esto lo podemos hacer para que no podamos levantar dos servicios que entran en conflicto (como por ejemplo, network vs. NetworkManager, iptables vs. firewalld ó chronid vs. ntpd).

`systemctl [mask|umask] <unit>` Una vez hecho esto, no podrá arrancar bajo ningún concepto.

***

# Configurando y asegurando el servicio SSH <a name="openssh"></a>

**OpenSSH - _Open Secure Shell_** - permite cifrar usando claves asimétricas entre dos máquinas.

Qué necesitamos:
* Una cuenta en el sistema remoto (IMPORTANTE: el usuario debe existir en el sistema remoto).
* Una shell

Podemos ver los usuarios que están conectados con `w -f`, que nos muestra los usuarios conectados, tanto en local, como remotos.

Comandos simples:
* `ssh <remotehost>` - Sesión con el mismo usuario que el que tenemos en local.
* `ssh <remoteuser>@<remotehost>` - Abre una sesión con un usuario distinto del que tenemos en local.
* `ssh <user>@<host> <comando>` - Ejecuta este comando en la máquina remota.

## Conexión

Cuando se inicia la conexión, se hace un intercambio de claves públicas.
   * Se guardan en una serie de ficheros dentro del directorio oculto en **~/.ssh**
   * **known_hosts**: Contiene la clave de host de cada una de las máquinas a las que nos hemos conectado desde nuestra máquina.
      * Si hemos tenido que reinstalar el servidor, se me han vuelto a generar la clave de máquina, y nos dará un warning de man-in-the-middle.
     * Habrá que borrar la línea en el known_hosts y volver a tirar el ssh.
     * Hay un fichero general para toda la máquina **/etc/ssh/ssh_known_hosts**
     * En el servidor, la lista de claves está en **/etc/ssh/\*key\*** (.pub => públicas, las que no tienen nada, privadas). Si queremos 
  * **authorized_keys**: Se guardan las claves públicas de los usuarios remotos que pueden hacer login con mi usuario en mi máquina sin meter passwd.

### Configuración de la conexión sin contraseña.

Para poder acceder por ssh a un host remoto desde nuestro host, tenemos que intercambiar las claves.

~~~ bash
# generamos el par de claves
$ ssh-keygen -t <alg_cifrado> -b <bytes_clave>
# copiamos la clave pública al host remoto -nos pedirá la passwd del <user> en el <server>
$ ssh-copy-id -i [ruta_clave_privada] <user>@<server>
~~~

Importante, los permisos de los ficheros:
* claves públicas: 644
* claves privadas: 600
* autorized_keys: 600

## Configuración del servicio

Fichero de configuracion: **/etc/ssh/sshd_config**. No suele ser habitual entrar con root por ssh, es más lógico conectarse con un usuario que tenga capacidad de sudo.

Parámetros:
* **PermitRootLogin** (_yes/no_) permite o deniega el acceso por ssh con root.
   * **PermitRootLogin _without-password_**  No permite el método passwd de autenticación, sólo permitirá con claves asimétricas.
* **PasswordAutentication** (_yes/no_) Se permite el acceso con passwd o sólo con claves.

Para que coja los cambios, `systemctl reload sshd`

***

# Manejo de logs <a name="logs"></a>

## Monitorización del sistema

Tenemos dos tipos de logs:
* Los que hay en /var/log
* Los colectados por systemd-journald, que no persisten entre reinicios, genera un registro en binario que podemos consultar con **journalctl**.
   * Mensajes del kernel.
   * Arranques.
   * Mensajes de demonios que se inician o ejecutan mal.
* Los colectados por **rsyslog**, cualquier aplicación que instalemos, la podemos acoplar a este sistema de log

### /var/log

**/var/log/messages** - la mayoría de los mensajes menos los que tengan un fichero específico.  
**/var/log/secure** - relacionado con autenticaciones y seguridad  
**/var/log/maillog** - relacionado con los correos electrónicos  
**/var/log/cron** - relacionado con las tareas programadas  
**/var/log/boot.log** - relacionado con el arranque  

### rsyslog

Procesa los mensajes _facility.severity_
* **facility** en `man 5 rsyslog.conf`
* **severity** 8 niveles

Fichero de configuración en `/etc/rsyslog.conf` o en cualquier fichero `/etc/rsyslog.d/`.

En el fichero de configuración, los logs vienen configurados en la forma: `facility.severity    <ruta_fich_log>`:
* Se pueden usar comodines para la severity y facility.
* Podemos tener varios pares facility.severity en la misma línea.
* Se pueden negar facilities con la severity _none_.
* en el mail, fijarse que viene `mail.* -/var/log/mail.log` el guión idica que los logs se hacen de forma asíncrona.

## Rotado de logs

Fichero de configuracion: `/etc/logrotate.conf` o en `/etc/logrotate.d/*`  
Cuando se hago un rotado, se guardará el antigüo con un timestamp.  
Después de cierto tiempo, se borran del histórico.

Si no rota correctamente habría que revisar el cron.

Mas información `man 8 logrotate`

### Analizando una entrada de syslog.

Las líneas viene en el formato: `timestamp:host:programa:mensaje`

Podemos usar un `tail -f <fichero_log>`

### Comando _logger_

Para comprobar configuraciones que hemos hecho en el syslog: `logger -p facility.severity "string"` nos mandará al fichero de log que esté configurado el mensaje.

## journalctl

Hay una BB.DD. central de systemd que manda a journald. Los logs se almacenan en el `/run/log/journal` que es un fichero binario indexado. No se conservan entre reinicios (todo esto es el comportamiento por defecto y se puede cambiar).

Para revisar todas las entradas de log que el sistema guarda usamos el comando **journalctl** hay que lanzarlo con root. 
* `journalctl -n <num>` Muestra las _num_ últimas líneas, sin no se le da valor, el defecto es 10
* `journalctl -p <severity>` Muestra los mensajes de cierta severidad y superiroes.
* `journalctl -f` Va refrescando
* `journal --since "YYYY-MM-DD_hh:mm:ss" --until "yyyy-mm-dd_hh:mm:ss"`
   * Admite modificadores: yesteday, today, ...
* `journalctl -o verbose`
   * Modificadores del comando, me dan facilidad para acotar ciertas entradas.
      - _COMM -- comando
      - _PID -- busca por PID
      - _EXE -- ruta del comando
      - _GID -- buscar por GID
      - _SYSTEMD_UNIT -- busca pro unidad de systemd
   
### Haciendo persistente el journal de systemd

Tenemos que crear una ruta paralela para hacerlo psersistente `/var/log/journal`, que tiene un rotado mensual, y donde se guardarán los logs de journal.

Fichero de configuración en `/etc/systemd/journald.conf`.

Por defecto el journal, no puede tener mas del 10% del sistema de ficheros, y tiene que dejar al menos el 15% libre. Estos límites se tocan en el fichero. Para ver estos límites: `journalctl |head -n 2`

Para ver si está corriendo: `sysemctl status systemd-journald`

**Procedimiento**

~~~ bash
# creamos el directorio
mkdir /var/log/journal
chown root:systemd-journal /var/log/journal
chmod 2755 /var/log/journal
# Pasamos una señal al journal para que empiece a trabajar en la nueva ruta
killall -USR1 systemd-journald
# Podemos forzar el rotado:
killall -USR2 systemd-journald
~~~

Ahora, como tenemos varios rebotes, podemos ver lo que hay desde el rebote _n_ con `journalctl -b -n` 

## NTP. Configuración del tiempo

_Network Time Protocol_ Nos sirve para mantener nuestro servidor en la hora correcta.

* `timedatectl` nos va a dar el status de tiempo del sistema.
* `timedateclt list-timezones` da un listado de TZ.
* `tzselect` nos ayuda a seleccionar la TimeZone
* `timedatectl set-timezone <nombre>` Cambia la hora a la de la TZ especificada
* `timedatectl set-time hh:mm:ss` Cambia la hora (conviene antes de sincronizar con el NTP)
* `timedatectl set-ntp true` activa NTP

### chronyd

Se encarga de mantener el reloj de sistema dentro de unos parámetros. Va registrando la sincronía del reloj con respecto al servidor NTP, con un `driftfile` que se configura en `/etc/chrony.conf`

Salvo casos especiales, configurar los NTP Pool Project como servidores NTP.

**IMPORTANTE** chronyd es incompatible con ntpd por lo que en un sistema tiene que estar funcionando uno u otro.

**Conceptos**
** stratum 0 --> siempre sincronizado
** stratum 1 --> sincronizado sobre el
** stratum 2 --> sincronizado con stratum 1.

Tenemos una serie de capas por estratos, servidores dentro del mismo estrato, se denominan _peer_ y el el estrato superior, _server_.

Todo se configura con `/etc/chrony.conf`
* se pude configurar mas de un server y un peer.
* server IP iburst --> 4 ráfagas de sincronización para sincronizar lo más rápido posible.
* para ver contra quién nos estamos sincronizando: `chronyc sources`
* El puerto TPC/UDP es el puerto 123 (ojo si queremos sincronizar con un servidor NTP externo a nuestra red, abrir puerto firewall).
* para sincronizar, hay que reiniciar `systemctl restart chronyd`

***

# Networking <a name="network"></a>

## Conceptos

### IPv4 - modelo de 4 capas

* **Capa 4** - Aplicacion (SSH, HTTP, HTTPS, NFS, CIFS, SMTP, ...), los datos que se mueven están relacionados con estos protocolos.
* **Capa 3** - Transporte (TCP, UDP) -- fichero `/etc/services`, aquí es donde tenemos que mirar los puertos de servicios (menos si está SELinux activo).
   * Aquí hablaremos de puertos e IP (socket)
* **Capa 2** - Red o internet, transporta los datos a través de la red a un host, capa de conexiones entre redes. (ICMP).
* **Capa 1** - Física o enlace, relacionado con las MACs (802.3 - Ethernet, 802.11 - Wireless), que deben identificar de manera unívoca una interfaz de red.

### Direcciones IP

4 octetos (32 bits), incluyen la dir de red y de host.

* Todos los hosts de la misma subred se comunican sin enrutador entre ellos.
* En una misma subred no puede haber dos hosts con la misma dirección de host.
* Para que una máquina salga a otras redes, necesitamos un gateway o enrrutador (que tiene que ser de su red), que tiene una tabla de rutas a otras redes.

### Enrrutamiento

Para ver la tabla de rutas `netstat -nr` ó `ip route`.  
El gateway nos sirve para enrutar a una red que no es la nuestra, para llegar a una ruta que no sea la de nuestro GW por defecto, tendrá que tener una ruta estática.

En la tabla de rutas:
0.0.0.0/0 --> GW por defecto
otra subred --> GW de esta subred (esto es la ruta estática)

Cada interfáz de red, tendrá su propia subred.
Para traducir las IPs a nombres, se usa DNS.

La configuracion la podemos tener automática (DHCP) o estática.  
Buscar "IP alias" (es una forma de sobrecargar las interfaces de red, una interfáz no tiene porqué tener una sola IP estática).

### Nomenclatura de interfaces de networking.

Estándar: eth0, eth1, eth2, ... Problema: el demonio _udev_ carga lo que tiene asignado, pero si se borra un intefáz o se rebota, puede dar probleams.

Nombrado de interfaces: iioN
* ii puede ser
   * Ethernet: en-...
   * Wireless: wl-...
   * WWAN: ww-
 * o puede ser:
   * o - incorporado
   * s - hot-plug conexión
   * p - ranura pci
   * n es el número de adaptador.
 
P.ej: enp0s3

Si se han definido reglas para _udev_ personalizadas o si tenemos definido _biosdevname_ se cambia el nombre de asignación (pXpY).
 
## Consultas de redes
 
`/sbin/ip` --> `ip addr [interfaz]` ~ `ip a [interfaz]`
 
* Chequear la intefáz: `ip -s link show [interfaz]`
* Chequear conexión: `ping -c1 <ip/DNS>` (así lo podemos usar en un script).
* Ver las rutas: `traceroute` - `tracepath`, la potente es la primera, ya que nos permite trabajar con UDP (predeterinado), ICMP (-I) o TCP (-T). 
   * Muestran lso enrutadores por los que va pasando.

### Sockets

Requiere puerto, ip y protocolo.

`netstat` (en desuso): -usar mejor la opción con _n_
* `netstat -tulpan`
* `netstat -putona`

`ss` - Muestra estadísticas de los sockets
* Nos interesa sobre todo la conexión local.
* Opciones:
   * -n -- numérico en vez de nombres (con nombres puede eternizarse para conectar con DNS)
   * -t -- TCP
   * -u -- UDP
   * -l -- muestra los sockets a la escucha
   * -a -- muestra todos los sockets
   * -p -- proceso que usa el socket
 
 ## NetworkManager
 
 **IMPORTANTE** NetworkManager es incompatible con network, con lo que en un sistema no pueden estar los dos servicios activos.
 
 De cara al network manager, tenemos que distinguir:
 * _device_name_ Cada una de las conexiones que puede establecer mi equipo.
 * _conexion_ 
 
 Ficheros de configuración:
 * `/etc/sysconfig/network-scripts/*`
   - `ifcfg-<conexion>` (uno por conexión)
   
## nmcli

Es el CLI para controlar el NetworkManager. 

El NetworkManager no puede estar corriendo a la vez que network (así que hay que enmascarar el network). Para ver si está corriendo: `systemctl status NetworkManager`

Tres seccines:
* dev -- Dispositivos, 4 opciones:
   - show
   - status
   - connect
   - disconnect
* con -- Conexiones, hay que pasarle el nombre de la conexión _CON_ID_
   - add
      - Con ip estática, necesitamos
         - Nombre de conexión
         - tipo de conexión
         - onboot (Sólo una a YES)
         - ipv4
         - network
         - nombre del dispositivo
         - GW
      - Con DHCP
         - Nombre de conexión
         - tipo de conexión
         - nombre del dispositivo
   - up
   - down
   - show
   - reload
   - delete
   - edit
   - mod <CON_ID>, podemos modificar parámetros de la conexión.
      - autoconnect(yes/no) - Es el ONBOOT del los ficheros de configuración, OJO, que solo puede haber uno en el arranque.
      - Añadir/Cambiar DNS
      - cambiar la IP
      - Cambiar GW
      - Ignore AutoDNS (yes/no) - el antigüo de los ficheros PEERDNS, Si está YES, ignora lso DNSs que le pasa el DHCP y se guarda los que tiene configurados en `/etc/resolv.conf`
      - Cuando se cambie una conexión de DHCP a manual, hay que poner el parámetro _ipv4.method_
* net -- Networking
   - on
   - off
   
Cada configuración que veamos aquí tiene su reflejo en el fichero de configuración. (`/etc/sysconfig/network-scripts/ifcfg-<conex>`).

Ayudas:
* man nmcli
* man nmcli-examples(5)
* man nm-settings(5)

## Archivos de configuracion

`/etc/sysconfig/network-scripts/ifcfg-<name>`
 
 Estática|Dinámica|Cualquiera de las dos
 --------|--------|-------
 BOOTPROTO=none| |DEVICE=eth0
 IPADRR0=172.25.X.10| | NAME="System eth0"
 GATEWAY0=172.25.X.254| BOOTPROTO=dhcp|ONBOOT=yes
 DEFROUTE=yes  |  | UUID=fsfds232-2...
 DNS1=172.25.254.254| |USERCTL=yes
  
Cuando cammbienos los ficheros de configuración:
1. `nmcli con reload`
2. `nmcli con down <con_id>`
3. `nmcli con up <con_id>`

## Configuración de Hostname y resolución de nombres

El nombre de la máquina, por defecto, viene en `/etc/hostname` (antes estaba en `/etc/sysconfig/netowrk`), se obtiene con el comando **hostname**.

Se puede meter un restart después de manipular el fichero, la manera "fina" es: `journalctl restart systemd-hostnamed`, pero más fina es con el comando hostnamectl.

* Consultar el status: `hostnamectl status`
* Cambiar el hostname: `hostnamectl set-hostname nombre`

Estructura de búsqueda (el orden de búsqueda se establece en el fichero `/etc/nsswitch.conf`):
1. `/etc/hosts` (mantiene concordancia nombre-ip)
   * para lanzar consultas aquí: `getent hosts <hostname>`
2. Consulta al DNS, que está configurado en `/etc/resolv.conf`
   ~~~ bash
   search   example.com
   domain   example.con
   nameserver  <ip>
   nameserver  <ip>
   ...
   ~~~
   Si configuramos _search_ y _domain_ se queda con **_domain_**
   
Para probar como funciona el DNS:
   * **nslookup** (este hay que instalarlo como paquete)
   * **host** ó **dig**

***

# Archivado y copia entre sistemas <a name="enpaquetado"></a>

## Empaquetado

TAR es una utilidad que permite empaquetar y/o comprimir una serie de ficheros en un solo fichero.

Se le pueden pasar los flags con o sin guión:
* c --> crear
* x --> extraer
* t --> enumerar
* v --> modo verboso
* f --> donde está el fichero (el fichero tiene que ir detrás de la f).
* p --> mantiene los permisos (de ejecución).

La sentencia es: `tar <flags> archivo.tar <fich_1>...<fich_n>`  
El empaquetado no conserva la barra, así la descompresión es relativa al directorio donde esté trabajando.

El empaquetado empaqueta los ficheros y directorios que el usuario pueda leer. Almacena usuario, grupo y permisos, pero solo cuando descomprimamos con root conservaremos eso, si no, cogerán los del usuario que descomprima.

Si queremos conservar SELinux y ACLs, tendremos que usar el flag **--xattrs**

### Empaquetado con compresion

Tipos de compresión permitidos:
* gzip (flag **z**) -- Más rápido y más antigüo
* bzip2 (flag **j**) -- Mejor compresion
* xz (flag **J**) -- Mejor compresión de todos

Necesitamos tener instalado el paquete del compresor. Al descomprimir, el tar detecta que tipo de algoritmo de compresión se usó, por lo que no es necesaro pasarle el flag.

## Copia entre sistemas

### scp

Para copiar ente sistemas, se usa el comando **scp**, que se hace sobre ssh.

Formato:
* scp remoto local --> Para traernos la copia
* scp local remoto --> Para llevarnos la copia

Admite recursividad con el flag **-r**

### sftp

Es un ftp que va sobre ssh, como en el ftp sin cifrar, se nos abre una subshell para interactuar con el servidor remoto.

~~~bash
$ sftp servidor
user@servidor password: xxxx
Connected to servidor.
sftp>
sftp> cd dir
sftp> get fichero (se trae el fichero)
#####
sftp> put fichero (se lleva el fichero)
####
~~~

Admite los siguientes comandos: ? (ayuda), (l)cd, ls, mkdir, rmdir, (l)pwd, (m)get, (m)put, exit

## Sincronización segura entre sistemas

**rsync** es una herramienta apara copiar de forma segura ficheros entre sistemas (se basa en ssh).

Hace un movimiento incremental entre directorios (estén o no en el mismo sistema). Se usa para backpus y recuperación de desastres (tenemos que tener una copia offline sincronizada con el sistema que queramos recuperar).

Hay que hacer una sincronización inicial (hará lo mismo que el scp), y a partir de ahí sólo llevará los cambios.

* -n: hacer un _dryrun_, con lo que nos aseguramos que no vamos a hacer ningún destrozo.
* -a: reune los flags:
   * -r: recursivo
   * -l: mantiene links simbólicos
   * -p: mantiene permisos
   * -t: mantiene timestamps
   * -g: mantine las propiedades de grupo
   * -o: mantiene propietario
   * -D: sincroniza archivos de dispositivo
* -H: se trae los hardLinks (así evitas tener que traerte dos veces los mismos datos).
* -v: verboso
* -A: mantiene ACLs
* -x: mantiene SELinux

Generalmente se copiará con -av, también se puede hacer entre dos directorios locales.

**IMPORTANTE** si quiero copiar el contenido de un directorio: hay que poner la barra al final, si no ponemos la barra al final, te llevas también el directorio

***

# Manejo de paquetes de software <a name="packages"></a>

Para instalar software en redhat, hay que usar la utilidad **yum**, para lo que la máquina tiene que estar licenciada, y con el _RedHat Subscription Manager_ veremos lo que podemos o no instalar.

Para ejecutarlo:
- Subscrition-manager-gui
- Applications --> System Tools --> Subscrition Manager

Necesitamos:
* Tener el sistema registrado `subscrition-manager register --username="username" --password="pass"`
* Tener el sistema subscritro
   * Visualizar Subscripciones disponibles: `subscrition-manager list --availabe| less`
   * Adjuntar una subscripción de forma automática: `subscription-manager attach --auto`
   * Visualizar susbscripciones consumidas: `subscription-manager list --consumed`
   * Eliminar la subscripción: `subscrition-manager unregister` 
* Habilitar los repositorios (al dar de alta las subscripciones, nos debería dar de alta las que tenemos permitidos)
* Revisar licenciamiento (Customer portal).

Para todo esto, hay que tener salida a internet.

## Certificados 

/etc/pki/product --> Certificados de los productos instalados
/etc/pki/consumer --> Certificados de la cuenta asociada
/etc/pki/entitlement --> Certificados que contienen las subscripciones adjuntas al sistema

## Paquetes RPM

Es la forma de agrupar todos los ficheros que forman parte de un software.

**IMPORTANTE** RPM se refiere a términos locales, YUM repositorios dinámicos, puede salir fuera. Los repositorios son conjuntos de paquetes.

YUM resuelve dependencias (cosa que rpm no).

### Nomenclatura

nombre-versión-release.arquitectura.rpm
- si no hay arquitectura: noarch, si no (x86_64, x86_32, i386, ...)
- para instalar sólo necesitamos el nombre.
- no es obligatorio instalar.

### Composición

Cada rpm tiene metadatos que podemos consultar:
* nombre
* versión
* release
* arquitectura
* resumen del paquete
* descripción
* dependencias (paquetes necesarios para que se instale el nuestro).
* licencia (si se da el caso)
* changelog
* otros detalles
   * Entre estos metadatos puedes tener scripts, que se pueden ejecutar en la instalación o en la desinstalación
   * Firma GPG, (la clave pública estará disponible para comprobar la firma ya que todos los paquetes lanzados por RH van firmados).
   
Cuando vamos a actualizar, no se meten parches, se instalan versiones. Sólo se puede instalar un paquete por sistema (generalmente), uno de los paquetes que podemos tener versionados es el kernel.

Cuando desinstalamos un paquete, también desinstala los paquetes dependientes de él, ya que no van a funcionar.

## YUM

* Para mirar los repositorios: `yum repolist`
* Listar las utilidades  `yum list yum*`
* lista grupos de paquetes `yum grouplist`

Si subscribimos un sistema, se configura automáticamente el acceso a los repositorios que tengamos adjuntos.

Comandos informativos:
* `yum help`
* `yum list 'http*'` - saca todo lo relacionado con http
* `yum search <palabra>` - busca en los campos nombre y resumen
* `yum search all <keyword>` - busca en nombre, resumen y descripción
* `yum info nombre_paquete` - Saca información del paquete
* `yum provides <fichero>` - Me dice que paquete instala este fichero

Comandos que hacen pupa:
* `yum install <nombre_paquete>` - Instala el paquete y sus dependencias.
* `yum update <nombre_paquete>` - Actualiza el paquete y sus dependencias, si no ponemos el nombre del paquete, actualiza todos. Hace copias de seguridad de los ficheros de configuración incompatibles y crea otro limpio.
   - Si es un kernel, este es tipo _always install_, siempre se instala, aunque se indique con update.  
      Para ver los kernels que tenemos instalados: `yum list kernel` y para ver el kernel que se está usando `uname -r`.  
      El kernel en versiones anteriores se instalaba, es decir no había opción de update.
* `yum remove <nombre_paquete>` - Borra el paquete
   - Si hay paquetes que dependen de él, también me los quita (porque ya no van a funcionar).
   - Esto es una pega, porque si desinstalamos por error y lo volvemos a instalar, no arreglamos las dependencias rotas.
* `yum reinstall <nombre_paquete>` - Reinstala el paquete (muy útil cuando nos hemos cargado algo).
   - hacemos primero `yum provides <loquenoshemoscargado>` y vemos qué paquete hay que instalar
   - `yum reinstall <paquete>` 

### Grupos
 
Agrupan paquetes y dan una funcionalidad completa, evidentemente al precio de perder el control de lo que se está instalando -puede que nos instale más cosas de las que necistamos.

Dos tipos:
* regular: un grupo de RPMs
* Entorno: un grupo de grupos regulares.
 
3 tipos de paquetes de grupos:
* obligatorios
* predeterminados
* opcionales
 
* `yum group list <nombre>` (en versiones anteriores: yum grouplist).
* `yum group info <nombre>` (en versiones anteriores: yum groupinfo)

OJO: Si le tiramos este comando, nos va a mostrar los paquetes que forman parte del grupo:
- **=** el paquete esá instalado o fué instalado como parte del grupo.
- **+** No está instalado y para instalarlo hay que instalar el grupo.
- **-** No está instalado y no se instalará (habría que instalarlo manualmente).
- (sin marcador) El paquete está instalado individualmente  
   en este caso, podemos decirle al sistema que nos marque al grupo que sólo instale los paquetes predeterminados u obligatorios que existan.
   
* `yum group install <grupo>`
* `yum group mark install <group>` --> marca que el grupo está instalado, y todos los paquetes que nos faltan por instalar de obligatorios y predeterminados, se nos instalaran (en la versión anterior esto no era así, si teníamos la paquetería instalada, el grupo se consideraba que estaba instalado).
   
### Historia

Todo lo referente a lo que ha hecho yum está en `/var/log/yum.log`

Además, tenemos un historial de lo que se ha hecho. `yum history`, que podemos consultar la paquetería que hemos instalado.

Podemos deshacer operaciones hechas desde el _yum history_

## Repositorios

Configuración por defeco de yum: `/etc/yum.conf`
Repositorios en: `/etc/yum.repos.d/*.repo`

Para definir un repositorio necesitamos un fichero **.repo**, con el siguiente contenido:

~~~text
[IDENTIFICACION]
name="nombre"
baseurl={ftp,http,file}
enabled={0|1}           # opcional (recomendable)
gpgcheck={0|1}          # opcional (recomendable)
gpgkey=url_public_key   # opcional (recomendable)
~~~

En el repositorio tendríamos que  tener los paquetes rpm y un repodata con los metadatos del repositorio.
* `yum repo list all`  --> devuelve lalista de todos los repositorios
* **yum-config-manager** --> utilidad para manipular los repositorios que tenemos.
   * `yum-config-manager --{enable|disable} <repositorio>`: nos habilita este respositorio (en el fich de config, mete un _enabled=1_).  
      Podemos configurar repositorios de terceros editando un fichero *.repo en `/etc/yum.repos.d/*.repo`
   * `yum-config-manager --add-rep=<url>`, genera un fichero de repositorio basándose en la URL que le hemos pasado, una vez que tenemos el fichero, podemos manipularlo.
* `rpm --import <url_clave>`: Importa la clave GPG
* `yum --enablerepo=<patrón_repo>` y `yum --disablerepo=<patrón_repo>`, se pueden usar combinados para determinar el paquete exacto que queramos, de forma temporal, para esa ejecución.

## RPM

Esto no nos resuelve dependencias así que ojito, mejor usar yum.
* Para ver lo que tenemos instalado: `rpm -qa  |grep httpd`
* `rpm -qf <fichero>` --> nos da las dependencias, trabaja en local, por lo que si no tenemos el paquete que provee el fichero, no nos devolverá nada.
* `rpm -qp <paquete_local>.rpm` --> Nos muestra el paquete
* `rpm -ql paquete` -- contenidos de un paquete instalado (añadir la -p si lo tenemos en local)
     - esto se usa para saber qué nos va a instalar el paquete (rpm -qlp paquete.rpm)
* `rpm -ivh <paquete>` -- nos instala el paquete
* `rpm -qdp <paquete>.rpm` -- nos dice lo que nos va a instalar de documentación un paquete local (sin la p, es de un paquete instalado)
   - c = ficheros de configuración
* `rpm -q --scripts <paquete>` -- Nos dice qué scripts nos va a ejecutar
* `rpm2cpio paquete.rpm |cpio -id "*txt"` nos saca del paquete todos los ficheros especificados con el filtro del cpio

***

# Sistemas de archivos <a name="filesystem"></a>

Un sistema de ficheros es una estructura organizada de ficheros y directorios que residen en un dispositivo de almacenamiento.

Los sistemas de ficheros los usamos para encapsular la estructura arbórea, cuya finalidad es poder ampliarla con facilidad. Es decir, "colgar" de un punto por debajo un dispositivo de almacenamiento para ampliar la capacidad del sistema e integrarla en la estructura arborescente.

Cada sistema de ficheros es independiente de los otros.

## Conceptos

* **Montaje (_mount_):** Añadir un dispositivo formateado al sistema de ficheros
* **Dispositivos:** El demonio udev es el que está buscando dispositivos nuevos y los pone en `/dev`
   - Discos SCSI: /dev/sda, /dev/sdb, ...
* **Particiones:** Cada disco admite 4 particiones primarias (sda1, ..., sda4)
   Admite una partición extendida que suele estar en la partición5, y se numeran desde el 5
   En caso de que usemos particiones extendidas, no nos aparecerá la partición 4.
* Los discos se pueden referescar en caliente **rescan-scsi-bus.sh** -- Busca en las primeras posiciones de la tarjeta SCSI que tenga.
   
### Comandos de consulta de discos

- **lsblk** Muestra los discos de la máquina, sus particiones y donde están montadas
- **blkid** Muestra los identificadores de los dispositivos montados (UUID) y el tipo de FS.

## LVM (Logical Volumen Management)

Supongamos que tenemos un disco o una partición (`/dev/sdb`).  
Tenemos que crear un Phisycal Volume (PV) (`/dev/sdb`) (_pvcreate_)  
Creamos un grupo de volúmenes (VG) al que le pondremos un nombre (`vg_datos`) (_vgcreate_), que tendrá el tamaño de los PV's que lo compongan.  
cuando lo dividimos el resutlado son Physical Extensions (PE)  
Troceamos en LogicalVolumen (LV) en Lógical Extensions (LE) (que deben tener el mismo tamaño de las PE). (`lvdatos1`)  
Formateamos el LV y lo montamos.  

¿Donde está la potencia?  
Si necesitamos ampliar, podemos usar un nuevo PV con un disco adicional, que podemos añadir al VG, extiendo el LV en la cantidad necesaria.

## Comandos

~~~bash
[kiosk@foundation12 ~]$ df -mlhi
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sda3        111M  124K  111M    1% /
devtmpfs         4.0M   447  4.0M    1% /dev
tmpfs            4.0M    42  4.0M    1% /dev/shm
tmpfs            4.0M   898  4.0M    1% /run
tmpfs            4.0M    16  4.0M    1% /sys/fs/cgroup
/dev/sda1        512K   374  512K    1% /boot
tmpfs            4.0M    24  4.0M    1% /run/user/1000
tmpfs            4.0M     1  4.0M    1% /run/user/0
~~~

**OJO**, no confundir KiB con KB, el primero es 2^10 (Flag -h) y el segundo 10^3 (Flag -H) y sus múltiplos

**Tamaño ocupado** `du`, esto nos sirve para ir buscando dónde está el espacio usándose. Los flags mas usados:
- -h (ó -H)
- -s (summarize, tamaño global)
- -m

## Montaje y desmontaje de FS

Para montar todo lo que esté definido en `/etc/fstab`: **mount -a**, cuando arranca el sistema, monta todo lo que está en este fichero, por lo que si hay algo mal, el sistema no arrancará.

Para ver lo que hay montado en el sistema: `mount`

**blkid** nos dará los UUID de los sistemas de ficheros formateados, podemos montar con el UUID o haciendo referencia a la partición formateada...

p.ej:
1. Tenemos /dev/vdb1.
2. Creamos el sistema de fichero con `mkfs -t {ext4|xfs} /dev/vdb1`
3. Creamos el punto de montaje: `mkdir /mnt/punto_montaje`
4. Montamos: `mount /dev/vdb1 /mnt/pto_montaje`

El punto de montaje debe existir (así que primero de todo, hay que crear el punto de montaje)

Para desmontar: `umount /dev/vdb1` ó `umount /mnt/punto_montaje`. Para desmontar no tiene que haber ningún proceso usando el punto de montaje...

Par ver si hay alguien usando algo en una ruta: `lsof /ruta` ó `fuser /ruta`

Con `fuser -k /ruta` nos mata todos los procesos de usuario que estén usando esta ruta.

El único dispositivo que pueden montar los usuarios son los USB, en la ruta `/run/media/<user>/<label>`

**OJO con los montajes y desmontajes**... si nos equivocamos y montamos sobre un directorio que está siendo usado o que tiene información, ocultaremos la información que estaba originalmente en el directorio. Si hacemos un listado del directorio, veremos lo que hay en el dispositivo montado NO lo que hay en el directorio. Nos podemos volver locos, porque si hacemos un df veremos un uso de disco y si hacemos un du, la suma no coincidirá con lo que hay en él.

**Montajes bindeados (_bind mount_)** de un directorio sobre otro, se usa para encapsular espacios de usuarios.

## Links

Dos tipos _hard link_ y _soft link_.

### Hard link

Una nueva entrada en un directorio que hace referencia a un archivo ya existente en el FS.
* Todos los archivos tienen un HL. Tienen que estar en el mismo sistema de ficheros.
* Si está en el mismo directorio, tendrá que tener un nombre distinto.
* Todos los HL de un mismo fichero son clones.
* Es un nombre que hace refencia a un mismo inodo.

`ln <fich_existente> <hard_link>`

### Soft link

No es un archivo regular (en un listado largo lo veremos con una l), es un puntero a un fichero (es lo más parcido que hay a los accesos directos de Windows).
* Tienen que apuntar a un archivo o directorio existente.
* Si borramos el fichero origen, el SL no desaparece, pero queda inconsistente.
* No tienen que estar en el mismo sistema de ficheros.
* Pueden usarse con directorios (el origen puede ser un directorio).

`ln -s <fich_existente> <soft_link>`

### Operando con links

Para ver si son hard links o no, en el listado largo, el segundo campo nos dice cuantos HL tiene.

Para ver los inodos de cada fichero, dos opciones.
* `ls -il <fichero>`
* `stat <fichero>`

## Buscando archivos en el sistema

### locate

Busca en una base de datos del sistema y devuelve el resultado de forma instantánea.

* Para actualizar la base de datos `updatedb`, almacena la ruta y el nombre de los ficheros. Diariamente se actualiza la BB.DD.
* Tenemos que tener permisos de lectura en los directorios por los que va a buscar.

ej.: `locate passwd`

Modificadores:
* i - case insensitive
* -n <numero> - limitas la cantidad de resultados que te devuelve

### find

Mucho más potente que locate, se puede afinar mucho la búsqueda, puedes ejecutar comandos sobre lo encontrado, ...
* Para buscar, tenemos que tener permisos r-x sobre el directorio
* Es recursivo

#### Casos de uso

`find <ruta> -name <nombre>`, Busca desde la ruta por el nombre, se pueden usar comodines en el nombre
* -iname -Case insensitive
* -user - busca por usuario
* -group - busca por grupo
* -uid - busca por uid
* -gid - busca por gid
* -perm -- busca por permisos
   - -perm xyz -- busca exáctamente esos permiso
   - -perm -xyz -- busca como mínimo esos permisos (ej: -755, encontraría 755, 765, 775, 765,..,) 
   - -perm /xyz -- como mínimo uno de los tres (ej: 755, 700, 050, ...), (el 0 es un comodín)
* -size -- Busca por tamaño (ojo, que el tamaño se redondea hacia arriba)
   - -size 10M -> tamaño exacto
   - -size +10M -> tamaño mayor de 10M
   - -size -10M --> tamaño menor de 10M
* -mmin -- busca por tiempo desde la última modfiicación (funcionan igual + y - que con los tamaños).
* -type - busca por tipo de archivo.
   - f - fichero
   - d - directorio
   - l - link simbólico
   - b - dispositivo de bloques
* -liks -- busca por ficheros con hardlinks (funcionan igual el + y el -)
* -exec - ejecuta el comando sobre los resultados del find 
    - Estructura: `find <dir> <parámetros busqueda> -exec <comando> {};\`

Todos los flags de búsqueda podemos combinarlos, si los combinamos tal cual funcionan como un AND, si queremos OR, tenemos que meter **-o**, y habría que usarlo con paréntesis.

***

# Virtualización <a name="virtualization"></a>

Las máquinas virtuales de RHEL se basan en KVM (Kernel Virtual Machine). Está basado en el Kernel, que lo único que necesita es que se instalen los módulos.

* Puede ejecutar casi cualquier sistema operativo.
* Se basa y administra con **libvirt**
* Se administra con **virt-manager**
* Las máquinas virtuales se usan con **virsh**

## Ecosistema

Junto con OpenStack, KVM es la que usa RH en su IaaS y se puede administrar todo el conjunto con CloudForms.

Hosts: RedHatEnterprise Virtualization Host (RHEV-H), que cargan las máquinas virtuales con KVM
Redes: Suele ser virtualizado
Almacenamiento: RHStorage
Adminsitracion: Virtual Manager (RHEV-Manager)

Todo va sobre RedHat. 

## Formas de trabajar.

Podemos confirar nodos de dos formas:
* thin host: con nodos pequeños dedicados excluisivamente a virtualización.
* thick host: admite tener máquinas virtuales y más cosas.

Si vamos a tener una granja, conviene que todos los host sean lo mas parecidos posibles.

## Requisitos mínimos

* Al menos 2 CPUs (una para el host y otra para la VM).
* 2 GB de RAM para el host y la RAM que necesitemos para cada VM.
* 6 GB de disco para el host
* CPU:
   - Intel(x86): VT-X, INTEL64
      - Buscar en el fichero los flags vmx ó svm: 
   - AMD: AMD-v, AMD64
      - Buscar los flags: svm
   - Flag común para las dos arquitecturas: nx
   - `grep --color -E "vms|svm" /proc/cpuinfo`
   - `grep --color - E "nx" /proc/cpuinfo`
   
### Paquetería.

Esto es lo que hay que instalar:
* qemu-kvm y qemu-img --
* liberías varias:
   - python-virtinst
   - libvirt
   - libvirt-python
   - virt-manager
   - libvirt-client
   
   
El instalador que usar RHEL es **anaconda**

## Comandos de manejo.

### virsh

* connect: conecta con el KVM-Host (`qemu://host`)
* nodeinfo: información basica del host
* autostart: configura el dominio KVM para que se inicie junto al host
* console: establece la conexión con la consola virtual del host
* create: Cra un dominio a partir de un archivo de configuración XML y lo inicia
* define: crea un dominio a partir de un archivo de configuración XML (no lo inicia).
* undefine: quita la definición anterior
* edit: edita la configuración
* reboot: Reinicia el dominio
* shutdown: Apaga correctamente el dominio
* screenshot
* destroy: shutdown + undefine
