/* =============================================================================
   Script:         07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prModificarPasswordUsuarios.
     - Cambiar contraseña:
         * Modo normal: requiere PassAnterior correcto.
         * Modo reset: ignora PassAnterior y fuerza nuevo password.
     - Devolver código de resultado vía RETURN
         1  = actualizado OK.
         0  = usuario no encontrado (no se actualiza).
        -2  = PassAnterior inválido.
        -3  = parámetros inválidos (@CodigoUsuario NULL/<=0 o @PassNuevo NULL).
   Notas:
     - Idempotente (CREATE OR ALTER).
     - Se mantiene el esquema "sin encripción": almacenamiento en VARBINARY(128)
       y comparación mediante CONVERT(VARCHAR(500), Pass).
     - No se registran secretos en texto plano en tablas auxiliares.
   Observación:
     Se preserva la funcionalidad original, agregando validaciones, códigos de
     retorno consistentes y documentación para una mejor integración con la capa
     de Negocio de SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

CREATE OR ALTER PROCEDURE dbo.prModificarPasswordUsuarios
(
    @CodigoUsuario  INT,
    @PassAnterior   VARCHAR(500),
    @PassNuevo      VARCHAR(500),
    @resetear       TINYINT    -- 1 = reset (ignora anterior), 0 = normal
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Validaciones de entrada */
    IF (@CodigoUsuario IS NULL OR @CodigoUsuario <= 0 OR @PassNuevo IS NULL)
        RETURN -3;  -- parámetros inválidos

    -- Normaliza el flag
    SET @resetear = ISNULL(@resetear, 0);

    /* ¿Existe el usuario? */
    IF NOT EXISTS (SELECT 1 FROM dbo.Perfiles WHERE CodigoUsuario = @CodigoUsuario)
        RETURN 0;   -- usuario no encontrado

    /* Modo reset: ignora PassAnterior */
    IF (@resetear = 1)
    BEGIN
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario;

        RETURN CASE WHEN @@ROWCOUNT = 1 THEN 1 ELSE 0 END;
    END

    /* Modo normal: verifica PassAnterior */
    IF EXISTS (
        SELECT 1
          FROM dbo.Perfiles
         WHERE CodigoUsuario = @CodigoUsuario
           AND CONVERT(VARCHAR(500), Pass) = @PassAnterior
    )
    BEGIN
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario;

        RETURN CASE WHEN @@ROWCOUNT = 1 THEN 1 ELSE 0 END;
    END
    ELSE
    BEGIN
        RETURN -2;  -- contraseña anterior inválida
    END
END
GO