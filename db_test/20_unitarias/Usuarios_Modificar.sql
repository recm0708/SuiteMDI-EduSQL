/* =============================================================================
   Script de PRUEBAS: 20_unitarias/Usuarios_Modificar.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Insertar un usuario y modificar sus datos con prModificarUsuarios.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario = @CodigoU OUTPUT,
     @NombreUsuario = 'Juan',
     @SegundoNombre = 'P',
     @ApellidoUsuario = 'Perez',
     @SegundoApellido = 'G',
     @ApellidoCasada = '',
     @Email = 'juan.perez@test.com',
     @Pass  = 'abc123';

PRINT 'Insertado CodigoUsuario=' + CONVERT(VARCHAR, @CodigoU);

-- Modificar
EXEC dbo.prModificarUsuarios
     @CodigoUsuario  = @CodigoU,
     @NombreUsuario  = 'Juan Edit',
     @SegundoNombre  = 'P',
     @ApellidoUsuario= 'Perez',
     @SegundoApellido= 'G',
     @ApellidoCasada = '',
     @Email          = 'juan.edit@test.com';

-- Assert
SELECT TOP 1 CodigoUsuario, NombreUsuario, Email
FROM dbo.Perfiles
WHERE CodigoUsuario = @CodigoU;

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';