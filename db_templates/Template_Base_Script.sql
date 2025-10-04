/* =============================================================================
   Script:         <NN_Nombre-logico>.sql
   Realizado por:  Prof. José Ortiz
   Modificado por: Ruben E. Cañizares M. en colaboración de ChatGPT
   Proyecto:       SuiteMDI-EduSQL
   Objetivos:
     - <Objetivo 1>.
     - <Objetivo 2>.
     - <...>
   Notas:
     - Idempotente (CREATE OR ALTER / IF EXISTS...).
     - Compatible con SQL Server 2019/2022.
     - Evita SETVAR; sin dependencias externas.
   Observación:
     Este script reestructura/normaliza el original para hacerlo idempotente,
     corregir nombres/casos y reforzar validaciones, preservando la intención
     funcional y la autoría conceptual del Prof. José Ortiz.
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [Ejemplo_SIN_Encripcion];
GO

-- <tu código idempotente aquí>

-- (Opcional) validaciones finales (solo SELECTs simples)
-- SELECT 'OK' AS Status;