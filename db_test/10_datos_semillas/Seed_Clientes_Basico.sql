/* =============================================================================
   Script de PRUEBAS (SEED DEV): 10_datos_semilla/Seed_Clientes_Basico.sql
   Autor:          Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Propósito:
     - Insertar clientes canónicos para apoyar pruebas de Solicitudes/Facturación.
   Alcance:
     - DEV: persiste datos (NO ROLLBACK).
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

PRINT '== Semilla básica de Clientes (DEV) ==';

INSERT INTO dbo.Clientes (NombreCliente, Cedula, Direccion, Telefono, Celular, Correo)
VALUES
('Cliente Uno',   '8-999-001', 'Calle 1', '222', '666', 'uno@correo.com'),
('Cliente Dos',   '8-999-002', 'Calle 2', '223', '667', 'dos@correo.com'),
('Cliente Tres',  '8-999-003', 'Calle 3', '224', '668', 'tres@correo.com');

PRINT 'Insertados ' + CONVERT(VARCHAR, @@ROWCOUNT) + ' clientes.';