/* =============================================================================
   Script de PRUEBAS: <Carpeta>/<NN_Nombre-logico>_Test.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - <Qué valida el test>
   Alcance:
     - DEV únicamente. No para producción.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

-- Arrange
-- ...

-- Act
-- ...

-- Assert (SELECTs de verificación)
-- ...

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';