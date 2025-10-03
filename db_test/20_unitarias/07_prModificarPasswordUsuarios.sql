/* =============================================================================
   Test:    07_prModificarPasswordUsuarios.sql
   Proyecto: SuiteMDI-EduSQL (db_test / unitarias)
   Objetivo:
     - Verificar cambio de contraseña normal (coincide/no coincide) y reset administrativo.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: prInsertarUsuario, prModificarPasswordUsuarios, prValidarUsuario
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

DECLARE @CodigoU INT;

PRINT '>> Insertar usuario temporal para pruebas';
EXEC dbo.prInsertarUsuario
     @CodigoUsuario    = @CodigoU OUTPUT,
     @NombreUsuario    = 'Temp07',
     @SegundoNombre    = 'Unit',
     @ApellidoUsuario  = 'Pass',
     @SegundoApellido  = 'Test',
     @ApellidoCasada   = '',
     @Email            = 'temp07.unit@test.local',
     @Pass             = 'Old07!';
SELECT CodigoCreado = @CodigoU;

PRINT '>> Cambio NORMAL con Pass incorrecta (esperado RC=0)';
DECLARE @rcBad INT;
EXEC @rcBad = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = 'Wrong!',
     @PassNuevo     = 'New07!',
     @Resetear      = 0;
SELECT RC_CambioIncorrecto = @rcBad;

PRINT '>> Cambio NORMAL con Pass correcta (esperado RC=1)';
DECLARE @rcOk INT;
EXEC @rcOk = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = 'Old07!',
     @PassNuevo     = 'New07!',
     @Resetear      = 0;
SELECT RC_CambioCorrecto = @rcOk;

PRINT '>> Validar login con Pass NUEVA (debe devolver filas)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'New07!';

PRINT '>> Validar login con Pass ANTIGUA (debe devolver 0 filas)';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'Old07!';

PRINT '>> RESET administrativo (ignora PassAnterior) (esperado RC=1)';
DECLARE @rcReset INT;
EXEC @rcReset = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @CodigoU,
     @PassAnterior  = NULL,
     @PassNuevo     = 'Reset07!',
     @Resetear      = 1;
SELECT RC_Reset = @rcReset;

PRINT '>> Validar login con Pass RESET';
EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = 'Reset07!';

PRINT '>> Limpieza';
DELETE FROM dbo.Perfiles WHERE CodigoUsuario = @CodigoU;
GO