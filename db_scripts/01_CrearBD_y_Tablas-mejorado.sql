/* =============================================================================
   Script:   01_CrearBD_y_Tablas-mejorado.sql
   Proyecto: SuiteMDI-EduSQL
   Objetivo:
     - (Opcional) Eliminar y crear la BD Ejemplo_SIN_Encripcion (solo DEV)
     - Crear tabla dbo.Perfiles (IDENTITY desde 1000) con PK
     - Crear LOGIN/USER [UsrProcesa] y (DEV) agregar a db_owner
   Notas:
     - Se mantiene VARCHAR (compatibilidad con scripts originales). Para soporte
       completo de tildes, usar NVARCHAR y literales N'...'.
     - El campo Pass queda VARBINARY(128) según especificación “Sin_Encripcion”.
     - Las PRUEBAS se movieron a /db_tests (ver README).
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

/* ---------------------------------------------------------------------------
   0) Parámetros (ajusta para tu entorno)
--------------------------------------------------------------------------- */
DECLARE @DbName        SYSNAME        = N'Ejemplo_SIN_Encripcion';
DECLARE @LoginName     SYSNAME        = N'UsrProcesa';
DECLARE @LoginPassword NVARCHAR(128)  = N'Panama-utp@2025'; -- DEV: cambia en PRODUCCIÓN

/* ---------------------------------------------------------------------------
   1) (OPCIONAL DEV) Eliminar BD si existe
   - Comenta este bloque si NO quieres recrear la base en cada ejecución.
--------------------------------------------------------------------------- */
IF DB_ID(@DbName) IS NOT NULL
BEGIN
    -- Forzamos a SINGLE_USER para evitar bloqueos por conexiones activas
    DECLARE @sql NVARCHAR(MAX) =
        N'ALTER DATABASE ' + QUOTENAME(@DbName) + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;';
    EXEC (@sql);

    SET @sql = N'DROP DATABASE ' + QUOTENAME(@DbName) + N';';
    EXEC (@sql);
END
GO

/* ---------------------------------------------------------------------------
   2) Crear BD si no existe
--------------------------------------------------------------------------- */
IF DB_ID(N'Ejemplo_SIN_Encripcion') IS NULL
BEGIN
    CREATE DATABASE [Ejemplo_SIN_Encripcion];
END
GO

/* ---------------------------------------------------------------------------
   3) Tablas del aplicativo
--------------------------------------------------------------------------- */
USE [Ejemplo_SIN_Encripcion];
GO

-- Crea la tabla dbo.Perfiles solo si no existe
IF OBJECT_ID(N'dbo.Perfiles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Perfiles
    (
        CodigoUsuario    INT            IDENTITY(1000, 1) NOT NULL,  -- inicia en 1000
        NombreUsuario    VARCHAR(50)    NULL,
        SegundoNombre    VARCHAR(50)    NULL,
        ApellidoUsuario  VARCHAR(50)    NULL,
        SegundoApellido  VARCHAR(50)    NULL,
        ApellidoCasada   VARCHAR(50)    NULL,
        Email            VARCHAR(100)   NULL,
        Pass             VARBINARY(128) NULL   -- reservado para almacenamiento binario (p.ej. hash/encripción)
    );

    ALTER TABLE dbo.Perfiles
        ADD CONSTRAINT PK_Perfiles PRIMARY KEY (CodigoUsuario);
END
GO

/* ---------------------------------------------------------------------------
   4) Seguridad DEV: LOGIN a nivel servidor y USER en la BD
   - En PROD: NO usar db_owner; dar permisos mínimos.
--------------------------------------------------------------------------- */
USE [master];
GO

-- Recrea el LOGIN (opcional en DEV)
IF SUSER_ID(@LoginName) IS NOT NULL
BEGIN
    DECLARE @drop NVARCHAR(MAX) = N'DROP LOGIN ' + QUOTENAME(@LoginName) + N';';
    EXEC (@drop);
END
GO

DECLARE @create NVARCHAR(MAX) =
N'CREATE LOGIN ' + QUOTENAME(N'UsrProcesa') + N'
   WITH PASSWORD = N''' + REPLACE(N'Panama-utp@2025', '''', '''''') + N''',
        CHECK_POLICY = ON,
        CHECK_EXPIRATION = OFF,
        DEFAULT_DATABASE = ' + QUOTENAME(N'Ejemplo_SIN_Encripcion') + N';';
EXEC (@create);
GO

USE [Ejemplo_SIN_Encripcion];
GO

IF USER_ID(@LoginName) IS NULL
BEGIN
    DECLARE @createUser NVARCHAR(MAX) =
        N'CREATE USER ' + QUOTENAME(@LoginName) + N' FOR LOGIN ' + QUOTENAME(@LoginName) + N' WITH DEFAULT_SCHEMA = [dbo];';
    EXEC (@createUser);
END
GO

-- Agregar a db_owner SOLO si no es miembro (DEV)
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id AND r.name = N'db_owner'
    JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id AND m.name = @LoginName
)
BEGIN
    ALTER ROLE [db_owner] ADD MEMBER [UsrProcesa];
END
GO

/* ---------------------------------------------------------------------------
   5) (Opcional) Regla para IDs > 999 (IDENTITY ya lo cumple)
--------------------------------------------------------------------------- */
/*
ALTER TABLE dbo.Perfiles
    ADD CONSTRAINT CK_Perfiles_CodigoMayor999 CHECK (CodigoUsuario > 999);
GO
*/

/* ---------------------------------------------------------------------------
   6) Ajuste del IDENTITY (útil en DEV tras borrados manuales)
--------------------------------------------------------------------------- */
DECLARE @mx INT = (SELECT ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles);
DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @mx);
GO