/* ===========================================
   Proyecto: SuiteMDI-EduSQL
   Test: T-02-identity-perfiles-inicia-1000
   Objetivo: Verificar que el IDENTITY arranca en 1000
   Requisitos: 01_CrearBD_y_Tablas-mejorado.sql aplicado
   BD: Ejemplo_SIN_Encripcion
   Limpieza: ROLLBACK (sin efectos)
=========================================== */

USE [Ejemplo_SIN_Encripcion];
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @pre INT = IDENT_CURRENT('dbo.Perfiles');  -- puede ser NULL si no hay filas
    INSERT INTO dbo.Perfiles (NombreUsuario, ApellidoUsuario, Email)
    VALUES ('Smoke', 'Test', 'smoke@test.local');

    DECLARE @id INT = SCOPE_IDENTITY();

    IF @id < 1000
        RAISERROR('IDENTITY no inició en 1000 (obtenido: %d)', 16, 1, @id);

    ROLLBACK TRAN;
    PRINT 'OK: T-02-identity-perfiles-inicia-1000 (ID=' + CONVERT(varchar(12), @id) + ')';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT CONCAT('ERROR: ', ERROR_MESSAGE());
    THROW;
END CATCH;