/* =============================================================================
   Script de PRUEBAS: 30_integracion/Flujo_Login_MDI_Smoke.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Verificar SELECT 1, existencia de objetos base y flujo de login mínimo.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

PRINT '== SELECT 1 ==';
SELECT 1 AS One;

PRINT '== Objetos críticos ==';
EXEC('SELECT IIF(OBJECT_ID(''dbo.Perfiles'',''U'') IS NOT NULL, ''OK'',''FALTA'') AS Perfiles');

PRINT '== Smoke SPs (02–07) ==';
SELECT p.name AS SP_Name
FROM sys.procedures p
WHERE p.name IN (
   'prValidarUsuario','prInsertarUsuario','prConsultarUsuarios',
   'prEliminarUsuarios','prModificarUsuarios','prModificarPasswordUsuarios'
);

-- Flujo: crear usuario, validar, limpiar (rollback)
DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario = @CodigoU OUTPUT,
     @NombreUsuario = 'Smoke',
     @SegundoNombre = '',
     @ApellidoUsuario = 'Test',
     @SegundoApellido = '',
     @ApellidoCasada = '',
     @Email = 'smoke@test.com',
     @Pass  = 'smk';

PRINT 'Validar login (smk)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'smk';

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';