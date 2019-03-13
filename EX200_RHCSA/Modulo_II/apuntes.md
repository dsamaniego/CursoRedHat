1. [Automatización de la instalación](#kickstart)
2. [Expresiones regulares y grep](#regular_expressions)
3. [Vim avanzado](#advanced_vim)
4. [Programación de tareas](#task_sched)

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

1. Crear un fichero de configuración kickstart
2. Publicar el fichero para el instalador: 
  * `ks=<medio>` indica dónde está el fichero (nfs, http, https, cd-rom, hd), Normalmente se lo diremon el la línea de arranque del kernel, pero hay virtualizadores donde podemos pasarle este parámetro.
3. Arrancar Anaconda y apuntar al fichero de configuración.



***

# Expresiones regulares y grep <a name="regular_expressions"></a>


***

# Vim avanzado <a name="advanced_vim"></a>

***

# Programación de tareas <a name="task_sched"></a>

