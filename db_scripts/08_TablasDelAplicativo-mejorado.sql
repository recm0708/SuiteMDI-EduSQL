/* =============================================================================
   Script:         08_TablasDelAplicativo-mejorado.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Crear tablas del aplicativo (Clientes, Departamentos, Servicios, puente, Solicitudes,
       SolicitudesDetalle, Facturas, FacturasDetalle, Recibos, RecibosDetalle)
     - Definir PKs, FKs y un índice único compuesto (IdDepartamento, IdServicio)
     - Normalizar nombre de columna: Dirrecion → Direccion
   Notas:
     - Idempotente: crea objetos solo si no existen; agrega FKs/índices si faltan.
     - Tipos originales conservados (VARCHAR/MONEY/DATETIME).
   Observación:
     Se corrige la columna **Direccion** (antes Dirrecion) y se estandarizan nombres
     de constraints/índices y checks, manteniendo el modelo funcional original.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

/* =========================
   CLIENTES
   ========================= */
IF OBJECT_ID('dbo.Clientes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes(
        IdCliente       INT IDENTITY(1000,1) NOT NULL,
        NombreCliente   VARCHAR(200) NULL,
        Cedula          VARCHAR(30)  NULL,
        Direccion       VARCHAR(300) NULL,   -- nombre corregido
        Telefono        VARCHAR(20)  NULL,
        Celular         VARCHAR(20)  NULL,
        Correo          VARCHAR(200) NULL,
        CONSTRAINT PK_Clientes PRIMARY KEY CLUSTERED (IdCliente ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END;
GO

/* =========================
   DEPARTAMENTOS
   ========================= */
IF OBJECT_ID('dbo.Departamentos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Departamentos(
        IdDepartamento          INT IDENTITY(1,1) NOT NULL,
        NombreDepartamento      VARCHAR(120) NULL,
        IdDepartamentoSuperior  INT NOT NULL,
        CONSTRAINT PK_Departamentos PRIMARY KEY CLUSTERED (IdDepartamento ASC)
    );
END;
GO

/* =========================
   SERVICIOS
   ========================= */
IF OBJECT_ID('dbo.Servicios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Servicios(
        IdServicio      INT NOT NULL,
        NombreServicio  VARCHAR(120) NULL,
        Precio          MONEY NULL,
        CONSTRAINT PK_Servicios PRIMARY KEY CLUSTERED (IdServicio ASC)
    );
END;
GO

/* =========================
   DEPARTAMENTOS-SERVICIOS (Puente)
   ========================= */
IF OBJECT_ID('dbo.DepartamentosServicios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DepartamentosServicios(
        IdDepartamentoServicio INT IDENTITY(1,1) NOT NULL,
        IdDepartamento         INT NOT NULL,
        IdServicio             INT NOT NULL,
        CONSTRAINT PK_DepartamentosServicios
            PRIMARY KEY CLUSTERED (IdDepartamentoServicio ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END;
GO

/* FKs y UNIQUE del puente (si faltan) */
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
     WHERE name = 'FK_DepartamentosServicios_Departamentos'
)
BEGIN
    ALTER TABLE dbo.DepartamentosServicios
        ADD CONSTRAINT FK_DepartamentosServicios_Departamentos
        FOREIGN KEY (IdDepartamento)
        REFERENCES dbo.Departamentos (IdDepartamento)
        WITH CHECK;
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
     WHERE name = 'FK_DepartamentosServicios_Servicios'
)
BEGIN
    ALTER TABLE dbo.DepartamentosServicios
        ADD CONSTRAINT FK_DepartamentosServicios_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES dbo.Servicios (IdServicio)
        WITH CHECK;
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
     WHERE name = 'UX_DepartamentosServicios_IdDepartamento_IdServicio'
       AND object_id = OBJECT_ID('dbo.DepartamentosServicios')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_DepartamentosServicios_IdDepartamento_IdServicio
        ON dbo.DepartamentosServicios (IdDepartamento, IdServicio)
        WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF);
END;
GO

/* =========================
   SOLICITUDES (maestro)
   ========================= */
IF OBJECT_ID('dbo.Solicitudes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Solicitudes(
        IdSolicitud     INT IDENTITY(1,1) NOT NULL,
        IdCliente       INT NOT NULL,
        NumeroSolicitud VARCHAR(20) NOT NULL,
        Fecha           DATETIME NOT NULL,
        Observacion     VARCHAR(300) NULL,
        Provincia       VARCHAR(50) NULL,
        CONSTRAINT PK_Solicitudes PRIMARY KEY CLUSTERED (IdSolicitud ASC)
    );

    -- UNIQUE para NumeroSolicitud
    ALTER TABLE dbo.Solicitudes
        ADD CONSTRAINT UX_Solicitudes_NumeroSolicitud UNIQUE NONCLUSTERED (NumeroSolicitud ASC);
END;
GO

/* FK Solicitudes → Clientes */
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
     WHERE name = 'FK_Solicitudes_Clientes'
)
BEGIN
    ALTER TABLE dbo.Solicitudes
        ADD CONSTRAINT FK_Solicitudes_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES dbo.Clientes (IdCliente)
        WITH CHECK;
