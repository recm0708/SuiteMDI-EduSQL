/* =============================================================================
   Test:    04_consultar_despues_de_insertar.sql
   Proyecto: SuiteMDI-EduSQL (db_test / integracion)
   Objetivo:
     - Insertar usuario (prInsertarUsuario)
     - Consultar ese usuario (prConsultarUsuarios)
     - No persistir datos por defecto (ROLLBACK)
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - SPs: dbo.prInsertarUsuario (03), dbo.prConsultarUsuarios (04)
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

DECLARE 
    @Persist BIT = 0,                          -- 0=ROLLBACK (por defecto), 1=COMMIT
    @OutCodigo INT,
    @NombreUsuario   VARCHAR(50) = 'IT-Consul',
    @ApellidoUsuario VARCHAR(50) = 'DespuésInsert',
    @Email           VARCHAR(100)= 'it.consul@local.test',
    @PassPlain       VARCHAR(500)= 'IT-Consul-789!';

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
         @Email           = @Email,
         @Pass            = @PassPlain;

    IF (@OutCodigo IS NULL OR @OutCodigo < 1000)
        THROW 54100, 'Inserción fallida: CodigoUsuario inválido.', 1;

    PRINT 'Insert OK. CodigoUsuario=' + CAST(@OutCodigo AS VARCHAR(20));

    -- 2) Consultar “uno”
    IF OBJECT_ID('tempdb..#uno') IS NOT NULL DROP TABLE #uno;
    CREATE TABLE #uno (
        CodigoUsuario   INT         NOT NULL,
        NombreUsuario   VARCHAR(50) NULL,
        SegundoNombre   VARCHAR(50) NULL,
        ApellidoUsuario VARCHAR(50) NULL,
        SegundoApellido VARCHAR(50) NULL,
        ApellidoCasada  VARCHAR(50) NULL,
        Email           VARCHAR(100) NULL
    );

    INSERT INTO #uno
    EXEC dbo.prConsultarUsuarios @CodigoUsuario = @OutCodigo;

    IF NOT EXISTS (SELECT 1 FROM #uno WHERE CodigoUsuario = @OutCodigo AND Email = @Email)
        THROW 54101, 'Consulta fallida: no se devolvió el usuario recién insertado.', 1;

    PRINT 'Consulta OK: usuario insertado encontrado.';

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
    RAISERROR('Test integracion 04_consultar_despues_de_insertar falló. (%d) %s', @sev, @sta, @num, @msg);
END CATCH;
GO