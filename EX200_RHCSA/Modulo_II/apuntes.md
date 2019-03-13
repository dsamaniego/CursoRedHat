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

* . --> Cualquier caracter
* [abc] --> Cualquiera de a, b o c (sólo 1).
* * --> El carácter anterior 0 o más veces repetido (ej: .* ==> cualquier carácter, 0 o más veces repetidos)
* + --> El caracter anterior 1 o más veces repetido.
* \{_n_\} --> repetir _n_ veces la expresión anterior (ej: c.\{2\}t ==> c seguida de dos cacracteres cualesquiera y seguido de t).

**NOTA:** si no queremos que nos hagan sustituciones el shell, envolver la expresión regular con comillas simples.

Ayuda: **regex(7)**

## grep



***

# Vim avanzado <a name="advanced_vim"></a>

***

# Programación de tareas <a name="task_sched"></a>

