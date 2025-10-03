/* =============================================================================
   Test:    02_prValidarUsuario.sql
   Proyecto: SuiteMDI-EduSQL (db_test / unitarias)
   Objetivo:
     - Validar que prValidarUsuario devuelve filas para credenciales correctas
       y resultset vacío para incorrectas. Verificar RETURN code 1/0.
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - Tabla dbo.Perfiles con un usuario válido existente
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '>> Test prValidarUsuario: caso VÁLIDO';
DECLARE @rc INT;
EXEC @rc = dbo.prValidarUsuario
     @CodigoUsuario = 1000,
     @Pass          = 'Panama-utp@2025';   -- ajusta según tus datos
SELECT RC_Valido = @rc;
GO

PRINT '>> Test prValidarUsuario: caso INVÁLIDO (pass incorrecta)';
DECLARE @rc2 INT;
EXEC @rc2 = dbo.prValidarUsuario
     @CodigoUsuario = 1000,
     @Pass          = 'incorrecta';
SELECT RC_Invalido = @rc2;
GO