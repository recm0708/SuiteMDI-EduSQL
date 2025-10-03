# Quick Checks (verificación rápida)

## Previo
- Docker SQL 2022 arriba en 127.0.0.1,2333
- SSMS se conecta con sa / TU_PASSWORD_SA
- Ejecutados scripts 01 → 11 sin errores

## BD / SPs
- Ejecuta `db_scripts/utils/00_smoke_test.sql`
  - Todos los OBJECT_ID <> NULL para tablas y SPs esperados
  - SELECT TOP 5 sin error

## App (cuando exista la solución)
1) App.config local creado desde template:
   - ActiveDb = Docker
   - connectionStrings con TU_PASSWORD_SA
2) Compila en Release (VS 2022)
3) Inicia (Ctrl+F5)
4) Login:
   - Inserta usuario de prueba con `prInsertarUsuario` en SSMS
   - Valida con `prValidarUsuario` (mismo pass que insertaste)
5) Usuarios:
   - Refrescar (listar todos)
   - Buscar por código
   - Editar en grilla y Guardar edición (ver que `@@ROWCOUNT=1`)
   - Eliminar y volver a listar
6) Clientes:
   - Insertar con SPs (11_) y luego consultar desde app (cuando esté UI)
7) Password:
   - Cambiar con `prModificarPasswordUsuarios` (modo normal y reset)
   - Validar login con nueva contraseña

## Si algo falla
- Revisa App.config (ActiveDb, cadenas)
- Confirma DB/objetos con `00_smoke_test.sql`
- Revisa logs del contenedor: `docker logs mssql2022`
- Verifica puertos (2333) y credenciales