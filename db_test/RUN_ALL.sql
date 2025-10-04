/* =============================================================================
   Script de PRUEBAS: RUN_ALL.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Orquestar ejecución de pruebas en orden:
       1) Smoke / Salud
       2) Unitarias (Usuarios)
       3) Integración (Login / Solicitudes)
       4) Consistencia FKs
   Alcance:
     - DEV. No para producción.
   Nota: Requiere SQLCMD Mode activado (Query → SQLCMD Mode) en SSMS.
   ============================================================================= */

:ON ERROR EXIT
SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT '== RUN_ALL: INICIO ==';

-- 0) Reseed (opcional)
:r ..\db_scripts\util\Reseed_All.sql

-- 1) Smoke / Salud
:r .\00_basicas\Smoke_Objetos.sql

-- 2) Unitarias Usuarios
:r .\20_unitarias\Usuarios_Insertar_Validar.sql
:r .\20_unitarias\Usuarios_Modificar.sql
:r .\20_unitarias\Usuarios_Eliminar.sql
:r .\20_unitarias\Usuarios_CambiarPassword.sql

-- 3) Integración
:r .\30_integracion\Flujo_Login_MDI_Smoke.sql
:r .\30_integracion\Flujo_Solicitud_Completa.sql

-- 4) FK Consistencia (al final)
:r .\00_basicas\FK_Consistencia.sql

PRINT '== RUN_ALL: FIN OK ==';