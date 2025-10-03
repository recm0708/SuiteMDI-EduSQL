/* ============================================================================
   Script: 05_CrearProcedimiento_de_Eliminacion_de_Usuario-mejorado.sql
   Proyecto: SuiteMDI-EduSQL
   Objetivo:
     - Crear SP dbo.prEliminarUsuario que elimine por @CodigoUsuario.
   Notas:
     - Idempotente (DROP/CREATE).
     - Devuelve filas afectadas en el código de retorno (RETURN @@ROWCOUNT).
     - No falla si el código no existe (retorna 0).
   ============================================================================ */

USE [Ejemplo_SIN_Encripcion];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Idempotencia: borrar si existe
IF OBJECT_ID(N'dbo.prEliminarUsuario', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prEliminarUsuario;
GO

CREATE PROCEDURE dbo.prEliminarUsuario
(
    @CodigoUsuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE p
    FROM dbo.Perfiles AS p
    WHERE p.CodigoUsuario = @CodigoUsuario;

    RETURN @@ROWCOUNT;   -- 1 si eliminó, 0 si no existía
END
GO