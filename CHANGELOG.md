# Changelog
All notable changes to this project will be documented in this file.

El formato sigue **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)** y este proyecto intenta apegarse a **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

> Notas:
> - Los cambios se listan en **ES/EN** cuando es relevante.
> - Tags y commits deben estar **firmados por SSH** para mostrar *Verified* en GitHub.

---

## [Unreleased]
### Added
- **Docs:** README bilingüe (ES/EN) con índice por idioma y anclas.
- **Docs:** `CONTRIBUTING.md` ampliado (flujo de trabajo, ramas, estilo C#/SQL/UI, testing mínimo).
- **Docs:** `SECURITY.md` ampliado (reporte privado, hardening, secretos).
- **Scripts SQL:** 01–11 colocados en `db_scripts/` (idempotentes, con pruebas comentadas).

### Changed
- Estructura del repositorio refinada (similar a la versión anterior pero más clara y bilingüe).

### Security
- Recordatorio de **no versionar** `App.config` real; firma SSH recomendada para commits/tags.

---

## [v0.3.1] - 2025-10-01
### Added
- **Docs:** README mejorado (bilingüe, TOC con anclas ES/EN).
- **Docs:** `CONTRIBUTING.md` y `SECURITY.md` (versiones extendidas ES/EN).

### Changed
- Ajustes en comentarios de estructura del repositorio (claridad y consistencia).

---

## [v0.3.0] - 2025-10-01
### Added
- **DB (08–11):**
  - `08_TablasDelAplicativo-mejorado.sql`: Clientes, Departamentos, Servicios, DepartamentosServicios, Solicitudes, SolicitudesDetalle, Facturas, FacturasDetalle, Recibos, RecibosDetalle; FKs e índices.
  - `09_ProcedimientosAplicativo-mejorado.sql`: SPs de solicitudes y catálogos (consultas y actualizaciones).
  - `11_Clientes_CRUD-mejorado.sql`: SPs de Clientes (insertar/consultar/modificar/eliminar).
- **DB (DEV opcional):**
  - `10_Mantenimiento_Reseed_Perfiles.sql`: alineación de `IDENTITY` en `Perfiles`.

### Changed
- Comentarios y pruebas comentadas consolidadas en scripts 08–11.

---

## [v0.2.0] - 2025-10-01
### Added
- **DB (03–07):**
  - `03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql` (OUTPUT de identity).
  - `04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql` (todos/uno; sin `Pass`).
  - `05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql` (retorna `@@ROWCOUNT`).
  - `06_CrearProcedimiento_de_Modificar_de_Usuario-modificado.sql` (retorna `@@ROWCOUNT`).
  - `07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql` (modo normal y reset; retorna `@@ROWCOUNT`).

### Changed
- Notas de pruebas en cada script (bloques comentados para SSMS).

---

## [v0.1.0] - 2025-10-01
### Added
- **Repo scaffolding & hardening:**
  - Estructura base: `.github/`, `assets/`, `db_scripts/`, `docs/`, `src/`, `tools/`.
  - **CI (GitHub Actions):** `build.yml` (Windows runner; detecta `.sln` y compila; crea `App.config` temporal en el runner).
  - **Licencias y políticas:** `LICENSE` (MIT, bilingüe), `SECURITY.md` (inicial).
  - **Contribución:** `CONTRIBUTING.md` (inicial), templates de Issues y PR, `CODEOWNERS`.
  - **Higiene:** `.gitignore`, `.gitattributes`.
- **DB (01–02):**
  - `01_CrearBD_y_Tablas-mejorado.sql` (BD + `Perfiles` con `IDENTITY(1000,1)`, `UsrProcesa`).
  - `02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql` (`prValidarUsuario` con comparación `VARBINARY(128)`).

---

## Legend / Leyenda
- **Added:** nuevas características o archivos.
- **Changed:** cambios de comportamiento o estructura (sin ruptura).
- **Deprecated:** marcado para eliminación futura.
- **Removed:** eliminado sin reemplazo.
- **Fixed:** correcciones de fallos.
- **Security:** cambios relativos a seguridad.

---

[Unreleased]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.3.1...HEAD
[v0.3.1]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.3.0...v0.3.1
[v0.3.0]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/recm0708/SuiteMDI-EduSQL/releases/tag/v0.1.0