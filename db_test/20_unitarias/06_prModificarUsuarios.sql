/* =============================================================================
   Test:    06_prModificarUsuarios.sql
   Proyecto: SuiteMDI-EduSQL (db_test / unitarias)
   Objetivo:
     - Verificar que prModificarUsuarios actualiza datos (RC=1) para un usuario existente
       y devuelve RC=0 para usuario inexistente.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: prInsertarUsuario, prModificarUsuarios
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '>> Preparar: insertar usuario temporal';
DECLARE @CodigoU INT;

EXEC dbo.prInsertarUsuario
     @CodigoUsuario    = @CodigoU OUTPUT,
     @NombreUsuario    = 'Temp06',
     @SegundoNombre    = 'Unit',
     @ApellidoUsuario  = 'Prueba',
     @SegundoApellido  = 'Mod',
     @ApellidoCasada   = '',
     @Email            = 'temp06.unit@test.local',
     @Pass             = 'UnitPass06';

SELECT CodigoCreado = @CodigoU;

PRINT '>> Modificar usuario existente';
DECLARE @rc1 INT;

EXEC @rc1 = dbo.prModificarUsuarios
     @CodigoUsuario   = @CodigoU,
     @NombreUsuario   = 'Temp06_Edit',
     @SegundoNombre   = 'Unit_Edit',
     @ApellidoUsuario = 'Prueba_Edit',
     @SegundoApellido = 'Mod_Edit',
     @ApellidoCasada  = 'Casada_Edit',
     @Email           = 'temp06.edit@test.local';

SELECT RC_Modificado = @rc1;  -- esperado: 1

PRINT '>> Validar datos modificados';
SELECT TOP 1
       CodigoUsuario,
       NombreUsuario,
       SegundoNombre,
       ApellidoUsuario,
       SegundoApellido,
       ApellidoCasada,
       Email
FROM dbo.Perfiles
WHERE CodigoUsuario = @CodigoU;

PRINT '>> Modificar usuario inexistente';
DECLARE @rc2 INT;

EXEC @rc2 = dbo.prModificarUsuarios
     @CodigoUsuario   = -9999,
     @NombreUsuario   = 'X',
     @SegundoNombre   = 'X',
     @ApellidoUsuario = 'X',
     @SegundoApellido = 'X',
     @ApellidoCasada  = 'X',
     @Email           = 'x@test.local';

SELECT RC_Inexistente = @rc2;  -- esperado: 0

PRINT '>> Limpieza: eliminar usuario temporal';
DELETE FROM dbo.Perfiles WHERE CodigoUsuario = @CodigoU;
GO