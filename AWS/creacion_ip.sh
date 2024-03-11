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