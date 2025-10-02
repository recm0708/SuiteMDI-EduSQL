# Changelog
All notable changes to this project will be documented in this file.

> This project adheres to [Semantic Versioning](https://semver.org/) and follows the
> [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

## [Unreleased]
### Added / Añadido
- Estructura de repo profesional (árbol de carpetas y archivos base).
- **.github/**: `ISSUE_TEMPLATE` (bug/feature/task), `PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`.
- Workflows: `workflows/build.yml` (Windows, detecta `.sln` y crea `App.config` temporal),
  `workflows/labeler.yml` (auto-etiquetado de PRs), `workflows/release-drafter.yml`.
- Config: `dependabot.yml` (actualización de dependencias).
- Documentación: `README` ES/EN con TOC y badges; `SECURITY.md`; `CONTRIBUTING.md`.
- **db_scripts/** colocados (01–11) con pruebas comentadas (SSMS).
- Guía para **commits/tags verificados vía SSH** (Verified).

### Changed / Cambiado
- Normalización de `.editorconfig`, `.gitattributes` y `.gitignore`.
- README: tabla de contenidos multi-idioma y secciones ES/EN simétricas.
- Comentarios y descripciones de estructura (ES/EN) más claras.

### Fixed / Corregido
- Badge de licencia apuntando a `LICENSE`.
- Anclas/IDs de secciones del README para navegación correcta ES/EN.

### Security / Seguridad
- Excluido `src/**/App.config` del repo (solo `App.config.template.config` con placeholders).
- Recomendaciones de mínimos privilegios en SQL Server para entornos no-DEV.

---

## [v0.1.0] - 2025-10-01
### Added / Añadido
- Arranque del repositorio: estructura base, plantillas de Issues/PR, CODEOWNERS.
- CI de build (Windows) con creación de `App.config` temporal en el runner.
- Primeras versiones de `SECURITY.md`, `CONTRIBUTING.md` y README ES/EN.

---

[Unreleased]: https://github.com/recm0708/SuiteMDI-EduSQL/compare/v0.1.0...HEAD
[v0.1.0]: https://github.com/recm0708/SuiteMDI-EduSQL/releases/tag/v0.1.0