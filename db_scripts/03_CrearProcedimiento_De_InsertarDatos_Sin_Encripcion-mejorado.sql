/* =============================================================================
   Script:         03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/Actualizar el SP dbo.prInsertarUsuario (modo “sin encripción”)
     - Insertar en dbo.Perfiles y devolver el CodigoUsuario generado (OUTPUT)
   Notas:
     - La columna Pass se almacena en VARBINARY(128); aquí se hace CONVERT desde VARCHAR.
     - Script idempotente con CREATE OR ALTER, seguro para re-ejecución.
     - Validación ligera: TRIM de entradas; blanks → NULL (para campos opcionales).
     - Las pruebas se mueven a /db_test (no se incluyen aquí).
   Observación:
     El procedimiento conserva la intención del material original (insertar usuario
     con Pass “sin encripción”) pero reorganiza el código, agrega normalización
     de entradas y documentación para uso académico-profesional en SuiteMDI-EduSQL.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

-- Crear o actualizar el SP de inserción de usuarios (SIN encripción)
CREATE OR ALTER PROCEDURE dbo.prInsertarUsuario
(
    @CodigoUsuario     INT           OUTPUT,   -- Identity devuelto al finalizar
    @NombreUsuario     VARCHAR(50),
    @SegundoNombre     VARCHAR(50),
    @ApellidoUsuario   VARCHAR(50),
    @SegundoApellido   VARCHAR(50),
    @ApellidoCasada    VARCHAR(50),
    @Email             VARCHAR(100),
    @Pass              VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Normalización ligera:
       - TRIM (LTRIM/RTRIM) a entradas de texto
       - Convertir cadenas vacías ('') a NULL para columnas opcionales
       Nota: La tabla permite NULLs; no se fuerza NOT NULL aquí.
    */
    DECLARE
        @vNombreUsuario   VARCHAR(50)  = NULLIF(LTRIM(RTRIM(@NombreUsuario)), ''),
        @vSegundoNombre   VARCHAR(50)  = NULLIF(LTRIM(RTRIM(@SegundoNombre)), ''),
        @vApellidoUsuario VARCHAR(50)  = NULLIF(LTRIM(RTRIM(@ApellidoUsuario)), ''),
        @vSegundoApellido VARCHAR(50)  = NULLIF(LTRIM(RTRIM(@SegundoApellido)), ''),
        @vApellidoCasada  VARCHAR(50)  = NULLIF(LTRIM(RTRIM(@ApellidoCasada)), ''),
        @vEmail           VARCHAR(100) = NULLIF(LTRIM(RTRIM(@Email)), ''),
        @vPass            VARCHAR(500) = ISNULL(@Pass, '');

    /* Inserción. Convertimos @vPass a VARBINARY(128).
       Observación: En un escenario real, aquí se aplicaría hashing/salto.
    */
    INSERT INTO dbo.Perfiles
    (
        NombreUsuario,
        SegundoNombre,
        ApellidoUsuario,
        SegundoApellido,
        ApellidoCasada,
        Email,
        Pass
    )
    VALUES
    (
        @vNombreUsuario,
        @vSegundoNombre,
        @vApellidoUsuario,
        @vSegundoApellido,
        @vApellidoCasada,
        @vEmail,
        CONVERT(VARBINARY(128), @vPass)
    );

    -- Identity generado (CodigoUsuario)
    SET @CodigoUsuario = SCOPE_IDENTITY();

    -- Señalización básica para consumidores que la usen
    RETURN @@ROWCOUNT;  -- 1 si insertó, 0 si no
END
GO