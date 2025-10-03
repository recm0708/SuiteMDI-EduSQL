/* =============================================================================
   Test:    05_eliminar_usuario_end_to_end.sql
   Grupo:   db_test / 30_integracion
   Objetivo:
     - Flujo E2E: Insertar usuario -> Consultar -> Eliminar -> Confirmar baja
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

PRINT '>> Insertar usuario (E2E)';
DECLARE @id INT;
EXEC dbo.prInsertarUsuario
     @CodigoUsuario   = @id OUTPUT,
     @NombreUsuario   = 'TmpE2E',
     @SegundoNombre   = 'X',
     @ApellidoUsuario = 'Eliminar',
     @SegundoApellido = 'Y',
     @ApellidoCasada  = '',
     @Email           = 'tmp.e2e@demo.test',
     @Pass            = 'Pass!E2E';
SELECT CodigoCreado = @id;

PRINT '>> Consultar (debería traer uno)';
EXEC dbo.prConsultarUsuarios @CodigoUsuario = @id;

PRINT '>> Eliminar';
DECLARE @rc INT;
EXEC @rc = dbo.prEliminarUsuario @CodigoUsuario = @id;
SELECT RC_Eliminar = @rc;  -- Esperado: 1

PRINT '>> Consultar nuevamente (no debería traer filas)';
EXEC dbo.prConsultarUsuarios @CodigoUsuario = @id;