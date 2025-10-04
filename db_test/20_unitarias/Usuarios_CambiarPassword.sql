/* =============================================================================
   Script de PRUEBAS: 20_unitarias/Usuarios_CambiarPassword.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Cambiar password por flujo normal y por reset (prModificarPasswordUsuarios).
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

DECLARE @CodigoU INT;

-- Arrange: crear usuario
EXEC dbo.prInsertarUsuario
     @CodigoUsuario = @CodigoU OUTPUT,
     @NombreUsuario = 'Pass',
     @SegundoNombre = '',
     @ApellidoUsuario = 'Test',
     @SegundoApellido = '',
     @ApellidoCasada = '',
     @Email = 'pass@test.com',
     @Pass  = '1234';

PRINT 'Insertado CodigoUsuario=' + CONVERT(VARCHAR, @CodigoU);

-- Validar login inicial
PRINT 'Login inicial (1234)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = '1234';

-- Cambio normal (requiere pass anterior)
PRINT 'Cambio normal: 1234 -> 9999';
EXEC dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = '1234',
     @PassNuevo     = '9999',
     @resetear      = 0;

PRINT 'Login tras cambio normal (9999)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = '9999';

-- Reset (ignora pass anterior)
PRINT 'Reset: (xxxx) -> abcd';
EXEC dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = 'xxxx',
     @PassNuevo     = 'abcd',
     @resetear      = 1;

PRINT 'Login tras reset (abcd)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'abcd';

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';