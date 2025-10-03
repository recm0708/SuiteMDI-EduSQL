/* =============================================================================
   Test:    07_cambio_y_reset_password_e2e.sql
   Proyecto: SuiteMDI-EduSQL (db_test / integracion)
   Objetivo:
     - Flujo completo: inserción, cambio normal, validaciones, reset y limpieza.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: prInsertarUsuario, prModificarPasswordUsuarios, prValidarUsuario
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

DECLARE @CodigoU INT;
PRINT '>> Insertar usuario E2E';
EXEC dbo.prInsertarUsuario
     @CodigoUsuario    = @CodigoU OUTPUT,
     @NombreUsuario    = 'E2E07',
     @SegundoNombre    = 'Flow',
     @ApellidoUsuario  = 'Pass',
     @SegundoApellido  = 'Change',
     @ApellidoCasada   = '',
     @Email            = 'e2e07.flow@test.local',
     @Pass             = 'E2E_Old!';
SELECT CodigoCreado = @CodigoU;

PRINT '>> Cambio normal a E2E_New!';
DECLARE @rc1 INT;
EXEC @rc1 = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = 'E2E_Old!',
     @PassNuevo     = 'E2E_New!',
     @Resetear      = 0;
SELECT RC_Cambio = @rc1;

PRINT '>> Validar login con nueva';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'E2E_New!';

PRINT '>> Reset a E2E_Reset!';
DECLARE @rc2 INT;
EXEC @rc2 = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = NULL,
     @PassNuevo     = 'E2E_Reset!',
     @Resetear      = 1;
SELECT RC_Reset = @rc2;

PRINT '>> Validar login con reset';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'E2E_Reset!';

PRINT '>> Limpieza';
DELETE FROM dbo.Perfiles WHERE CodigoUsuario = @CodigoU;
GO