1. [Automatización de la instalación](#kickstart)
2. [Expresiones regulares y grep](#regular_expressions)
3. [Vim avanzado](#advanced_vim)
4. [Programación de tareas](#task_sched)
5. [Prioridades](#priority)
6. [Control de acceso a ficheros (ACLs)](#acls)
7. [Manejo de SELinux](#selinux)
8. [Conexión a redes](#redes)
9. [Añadir discos, particiones y sistemas de ficheros](#discos)
10. [Logical Volume Management (LVM)](#lvm)
11. [Network Storage NFS](#nfs)
12. [Networ Storage SMB](#smb)
13. [Troubleshooting](#troubleshooting)
14. [Limitar comunicaciones de red](#firewalld)

***

# Automatización de la instalación <a name="kickstart"></a>

**Anaconda** es el instalador que necesita que el que está haciendo la instalación le responda a una serie de preguntas.

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

* **url** Especifica donde está el medio de instalación
* **repo** Donde encontrar los paquetes para la instalación.
* **text** Sólo instala en modo texto
* **vnc** Habilita para ver lainstalación remotamente.
* **askmethod** 

### Comandos de particionado

* **clearpart** limpia las particiones antes de la instalación
* **part** Especifica los parámetros para crear la partición.
* **ignoredisk** Se pueden especificar discos que se ignoran en la instalación.
* **bootloader** Especifica donde instalar el _bootloader_
* **volgroup,logvol** Crea grupos de volúmenes y volúmenes lógicos de LVM.
* **zerombr** Se usa con sistemas a los que queremos formar el borrado del MBR.

### Comandos de networking

* **network** Configuraicón de red
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

Hay una utilidad que ayuda a configurar el fichero de Kickstart: **system-config-kickstart**, .

También podemos modificar un fichero ya existente, luego podremos validar la sintaxis con **ksvalidator** por si hemos metido la pata. (En nuestro sistema siempre habrá un fichero de configuración: `/root/anaconda-ks.cfg`

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



***

# Prioridades <a name="priority"></a>

***

# Control de acceso a ficheros (ACLs) <a name="acls"></a>

***

# Manejo de SELinux <a name="selinux"></a>

***

# Conexión a redes <a name="redes"></a>

***

# Añadir discos, particiones y sistemas de ficheros <a name="discos"></a>

***

# Logical Volume Management (LVM) <a name="lvm"></a>

***

Network Storage NFS <a name="nfs"></a>

***

Network Storage SMB <a name="smb"></a>

***

Troubleshooting <a name="troubleshooting"></a>

***

Limitar comunicaciones de red <a name="firewalld"></a>
