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
##### El primer script que tenemos que hacer y ejecutar es el de los grupos de seguridad donde creamos sus grupos de seguridad y sus respectivas reglas,que se nos debería de quedar así:
~~~
#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Importamos las variables de entorno
source .env


#Creamos grupo de seguridad del Load Balancer

aws ec2 create-security-group \
    --group-name  $SECURITY_GROUP_LOAD_BALANCER \
    --description "Reglas para el Load balancer"

#Añadimos reglas del grupo de load balancer

aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_LOAD_BALANCER \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_LOAD_BALANCER \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_LOAD_BALANCER \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

# Creamos el grupo de seguridad: nfs-sg
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NFS \
    --description "Reglas para el frontend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 2049 \
    --cidr 0.0.0.0/0

# Creamos el grupo de seguridad: frontend-sg
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_FRONTEND \
    --description "Reglas para el frontend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_FRONTEND \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_FRONTEND \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_FRONTEND \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0


# Creamos el grupo de seguridad: backend-sg
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_BACKEND \
    --description "Reglas para el backend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_BACKEND \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso para MySQL
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_BACKEND \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
~~~
##### El segundo script que debemos ejecutar es el de crear las instancias, que se nos debe quedar algo así:
~~~
#!/bin/bash
set -ex

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Importamos las variables de entorno
source .env

#CREAMOS LAS INSTANCIAS

# Creamos una intancia EC2 para el load balancer
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_LOAD_BALANCER \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_LOAD_BALANCER}]"

# Creamos una intancia EC2 para el frontend-1
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND}]"

# Creamos una intancia EC2 para el frontend-2
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_NFSERVER}]"

# Creamos una intancia EC2 para el backend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]"
~~~
##### En tercer lugar creamos el script para crear y asociar las ips elásticas a las máquinas, se nos debe quedar así:
~~~
#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Importamos las variables de entorno
source .env

#IP LOAD BALANCER
# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID_lb=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Creamos una IP elástica
ELASTIC_IP_lb=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica a la instancia del balanceador
aws ec2 associate-address --instance-id $INSTANCE_ID_lb --public-ip $ELASTIC_IP_lb

#IP FRONTEND 1
# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID_ft1=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Creamos una IP elástica
ELASTIC_IP_ft1=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica a la instancia del balanceador
aws ec2 associate-address --instance-id $INSTANCE_ID_ft1 --public-ip $ELASTIC_IP_ft1



#IP nfs
# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID_nfs=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME_NFSERVER" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Creamos una IP elástica
ELASTIC_IP_nfs=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica a la instancia del balanceador
aws ec2 associate-address --instance-id $INSTANCE_ID_nfs --public-ip $ELASTIC_IP_nfs


#IP Backend
# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID_bk=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Creamos una IP elástica
ELASTIC_IP_bk=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica a la instancia del balanceador
aws ec2 associate-address --instance-id $INSTANCE_ID_bk --public-ip $ELASTIC_IP_bk
~~~
#### Ya con esto tendriamos las instancias con los grupos e ips creadas
####
#### Pero ahora hemos creado dos scripts para eliminar las instancias y los grupos de seguridad
##### El primero que creamos fue el de eliminar las insntancias que se debería ver así:
~~~
#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Importamos las variables de entorno
source .env


#BORRAMOS LOAD BALANCER
#Sacamos el id
INSTANCE_ID_lb=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LOAD_BALANCER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


#Terminamos una instancia

aws ec2 terminate-instances --instance-ids $INSTANCE_ID_lb


#BORRAMOS FORNTEND_1
#Sacamos el id
INSTANCE_ID_fr1=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


#Terminamos una instancia

aws ec2 terminate-instances --instance-ids $INSTANCE_ID_fr1

#BORRAMOS FORNTEND_2
#Sacamos el id
INSTANCE_ID_nfs=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_NFSERVER" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


#Terminamos una instancia

aws ec2 terminate-instances --instance-ids $INSTANCE_ID_nfs

#BORRAMOS BACKEND

#Sacamos el id

INSTANCE_ID_bk=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


#Terminamos una instancia

aws ec2 terminate-instances --instance-ids $INSTANCE_ID_bk
~~~
##### Y por último tenemos el script para eliminar los grupos de seguridad, que se nos debería ver así:
~~~
#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Importamos las variables de entorno
source .env

#Buscamos el id del grupo del load balancer

ID_GRUPO_lb=$(aws ec2 describe-security-groups \
            --group-names $SECURITY_GROUP_LOAD_BALANCER \
            --query "SecurityGroups[*].GroupId" \
            --output text)

#Borramos el grupo de seguridad load balancer

aws ec2 delete-security-groups --group-ids $ID_GRUPO_lb

#Buscamos el id del grupo del load frontend

ID_GRUPO_f=$(aws ec2 describe-security-groups \
            --group-names $SECURITY_GROUP_FRONTEND \
            --query "SecurityGroups[*].GroupId" \
            --output text)

#Borramos el grupo de seguridad load balancer

aws ec2 delete-security-groups --group-ids $ID_GRUPO_f

#Buscamos el id del grupo del load balancer

ID_GRUPO_b=$(aws ec2 describe-security-groups \
            --group-names $SECURITY_GROUP_LOAD_BALANCER \
            --query "SecurityGroups[*].GroupId" \
            --output text)

#Borramos el grupo de seguridad load balancer

aws ec2 delete-security-groups --group-ids $ID_GRUPO_b
~~~
#### Las ips no las tenemos que borrar ya que se borran solas cuando eliminamos las instancias.
#### Y por último el .env donde he guardado las variables.
~~~
AMI_ID=ami-07d9b9ddc6cd8dd30
COUNT=1
INSTANCE_TYPE=t2.small
KEY_NAME=vockey

SECURITY_GROUP_LOAD_BALANCER=loadbalancer-sg
SECURITY_GROUP_FRONTEND=frontend-sg
SECURITY_GROUP_NFS=nfs-sg
SECURITY_GROUP_BACKEND=backend-sg

INSTANCE_NAME_LOAD_BALANCER=load_balancer
INSTANCE_NAME_FRONTEND=frontend_1
INSTANCE_NAME_NFSERVER=NFSserver
INSTANCE_NAME_BACKEND=backend
~~~
