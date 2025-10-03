/* ===========================================
   RUN_ALL.sql — Orquestador de pruebas (SQLCMD)
   Requisitos: SQLCMD Mode habilitado en SSMS
   Ejecuta en orden: básicas → unitarias → integración
=========================================== */

:setvar RootPath .  -- Cambiar si ejecutas desde otra carpeta

-- 00) Básicas
:r $(RootPath)\00_basicas\T-01-smoke-objetos-principales.sql

-- 20) Unitarias (ejemplos)
:r $(RootPath)\20_unitarias\T-03-insertar-usuario.sql
:r $(RootPath)\20_unitarias\T-07-modificar-password.sql

-- 30) Integración (ejemplo)
:r $(RootPath)\30_integracion\T-usuarios-crud-end2end.sql

PRINT 'OK: RUN_ALL finalizado.';