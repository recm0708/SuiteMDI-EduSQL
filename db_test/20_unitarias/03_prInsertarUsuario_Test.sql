/* =============================================================================
   Script de PRUEBAS: 03_prInsertarUsuario_Test.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Verificar dbo.prInsertarUsuario (modo “sin encripción”)
       * Debe insertar y devolver @CodigoUsuario (IDENTITY)
       * La columna Pass debe quedar en VARBINARY y ser convertible a la clave original
   Notas:
     - Usa TRAN + ROLLBACK para no persistir datos de prueba.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRY
    BEGIN TRAN;

    DECLARE @NuevoCodigo INT,
            @rc          INT;

    EXEC @rc = dbo.prInsertarUsuario
         @CodigoUsuario   = @NuevoCodigo OUTPUT,
         @NombreUsuario   = 'Juan',
         @SegundoNombre   = 'Carlos',
         @ApellidoUsuario = 'Pérez',
         @SegundoApellido = NULL,
         @ApellidoCasada  = NULL,
         @Email           = 'juan.perez@demo.local',
         @Pass            = 'MiClave#123';

    PRINT CONCAT('@@ROWCOUNT (RETURN): ', @rc);
    PRINT CONCAT('Nuevo CodigoUsuario: ', @NuevoCodigo);

    -- Verificaciones mínimas
    SELECT TOP 1
        CodigoUsuario,
        NombreUsuario,
        ApellidoUsuario,
        Email,
        Pass              AS PassVarbinary,
        CONVERT(VARCHAR(500), Pass) AS PassTexto
    FROM dbo.Perfiles
    WHERE CodigoUsuario = @NuevoCodigo;

    -- EXPECTED:
    --   - 1 fila
    --   - PassTexto = 'MiClave#123'

    ROLLBACK TRAN;  -- no persistir
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE(),
            @num INT = ERROR_NUMBER();
    RAISERROR('Fallo en pruebas de prInsertarUsuario (%d): %s', 16, 1, @num, @msg);
END CATCH;