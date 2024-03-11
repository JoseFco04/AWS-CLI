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