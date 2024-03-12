# AWS-CLI Jose Francisco León López
## En esta práctica vamos a automatizar la creación y eliminación de instancias,grupos de seguirdad e ip elásticas con aws-cli
### Para ello primero debemos instalar aws-cli en nuestra máquina.
#### Para instalaarlo primero descargamos un archivo .zip con la app de aws-cli
~~~
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
~~~
#### Despúes lo descomprimimos
~~~
unzip awscliv2.zip
~~~
#### Ejecutamos el script de instalación
~~~
sudo ./aws/install
~~~
#### Y ya comprobamos si está instalado y que versión tenemos
~~~
aws --version
~~~
#### Después lo tenemos que configurar y ponerle al igual que en terraform los datos que salen en el laboratorio de aws
~~~
aws configure
~~~
#### Nos preguntará por estos datos que debemos poner los de nuestro laboratorio de aws que cambia cada vez que inicias el laboratorio:
~~~
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]: 
~~~
#### Una vez configurado creamos los scripts:
##### El primer script que tenemos que hacer y ejecutar es el de los grupos de seguridad que se nos debería de quedar así:
~~~

~~~
