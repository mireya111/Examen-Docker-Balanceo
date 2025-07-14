# Configuración de replicación MySQL Master-Slave

Write-Host "Esperando a que los servidores MySQL estén listos..."
Start-Sleep -Seconds 30

Write-Host "Configurando usuario de replicación en maestro1..."
docker exec examen-docker-balanceo-maestro1-1 mysql -uroot -proot -e "CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY 'replication_pass'; GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%'; FLUSH PRIVILEGES;"

Write-Host "Obteniendo información del maestro..."
$masterStatus = docker exec examen-docker-balanceo-maestro1-1 mysql -uroot -proot -e "SHOW MASTER STATUS;" | Select-Object -Last 1
$statusParts = $masterStatus -split '\s+'
$masterFile = $statusParts[0]
$masterPosition = $statusParts[1]

Write-Host "Master File: $masterFile"
Write-Host "Master Position: $masterPosition"

Write-Host "Configurando esclavo (maestro2)..."
docker exec examen-docker-balanceo-maestro2-1 mysql -uroot -proot -e "STOP SLAVE; CHANGE MASTER TO MASTER_HOST='maestro1', MASTER_USER='replication', MASTER_PASSWORD='replication_pass', MASTER_LOG_FILE='$masterFile', MASTER_LOG_POS=$masterPosition; START SLAVE;"

Write-Host "Verificando estado del esclavo..."
docker exec examen-docker-balanceo-maestro2-1 mysql -uroot -proot -e "SHOW SLAVE STATUS\G"

Write-Host "Configuración de replicación completada!"
