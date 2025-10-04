/* =============================================================================
   Script:         06_CrearProcedimiento_de_Modificar_de_Usuario-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prModificarUsuarios.
     - Actualizar datos de un usuario (Perfiles) sin tocar Pass ni el ID.
     - Devolver @@ROWCOUNT (0 si no encontró, 1 si actualizó).
   Notas:
     - Idempotente (CREATE OR ALTER), seguro para re-ejecución.
     - Valida @CodigoUsuario (NULL/<=0) y normaliza entradas (NULL → '').
     - No modifica la contraseña (Pass) ni el Identity.
   Observación:
     Se preserva el objetivo original, pero se agregan validaciones, retorno
     estandarizado y documentación para garantizar un consumo consistente
     desde la capa de Negocio en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

CREATE OR ALTER PROCEDURE dbo.prModificarUsuarios
(
    @CodigoUsuario   INT,
    @NombreUsuario   VARCHAR(50),
    @SegundoNombre   VARCHAR(50),
    @ApellidoUsuario VARCHAR(50),
    @SegundoApellido VARCHAR(50),
    @ApellidoCasada  VARCHAR(50),
    @Email           VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Reglas:
       - @CodigoUsuario NULL/<=0 → no hace nada, RETURN 0
       - Campos de texto: si vienen NULL, se normalizan a ''
         (evita que un UPDATE falle por asignar NULL si no se desea)
    */
    IF (@CodigoUsuario IS NULL OR @CodigoUsuario <= 0)
        RETURN 0;

    SET @NombreUsuario   = ISNULL(@NombreUsuario,   '');
    SET @SegundoNombre   = ISNULL(@SegundoNombre,   '');
    SET @ApellidoUsuario = ISNULL(@ApellidoUsuario, '');
    SET @SegundoApellido = ISNULL(@SegundoApellido, '');
    SET @ApellidoCasada  = ISNULL(@ApellidoCasada,  '');
    SET @Email           = ISNULL(@Email,           '');

    UPDATE p
       SET p.NombreUsuario   = @NombreUsuario,
           p.SegundoNombre   = @SegundoNombre,
           p.ApellidoUsuario = @ApellidoUsuario,
           p.SegundoApellido = @SegundoApellido,
           p.ApellidoCasada  = @ApellidoCasada,
           p.Email           = @Email
      FROM dbo.Perfiles AS p
     WHERE p.CodigoUsuario   = @CodigoUsuario;

    RETURN @@ROWCOUNT;  -- 1 si actualizó, 0 si no encontró
END
GO