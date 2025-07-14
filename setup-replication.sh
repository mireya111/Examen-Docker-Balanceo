#!/bin/bash

# Configuración de replicación MySQL Master-Slave

echo "Esperando a que los servidores MySQL estén listos..."
sleep 30

echo "Configurando usuario de replicación en maestro1..."
docker exec examen-docker-balanceo-maestro1-1 mysql -uroot -proot -e "
CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY 'replication_pass';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
FLUSH PRIVILEGES;
"

echo "Obteniendo información del maestro..."
MASTER_STATUS=$(docker exec examen-docker-balanceo-maestro1-1 mysql -uroot -proot -e "SHOW MASTER STATUS;" | tail -n 1)
MASTER_FILE=$(echo $MASTER_STATUS | awk '{print $1}')
MASTER_POSITION=$(echo $MASTER_STATUS | awk '{print $2}')

echo "Master File: $MASTER_FILE"
echo "Master Position: $MASTER_POSITION"

echo "Configurando esclavo (maestro2)..."
docker exec examen-docker-balanceo-maestro2-1 mysql -uroot -proot -e "
STOP SLAVE;
CHANGE MASTER TO 
  MASTER_HOST='maestro1',
  MASTER_USER='replication',
  MASTER_PASSWORD='replication_pass',
  MASTER_LOG_FILE='$MASTER_FILE',
  MASTER_LOG_POS=$MASTER_POSITION;
START SLAVE;
"

echo "Verificando estado del esclavo..."
docker exec examen-docker-balanceo-maestro2-1 mysql -uroot -proot -e "SHOW SLAVE STATUS\G"

echo "Configuración de replicación completada!"
