/* =============================================================================
   Script de PRUEBAS: 02_prValidarUsuario_Test.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Verificar dbo.prValidarUsuario en modo “sin encripción”.
       * Caso válido → devuelve 1 fila con datos.
       * Caso inválido → devuelve 0 filas.
   Notas:
     - Inserta datos de prueba y hace ROLLBACK para no persistir.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRY
    BEGIN TRAN;

    DECLARE @Id INT;

    INSERT INTO dbo.Perfiles (NombreUsuario, ApellidoUsuario, Email, Pass)
    VALUES ('UsuarioTest', 'Demo', 'usuario.demo@local',
            CONVERT(VARBINARY(128), 'clave123'));

    SET @Id = SCOPE_IDENTITY();

    PRINT '>> Caso VÁLIDO (esperado: 1 fila)';
    EXEC dbo.prValidarUsuario @CodigoUsuario = @Id, @Pass = 'clave123';

    PRINT '>> Caso INVÁLIDO (esperado: 0 filas)';
    EXEC dbo.prValidarUsuario @CodigoUsuario = @Id, @Pass = 'clave-incorrecta';

    ROLLBACK TRAN;  -- no persistir datos de prueba
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @num INT = ERROR_NUMBER();
    RAISERROR('Fallo en pruebas de prValidarUsuario (%d): %s', 16, 1, @num, @msg);
END CATCH;