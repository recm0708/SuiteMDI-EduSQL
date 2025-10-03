/* =============================================================================
   Test:    05_prEliminarUsuario.sql
   Grupo:   db_test / 20_unitarias
   Objetivo:
     - Verificar que dbo.prEliminarUsuario:
       * Devuelve 1 y elimina cuando el usuario existe.
       * Devuelve 0 cuando el usuario no existe.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

PRINT '>> Preparar: insertar usuario temporal para eliminar';
DECLARE @nuevo INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario   = @nuevo OUTPUT,
     @NombreUsuario   = 'TmpDelete',
     @SegundoNombre   = '',
     @ApellidoUsuario = 'Unit',
     @SegundoApellido = '',
     @ApellidoCasada  = '',
     @Email           = 'tmp.delete@unit.test',
     @Pass            = 'TmpPass123';

SELECT Prep_CodigoCreado = @nuevo;

PRINT '>> Eliminar usuario existente';
DECLARE @rc1 INT;
EXEC @rc1 = dbo.prEliminarUsuario @CodigoUsuario = @nuevo;
SELECT RC_EliminarExistente = @rc1;   -- Esperado: 1

PRINT '>> Validar que ya no exista';
SELECT Existe = COUNT(*) FROM dbo.Perfiles WHERE CodigoUsuario = @nuevo;

PRINT '>> Intentar eliminar un código inexistente';
DECLARE @rc2 INT;
EXEC @rc2 = dbo.prEliminarUsuario @CodigoUsuario = -999999;
SELECT RC_EliminarInexistente = @rc2; -- Esperado: 0