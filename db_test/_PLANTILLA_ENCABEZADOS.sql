/* ===========================================
   Proyecto: SuiteMDI-EduSQL
   Test: T-XX-<nombre_corto>
   Objetivo: <qué valida>
   Requisitos: Script(s) de producción aplicados (XX)
   BD: Ejemplo_SIN_Encripcion
   Limpieza: No deja efectos (ROLLBACK)
=========================================== */

USE [Ejemplo_SIN_Encripcion];
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    -- Arrange (datos de prueba locales o de 10_datos_semilla)

    -- Act
    -- EXEC dbo.<SP> ...

    -- Assert (falla si no se cumple la condición)
    IF NOT EXISTS (SELECT 1 /* condición esperada */)
    BEGIN
        RAISERROR('Fallo T-XX-<nombre_corto>: condición esperada no encontrada', 16, 1);
    END

    ROLLBACK TRAN;  -- mantener sin efectos
    PRINT 'OK: T-XX-<nombre_corto>';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT CONCAT('ERROR: ', ERROR_MESSAGE());
    THROW;
END CATCH;