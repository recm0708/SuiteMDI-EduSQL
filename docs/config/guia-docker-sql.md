# Guía: SQL Server 2022 en Docker (Windows)

## Requisitos
- Docker Desktop instalado y en ejecución.
- Puerto externo 2333 libre.

## Crear contenedor
# Cambia "TU_PASSWORD_SA" por una contraseña fuerte.
docker pull mcr.microsoft.com/mssql/server:2022-latest

docker run -d ^
  --name mssql2022 ^
  -e "ACCEPT_EULA=Y" ^
  -e "MSSQL_SA_PASSWORD=TU_PASSWORD_SA" ^
  -p 2333:1433 ^
  --restart unless-stopped ^
  mcr.microsoft.com/mssql/server:2022-latest

## Verificar
docker ps
docker logs mssql2022

## Conectar desde SSMS
- Server: 127.0.0.1,2333
- Login: sa
- Password: TU_PASSWORD_SA

## Operaciones útiles
# Reiniciar
docker restart mssql2022

# Detener / iniciar
docker stop mssql2022
docker start mssql2022

# Eliminar (borra datos del contenedor)
docker rm -f mssql2022

## Persistencia (opcional, usar volumen)
# Crea contenedor mapeando volumen local C:\SqlData a /var/opt/mssql
docker run -d ^
  --name mssql2022 ^
  -e "ACCEPT_EULA=Y" ^
  -e "MSSQL_SA_PASSWORD=TU_PASSWORD_SA" ^
  -p 2333:1433 ^
  -v "C:\SqlData":/var/opt/mssql ^
  --restart unless-stopped ^
  mcr.microsoft.com/mssql/server:2022-latest

## Troubleshooting
- Error de login 18456 → verifica password o políticas.
- Timeout → confirma que el contenedor está "Up" y el puerto 2333 no esté ocupado.
- Certificado/SSL → usa TrustServerCertificate=True en la cadena de conexión mientras desarrollas.