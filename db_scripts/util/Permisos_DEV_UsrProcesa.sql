/* =============================================================================
   Script de PRUEBAS/UTIL: db_scripts/util/Permisos_DEV_UsrProcesa.sql
   Autor:          Ruben E. Cañizares M.
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Reaplicar permisos mínimos para el usuario [UsrProcesa] en DEV
   Alcance:
     - DEV únicamente. No para producción.
   Nota: En 01 ya le dimos db_owner a UsrProcesa. Este script está por si
         cambiaste permisos y quieres GRANT mínimos para DEV.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

IF USER_ID(N'UsrProcesa') IS NULL
BEGIN
    PRINT 'El usuario [UsrProcesa] no existe en la BD. Ejecuta 01 primero.';
    RETURN;
END

PRINT '== Reasignando permisos mínimos a [UsrProcesa] (DEV) ==';

-- SELECT en tablas clave
DECLARE @grantSql NVARCHAR(MAX) = N'';
SELECT @grantSql = STRING_AGG(N'GRANT SELECT ON dbo.' + QUOTENAME(t.name) + N' TO [UsrProcesa];', CHAR(10))
FROM sys.tables t
WHERE t.name IN (
    'Perfiles','Clientes','Departamentos','Servicios','DepartamentosServicios',
    'Solicitudes','SolicitudesDetalle','Facturas','FacturasDetalle','Recibos','RecibosDetalle'
);
EXEC sys.sp_executesql @grantSql;

-- EXECUTE en SPs principales
SET @grantSql = N'';
SELECT @grantSql = STRING_AGG(N'GRANT EXECUTE ON dbo.' + QUOTENAME(p.name) + N' TO [UsrProcesa];', CHAR(10))
FROM sys.procedures p
WHERE p.name IN (
    'prValidarUsuario','prInsertarUsuario','prConsultarUsuarios','prEliminarUsuarios',
    'prModificarUsuarios','prModificarPasswordUsuarios',
    'prActualizarSolicitud','prActualizarSolicitudDetalle','prConsultaAvanzadaSolicitud',
    'prConsultarCliente','prConsultarDepartamento','prConsultarProductosServicios',
    'prConsultarSolicitud','prConsultarSolicitudDetalle','prEliminarSolicitudesDetalle',
    'prInsertarSolicitud','prInsertarSolicitudDetalle'
);
EXEC sys.sp_executesql @grantSql;

PRINT '== Permisos mínimos (DEV) otorgados a [UsrProcesa] ==';