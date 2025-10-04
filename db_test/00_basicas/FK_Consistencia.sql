/* =============================================================================
   Script de PRUEBAS: 00_basicas/FK_Consistencia.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Detectar orfandad en FKs importantes.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

-- Solicitudes -> Clientes
SELECT 'Solicitudes.Cliente huérfano' AS CheckName, s.*
FROM dbo.Solicitudes s
LEFT JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
WHERE c.IdCliente IS NULL;

-- SolicitudesDetalle -> Solicitudes
SELECT 'SolicitudesDetalle.Solicitud huérfano' AS CheckName, sd.*
FROM dbo.SolicitudesDetalle sd
LEFT JOIN dbo.Solicitudes s ON s.IdSolicitud = sd.IdSolicitud
WHERE s.IdSolicitud IS NULL;

-- SolicitudesDetalle -> Servicios
SELECT 'SolicitudesDetalle.Servicio huérfano' AS CheckName, sd.*
FROM dbo.SolicitudesDetalle sd
LEFT JOIN dbo.Servicios sv ON sv.IdServicio = sd.IdServicio
WHERE sv.IdServicio IS NULL;

-- SolicitudesDetalle -> Departamentos
SELECT 'SolicitudesDetalle.Departamento huérfano' AS CheckName, sd.*
FROM dbo.SolicitudesDetalle sd
LEFT JOIN dbo.Departamentos d ON d.IdDepartamento = sd.IdDepartamento
WHERE d.IdDepartamento IS NULL;

-- Facturas -> Clientes
SELECT 'Facturas.Cliente huérfano' AS CheckName, f.*
FROM dbo.Facturas f
LEFT JOIN dbo.Clientes c ON c.IdCliente = f.IdCliente
WHERE c.IdCliente IS NULL;

-- FacturasDetalle -> Facturas
SELECT 'FacturasDetalle.Factura huérfano' AS CheckName, fd.*
FROM dbo.FacturasDetalle fd
LEFT JOIN dbo.Facturas f ON f.IdFactura = fd.IdFactura
WHERE f.IdFactura IS NULL;

-- FacturasDetalle -> Servicios
SELECT 'FacturasDetalle.Servicio huérfano' AS CheckName, fd.*
FROM dbo.FacturasDetalle fd
LEFT JOIN dbo.Servicios sv ON sv.IdServicio = fd.IdServicio
WHERE sv.IdServicio IS NULL;

-- FacturasDetalle -> SolicitudesDetalle
SELECT 'FacturasDetalle.SolicitudDetalle huérfano' AS CheckName, fd.*
FROM dbo.FacturasDetalle fd
LEFT JOIN dbo.SolicitudesDetalle sd ON sd.IdSolicitudDetalle = fd.IdSolicitudDetalle
WHERE sd.IdSolicitudDetalle IS NULL;

-- Recibos -> Clientes
SELECT 'Recibos.Cliente huérfano' AS CheckName, r.*
FROM dbo.Recibos r
LEFT JOIN dbo.Clientes c ON c.IdCliente = r.IdCliente
WHERE c.IdCliente IS NULL;

-- RecibosDetalle -> Recibos
SELECT 'RecibosDetalle.Recibo huérfano' AS CheckName, rd.*
FROM dbo.RecibosDetalle rd
LEFT JOIN dbo.Recibos r ON r.IdRecibo = rd.IdRecibo
WHERE r.IdRecibo IS NULL;

-- RecibosDetalle -> FacturasDetalle
SELECT 'RecibosDetalle.FacturasDetalle huérfano' AS CheckName, rd.*
FROM dbo.RecibosDetalle rd
LEFT JOIN dbo.FacturasDetalle fd ON fd.IdFacturaDetalle = rd.IdFacturaDetalle
WHERE fd.IdFacturaDetalle IS NULL;

-- RecibosDetalle -> Servicios
SELECT 'RecibosDetalle.Servicio huérfano' AS CheckName, rd.*
FROM dbo.RecibosDetalle rd
LEFT JOIN dbo.Servicios sv ON sv.IdServicio = rd.IdServicio
WHERE sv.IdServicio IS NULL;