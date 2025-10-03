/* =============================================================================
   Seed:    11_seed_usuario_1000.sql
   Proyecto: SuiteMDI-EduSQL (db_test / datos_semilla)
   Objetivo:
     - Asegurar existencia del usuario CodigoUsuario = 1000 en dbo.Perfiles
     - Establecer Pass como VARBINARY(128) a partir de una contraseña en texto
   Notas:
     - Idempotente: si existe, actualiza; si no, inserta con IDENTITY_INSERT.
     - Edita valores por defecto debajo si lo necesitas.
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

-- Parámetros (ajustables)
DECLARE
  @Codigo           INT           = 1000,
  @Nombre           VARCHAR(50)   = 'Usuario',
  @SegundoNombre    VARCHAR(50)   = 'Demo',
  @Apellido         VARCHAR(50)   = 'Prueba',
  @SegundoApellido  VARCHAR(50)   = '',
  @ApellidoCasada   VARCHAR(50)   = '',
  @Email            VARCHAR(100)  = 'usuario.demo@ejemplo.com',
  @PassPlano        VARCHAR(500)  = 'Panama-utp@2025';

PRINT '>> Seed usuario ' + CAST(@Codigo AS VARCHAR(12)) + ' en dbo.Perfiles';

IF EXISTS (SELECT 1 FROM dbo.Perfiles WHERE CodigoUsuario = @Codigo)
BEGIN
    UPDATE dbo.Perfiles
       SET NombreUsuario   = @Nombre,
           SegundoNombre   = @SegundoNombre,
           ApellidoUsuario = @Apellido,
           SegundoApellido = @SegundoApellido,
           ApellidoCasada  = @ApellidoCasada,
           Email           = @Email,
           Pass            = CONVERT(VARBINARY(128), @PassPlano)
     WHERE CodigoUsuario = @Codigo;

    PRINT '>> Actualizado usuario existente ' + CAST(@Codigo AS VARCHAR(12));
END
ELSE
BEGIN
    SET IDENTITY_INSERT dbo.Perfiles ON;

    INSERT INTO dbo.Perfiles
        (CodigoUsuario, NombreUsuario, SegundoNombre, ApellidoUsuario,
         SegundoApellido, ApellidoCasada, Email, Pass)
    VALUES
        (@Codigo, @Nombre, @SegundoNombre, @Apellido,
         @SegundoApellido, @ApellidoCasada, @Email,
         CONVERT(VARBINARY(128), @PassPlano));

    SET IDENTITY_INSERT dbo.Perfiles OFF;

    PRINT '>> Insertado usuario nuevo ' + CAST(@Codigo AS VARCHAR(12));
END
GO

-- Alinear IDENTITY al MAX(CodigoUsuario)
DECLARE @mx INT = (SELECT ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles);
DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @mx);
GO

-- Verificación rápida
SELECT CodigoUsuario, NombreUsuario, ApellidoUsuario, Email,
       PassPreview = CONVERT(VARBINARY(16), Pass)
FROM dbo.Perfiles
WHERE CodigoUsuario = 1000;
GO