/* =============================================================================
   Script:         02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prValidarUsuario (validación “sin encripción”)
     - Devolver datos básicos del perfil si las credenciales son válidas
   Notas:
     - Este proyecto mantiene Pass en VARBINARY(128) (modo educativo “sin encripción”).
       Aquí se compara CONVERT(VARCHAR(500), Pass) con el parámetro @Pass de texto.
     - Script idempotente con CREATE OR ALTER (re-ejecutable).
     - Las pruebas se mueven a /db_test (no se incluyen aquí).
   Observación:
     El procedimiento ha sido reorganizado para claridad, práctica idempotente y
     manejo limpio de resultados. Mantiene la intención funcional del material
     original del Prof. José Ortiz (validación simple “sin encripción”), pero
     actualiza su estructura y documentación para uso académico-profesional
     en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

-- Crear o actualizar el SP de validación de usuario (SIN encripción)
CREATE OR ALTER PROCEDURE dbo.prValidarUsuario
(
    @CodigoUsuario INT,
    @Pass          VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    /*  Compara el texto de @Pass con el contenido de la columna Pass (VARBINARY),
        “sin encripción” → CONVERT(VARCHAR(500), Pass).
        Resultado:
          - 1 fila con Nombre/Apellido/Email si válido
          - 0 filas si inválido (forma más limpia que devolver fila vacía)
    */
    SELECT
        p.NombreUsuario,
        p.ApellidoUsuario,
        p.Email
    FROM dbo.Perfiles AS p
    WHERE p.CodigoUsuario = @CodigoUsuario
      AND TRY_CONVERT(VARCHAR(500), p.Pass) = @Pass;
END
GO