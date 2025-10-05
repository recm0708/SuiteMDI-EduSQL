# Changelog
Todas las modificaciones relevantes de este proyecto se documentan aquí.

> Este proyecto adhiere a [Semantic Versioning](https://semver.org/) y al formato
> [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]
### Añadido
- Estructura de repositorio profesional (árbol de carpetas y archivos base).
- **.github/**: `ISSUE_TEMPLATE` (bug/feature/task), `PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`.
- Workflows: `workflows/build.yml` (Windows; detecta `.sln` y crea `App.config` temporal),
  `workflows/labeler.yml` (autoetiquetado de PRs), `workflows/release-drafter.yml`.
- Configuración: `dependabot.yml` (actualizaciones programadas).
- Documentación: `README` (ES) con TOC y badges; `SECURITY.md` (ES); `CONTRIBUTING.md` (ES);
  `CODE_OF_CONDUCT.md` (ES) y `SUPPORT.md` (ES).
- **db_scripts/** (01–09) colocados, con pruebas movidas a `db_test/`.
- **db_test/** estructurado: `00_basicas/`, `10_datos_semilla/`, `20_unitarias/`, `30_integracion/` y `RUN_ALL.sql` (orquestador en modo SQLCMD).
- Semillas y pruebas iniciales:
  - `db_test/10_datos_semilla/Seed_Clientes_Basico.sql`
  - `db_test/00_basicas/Smoke_Objetos.sql`
  - `db_test/20_unitarias/Usuarios_Insertar_Validar.sql` (y casos afines)

- Nuevas plantillas en **.github/ISSUE_TEMPLATE/**:
  `security_question.yml`, `sql_change.yml`, `support.yml`, `config.yml`.

### Cambiado
- `README.md`: descripción ampliada, TOC y nota de ejecución (login real con SP 02); se agrega sección **🧪 Pruebas SQL (db_test)** y guía de ejecución con SQLCMD.
- `.github/workflows/build.yml`: omite build si no hay `.sln`, añade caché de NuGet, `App.config` temporal con DB por defecto, permisos mínimos y `concurrency`.
- `.github/workflows/labeler.yml`: permisos mínimos, `pull_request_target`, `sync-labels` y `configuration-path` explícito.
- `.github/workflows/release-drafter.yml`: permisos mínimos, `concurrency` y `config-name` explícito.
- `.gitattributes` / `.editorconfig`: políticas CRLF/LF y estilo C# afinadas (coherentes con Windows/CI).
- `02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql`: comparación **VARBINARY = VARBINARY** y resultset vacío coherente cuando no hay coincidencia.
- Bloque **Estructura** del README actualizado (incluye `db_test/` y nuevas plantillas de Issues).

### Corregido
- Badge de licencia apuntando a `LICENSE`.
- Anclas/IDs y rutas internas del README (TOC → Estructura/Pruebas).
- Normalización de nombre **`db_test/`** (antes aparecía como `db_tests/` en algunos textos).

### Seguridad
- Excluido `src/**/App.config` del repo (solo `App.config.template.config` con placeholders).
- Recomendación de **mínimos privilegios** para SQL Server en entornos no-DEV.

---

## [v0.1.0] - 2025-10-01
### Añadido
- Arranque del repositorio: estructura base, plantillas de Issues/PR, CODEOWNERS.
- CI de build (Windows) con creación de `App.config` temporal en el runner.
- Primeras versiones de [`SECURITY`](./SECURITY.md), [`CONTRIBUTING`](./CONTRIBUTING.md) y [`README`](./README.md).

---

[Unreleased]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.1.0...HEAD
[v0.1.0]: https://github.com/recm0708/SuiteMDI-EduSQL/releases/tag/v0.1.0