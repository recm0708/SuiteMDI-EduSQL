/* =============================================================================
   Script:   02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
   Proyecto: SuiteMDI-EduSQL
   Objetivo:
     - Crear/Actualizar el SP dbo.prValidarUsuario para validar (CodigoUsuario, Pass)
   Notas:
     - La columna Perfiles.Pass es VARBINARY(128). Comparamos en binario
       convirtiendo @Pass (VARCHAR) a VARBINARY(128) para evitar problemas de colación.
     - Este SP devuelve:
         * Resultset con NombreUsuario, ApellidoUsuario, Email cuando es válido.
         * Resultset vacío (mismas columnas) cuando no es válido.
       Adicionalmente retorna código:
         * RETURN 1 si válido, RETURN 0 si inválido (opcional para consumidores).
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Idempotente (no requiere DROP)
CREATE OR ALTER PROCEDURE dbo.prValidarUsuario
(
    @CodigoUsuario INT,
    @Pass          VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalización mínima de entradas
    SET @Pass = LTRIM(RTRIM(@Pass));

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Perfiles
        WHERE CodigoUsuario = @CodigoUsuario
          AND Pass = CONVERT(VARBINARY(128), @Pass)
    )
    BEGIN
        SELECT  NombreUsuario,
                ApellidoUsuario,
                Email
        FROM dbo.Perfiles
        WHERE CodigoUsuario = @CodigoUsuario;

        RETURN 1;  -- válido
    END
    ELSE
    BEGIN
        -- Resultset vacío con mismas columnas
        SELECT CAST('' AS VARCHAR(50))  AS NombreUsuario,
               CAST('' AS VARCHAR(50))  AS ApellidoUsuario,
               CAST('' AS VARCHAR(100)) AS Email
        WHERE 1 = 0;

        RETURN 0;  -- inválido
    END
END
GO