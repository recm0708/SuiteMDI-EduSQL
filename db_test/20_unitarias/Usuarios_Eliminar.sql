/* =============================================================================
   Script de PRUEBAS: 20_unitarias/Usuarios_Eliminar.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Insertar un usuario y eliminarlo con prEliminarUsuarios.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario = @CodigoU OUTPUT,
     @NombreUsuario = 'Del',
     @SegundoNombre = '',
     @ApellidoUsuario = 'Me',
     @SegundoApellido = '',
     @ApellidoCasada = '',
     @Email = 'del.me@test.com',
     @Pass  = 'del';

PRINT 'Insertado CodigoUsuario=' + CONVERT(VARCHAR, @CodigoU);

EXEC dbo.prEliminarUsuarios @CodigoUsuario = @CodigoU;

-- Assert: no debe existir
SELECT COUNT(*) AS Existe
FROM dbo.Perfiles
WHERE CodigoUsuario = @CodigoU;

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';