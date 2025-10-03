/* =============================================================================
   Script: 03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql
   Proyecto: SuiteMDI-EduSQL
   Objetivo:
     - Crear/actualizar el SP dbo.prInsertarUsuario para insertar en dbo.Perfiles
       y devolver el CodigoUsuario (IDENTITY) vía parámetro OUTPUT.
   Notas:
     - “Sin encripción”: se almacena Pass como VARBINARY(128) convirtiendo desde VARCHAR.
     - Idempotente con CREATE OR ALTER. Manejo de errores con TRY/CATCH + THROW.
     - Normaliza entradas (TRIM) y convierte cadenas vacías a NULL donde aplica.
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE dbo.prInsertarUsuario
(
    @CodigoUsuario    INT            OUTPUT,   -- se devolverá aquí el IDENTITY generado
    @NombreUsuario    VARCHAR(50),
    @SegundoNombre    VARCHAR(50)    = NULL,
    @ApellidoUsuario  VARCHAR(50),
    @SegundoApellido  VARCHAR(50)    = NULL,
    @ApellidoCasada   VARCHAR(50)    = NULL,
    @Email            VARCHAR(100)   = NULL,
    @Pass             VARCHAR(500)             -- llega como texto; se convertirá a VARBINARY(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        /* Normalización básica (TRIM + NULLIF para vacíos) */
        SET @NombreUsuario   = NULLIF(LTRIM(RTRIM(@NombreUsuario)),   '');
        SET @SegundoNombre   = NULLIF(LTRIM(RTRIM(@SegundoNombre)),   '');
        SET @ApellidoUsuario = NULLIF(LTRIM(RTRIM(@ApellidoUsuario)), '');
        SET @SegundoApellido = NULLIF(LTRIM(RTRIM(@SegundoApellido)), '');
        SET @ApellidoCasada  = NULLIF(LTRIM(RTRIM(@ApellidoCasada)),  '');
        SET @Email           = NULLIF(LTRIM(RTRIM(@Email)),           '');
        SET @Pass            = LTRIM(RTRIM(@Pass));

        /* Validaciones mínimas (ajusta según las reglas del negocio) */
        IF (@NombreUsuario IS NULL)
            THROW 50000, 'El NombreUsuario es obligatorio.', 1;

        IF (@ApellidoUsuario IS NULL)
            THROW 50001, 'El ApellidoUsuario es obligatorio.', 1;

        IF (@Pass IS NULL OR @Pass = '')
            THROW 50002, 'La contraseña (Pass) es obligatoria.', 1;

        /* (Opcional) Validación de unicidad por Email si lo manejas como único
           IF (@Email IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.Perfiles WHERE Email = @Email))
               THROW 50003, 'El Email ya existe en Perfiles.', 1;
        */

        INSERT INTO dbo.Perfiles
        (
            NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido,
            ApellidoCasada, Email, Pass
        )
        VALUES
        (
            @NombreUsuario, @SegundoNombre, @ApellidoUsuario, @SegundoApellido,
            @ApellidoCasada, @Email,
            CONVERT(VARBINARY(128), @Pass)  -- SIN encripción: cast directo a binario
        );

        SET @CodigoUsuario = CONVERT(INT, SCOPE_IDENTITY());  -- IDENTITY (inicia en 1000)
        RETURN 0;  -- éxito
    END TRY
    BEGIN CATCH
        /* Re-lanzar el error original manteniendo número/línea */
        THROW;
    END CATCH
END
GO