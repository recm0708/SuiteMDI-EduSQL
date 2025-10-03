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

### Cambiado
- README: descripción ampliada, TOC y nota de ejecución (login real con SP 02).
- `CONTRIBUTING.md` convertido a **español** (alineado a la política de idioma).
- Normalización de `.editorconfig`, `.gitattributes` y `.gitignore`.
- Comentarios y descripciones de la estructura más claras.

### Corregido
- Badge de licencia apuntando a `LICENSE`.
- Anclas/IDs de secciones en README para navegación correcta.

### Seguridad
- Excluido `src/**/App.config` del repo (solo `App.config.template.config` con placeholders).
- Recomendación de **mínimos privilegios** para SQL Server en entornos no DEV.

---

## [v0.1.0] - 2025-10-01
### Añadido
- Arranque del repositorio: estructura base, plantillas de Issues/PR, CODEOWNERS.
- CI de build (Windows) con creación de `App.config` temporal en el runner.
- Primeras versiones de `SECURITY.md`, `CONTRIBUTING.md` y `README`.

---

[Unreleased]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.1.0...HEAD
[v0.1.0]: https://github.com/recm0708/SuiteMDI-EduSQL/releases/tag/v0.1.0