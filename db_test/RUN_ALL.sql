/* =============================================================================
   Script:         db_test/RUN_ALL.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - Orquestar la ejecución de pruebas SQL separadas de producción.
     - Mantener orden lógico: básicas → semillas → unitarias → integración.
     - Evitar efectos secundarios: cada test maneja sus transacciones.
   Notas:
     - Ejecutar en SSMS con SQLCMD Mode: Query → SQLCMD Mode (✔).
     - Rutas relativas: se asume que abres este archivo desde /db_test/.
     - Sin :setvar. Si deseas fail-fast, descomenta “:ON ERROR EXIT”.
   ============================================================================= */

:OUT std  -- (opcional) para ver salida normal
-- :ON ERROR EXIT  -- (opcional) fail-fast. Déjalo comentado si prefieres continuar tras errores.

PRINT '=== SuiteMDI-EduSQL :: RUN_ALL (inicio) ===';
SET NOCOUNT ON;
SET XACT_ABORT OFF;

/* ---------------------------------------------------------------------------
   0) Guardas y pre-checks
--------------------------------------------------------------------------- */
PRINT ':: Verificando base de datos de trabajo...';
IF DB_ID(N'Ejemplo_SIN_Encripcion') IS NULL
BEGIN
    RAISERROR('La BD [Ejemplo_SIN_Encripcion] no existe. Ejecuta primero los scripts de /db_scripts.', 16, 1);
END;

USE [Ejemplo_SIN_Encripcion];
GO

/* ---------------------------------------------------------------------------
   1) Pruebas básicas (smoke) y consistencia
      - Validaciones de objetos, PK/FK e higiene de entorno (reset DEV).
--------------------------------------------------------------------------- */
PRINT '>> 1) Básicas / Smoke / Consistencia';

:r .\00_basicas\01_CrearBD_y_Tablas_Test.sql
:r .\00_basicas\Smoke_Objetos.sql
:r .\00_basicas\FK_Consistencia.sql
:r .\00_basicas\Reset_Limpio_DEV.sql

/* ---------------------------------------------------------------------------
   2) Datos semilla (opcionales)
--------------------------------------------------------------------------- */
PRINT '>> 2) Datos semilla (opcionales)';

:r .\10_datos_semilla\Seed_Clientes_Basico.sql

/* ---------------------------------------------------------------------------
   3) Pruebas unitarias por objeto (SP/Tablas/Índices)
      - Usuarios (02–07) y tablas del aplicativo (08)
--------------------------------------------------------------------------- */
PRINT '>> 3) Unitarias por objeto';

:r .\20_unitarias\02_prValidarUsuario_Test.sql
:r .\20_unitarias\03_prInsertarUsuario_Test.sql
:r .\20_unitarias\04_prConsultarUsuarios_Test.sql
:r .\20_unitarias\06_prModificarUsuarios_Test.sql
:r .\20_unitarias\07_prModificarPasswordUsuarios_Test.sql
:r .\20_unitarias\05_prEliminarUsuarios_Test.sql

:r .\20_unitarias\08_TablasDelAplicativo_Test.sql

-- Casos dirigidos (si los usas; cada uno maneja su propia TX)
:r .\20_unitarias\Usuarios_Insertar_Validar.sql
:r .\20_unitarias\Usuarios_Modificar.sql
:r .\20_unitarias\Usuarios_CambiarPassword.sql
:r .\20_unitarias\Usuarios_Eliminar.sql

/* ---------------------------------------------------------------------------
   4) Integración (flujos end-to-end)
--------------------------------------------------------------------------- */
PRINT '>> 4) Integración (end-to-end)';

:r .\30_integracion\09_ProcedimientosAplicativo_Test.sql
:r .\30_integracion\Flujo_Login_MDI_Smoke.sql
:r .\30_integracion\Flujo_Solicitud_Completa.sql

/* ---------------------------------------------------------------------------
   5) Resumen
--------------------------------------------------------------------------- */
PRINT '=== SuiteMDI-EduSQL :: RUN_ALL (fin) ===';