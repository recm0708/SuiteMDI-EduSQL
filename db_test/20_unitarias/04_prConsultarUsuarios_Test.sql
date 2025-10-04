/* =============================================================================
   Script de PRUEBAS: 04_prConsultarUsuarios_Test.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar dbo.prConsultarUsuarios sin exponer Pass
     - Caso A: listar todos (NULL o 0)
     - Caso B: consultar un código específico (si existe)
   Notas:
     - Solo lectura; no requiere TRAN.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

PRINT 'Caso A: @CodigoUsuario = 0 (listar todos)';
DECLARE @rc INT;
EXEC @rc = dbo.prConsultarUsuarios @CodigoUsuario = 0;
PRINT CONCAT('@@ROWCOUNT (RETURN estimado): ', @rc);
PRINT '---';

PRINT 'Caso A2: @CodigoUsuario = NULL (listar todos)';
EXEC @rc = dbo.prConsultarUsuarios @CodigoUsuario = NULL;
PRINT CONCAT('@@ROWCOUNT (RETURN estimado): ', @rc);
PRINT '---';

PRINT 'Caso B: @CodigoUsuario = 1000 (si existe)';
EXEC @rc = dbo.prConsultarUsuarios @CodigoUsuario = 1000;
PRINT CONCAT('@@ROWCOUNT (RETURN estimado): ', @rc);
PRINT '---';

-- Comprobación rápida: estructura de columnas (sin Pass)
SELECT TOP 0
       p.CodigoUsuario,
       p.NombreUsuario,
       p.SegundoNombre,
       p.ApellidoUsuario,
       p.SegundoApellido,
       p.ApellidoCasada,
       p.Email
FROM dbo.Perfiles AS p;