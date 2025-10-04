/* =============================================================================
   Script de PRUEBAS/UTIL: db_scripts/util/Reseed_All.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Reseed de identidades a valores coherentes para DEV
       (Perfiles y Clientes vuelven a “999” para que el siguiente sea 1000).
   Alcance:
     - DEV únicamente. No para producción.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '== Reseed identidades (DEV) ==';

DECLARE @max INT, @sql NVARCHAR(MAX);

-- Perfiles (IDENTITY(1000,1))
IF OBJECT_ID('dbo.Perfiles','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles;
    DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'Perfiles -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- Clientes (IDENTITY(1000,1))
IF OBJECT_ID('dbo.Clientes','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdCliente), 999) FROM dbo.Clientes;
    DBCC CHECKIDENT ('dbo.Clientes', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'Clientes -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- Solicitudes (IDENTITY(1,1))
IF OBJECT_ID('dbo.Solicitudes','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdSolicitud), 0) FROM dbo.Solicitudes;
    DBCC CHECKIDENT ('dbo.Solicitudes', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'Solicitudes -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- SolicitudesDetalle (IDENTITY(1,1))
IF OBJECT_ID('dbo.SolicitudesDetalle','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdSolicitudDetalle), 0) FROM dbo.SolicitudesDetalle;
    DBCC CHECKIDENT ('dbo.SolicitudesDetalle', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'SolicitudesDetalle -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- Facturas (IDENTITY(1,1))
IF OBJECT_ID('dbo.Facturas','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdFactura), 0) FROM dbo.Facturas;
    DBCC CHECKIDENT ('dbo.Facturas', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'Facturas -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- FacturasDetalle (IDENTITY(1,1))
IF OBJECT_ID('dbo.FacturasDetalle','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdFacturaDetalle), 0) FROM dbo.FacturasDetalle;
    DBCC CHECKIDENT ('dbo.FacturasDetalle', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'FacturasDetalle -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- Recibos (IDENTITY(1,1))
IF OBJECT_ID('dbo.Recibos','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdRecibo), 0) FROM dbo.Recibos;
    DBCC CHECKIDENT ('dbo.Recibos', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'Recibos -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

-- RecibosDetalle (IDENTITY(1,1))
IF OBJECT_ID('dbo.RecibosDetalle','U') IS NOT NULL
BEGIN
    SELECT @max = ISNULL(MAX(IdReciboDetalle), 0) FROM dbo.RecibosDetalle;
    DBCC CHECKIDENT ('dbo.RecibosDetalle', RESEED, @max) WITH NO_INFOMSGS;
    PRINT 'RecibosDetalle -> reseed a ' + CONVERT(VARCHAR(20), @max);
END

PRINT '== Reseed completado ==';