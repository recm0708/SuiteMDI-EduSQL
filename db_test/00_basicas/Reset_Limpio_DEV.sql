/* =============================================================================
   Script de PRUEBAS/UTIL: 00_basicas/Reset_Limpio_DEV.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Limpiar tablas de negocio en orden de FKs y reseedear identidades.
   Alcance:
     - DEV únicamente. No para producción.
   Nota: Este script usa :r para invocar Reseed_All.sql. Activa SQLCMD Mode
         en SSMS (Query → SQLCMD Mode) antes de ejecutarlo.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

PRINT '== Limpieza (DELETE en orden de FKs) ==';

-- Hijas primero
IF OBJECT_ID('dbo.RecibosDetalle','U') IS NOT NULL DELETE FROM dbo.RecibosDetalle;
IF OBJECT_ID('dbo.Recibos','U')       IS NOT NULL DELETE FROM dbo.Recibos;
IF OBJECT_ID('dbo.FacturasDetalle','U') IS NOT NULL DELETE FROM dbo.FacturasDetalle;
IF OBJECT_ID('dbo.Facturas','U')        IS NOT NULL DELETE FROM dbo.Facturas;
IF OBJECT_ID('dbo.SolicitudesDetalle','U') IS NOT NULL DELETE FROM dbo.SolicitudesDetalle;
IF OBJECT_ID('dbo.Solicitudes','U')       IS NOT NULL DELETE FROM dbo.Solicitudes;
IF OBJECT_ID('dbo.DepartamentosServicios','U') IS NOT NULL DELETE FROM dbo.DepartamentosServicios;

-- Tablas base (sin FKs entrantes en este esquema)
IF OBJECT_ID('dbo.Servicios','U')      IS NOT NULL DELETE FROM dbo.Servicios;
IF OBJECT_ID('dbo.Departamentos','U')  IS NOT NULL DELETE FROM dbo.Departamentos;

-- Clientes por último (tiene FKs desde Solicitudes/Facturas/Recibos)
IF OBJECT_ID('dbo.Clientes','U')       IS NOT NULL DELETE FROM dbo.Clientes;

-- Perfiles (independiente del resto)
IF OBJECT_ID('dbo.Perfiles','U')       IS NOT NULL DELETE FROM dbo.Perfiles;

COMMIT TRAN;

PRINT '== Reseed posterior ==';
:r ..\..\db_scripts\util\Reseed_All.sql