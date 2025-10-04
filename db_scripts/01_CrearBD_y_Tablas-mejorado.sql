/* =============================================================================
   Script:         01_CrearBD_y_Tablas-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear (si no existe) la base de datos [Ejemplo_SIN_Encripcion].
     - Crear la tabla dbo.Perfiles con IDENTITY desde 1000 y PK.
     - Crear LOGIN/USER [UsrProcesa] (DEV) y asignar db_owner en la BD.
     - Dejar el IDENTITY en Perfiles correctamente reseedeado.
   Notas:
     - Script idempotente (re-ejecutable sin fallar).
     - Sin uso de :setvar; parámetros definidos con DECLARE.
     - Las pruebas se mueven a db_test/ (no se incluyen aquí).
   Observación:
     Este script ha sido reorganizado y documentado con prácticas de robustez
     (idempotencia, validaciones, permisos y comentarios). Mantiene la intención
     funcional del material original del Prof. José Ortiz, pero su estructura,
     orden y comentarios han sido refactorizados para uso académico-profesional
     en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

/* ---------------------------------------------------------------------------
   1) Parámetros generales
--------------------------------------------------------------------------- */
DECLARE @DbName        SYSNAME        = N'Ejemplo_SIN_Encripcion';
DECLARE @LoginName     SYSNAME        = N'UsrProcesa';
DECLARE @LoginPassword NVARCHAR(128)  = N'Panama-utp@2025';  -- DEV: cambia en PROD

/* ---------------------------------------------------------------------------
   2) Crear BD si no existe (no se hace DROP por defecto)
--------------------------------------------------------------------------- */
IF DB_ID(@DbName) IS NULL
BEGIN
    DECLARE @sqlCreateDb NVARCHAR(MAX) =
        N'CREATE DATABASE [' + @DbName + N'];';
    EXEC (@sqlCreateDb);
END

/* ---------------------------------------------------------------------------
   3) Contexto a la BD de trabajo
--------------------------------------------------------------------------- */
DECLARE @sqlUseDb NVARCHAR(MAX) = N'USE [' + @DbName + N'];';
EXEC (@sqlUseDb);

/* ---------------------------------------------------------------------------
   4) Tabla principal: dbo.Perfiles (solo si no existe)
--------------------------------------------------------------------------- */
IF OBJECT_ID(N'dbo.Perfiles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Perfiles
    (
        CodigoUsuario    INT IDENTITY(1000, 1) NOT NULL,   -- comienza en 1000
        NombreUsuario    VARCHAR(50)     NULL,
        SegundoNombre    VARCHAR(50)     NULL,
        ApellidoUsuario  VARCHAR(50)     NULL,
        SegundoApellido  VARCHAR(50)     NULL,
        ApellidoCasada   VARCHAR(50)     NULL,
        Email            VARCHAR(100)    NULL,
        Pass             VARBINARY(128)  NULL
    );

    ALTER TABLE dbo.Perfiles
        ADD CONSTRAINT PK_Perfiles PRIMARY KEY (CodigoUsuario);
END

/* ---------------------------------------------------------------------------
   5) Seguridad DEV: LOGIN a nivel servidor y USER en la BD
      - En PROD asignar mínimos permisos; db_owner solo para DEV.
--------------------------------------------------------------------------- */
-- Crear LOGIN si no existe
IF SUSER_ID(@LoginName) IS NULL
BEGIN
    DECLARE @sqlCreateLogin NVARCHAR(MAX) =
        N'CREATE LOGIN [' + @LoginName + N'] WITH ' +
        N'PASSWORD = ' + QUOTENAME(@LoginPassword, '''') + N',' +
        N'CHECK_POLICY = ON, CHECK_EXPIRATION = OFF, ' +
        N'DEFAULT_DATABASE = [' + @DbName + N'];';
    EXEC (@sqlCreateLogin);
END

-- Crear USER en la BD si no existe
IF USER_ID(@LoginName) IS NULL
BEGIN
    DECLARE @sqlCreateUser NVARCHAR(MAX) =
        N'CREATE USER [' + @LoginName + N'] FOR LOGIN [' + @LoginName + N'] WITH DEFAULT_SCHEMA=[dbo];';
    EXEC (@sqlCreateUser);
END

-- Agregar a db_owner (DEV). En PROD: restringir a permisos mínimos.
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id AND r.name = N'db_owner'
    JOIN sys.database_principals m ON m.principal_id = drm.member_principal_id AND m.name = @LoginName
)
BEGIN
    DECLARE @sqlAddToDbOwner NVARCHAR(MAX) =
        N'ALTER ROLE [db_owner] ADD MEMBER [' + @LoginName + N'];';
    EXEC (@sqlAddToDbOwner);
END

/* ---------------------------------------------------------------------------
   6) Asegurar reseed correcto del IDENTITY en Perfiles
      - Si hay filas, reseed a MAX(CodigoUsuario)
      - Si no hay filas, reseed a 999 -> el próximo será 1000
--------------------------------------------------------------------------- */
DECLARE @mx INT = (SELECT ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles);
DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @mx) WITH NO_INFOMSGS;