/* =============================================================================
   Script de PRUEBAS: 30_integracion/Flujo_Solicitud_Completa.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Simular flujo completo: Cliente -> Solicitud -> Detalle -> Consultas.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

-- Arrange mínimos: cliente + catálogo básico
DECLARE @IdCliente INT;

INSERT INTO dbo.Clientes (NombreCliente, Cedula, Direccion, Telefono, Celular, Correo)
VALUES ('Cli Flujo', '8-123-456', 'Calle Flujo', '200', '600', 'flujo@demo.com');

SELECT @IdCliente = SCOPE_IDENTITY();

-- Departamento + Servicio + vínculo
DECLARE @IdDep INT, @IdSrv INT;

INSERT INTO dbo.Departamentos (NombreDepartamento, IdDepartamentoSuperior) VALUES ('General', 0);
SET @IdDep = SCOPE_IDENTITY();

INSERT INTO dbo.Servicios (IdServicio, NombreServicio, Precio) VALUES (100, 'Servicio X', 10.00);
SET @IdSrv = 100;

INSERT INTO dbo.DepartamentosServicios (IdDepartamento, IdServicio) VALUES (@IdDep, @IdSrv);

-- Insertar Solicitud por SP
DECLARE @IdSolicitud INT, @Nro VARCHAR(20);
EXEC dbo.prInsertarSolicitud
     @IdSolicitud = @IdSolicitud OUTPUT,
     @IdCliente = @IdCliente,
     @NumeroSolicitud = @Nro OUTPUT,
     @Fecha = GETDATE(),
     @Observacion = 'Flujo demo';

PRINT 'Solicitud creada Id=' + CONVERT(VARCHAR, @IdSolicitud) + ' Nro=' + ISNULL(@Nro,'(null)');

-- Detalle
DECLARE @IdDet INT;
EXEC dbo.prInsertarSolicitudDetalle
     @IdSolicitudDetalle = @IdDet OUTPUT,
     @IdSolicitud = @IdSolicitud,
     @IdServicio = @IdSrv,
     @IdDepartamento = @IdDep,
     @Precio = 10.00,
     @Cantidad = 2,
     @OtrosImportes = 0,
     @ITMBS = 0;

PRINT 'Detalle creado Id=' + CONVERT(VARCHAR, @IdDet);

-- Consultas
PRINT '== prConsultarSolicitud (por Id) ==';
EXEC dbo.prConsultarSolicitud @IdSolicitud = @IdSolicitud, @NumeroSolicitud = '';

PRINT '== prConsultarSolicitudDetalle (por IdSolicitud) ==';
EXEC dbo.prConsultarSolicitudDetalle @IdSolicitudDetalle = 0, @IdSolicitud = @IdSolicitud;

ROLLBACK TRAN;
PRINT 'Rollback (pruebas).';