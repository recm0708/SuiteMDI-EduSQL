/* =============================================================================
   Script:         05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prEliminarUsuarios
     - Eliminar un perfil por su CodigoUsuario
     - Devolver @@ROWCOUNT como resultado de la operación (0 o 1 típico)
   Notas:
     - Idempotente (CREATE OR ALTER), seguro para re-ejecución.
     - Valida parámetros (NULL/<=0) para evitar operaciones accidentales.
     - Las pruebas se mueven a /db_test (no se incluyen aquí).
   Observación:
     Se respeta el objetivo original (eliminar por Código), pero se robustecen
     validaciones, se documenta y se agrega retorno de @@ROWCOUNT para consumo
     consistente desde la capa de Negocio en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

CREATE OR ALTER PROCEDURE dbo.prEliminarUsuarios
(
    @CodigoUsuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Regla:
       - @CodigoUsuario IS NULL o <= 0 → no realiza acción, retorna 0
       - @CodigoUsuario > 0             → intenta eliminar y retorna @@ROWCOUNT (0/1)
    */
    IF (@CodigoUsuario IS NULL OR @CodigoUsuario <= 0)
        RETURN 0;

    DELETE FROM dbo.Perfiles
    WHERE CodigoUsuario = @CodigoUsuario;

    RETURN @@ROWCOUNT;
END
GO