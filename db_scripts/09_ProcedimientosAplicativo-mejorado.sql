/* =============================================================================
   Script:         09_ProcedimientosAplicativo-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear/actualizar SPs de Solicitudes (maestro/detalle) y consultas auxiliares.
     - Normalizar lógica de fechas y generación de NumeroSolicitud (SBSYY-N).
     - Corregir referencias de Clientes.Direccion (antes: Dirrecion).
   Notas:
     - Idempotente: CREATE OR ALTER para todos los SPs.
     - Fechas: se evita depender de SET DATEFORMAT; se usa CONVERT y rangos inclusivos.
     - NumeroSolicitud: secuencial por año (YY) con búsqueda MAX segura.
   Observación:
     Se homologa el estilo de los procedimientos, se corrigen nombres heredados
     (Direccion) y se robustece la generación de Número de Solicitud sin asumir
     datos previos, manteniendo la intención funcional original.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

/* ============================================================================
   ACTUALIZAR SOLICITUD (maestro)
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prActualizarSolicitud
(
    @IdSolicitud     INT,
    @IdCliente       INT,
    @NumeroSolicitud VARCHAR(20),
    @Fecha           DATETIME,
    @Observacion     VARCHAR(300)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
       SET s.IdCliente       = @IdCliente,
           s.NumeroSolicitud = @NumeroSolicitud,
           s.Fecha           = @Fecha,
           s.Observacion     = @Observacion
      FROM dbo.Solicitudes s
     WHERE s.IdSolicitud = @IdSolicitud;

    RETURN @@ROWCOUNT;
END
GO

/* ============================================================================
   ACTUALIZAR SOLICITUD DETALLE
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prActualizarSolicitudDetalle
(
    @IdSolicitudDetalle INT,
    @IdSolicitud        INT,
    @IdServicio         INT,
    @IdDepartamento     INT,
    @Precio             DECIMAL(19,2),
    @Cantidad           INT,
    @OtrosImportes      DECIMAL(19,2),
    @ITMBS              DECIMAL(19,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sd
       SET sd.IdSolicitud   = @IdSolicitud,
           sd.IdServicio    = @IdServicio,
           sd.IdDepartamento= @IdDepartamento,
           sd.Precio        = @Precio,
           sd.Cantidad      = @Cantidad,
           sd.OtrosImportes = @OtrosImportes,
           sd.ITMBS         = @ITMBS
      FROM dbo.SolicitudesDetalle sd
     WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;

    RETURN @@ROWCOUNT;
END
GO

/* ============================================================================
   CONSULTA AVANZADA DE SOLICITUD
   - Si @NumeroSolicitud no es NULL/'' => busca exacto por número
   - Si no, filtra por fecha (rango inclusive) y opcional @IdCliente (0 = todos)
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultaAvanzadaSolicitud
(
    @NumeroSolicitud VARCHAR(20) = NULL,
    @IdCliente       INT         = 0,
    @FechaIni        DATETIME    = NULL,
    @FechaFin        DATETIME    = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (NULLIF(LTRIM(RTRIM(ISNULL(@NumeroSolicitud, ''))), '') IS NOT NULL)
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion, c.NombreCliente
          FROM dbo.Solicitudes s
          JOIN dbo.Clientes    c ON c.IdCliente = s.IdCliente
         WHERE s.NumeroSolicitud = @NumeroSolicitud;
        RETURN;
    END

    -- Normalizar fechas: si vienen NULL, usar hoy; si vienen con hora, se arma rango inclusivo
    DECLARE @dIni DATE = ISNULL(CONVERT(DATE, @FechaIni), CONVERT(DATE, GETDATE()));
    DECLARE @dFin DATE = ISNULL(CONVERT(DATE, @FechaFin), CONVERT(DATE, GETDATE()));

    SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion, c.NombreCliente
      FROM dbo.Solicitudes s
      JOIN dbo.Clientes    c ON c.IdCliente = s.IdCliente
     WHERE s.Fecha >= @dIni
       AND s.Fecha < DATEADD(DAY, 1, @dFin)
       AND (@IdCliente = 0 OR s.IdCliente = @IdCliente);
END
GO

/* ============================================================================
   CONSULTAR CLIENTE(S)
   - @IdCliente > 0: uno
   - @IdCliente <=0 / NULL: todos
   - Corrige columna Direccion
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultarCliente
(
    @IdCliente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@IdCliente, 0) > 0
    BEGIN
        SELECT c.IdCliente, c.NombreCliente, c.Cedula, c.Direccion, c.Telefono, c.Celular, c.Correo
          FROM dbo.Clientes c
         WHERE c.IdCliente = @IdCliente
         ORDER BY c.IdCliente;
        RETURN;
    END

    SELECT c.IdCliente, c.NombreCliente, c.Cedula, c.Direccion, c.Telefono, c.Celular, c.Correo
      FROM dbo.Clientes c
     ORDER BY c.IdCliente;
END
GO

/* ============================================================================
   CONSULTAR DEPARTAMENTO(S)
   - @Opcion = 0: solo con servicios asociados + (NINGUNO) = 0
   - @Opcion = 1: todos (si @IdDepartamento>0, uno)
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultarDepartamento
(
    @IdDepartamento INT,
    @Opcion         INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @Opcion = ISNULL(@Opcion, 0);

    IF @Opcion = 0
    BEGIN
        SELECT 0 AS IdDepartamento, '(NINGUNO)' AS NombreDepartamento, 0 AS IdDepartamentoSuperior
        UNION
        SELECT DISTINCT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
          FROM dbo.Departamentos d
          JOIN dbo.DepartamentosServicios ds ON ds.IdDepartamento = d.IdDepartamento
         ORDER BY IdDepartamento;
        RETURN;
    END

    IF ISNULL(@IdDepartamento, 0) > 0
    BEGIN
        SELECT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
          FROM dbo.Departamentos d
         WHERE d.IdDepartamento = @IdDepartamento
         ORDER BY IdDepartamento;
        RETURN;
    END

    SELECT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
      FROM dbo.Departamentos d
     ORDER BY IdDepartamento;
END
GO

/* ============================================================================
   CONSULTAR PRODUCTOS/SERVICIOS
   - @IdServicio > 0: uno
   - @IdServicio = 0 y @IdDepartamento = 0: todos
   - @IdServicio = 0 y @IdDepartamento > 0: por departamento
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultarProductosServicios
(
    @IdServicio     INT,
    @IdDepartamento INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@IdServicio, 0) > 0
    BEGIN
        SELECT  s.IdServicio,
                NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
                s.Precio
          FROM dbo.Servicios s
         WHERE s.IdServicio = @IdServicio
         ORDER BY s.IdServicio;
        RETURN;
    END

    IF ISNULL(@IdDepartamento, 0) = 0
    BEGIN
        SELECT  s.IdServicio,
                NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
                s.Precio
          FROM dbo.Servicios s
         ORDER BY s.IdServicio;
        RETURN;
    END

    SELECT  s.IdServicio,
            NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
            s.Precio
      FROM dbo.Servicios s
      JOIN dbo.DepartamentosServicios ds ON ds.IdServicio = s.IdServicio
     WHERE ds.IdDepartamento = @IdDepartamento
     ORDER BY s.IdServicio;
END
GO

/* ============================================================================
   CONSULTAR SOLICITUD(ES)
   - @IdSolicitud > 0: una
   - @IdSolicitud <=0 y @NumeroSolicitud <> '' : por número
   - ambos vacíos: todas
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultarSolicitud
(
    @IdSolicitud     INT,
    @NumeroSolicitud VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@IdSolicitud, 0) > 0
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
          FROM dbo.Solicitudes s
          JOIN dbo.Clientes   c ON c.IdCliente = s.IdCliente
         WHERE s.IdSolicitud = @IdSolicitud;
        RETURN;
    END

    IF NULLIF(LTRIM(RTRIM(ISNULL(@NumeroSolicitud, ''))), '') IS NOT NULL
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
          FROM dbo.Solicitudes s
          JOIN dbo.Clientes   c ON c.IdCliente = s.IdCliente
         WHERE s.NumeroSolicitud = @NumeroSolicitud;
        RETURN;
    END

    SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
      FROM dbo.Solicitudes s
      JOIN dbo.Clientes   c ON c.IdCliente = s.IdCliente;
END
GO

/* ============================================================================
   CONSULTAR SOLICITUD DETALLE(S)
   - @IdSolicitud > 0: por solicitud
   - @IdSolicitud = 0 y @IdSolicitudDetalle > 0: por detalle
   - ambos vacíos: todos (uso de pruebas)
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prConsultarSolicitudDetalle
(
    @IdSolicitudDetalle INT,
    @IdSolicitud        INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@IdSolicitud, 0) > 0
    BEGIN
        SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
               ps.NombreServicio, d.NombreDepartamento,
               sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
               Total = (sd.Cantidad * sd.Precio) + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
               s.NumeroSolicitud
          FROM dbo.SolicitudesDetalle sd
          JOIN dbo.Solicitudes       s  ON s.IdSolicitud   = sd.IdSolicitud
          JOIN dbo.Departamentos     d  ON d.IdDepartamento= sd.IdDepartamento
          JOIN dbo.Servicios         ps ON ps.IdServicio   = sd.IdServicio
         WHERE sd.IdSolicitud = @IdSolicitud;
        RETURN;
    END

    IF ISNULL(@IdSolicitudDetalle, 0) > 0
    BEGIN
        SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
               ps.NombreServicio, d.NombreDepartamento,
               sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
               Total = (sd.Cantidad * sd.Precio) + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
               s.NumeroSolicitud
          FROM dbo.SolicitudesDetalle sd
          JOIN dbo.Solicitudes       s  ON s.IdSolicitud   = sd.IdSolicitud
          JOIN dbo.Departamentos     d  ON d.IdDepartamento= sd.IdDepartamento
          JOIN dbo.Servicios         ps ON ps.IdServicio   = sd.IdServicio
         WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;
        RETURN;
    END

    -- Solo para inspección (tests)
    SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
           ps.NombreServicio, d.NombreDepartamento,
           sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
           Total = (sd.Cantidad * sd.Precio) + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
           s.NumeroSolicitud
      FROM dbo.SolicitudesDetalle sd
      JOIN dbo.Solicitudes       s  ON s.IdSolicitud   = sd.IdSolicitud
      JOIN dbo.Departamentos     d  ON d.IdDepartamento= sd.IdDepartamento
      JOIN dbo.Servicios         ps ON ps.IdServicio   = sd.IdServicio;
END
GO

/* ============================================================================
   ELIMINAR DETALLE DE SOLICITUD
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prEliminarSolicitudesDetalle
(
    @IdSolicitudDetalle INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE sd
      FROM dbo.SolicitudesDetalle sd
     WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;

    RETURN @@ROWCOUNT;
END
GO

/* ============================================================================
   INSERTAR SOLICITUD (genera @IdSolicitud y @NumeroSolicitud)
   - NumeroSolicitud = SBS + (YY) + '-' + secuencial por año (1..N)
   - Busca MAX(seg) para el año YY; si no hay, arranca en 1
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prInsertarSolicitud
(
    @IdSolicitud     INT         OUTPUT,
    @IdCliente       INT,
    @NumeroSolicitud VARCHAR(20) OUTPUT,
    @Fecha           DATETIME,
    @Observacion     VARCHAR(300)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @yy CHAR(2) = RIGHT(CONVERT(CHAR(4), YEAR(@Fecha)), 2);
    DECLARE @next INT;

    SELECT @next =
        ISNULL(MAX(TRY_CONVERT(INT, SUBSTRING(s.NumeroSolicitud, 7, 20))), 0) + 1
      FROM dbo.Solicitudes s
     WHERE SUBSTRING(s.NumeroSolicitud, 4, 2) = @yy
       AND LEFT(s.NumeroSolicitud, 3) = 'SBS';

    SET @NumeroSolicitud = 'SBS' + @yy + '-' + CONVERT(VARCHAR(17), @next);

    INSERT INTO dbo.Solicitudes (IdCliente, NumeroSolicitud, Fecha, Observacion)
    VALUES (@IdCliente, @NumeroSolicitud, @Fecha, @Observacion);

    SET @IdSolicitud = SCOPE_IDENTITY();
    RETURN 1;
END
GO

/* ============================================================================
   INSERTAR DETALLE DE SOLICITUD
   ============================================================================ */
CREATE OR ALTER PROCEDURE dbo.prInsertarSolicitudDetalle
(
    @IdSolicitudDetalle INT         OUTPUT,
    @IdSolicitud        INT,
    @IdServicio         INT,
    @IdDepartamento     INT,
    @Precio             DECIMAL(19,2),
    @Cantidad           INT,
    @OtrosImportes      DECIMAL(19,2),
    @ITMBS              DECIMAL(19,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SolicitudesDetalle
        (IdSolicitud, IdServicio, IdDepartamento, Precio, Cantidad, OtrosImportes, ITMBS)
    VALUES
        (@IdSolicitud, @IdServicio, @IdDepartamento, @Precio, @Cantidad, @OtrosImportes, @ITMBS);

    SET @IdSolicitudDetalle = SCOPE_IDENTITY();
    RETURN 1;
END
GO