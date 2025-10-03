/* =============================================================================
   Test:    03_prInsertarUsuario.sql
   Proyecto: SuiteMDI-EduSQL (db_test / unitarias)
   Objetivo:
     - Validar inserción vía dbo.prInsertarUsuario
     - Verificar campos clave y conversión a VARBINARY(128) del Pass
     - Mantener la BD limpia por defecto (ROLLBACK)
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - Tabla: dbo.Perfiles
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

DECLARE 
    @Persist BIT = 0,                          -- 0=ROLLBACK (por defecto), 1=COMMIT
    @OutCodigo INT,
    @NombreUsuario   VARCHAR(50) = 'UnitTest',
    @SegundoNombre   VARCHAR(50) = NULL,
    @ApellidoUsuario VARCHAR(50) = 'Insertar',
    @SegundoApellido VARCHAR(50) = NULL,
    @ApellidoCasada  VARCHAR(50) = NULL,
    @Email           VARCHAR(100)= 'unittest.insertar@local.test',
    @PassPlain       VARCHAR(500)= 'UT-Insertar-123!';

BEGIN TRAN;

BEGIN TRY
    EXEC dbo.prInsertarUsuario
         @CodigoUsuario   = @OutCodigo OUTPUT,
         @NombreUsuario   = @NombreUsuario,
         @SegundoNombre   = @SegundoNombre,
         @ApellidoUsuario = @ApellidoUsuario,
         @SegundoApellido = @SegundoApellido,
         @ApellidoCasada  = @ApellidoCasada,
         @Email           = @Email,
         @Pass            = @PassPlain;

    IF (@OutCodigo IS NULL OR @OutCodigo < 1000)
        THROW 51000, 'prInsertarUsuario no devolvió un CodigoUsuario válido (>=1000).', 1;

    -- Verifica registro y Pass binario
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Perfiles
        WHERE CodigoUsuario = @OutCodigo
          AND NombreUsuario   = @NombreUsuario
          AND ApellidoUsuario = @ApellidoUsuario
          AND Email           = @Email
          AND Pass            = CONVERT(VARBINARY(128), @PassPlain)
    )
        THROW 51001, 'El registro insertado no coincide o el Pass no fue almacenado como VARBINARY esperado.', 1;

    PRINT 'OK: Inserción y verificación correctas. CodigoUsuario=' + CAST(@OutCodigo AS VARCHAR(20));

    IF (@Persist = 1)
    BEGIN
        COMMIT TRAN;
        PRINT 'Transacción COMMIT (persistida por @Persist=1).';
    END
    ELSE
    BEGIN
        ROLLBACK TRAN;
        PRINT 'Transacción ROLLBACK (modo prueba por defecto).';
    END
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @num INT = ERROR_NUMBER();
    DECLARE @sev INT = ERROR_SEVERITY();
    DECLARE @sta INT = ERROR_STATE();
    RAISERROR('Test 03_prInsertarUsuario falló. (%d) %s', @sev, @sta, @num, @msg);
END CATCH;
GO