/* =============================================================================
   Script de PRUEBAS: 05_prEliminarUsuarios_Test.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar dbo.prEliminarUsuarios con casos de éxito y nulos.
     - No dejar datos de prueba: se usa TRAN + ROLLBACK.
   Notas:
     - Se inserta un registro temporal, se elimina con el SP y se revierte.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

PRINT 'Caso 0: Parámetros inválidos (NULL/0) → retorno 0';
DECLARE @rc INT;

EXEC @rc = dbo.prEliminarUsuarios @CodigoUsuario = NULL;
PRINT CONCAT('NULL → RETURN: ', @rc);

EXEC @rc = dbo.prEliminarUsuarios @CodigoUsuario = 0;
PRINT CONCAT('0 → RETURN: ', @rc);
PRINT '---';

PRINT 'Caso 1: Eliminar un registro existente (en transacción)';
BEGIN TRAN;

DECLARE @Nuevo INT;

INSERT INTO dbo.Perfiles (NombreUsuario, ApellidoUsuario, Email, Pass)
VALUES ('Tmp', 'Eliminar', 'tmp-eliminar@local', CONVERT(VARBINARY(128), 'x'));

SET @Nuevo = SCOPE_IDENTITY();

SELECT 'Pre-DELETE existe?' AS Etapa,
       COUNT(*) AS Existe
FROM dbo.Perfiles
WHERE CodigoUsuario = @Nuevo;

EXEC @rc = dbo.prEliminarUsuarios @CodigoUsuario = @Nuevo;
PRINT CONCAT('DELETE RETURN: ', @rc);

SELECT 'Post-DELETE existe?' AS Etapa,
       COUNT(*) AS Existe
FROM dbo.Perfiles
WHERE CodigoUsuario = @Nuevo;

ROLLBACK TRAN;
PRINT 'Rollback realizado: la tabla queda como antes.';
PRINT '---';

PRINT 'Caso 2: Código inexistente → retorno 0';
EXEC @rc = dbo.prEliminarUsuarios @CodigoUsuario = -999;
PRINT CONCAT('Inexistente → RETURN: ', @rc);