END;
GO

/* Extended property (descripción formato de Número) */
IF NOT EXISTS (
    SELECT 1
      FROM sys.extended_properties
     WHERE name = N'MS_Description'
       AND class = 1  -- column
       AND major_id = OBJECT_ID(N'dbo.Solicitudes')
       AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'dbo.Solicitudes'), 'NumeroSolicitud', 'ColumnId')
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Formato: SBSNN-secuencial. SBS=Solicitud; NN=dos dígitos del año; "-" guion; secuencial por año',
        @level0type = N'SCHEMA',  @level0name = N'dbo',
        @level1type = N'TABLE',   @level1name = N'Solicitudes',
        @level2type = N'COLUMN',  @level2name = N'NumeroSolicitud';
END;
GO

/* =========================
   SOLICITUDES DETALLE
   ========================= */
IF OBJECT_ID('dbo.SolicitudesDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SolicitudesDetalle(
        IdSolicitudDetalle  INT IDENTITY(1,1) NOT NULL,
        IdSolicitud         INT NULL,
        IdServicio          INT NULL,
        IdDepartamento      INT NULL,
        Precio              DECIMAL(19,2) NULL,
        Cantidad            INT NULL,
        OtrosImportes       DECIMAL(19,2) NULL,
        ITMBS               DECIMAL(19,2) NULL,
        CONSTRAINT PK_SolicitudesDetalle
            PRIMARY KEY CLUSTERED (IdSolicitudDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END;
GO

/* FKs de detalle */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SolicitudesDetalle_Solicitudes')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
        ADD CONSTRAINT FK_SolicitudesDetalle_Solicitudes
        FOREIGN KEY (IdSolicitud)
        REFERENCES dbo.Solicitudes (IdSolicitud)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SolicitudesDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
        ADD CONSTRAINT FK_SolicitudesDetalle_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES dbo.Servicios (IdServicio)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SolicitudesDetalle_Departamentos')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
        ADD CONSTRAINT FK_SolicitudesDetalle_Departamentos
        FOREIGN KEY (IdDepartamento)
        REFERENCES dbo.Departamentos (IdDepartamento)
        WITH CHECK;
END;
GO

/* =========================
   FACTURAS (maestro)
   ========================= */
IF OBJECT_ID('dbo.Facturas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Facturas(
        IdFactura      INT IDENTITY(1,1) NOT NULL,
        IdCliente      INT NOT NULL,
        IdDepartamento INT NULL,
        Fecha          VARCHAR(20) NULL,
        CONSTRAINT PK_Facturas
            PRIMARY KEY CLUSTERED (IdFactura ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END;
GO

/* FKs de Facturas */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Facturas_Clientes')
BEGIN
    ALTER TABLE dbo.Facturas
        ADD CONSTRAINT FK_Facturas_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES dbo.Clientes (IdCliente)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Facturas_Departamentos')
BEGIN
    ALTER TABLE dbo.Facturas
        ADD CONSTRAINT FK_Facturas_Departamentos
        FOREIGN KEY (IdDepartamento)
        REFERENCES dbo.Departamentos (IdDepartamento)
        WITH CHECK;
END;
GO

/* =========================
   FACTURAS DETALLE
   ========================= */
IF OBJECT_ID('dbo.FacturasDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FacturasDetalle(
        IdFacturaDetalle INT IDENTITY(1,1) NOT NULL,
        IdFactura        INT NULL,
        IdServicio       INT NULL,
        IdSolicitudDetalle INT NULL,
        Precio           MONEY NULL,
        Cantidad         INT NULL,
        OtrosImportes    DECIMAL(4, 2) NULL,
        ITMBS            DECIMAL(4, 2) NULL,
        Descuento        DECIMAL(4, 2) NULL,
        CONSTRAINT PK_FacturasDetalle
            PRIMARY KEY CLUSTERED (IdFacturaDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END;
GO

/* FKs de FacturasDetalle */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FacturasDetalle_Facturas')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
        ADD CONSTRAINT FK_FacturasDetalle_Facturas
        FOREIGN KEY (IdFactura)
        REFERENCES dbo.Facturas (IdFactura)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FacturasDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
        ADD CONSTRAINT FK_FacturasDetalle_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES dbo.Servicios (IdServicio)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FacturasDetalle_SolicitudesDetalle')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
        ADD CONSTRAINT FK_FacturasDetalle_SolicitudesDetalle
        FOREIGN KEY (IdSolicitudDetalle)
        REFERENCES dbo.SolicitudesDetalle (IdSolicitudDetalle)
        WITH CHECK;
END;
GO

/* =========================
   RECIBOS (maestro)
   ========================= */
IF OBJECT_ID('dbo.Recibos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Recibos(
        IdRecibo      INT IDENTITY(1,1) NOT NULL,
        IdCliente     INT NOT NULL,
        Fecha         VARCHAR(20) NULL,
        Observaciones VARCHAR(300) NULL,
        CONSTRAINT PK_Recibos
            PRIMARY KEY CLUSTERED (IdRecibo ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    );
END;
GO

/* FK Recibos → Clientes */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Recibos_Clientes')
BEGIN
    ALTER TABLE dbo.Recibos
        ADD CONSTRAINT FK_Recibos_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES dbo.Clientes (IdCliente)
        WITH CHECK;
END;
GO

/* =========================
   RECIBOS DETALLE
   ========================= */
IF OBJECT_ID('dbo.RecibosDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RecibosDetalle(
        IdReciboDetalle INT IDENTITY(1,1) NOT NULL,
        IdRecibo        INT NOT NULL,
        IdFacturaDetalle INT NOT NULL,
        IdServicio      INT NULL,
        Precio          MONEY NULL,
        Cantidad        INT NULL,
        OtrosImportes   DECIMAL(4, 2) NULL,
        ITMBS           DECIMAL(4, 2) NULL,
        Descuento       DECIMAL(4, 2) NULL,
        CONSTRAINT PK_RecibosDetalle
            PRIMARY KEY CLUSTERED (IdReciboDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    );
END;
GO

/* FKs de RecibosDetalle */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_RecibosDetalle_Recibos')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
        ADD CONSTRAINT FK_RecibosDetalle_Recibos
        FOREIGN KEY (IdRecibo)
        REFERENCES dbo.Recibos (IdRecibo)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_RecibosDetalle_FacturasDetalle')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
        ADD CONSTRAINT FK_RecibosDetalle_FacturasDetalle
        FOREIGN KEY (IdFacturaDetalle)
        REFERENCES dbo.FacturasDetalle (IdFacturaDetalle)
        WITH CHECK;
END;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_RecibosDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
        ADD CONSTRAINT FK_RecibosDetalle_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES dbo.Servicios (IdServicio)
        WITH CHECK;
END;
GO