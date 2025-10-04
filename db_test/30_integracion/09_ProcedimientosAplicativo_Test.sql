/* =============================================================================
   Script de PRUEBAS (Integración): 09_ProcedimientosAplicativo_Test.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar inserción maestro/detalle de Solicitudes (genera NumeroSolicitud).
     - Probar consultas avanzadas y por número.
     - Confirmar corrección de Clientes.Direccion en prConsultarCliente.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

BEGIN TRAN;

DECLARE @IdCli INT, @IdSol INT, @NumSol VARCHAR(20), @IdDet INT;

-- Semilla mínima: Departamento + Servicio si no existen
IF NOT EXISTS (SELECT 1 FROM dbo.Departamentos) BEGIN
    INSERT INTO dbo.Departamentos (NombreDepartamento, IdDepartamentoSuperior) VALUES ('DEP TEST', 0);
END

IF NOT EXISTS (SELECT 1 FROM dbo.Servicios WHERE IdServicio = 9001) BEGIN
    INSERT INTO dbo.Servicios (IdServicio, NombreServicio, Precio) VALUES (9001, 'SERV TEST', 25.00);
END

-- Asociar alguno (puente) si no existe
IF NOT EXISTS (
   SELECT 1 FROM dbo.DepartamentosServicios ds
   JOIN dbo.Departamentos d ON d.IdDepartamento = ds.IdDepartamento
   WHERE ds.IdServicio = 9001
)
BEGIN
    DECLARE @dep INT = (SELECT TOP 1 IdDepartamento FROM dbo.Departamentos ORDER BY IdDepartamento);
    INSERT INTO dbo.DepartamentosServicios (IdDepartamento, IdServicio) VALUES (@dep, 9001);
END

-- Cliente de prueba
INSERT INTO dbo.Clientes (NombreCliente, Cedula, Direccion, Telefono, Celular, Correo)
VALUES ('Cliente Test 09', 'X-999', 'Calle 09', '111', '666', 't09@x.com');
SET @IdCli = SCOPE_IDENTITY();

-- Insertar SOLICITUD (genera NumeroSolicitud)
EXEC dbo.prInsertarSolicitud
     @IdSolicitud = @IdSol OUTPUT,
     @IdCliente   = @IdCli,
     @NumeroSolicitud = @NumSol OUTPUT,
     @Fecha       = GETDATE(),
     @Observacion = 'Obs 09';

PRINT 'IdSolicitud=' + CONVERT(VARCHAR, @IdSol) + '  NumeroSolicitud=' + ISNULL(@NumSol,'(null)');

-- Insertar DETALLE
EXEC dbo.prInsertarSolicitudDetalle
     @IdSolicitudDetalle = @IdDet OUTPUT,
     @IdSolicitud        = @IdSol,
     @IdServicio         = 9001,
     @IdDepartamento     = (SELECT TOP 1 IdDepartamento FROM dbo.Departamentos ORDER BY IdDepartamento),
     @Precio             = 25.00,
     @Cantidad           = 2,
     @OtrosImportes      = 0,
     @ITMBS              = 0;

-- Consultas
PRINT '=== prConsultarSolicitud (por número) ===';
EXEC dbo.prConsultarSolicitud @IdSolicitud = 0, @NumeroSolicitud = @NumSol;

PRINT '=== prConsultaAvanzadaSolicitud (por rango / todos clientes) ===';
DECLARE @dIni DATETIME = CONVERT(DATE, GETDATE());
DECLARE @dFin DATETIME = CONVERT(DATE, GETDATE());
EXEC dbo.prConsultaAvanzadaSolicitud
     @NumeroSolicitud = NULL,
     @IdCliente       = 0,
     @FechaIni        = @dIni,
     @FechaFin        = @dFin;

PRINT '=== prConsultarCliente (Direccion) ===';
EXEC dbo.prConsultarCliente @IdCliente = @IdCli;

ROLLBACK TRAN;
PRINT 'Rollback realizado (solo pruebas).';