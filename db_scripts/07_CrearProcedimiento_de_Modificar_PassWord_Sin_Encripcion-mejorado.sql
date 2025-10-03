/* ============================================================================
   Script: 07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
   Proyecto: SuiteMDI-EduSQL
   Objetivo:
     - Cambiar la contraseña de un usuario (modo normal o reset administrativo).
   Notas:
     - Idempotente (DROP/CREATE).
     - Retorna @@ROWCOUNT:
         1 = se actualizó
         0 = no coincide Pass anterior o no existe el usuario
     - @Resetear = 1 ignora @PassAnterior (reseteo administrativo).
     - Comparación VARBINARY = VARBINARY (evita problemas de encoding/colación).
   ============================================================================ */

USE [Ejemplo_SIN_Encripcion];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.prModificarPasswordUsuarios', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prModificarPasswordUsuarios;
GO

CREATE PROCEDURE dbo.prModificarPasswordUsuarios
(
    @CodigoUsuario INT,
    @PassAnterior  VARCHAR(500) = NULL,
    @PassNuevo     VARCHAR(500),
    @Resetear      BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Validaciones opcionales
    IF (@PassNuevo IS NULL OR LTRIM(RTRIM(@PassNuevo)) = '')
        RETURN 0; -- o THROW 50010, 'PassNuevo obligatorio.', 1;
    */

    IF (@Resetear = 1)
    BEGIN
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario;

        RETURN @@ROWCOUNT;  -- 1 si existía, 0 si no
    END
    ELSE
    BEGIN
        -- Modo normal: solo si coincide el Pass actual (binario contra binario)
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario
           AND p.Pass = CONVERT(VARBINARY(128), @PassAnterior);

        RETURN @@ROWCOUNT;  -- 1 si coincidió y actualizó, 0 si no
    END
END
GO