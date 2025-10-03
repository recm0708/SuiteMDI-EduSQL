/* ===========================================
   Proyecto: SuiteMDI-EduSQL
   Test: T-01-smoke-objetos-principales
   Objetivo: Verificar existencia de BD, tabla Perfiles y PK
   Requisitos: 01_CrearBD_y_Tablas-mejorado.sql aplicado
   BD: Ejemplo_SIN_Encripcion
   Limpieza: Sin efectos
=========================================== */

USE [Ejemplo_SIN_Encripcion];
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    -- DB
    IF DB_ID('Ejemplo_SIN_Encripcion') IS NULL
        RAISERROR('BD no existe', 16, 1);

    -- Tabla
    IF OBJECT_ID('dbo.Perfiles','U') IS NULL
        RAISERROR('dbo.Perfiles no existe', 16, 1);

    -- PK
    IF NOT EXISTS (
        SELECT 1 FROM sys.key_constraints
        WHERE [name] = 'PK_Perfiles' AND [type] = 'PK'
    )
        RAISERROR('PK_Perfiles no existe', 16, 1);

    PRINT 'OK: T-01-smoke-objetos-principales';
END TRY
BEGIN CATCH
    PRINT CONCAT('ERROR: ', ERROR_MESSAGE());
    THROW;
END CATCH;