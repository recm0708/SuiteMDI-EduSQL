/* =============================================================================
   Script:         04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prConsultarUsuarios
     - Consultar perfiles SIN exponer la columna Pass (solo datos públicos)
     - Permitir consulta de 1 usuario por código o de todos (código <= 0 / NULL)
   Notas:
     - Idempotente (CREATE OR ALTER), seguro para re-ejecución.
     - Ordena por CodigoUsuario para resultados consistentes.
     - Las pruebas se mueven a /db_test (no se incluyen aquí).
   Observación:
     Se mantiene la intención y firma original del procedimiento, pero se mejora
     su robustez (manejo de NULL/<=0), ordenación y documentación para uso
     académico-profesional en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

CREATE OR ALTER PROCEDURE dbo.prConsultarUsuarios
(
    @CodigoUsuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Regla:
       - @CodigoUsuario IS NULL o <= 0  → devolver TODOS (sin Pass)
       - @CodigoUsuario > 0             → devolver SOLO ese Código (sin Pass)
    */
    IF (@CodigoUsuario IS NULL OR @CodigoUsuario <= 0)
    BEGIN
        SELECT
            p.CodigoUsuario,
            p.NombreUsuario,
            p.SegundoNombre,
            p.ApellidoUsuario,
            p.SegundoApellido,
            p.ApellidoCasada,
            p.Email
        FROM dbo.Perfiles AS p
        ORDER BY p.CodigoUsuario ASC;

        RETURN @@ROWCOUNT;  -- filas leídas
    END
    ELSE
    BEGIN
        SELECT
            p.CodigoUsuario,
            p.NombreUsuario,
            p.SegundoNombre,
            p.ApellidoUsuario,
            p.SegundoApellido,
            p.ApellidoCasada,
            p.Email
        FROM dbo.Perfiles AS p
        WHERE p.CodigoUsuario = @CodigoUsuario;

        RETURN @@ROWCOUNT;  -- 0 o 1 típico
    END
END
GO