/* =============================================================================
   Script de PRUEBAS: 07_prModificarPasswordUsuarios_Test.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar dbo.prModificarPasswordUsuarios en escenarios típicos
       * Usuario inexistente
       * Parámetros inválidos
       * Reset de contraseña (ignora PassAnterior)
       * Cambio normal con PassAnterior correcto
       * Cambio normal con PassAnterior incorrecto
     - Evitar persistencia (usa TRAN + ROLLBACK)
   Notas:
     - Se usa el mismo esquema "sin encripción" (CONVERT a VARBINARY/VARCHAR).
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

DECLARE @rc INT;

PRINT 'Caso A: Usuario inexistente → RETURN 0';
EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = -999,
     @PassAnterior  = 'x',
     @PassNuevo     = 'nuevoA',
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);
PRINT '---';

PRINT 'Caso B: Parámetros inválidos → RETURN -3';
EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = NULL,
     @PassAnterior  = 'x',
     @PassNuevo     = 'nuevoB',
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);

EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = 0,
     @PassAnterior  = 'x',
     @PassNuevo     = 'nuevoB',
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);

EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = 1000,
     @PassAnterior  = 'x',
     @PassNuevo     = NULL,
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);
PRINT '---';

PRINT 'Caso C: Reset (ignora PassAnterior) → RETURN 1 si actualiza';
BEGIN TRAN;
DECLARE @Nuevo INT;

INSERT INTO dbo.Perfiles
    (NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido, ApellidoCasada, Email, Pass)
VALUES
    ('U1','S1','A1','A2','C1','u1@test', CONVERT(VARBINARY(128),'old'));

SET @Nuevo = SCOPE_IDENTITY();
PRINT CONCAT('Insertado CodigoUsuario=', @Nuevo);

EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @Nuevo,
     @PassAnterior  = 'lo-que-sea',
     @PassNuevo     = 'reset-OK',
     @resetear      = 1;
PRINT CONCAT('Return: ', @rc);

SELECT CodigoUsuario, CONVERT(VARCHAR(500), Pass) AS PassTxt
  FROM dbo.Perfiles
 WHERE CodigoUsuario = @Nuevo;

ROLLBACK TRAN;
PRINT 'Rollback realizado.';
PRINT '---';

PRINT 'Caso D: Cambio normal con PassAnterior correcto → RETURN 1';
BEGIN TRAN;

INSERT INTO dbo.Perfiles
    (NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido, ApellidoCasada, Email, Pass)
VALUES
    ('U2','S2','A1','A2','C2','u2@test', CONVERT(VARBINARY(128),'anterior'));

SET @Nuevo = SCOPE_IDENTITY();

EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @Nuevo,
     @PassAnterior  = 'anterior',
     @PassNuevo     = 'nuevo-OK',
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);

SELECT CodigoUsuario, CONVERT(VARCHAR(500), Pass) AS PassTxt
  FROM dbo.Perfiles
 WHERE CodigoUsuario = @Nuevo;

ROLLBACK TRAN;
PRINT 'Rollback realizado.';
PRINT '---';

PRINT 'Caso E: Cambio normal con PassAnterior incorrecto → RETURN -2';
BEGIN TRAN;

INSERT INTO dbo.Perfiles
    (NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido, ApellidoCasada, Email, Pass)
VALUES
    ('U3','S3','A1','A2','C3','u3@test', CONVERT(VARBINARY(128),'anterior'));

SET @Nuevo = SCOPE_IDENTITY();

EXEC @rc = dbo.prModificarPasswordUsuarios
     @CodigoUsuario = @Nuevo,
     @PassAnterior  = 'incorrecta',
     @PassNuevo     = 'no-deberia',
     @resetear      = 0;
PRINT CONCAT('Return: ', @rc);

SELECT CodigoUsuario, CONVERT(VARCHAR(500), Pass) AS PassTxt
  FROM dbo.Perfiles
 WHERE CodigoUsuario = @Nuevo;

ROLLBACK TRAN;
PRINT 'Rollback realizado.';