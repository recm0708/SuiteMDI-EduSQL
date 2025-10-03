/* =============================================================================
   Test:    03_insertar_y_validar_login.sql
   Proyecto: SuiteMDI-EduSQL (db_test / integracion)
   Objetivo:
     - Insertar usuario con prInsertarUsuario
     - Validar login correcto/incorrecto con prValidarUsuario
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: dbo.prInsertarUsuario (03), dbo.prValidarUsuario (02)
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

DECLARE 
    @Persist BIT = 0,                          -- 0=ROLLBACK (por defecto), 1=COMMIT
    @OutCodigo INT,
    @PassPlain VARCHAR(500) = 'IT-Login-456!',
    @NombreUsuario   VARCHAR(50) = 'ITUser',
    @ApellidoUsuario VARCHAR(50) = 'Login';

BEGIN TRAN;

BEGIN TRY
    -- 1) Insertar
    EXEC dbo.prInsertarUsuario
         @CodigoUsuario   = @OutCodigo OUTPUT,
         @NombreUsuario   = @NombreUsuario,
         @SegundoNombre   = NULL,
         @ApellidoUsuario = @ApellidoUsuario,
         @SegundoApellido = NULL,
         @ApellidoCasada  = NULL,
         @Email           = 'it.login@local.test',
         @Pass            = @PassPlain;

    IF (@OutCodigo IS NULL OR @OutCodigo < 1000)
        THROW 52000, 'Inserción fallida: CodigoUsuario inválido.', 1;

    PRINT 'Insert OK. CodigoUsuario=' + CAST(@OutCodigo AS VARCHAR(20));

    -- 2) Login válido
    CREATE TABLE #valid (
        NombreUsuario VARCHAR(50),
        ApellidoUsuario VARCHAR(50),
        Email VARCHAR(100)
    );

    INSERT INTO #valid
    EXEC dbo.prValidarUsuario
         @CodigoUsuario = @OutCodigo,
         @Pass          = @PassPlain;

    IF NOT EXISTS (SELECT 1 FROM #valid)
        THROW 52001, 'Login VÁLIDO: prValidarUsuario no devolvió filas.', 1;

    PRINT 'Login VÁLIDO OK.';

    -- 3) Login inválido
    CREATE TABLE #invalid (
        NombreUsuario VARCHAR(50),
        ApellidoUsuario VARCHAR(50),
        Email VARCHAR(100)
    );

    INSERT INTO #invalid
    EXEC dbo.prValidarUsuario
         @CodigoUsuario = @OutCodigo,
         @Pass          = 'contraseña equivocada';

    IF EXISTS (SELECT 1 FROM #invalid)
        THROW 52002, 'Login INVÁLIDO: prValidarUsuario devolvió filas cuando no debía.', 1;

    PRINT 'Login INVÁLIDO OK.';

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
    RAISERROR('Test integracion 03_insertar_y_validar_login falló. (%d) %s', @sev, @sta, @num, @msg);
END CATCH;
GO