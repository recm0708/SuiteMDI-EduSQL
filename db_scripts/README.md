# Guía de scripts SQL (orden y propósito)

## Orden de ejecución (SSMS → 127.0.0.1,2333)
01) 01_CrearBD_y_Tablas-mejorado.sql
    - Crea DB Ejemplo_SIN_Encripcion
    - Tabla dbo.Perfiles (IDENTITY 1000,1; Pass VARBINARY(128))
    - Login/User UsrProcesa (rol db_owner en DEV)
    - Idempotente + comentarios

02) 02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
    - SP dbo.prValidarUsuario(@Codigo, @Pass)
    - Comparación VARBINARY = CONVERT(VARBINARY(128), @Pass)

03) 03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql
    - SP dbo.prInsertarUsuario (OUTPUT @CodigoUsuario)
    - Inserta Pass como VARBINARY(128)

04) 04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql
    - SP dbo.prConsultarUsuarios(@CodigoUsuario)
    - 0 → todos; >0 → uno; NUNCA retorna Pass

05) 05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql
    - SP dbo.prEliminarUsuarios(@CodigoUsuario)
    - RETURN @@ROWCOUNT

06) 06_CrearProcedimiento_de_Modificar_de_Usuario-modificado.sql
    - SP dbo.prModificarUsuarios(...)
    - RETURN @@ROWCOUNT

07) 07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
    - SP dbo.prModificarPasswordUsuarios(@Codigo, @PassAnterior, @PassNuevo, @Resetear)
    - RETURN @@ROWCOUNT (1=ok,0=falló)

08) 08_TablasDelAplicativo-mejorado.sql
    - Tablas Clientes, Departamentos, Servicios, Solicitudes (+ detalle), Facturas (+ detalle), Recibos (+ detalle)
    - Indices y FKs (idempotente). Campo Dirrecion normalizado

09) 09_ProcedimientosAplicativo-mejorado.sql
    - SPs de Solicitudes, Consultas avanzadas, etc.

10) 10_Mantenimiento_Reseed_Perfiles.sql
    - DEV: realinea IDENTITY de Perfiles al MAX(CodigoUsuario)

11) 11_Clientes_CRUD-mejorado.sql
    - SPs Insertar/Modificar/Eliminar/Consultar Clientes (con Dirrecion)

## Pruebas
- Cada archivo incluye ejemplos comentados.
- Smoke test global: utils/00_smoke_test.sql

## Convenciones
- Schema dbo explícito
- Idempotencia: IF OBJECT_ID(...) IS NULL / DROP IF EXISTS
- RETURN @@ROWCOUNT en operaciones DML