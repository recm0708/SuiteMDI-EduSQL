/* =============================================================================
   Script de PRUEBAS: 00_basicas/Smoke_Objetos.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Validar existencia mínima de tablas/SPs base.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

-- Tablas clave
SELECT 'Perfiles'     AS Objeto, IIF(OBJECT_ID('dbo.Perfiles','U') IS NOT NULL, 'OK','FALTA')   AS Estado
UNION ALL
SELECT 'Clientes'     , IIF(OBJECT_ID('dbo.Clientes','U') IS NOT NULL, 'OK','FALTA')
UNION ALL
SELECT 'Solicitudes'  , IIF(OBJECT_ID('dbo.Solicitudes','U') IS NOT NULL, 'OK','FALTA')
UNION ALL
SELECT 'SolicitudesDetalle', IIF(OBJECT_ID('dbo.SolicitudesDetalle','U') IS NOT NULL, 'OK','FALTA');

-- SPs base (02–07)
SELECT p.name AS SP_Name
  FROM sys.procedures p
 WHERE p.name IN
 (
   'prValidarUsuario',
   'prInsertarUsuario',
   'prConsultarUsuarios',
   'prEliminarUsuarios',
   'prModificarUsuarios',
   'prModificarPasswordUsuarios'
 );