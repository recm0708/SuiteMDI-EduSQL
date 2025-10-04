/* =============================================================================
   Script de PRUEBAS: 08_TablasDelAplicativo_Test.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Verificar existencia de tablas, PK/UK/FK, y nombre de columna Direccion
     - Probar integridad mínima (inserts maestro-detalle) con ROLLBACK
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '=== Existencia de tablas ===';
SELECT 'Clientes'              AS Tabla, OBJECT_ID('dbo.Clientes','U')              AS ObjId
UNION ALL SELECT 'Departamentos',           OBJECT_ID('dbo.Departamentos','U')
UNION ALL SELECT 'Servicios',               OBJECT_ID('dbo.Servicios','U')
UNION ALL SELECT 'DepartamentosServicios',  OBJECT_ID('dbo.DepartamentosServicios','U')
UNION ALL SELECT 'Solicitudes',             OBJECT_ID('dbo.Solicitudes','U')
UNION ALL SELECT 'SolicitudesDetalle',      OBJECT_ID('dbo.SolicitudesDetalle','U')
UNION ALL SELECT 'Facturas',                OBJECT_ID('dbo.Facturas','U')
UNION ALL SELECT 'FacturasDetalle',         OBJECT_ID('dbo.FacturasDetalle','U')
UNION ALL SELECT 'Recibos',                 OBJECT_ID('dbo.Recibos','U')
UNION ALL SELECT 'RecibosDetalle',          OBJECT_ID('dbo.RecibosDetalle','U');

PRINT '=== Columna Direccion (corregida) ===';
SELECT c.name AS Columna
FROM sys.columns c
JOIN sys.objects o ON o.object_id = c.object_id
WHERE o.name = 'Clientes' AND c.name = 'Direccion';

PRINT '=== Constraint única en DepartamentosServicios (IdDepartamento, IdServicio) ===';
SELECT i.name, i.is_unique
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.DepartamentosServicios') AND i.name = 'UX_DepartamentosServicios_IdDepartamento_IdServicio';

PRINT '=== FKs clave ===';
SELECT fk.name, OBJECT_NAME(fk.parent_object_id) AS Tabla
FROM sys.foreign_keys fk
WHERE fk.name IN (
  'FK_DepartamentosServicios_Departamentos',
  'FK_DepartamentosServicios_Servicios',
  'FK_Solicitudes_Clientes',
  'FK_SolicitudesDetalle_Solicitudes',
  'FK_SolicitudesDetalle_Servicios',
  'FK_SolicitudesDetalle_Departamentos',
  'FK_Facturas_Clientes',
  'FK_Facturas_Departamentos',
  'FK_FacturasDetalle_Facturas',
  'FK_FacturasDetalle_Servicios',
  'FK_FacturasDetalle_SolicitudesDetalle',
  'FK_Recibos_Clientes',
  'FK_RecibosDetalle_Recibos',
  'FK_RecibosDetalle_FacturasDetalle',
  'FK_RecibosDetalle_Servicios'
);

PRINT '=== Smoke maestro-detalle con ROLLBACK ===';
BEGIN TRAN;

DECLARE @IdDepto INT, @IdServ INT, @IdCli INT, @IdSol INT, @IdDet INT, @IdFac INT, @IdFacDet INT, @IdRec INT, @IdRecDet INT;

INSERT INTO dbo.Departamentos (NombreDepartamento, IdDepartamentoSuperior) VALUES ('DEP 1', 0);
SET @IdDepto = SCOPE_IDENTITY();

INSERT INTO dbo.Servicios (IdServicio, NombreServicio, Precio) VALUES (100, 'Servicio 100', 10.00);

INSERT INTO dbo.DepartamentosServicios (IdDepartamento, IdServicio) VALUES (@IdDepto, 100);

INSERT INTO dbo.Clientes (NombreCliente, Cedula, Direccion, Telefono, Celular, Correo)
VALUES ('Cliente Prueba','X-1','Calle 1','111','666','c@x.com');
SET @IdCli = SCOPE_IDENTITY();

INSERT INTO dbo.Solicitudes (IdCliente, NumeroSolicitud, Fecha, Observacion, Provincia)
VALUES (@IdCli, 'SBS25-1', GETDATE(), 'Obs', 'PA');
SET @IdSol = SCOPE_IDENTITY();

INSERT INTO dbo.SolicitudesDetalle (IdSolicitud, IdServicio, IdDepartamento, Precio, Cantidad, OtrosImportes, ITMBS)
VALUES (@IdSol, 100, @IdDepto, 10.00, 1, 0, 0);
SET @IdDet = SCOPE_IDENTITY();

INSERT INTO dbo.Facturas (IdCliente, IdDepartamento, Fecha) VALUES (@IdCli, @IdDepto, '2025-10-01');
SET @IdFac = SCOPE_IDENTITY();

INSERT INTO dbo.FacturasDetalle (IdFactura, IdServicio, IdSolicitudDetalle, Precio, Cantidad, OtrosImportes, ITMBS, Descuento)
VALUES (@IdFac, 100, @IdDet, 10.00, 1, 0, 0, 0);
SET @IdFacDet = SCOPE_IDENTITY();

INSERT INTO dbo.Recibos (IdCliente, Fecha, Observaciones) VALUES (@IdCli, '2025-10-01', 'Pago');
SET @IdRec = SCOPE_IDENTITY();

INSERT INTO dbo.RecibosDetalle (IdRecibo, IdFacturaDetalle, IdServicio, Precio, Cantidad, OtrosImportes, ITMBS, Descuento)
VALUES (@IdRec, @IdFacDet, 100, 10.00, 1, 0, 0, 0);
SET @IdRecDet = SCOPE_IDENTITY();

SELECT
  @IdDepto AS IdDepto, @IdServ AS IdServ, @IdCli AS IdCli, @IdSol AS IdSol,
  @IdDet AS IdSolDet, @IdFac AS IdFac, @IdFacDet AS IdFacDet, @IdRec AS IdRec, @IdRecDet AS IdRecDet;

ROLLBACK TRAN;
PRINT 'Rollback realizado.';