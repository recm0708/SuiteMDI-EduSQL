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
- Documentación: `README` (ES) con TOC y badges; `SECURITY.md` (ES); `CONTRIBUTING.md` (ES).
- **db_scripts/** colocados (01–11) con pruebas comentadas (SSMS).
- Guía para **commits/tags verificados por SSH** (*Verified*).
- Sección **“🧪 Pruebas SQL (db_test)”** en el README (ejecución con SQLCMD y runner de ejemplo).
- Documentación en README de **nuevas ISSUE_TEMPLATE**: `security_question.yml`, `sql_change.yml`, `support.yml`, y `config.yml`.
- Estructura inicial de **`db_test/`** y **`RUN_ALL.sql`** (orquestador SQLCMD).

### Cambiado
- README: descripción ampliada, TOC y nota de ejecución (login real con SP 02).
- `CONTRIBUTING.md` convertido a **español** (alineado a la política de idioma).
- Normalización de `.editorconfig`, `.gitattributes` y `.gitignore`.
- Comentarios y descripciones de la estructura más claras.
- Pruebas SQL separadas de `db_scripts/` a `db_tests/` (smoke/unit/integration)
- Bloque de **Estructura** en README: comentarios completos y rutas actualizadas (incluye `db_test/` y nuevas plantillas de Issues).

### Corregido
- Badge de licencia apuntando a `LICENSE`.
- Anclas/IDs de secciones en README para navegación correcta.
- Enlaces internos del README (TOC → nueva sección de Pruebas).

### Seguridad
- Excluido `src/**/App.config` del repo (solo `App.config.template.config` con placeholders).
- Recomendación de **mínimos privilegios** para SQL Server en entornos no DEV.

---

## [v0.1.0] - 2025-10-01
### Añadido
- Arranque del repositorio: estructura base, plantillas de Issues/PR, CODEOWNERS.
- CI de build (Windows) con creación de `App.config` temporal en el runner.
- Primeras versiones de [`SECURITY`](./SECURITY.md), [`CONTRIBUTING`](./CONTRIBUTING.md) y [`README`](./README.md).

---

[Unreleased]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.1.0...HEAD
[v0.1.0]: https://github.com/recm0708/SuiteMDI-EduSQL/releases/tag/v0.1.0