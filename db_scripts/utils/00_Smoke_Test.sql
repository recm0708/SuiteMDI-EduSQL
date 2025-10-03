/* =============================================================================
   Script: 00_Smoke_Test.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Validar objetos clave tras ejecutar scripts 01–11
   ============================================================================= */

USE Ejemplo_SIN_Encripcion;
GO

SELECT DB_NAME() AS DBName;

-- Tablas base
SELECT
  Perfiles = OBJECT_ID('dbo.Perfiles','U'),
  Clientes = OBJECT_ID('dbo.Clientes','U'),
  Departamentos = OBJECT_ID('dbo.Departamentos','U'),
  Servicios = OBJECT_ID('dbo.Servicios','U'),
  Solicitudes = OBJECT_ID('dbo.Solicitudes','U'),
  SolicitudesDetalle = OBJECT_ID('dbo.SolicitudesDetalle','U');

-- SPs usuarios
SELECT
  prValidarUsuario   = OBJECT_ID('dbo.prValidarUsuario','P'),
  prInsertarUsuario  = OBJECT_ID('dbo.prInsertarUsuario','P'),
  prConsultarUsuarios= OBJECT_ID('dbo.prConsultarUsuarios','P'),
  prEliminarUsuarios = OBJECT_ID('dbo.prEliminarUsuarios','P'),
  prModificarUsuarios= OBJECT_ID('dbo.prModificarUsuarios','P'),
  prModificarPass    = OBJECT_ID('dbo.prModificarPasswordUsuarios','P');

-- SPs clientes
SELECT
  prInsertarCliente   = OBJECT_ID('dbo.prInsertarCliente','P'),
  prModificarCliente  = OBJECT_ID('dbo.prModificarCliente','P'),
  prEliminarCliente   = OBJECT_ID('dbo.prEliminarCliente','P'),
  prConsultarCliente  = OBJECT_ID('dbo.prConsultarCliente','P');

-- Conteos rápidos (no falla si vacío)
SELECT TOP 5 * FROM dbo.Perfiles ORDER BY CodigoUsuario;
SELECT TOP 5 * FROM dbo.Clientes ORDER BY IdCliente;