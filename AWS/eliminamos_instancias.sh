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
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND_1" \
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