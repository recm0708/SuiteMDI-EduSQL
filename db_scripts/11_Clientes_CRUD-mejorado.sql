/* =========================================================================================
   11_Clientes_CRUD-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo: Procedimientos para CRUD de Clientes.
   Requiere: Tabla dbo.Clientes (script 08) con índice único filtrado en Cedula (UX_Clientes_Cedula)
   Notas:
     - Valida Cédula duplicada (respeta UX_Clientes_Cedula).
     - Devuelve @@ROWCOUNT cuando aplica y mensajes orientativos vía SELECT (opcional).
   ========================================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- INSERTAR
CREATE OR ALTER PROCEDURE dbo.prInsertarCliente
(
    @IdCliente       INT           OUTPUT,      -- identity generado
    @NombreCliente   VARCHAR(200),
    @Cedula          VARCHAR(30)   = NULL,
    @Direccion       VARCHAR(300)  = NULL,
    @Telefono        VARCHAR(20)   = NULL,
    @Celular         VARCHAR(20)   = NULL,
    @Correo          VARCHAR(200)  = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de cédula duplicada (si no es NULL)
    IF @Cedula IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.Clientes WHERE Cedula = @Cedula)
    BEGIN
        -- 2601/2627 vendría de índice único; devolvemos 0 para que la app lo trate bonito
        SELECT 'CedulaDuplicada' AS Estado, 'La cédula ya existe' AS Mensaje;
        RETURN 0;
    END

    INSERT INTO dbo.Clientes (NombreCliente, Cedula, Direccion, Telefono, Celular, Correo)
    VALUES (@NombreCliente, @Cedula, @Direccion, @Telefono, @Celular, @Correo);

    SET @IdCliente = SCOPE_IDENTITY();
    RETURN 1;
END
GO

-- MODIFICAR
CREATE OR ALTER PROCEDURE dbo.prModificarCliente
(
    @IdCliente       INT,
    @NombreCliente   VARCHAR(200),
    @Cedula          VARCHAR(30)   = NULL,
    @Direccion       VARCHAR(300)  = NULL,
    @Telefono        VARCHAR(20)   = NULL,
    @Celular         VARCHAR(20)   = NULL,
    @Correo          VARCHAR(200)  = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Cedula IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.Clientes WHERE Cedula = @Cedula AND IdCliente <> @IdCliente)
    BEGIN
        SELECT 'CedulaDuplicada' AS Estado, 'La cédula ya existe para otro cliente' AS Mensaje;
        RETURN 0;
    END

    UPDATE c
       SET c.NombreCliente = @NombreCliente,
           c.Cedula        = @Cedula,
           c.Direccion     = @Direccion,
           c.Telefono      = @Telefono,
           c.Celular       = @Celular,
           c.Correo        = @Correo
    FROM dbo.Clientes c
    WHERE c.IdCliente = @IdCliente;

    RETURN @@ROWCOUNT; -- 1=actualizado, 0=no existía
END
GO

-- ELIMINAR
CREATE OR ALTER PROCEDURE dbo.prEliminarCliente
(
    @IdCliente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE c
    FROM dbo.Clientes c
    WHERE c.IdCliente = @IdCliente;

    RETURN @@ROWCOUNT; -- 1=eliminado, 0=no existía
END
GO

/* =========================
   PRUEBAS (SSMS) - OPCIONALES (Descomentar para usar)
   Ejecutamos por bloques seleccionando y presionando F5
   ========================= */
-- /*
-- DECLARE @id INT;
-- EXEC dbo.prInsertarCliente @IdCliente=@id OUTPUT, @NombreCliente='Cliente Uno', @Cedula='8-999-001', @Direccion='Calle X', @Telefono='222', @Celular='666', @Correo='uno@correo.com';
-- SELECT @id IdCliente;
-- EXEC dbo.prModificarCliente @IdCliente=@id, @NombreCliente='Cliente Uno Edit', @Cedula='8-999-001', @Direccion='Calle Y', @Telefono='223', @Celular='667', @Correo='uno@edit.com';
-- EXEC dbo.prEliminarCliente @IdCliente=@id;
-- */