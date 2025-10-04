/* =============================================================================
   Script de PRUEBAS: 01_CrearBD_y_Tablas_Test.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Verificar existencia de la BD, tabla Perfiles y PK.
     - Verificar existencia de LOGIN/USER [UsrProcesa].
     - Verificar reseed correcto del IDENTITY de Perfiles.
   Notas:
     - Sin :setvar. Usa TRY...CATCH y ROLLBACK por defecto.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @DbName SYSNAME = N'Ejemplo_SIN_Encripcion';
DECLARE @Login  SYSNAME = N'UsrProcesa';

IF DB_ID(@DbName) IS NULL
BEGIN
    THROW 51000, 'DB no existe. Ejecuta primero el script base 01.', 1;
END

DECLARE @sqlUse NVARCHAR(MAX) = N'USE [' + @DbName + N'];';
EXEC (@sqlUse);

BEGIN TRY
    BEGIN TRAN;

    -- 1) Objetos existen
    IF OBJECT_ID(N'dbo.Perfiles', N'U') IS NULL
        THROW 51001, 'Falta tabla dbo.Perfiles', 1;

    IF NOT EXISTS (
        SELECT 1 FROM sys.key_constraints
        WHERE name = N'PK_Perfiles'
          AND parent_object_id = OBJECT_ID(N'dbo.Perfiles')
    )
        THROW 51002, 'Falta PK_Perfiles', 1;

    -- 2) Seguridad DEV
    IF SUSER_ID(@Login) IS NULL
        THROW 51003, 'Falta LOGIN [UsrProcesa]', 1;

    IF USER_ID(@Login) IS NULL
        THROW 51004, 'Falta USER [UsrProcesa] en la BD', 1;

    -- 3) IDENTITY se incrementa desde 1000
    DECLARE @id1 INT, @id2 INT;

    INSERT INTO dbo.Perfiles (NombreUsuario, ApellidoUsuario, Email)
    VALUES ('Test', 'Uno', 'test+uno@local');

    SET @id1 = SCOPE_IDENTITY();

    INSERT INTO dbo.Perfiles (NombreUsuario, ApellidoUsuario, Email)
    VALUES ('Test', 'Dos', 'test+dos@local');

    SET @id2 = SCOPE_IDENTITY();

    IF @id1 < 1000 OR @id2 <> @id1 + 1
        THROW 51005, 'El IDENTITY no está en el rango esperado (>=1000 y secuencial).', 1;

    PRINT 'OK: BD/Tabla/PK/Login/User e IDENTITY verificados.';
    ROLLBACK TRAN;  -- no persistir datos de prueba
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @num INT = ERROR_NUMBER();
    DECLARE @sev INT = ERROR_SEVERITY();
    DECLARE @st INT = ERROR_STATE();
    RAISERROR('Fallo de prueba (%d): %s', @sev, @st, @num, @msg);
END CATCH;