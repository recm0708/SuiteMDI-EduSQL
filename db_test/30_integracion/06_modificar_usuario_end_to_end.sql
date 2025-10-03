/* =============================================================================
   Test:    06_modificar_usuario_end_to_end.sql
   Proyecto: SuiteMDI-EduSQL (db_test / integracion)
   Objetivo:
     - Flujo de extremo a extremo para modificación:
       Insertar -> Consultar -> Modificar -> Consultar -> Limpiar.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: prInsertarUsuario, prConsultarUsuarios, prModificarUsuarios
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '>> E2E: Insertar usuario inicial';
DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario    = @CodigoU OUTPUT,
     @NombreUsuario    = 'E2E06',
     @SegundoNombre    = 'Init',
     @ApellidoUsuario  = 'Caso',
     @SegundoApellido  = 'Mod',
     @ApellidoCasada   = '',
     @Email            = 'e2e06.init@test.local',
     @Pass             = 'E2E06Pass';

SELECT CodigoCreado = @CodigoU;

PRINT '>> Consultar antes de modificar';
EXEC dbo.prConsultarUsuarios @CodigoUsuario = @CodigoU;

PRINT '>> Modificar datos';
DECLARE @rc INT;

EXEC @rc = dbo.prModificarUsuarios
     @CodigoUsuario   = @CodigoU,
     @NombreUsuario   = 'E2E06_Edit',
     @SegundoNombre   = 'Init_Edit',
     @ApellidoUsuario = 'Caso_Edit',
     @SegundoApellido = 'Mod_Edit',
     @ApellidoCasada  = 'Casada_E2E',
     @Email           = 'e2e06.edit@test.local';

SELECT RC_Modificado = @rc;  -- esperado: 1

PRINT '>> Consultar después de modificar';
EXEC dbo.prConsultarUsuarios @CodigoUsuario = @CodigoU;

PRINT '>> Limpieza';
DELETE FROM dbo.Perfiles WHERE CodigoUsuario = @CodigoU;
GO