/* =============================================================================
   Script de PRUEBAS: 06_prModificarUsuarios_Test.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar dbo.prModificarUsuarios en casos típicos y nulos
     - No dejar datos persistentes (TRAN + ROLLBACK)
   Notas:
     - Se inserta un registro temporal, se modifica y se valida el cambio.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

DECLARE @rc INT;

PRINT 'Caso 0: Código inválido (NULL/0) → retorna 0';
EXEC @rc = dbo.prModificarUsuarios
     @CodigoUsuario=NULL,
     @NombreUsuario='X',
     @SegundoNombre='',
     @ApellidoUsuario='Y',
     @SegundoApellido='',
     @ApellidoCasada='',
     @Email='x@y';
PRINT CONCAT('NULL → RETURN: ', @rc);

EXEC @rc = dbo.prModificarUsuarios
     @CodigoUsuario=0,
     @NombreUsuario='X',
     @SegundoNombre='',
     @ApellidoUsuario='Y',
     @SegundoApellido='',
     @ApellidoCasada='',
     @Email='x@y';
PRINT CONCAT('0 → RETURN: ', @rc);
PRINT '---';

PRINT 'Caso 1: Modificar un registro existente (en transacción)';
BEGIN TRAN;

DECLARE @Nuevo INT;

INSERT INTO dbo.Perfiles (NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido, ApellidoCasada, Email, Pass)
VALUES ('Nombre0', 'Seg0', 'Ape0', 'Ape02', 'Cas0', 'prueba@local', CONVERT(VARBINARY(128),'p0'));

SET @Nuevo = SCOPE_IDENTITY();

PRINT CONCAT('Insertado CodigoUsuario=', @Nuevo);

EXEC @rc = dbo.prModificarUsuarios
     @CodigoUsuario=@Nuevo,
     @NombreUsuario='NombreMod',
     @SegundoNombre=NULL,              -- prueba normalización a ''
     @ApellidoUsuario='ApeMod',
     @SegundoApellido='',
     @ApellidoCasada='CasMod',
     @Email='mod@local';

PRINT CONCAT('UPDATE RETURN: ', @rc);

SELECT TOP 1 CodigoUsuario, NombreUsuario, SegundoNombre, ApellidoUsuario, Email
FROM dbo.Perfiles
WHERE CodigoUsuario = @Nuevo;

ROLLBACK TRAN;
PRINT 'Rollback realizado: la tabla vuelve al estado previo.';
PRINT '---';

PRINT 'Caso 2: Código inexistente → retorno 0';
EXEC @rc = dbo.prModificarUsuarios
     @CodigoUsuario=-999,
     @NombreUsuario='Nombre',
     @SegundoNombre='',
     @ApellidoUsuario='Ape',
     @SegundoApellido='',
     @ApellidoCasada='',
     @Email='n@local';
PRINT CONCAT('Inexistente → RETURN: ', @rc);