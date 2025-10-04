/* =============================================================================
   Script de PRUEBAS: 20_unitarias/Usuarios_Insertar_Validar.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Insertar usuario con prInsertarUsuario.
     - Validar login con prValidarUsuario.
     - Consultar usuario con prConsultarUsuarios.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario = @CodigoU OUTPUT,
     @NombreUsuario = 'Test',
     @SegundoNombre = '',
     @ApellidoUsuario = 'Unit',
     @SegundoApellido = '',
     @ApellidoCasada = '',
     @Email = 'unit@test.com',
     @Pass  = '123456';

PRINT 'Nuevo CodigoUsuario=' + CONVERT(VARCHAR, @CodigoU);

PRINT '== Validar login ==';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = '123456';

PRINT '== Consultar (uno) ==';
EXEC dbo.prConsultarUsuarios @CodigoUsuario = @CodigoU;

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';