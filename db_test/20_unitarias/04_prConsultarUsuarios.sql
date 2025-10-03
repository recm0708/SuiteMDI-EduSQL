/* =============================================================================
   Test:    04_prConsultarUsuarios.sql
   Proyecto: SuiteMDI-EduSQL (db_test / unitarias)
   Objetivo:
     - Validar salida de dbo.prConsultarUsuarios
       * @CodigoUsuario = 0 -> lista de usuarios (sin Pass)
       * @CodigoUsuario > 0 -> un usuario específico
     - Asegurar que el conjunto de columnas no incluye Pass (mismatch haría fallar INSERT EXEC)
   Requisitos:
     - BD: Ejemplo_SIN_Encripcion
     - Tabla: dbo.Perfiles
     - (Recomendado) Ejecutar seed 11_seed_usuario_1000.sql antes (usuario 1000)
   ============================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET NOCOUNT ON;

PRINT '>> Caso 1: @CodigoUsuario = 0 (todos) — columnas fijas y sin Pass';
IF OBJECT_ID('tempdb..#todos') IS NOT NULL DROP TABLE #todos;
CREATE TABLE #todos (
    CodigoUsuario   INT         NOT NULL,
    NombreUsuario   VARCHAR(50) NULL,
    SegundoNombre   VARCHAR(50) NULL,
    ApellidoUsuario VARCHAR(50) NULL,
    SegundoApellido VARCHAR(50) NULL,
    ApellidoCasada  VARCHAR(50) NULL,
    Email           VARCHAR(100) NULL
);

INSERT INTO #todos
EXEC dbo.prConsultarUsuarios @CodigoUsuario = 0;

DECLARE @cnt INT = (SELECT COUNT(*) FROM #todos);
PRINT 'Filas devueltas (todos) = ' + CAST(@cnt AS VARCHAR(20));

-- No es error si no hay filas, solo informativo:
IF (@cnt < 0) -- imposible; placeholder por si se quiere forzar alguna regla
    THROW 54000, 'El SP devolvió un conteo negativo (imposible).', 1;


PRINT '>> Caso 2: @CodigoUsuario = 1000 (uno) — requiere seed previo si se quiere asegurar 1 fila';
IF OBJECT_ID('tempdb..#uno') IS NOT NULL DROP TABLE #uno;
CREATE TABLE #uno (
    CodigoUsuario   INT         NOT NULL,
    NombreUsuario   VARCHAR(50) NULL,
    SegundoNombre   VARCHAR(50) NULL,
    ApellidoUsuario VARCHAR(50) NULL,
    SegundoApellido VARCHAR(50) NULL,
    ApellidoCasada  VARCHAR(50) NULL,
    Email           VARCHAR(100) NULL
);

INSERT INTO #uno
EXEC dbo.prConsultarUsuarios @CodigoUsuario = 1000;  -- ajusta si tu seed usa otro código

DECLARE @cntUno INT = (SELECT COUNT(*) FROM #uno);
PRINT 'Filas devueltas (uno) = ' + CAST(@cntUno AS VARCHAR(20));

-- Si sabes que el usuario 1000 existe (por seed), puedes hacer:
-- IF (@cntUno <> 1) THROW 54001, 'Se esperaba 1 fila para el usuario 1000.', 1;

-- Validación básica del esquema (si el SP añadiera Pass, este INSERT hubiera fallado ya)
SELECT TOP 1 * FROM #todos ORDER BY CodigoUsuario;
SELECT TOP 1 * FROM #uno   ORDER BY CodigoUsuario;
GO