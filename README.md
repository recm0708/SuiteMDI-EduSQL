# SuiteMDI-EduSQL ✨
[![Build](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml/badge.svg)](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

**ES** · Aplicación educativa **C# WinForms (.NET Framework 4.8)** con interfaz **MDI** y backend **SQL Server 2022** (prioridad **Docker**). Proyecto **100% por código (sin diseñador)**, arquitectura por capas, **CI en GitHub Actions** y **scripts SQL idempotentes (01–11)**.  
**EN** · Educational **C# WinForms (.NET Framework 4.8)** app with **MDI** and **SQL Server 2022** (Docker-first). **Pure code UI** (no designer), layered architecture, **GitHub Actions CI**, and **idempotent SQL scripts (01–11)**.

---

## 🧭 Table of Contents / Índice
- 🇪🇸 Español
  - [Descripción](#es-descripcion)
  - [Estructura](#es-estructura)
  - [Requisitos](#es-requisitos)
  - [Configuración](#es-configuracion)
  - [Base de Datos](#es-bd)
  - [Seguridad](#es-seguridad)
  - [Ejecución y Pruebas](#es-ejecucion)
  - [Flujo de Trabajo](#es-flujo)
  - [Convenciones y Calidad](#es-convenciones)
  - [Problemas Comunes](#es-problemas)
  - [Roadmap y Releases](#es-roadmap)
  - [Licencia](#es-licencia)
- 🇺🇸 English
  - [Overview](#en-overview)
  - [Structure](#en-structure)
  - [Requirements](#en-requirements)
  - [Setup](#en-setup)
  - [Database](#en-database)
  - [Security](#en-security)
  - [Run & Test](#en-run)
  - [Workflow](#en-workflow)
  - [Conventions & Quality](#en-conventions)
  - [Troubleshooting](#en-troubleshooting)
  - [Roadmap & Releases](#en-roadmap)
  - [License](#en-license)

---

## 🇪🇸 Español

<a id="es-descripcion"></a>
### 📌 Descripción

SuiteMDI-EduSQL es una app WinForms educativa con MDI, login validado por SP y CRUD sobre SQL Server. Se prioriza Docker, se versiona código limpio (sin diseñador), y se integran buenas prácticas: scripts idempotentes, CI estable, seguridad de configuración y flujo de trabajo con Issues/PR/Releases.

<a id="es-estructura"></a>
### 📁 Estructura

```
SuiteMDI-EduSQL/
│
├── .github/                              # Configuración de GitHub (CI, plantillas, revisiones)
│   ├── ISSUE_TEMPLATE/                   # Plantillas para Issues (bug, feature, task)
│   │   ├── bug_report.yml
│   │   ├── feature_request.yml
│   │   └── task.yml
│   ├── workflows/
│   │   └── build.yml                     # GitHub Actions: build en Windows (detecta .sln y compila)
│   ├── CODEOWNERS                        # Responsables por defecto para PRs / revisiones
│   └── PULL_REQUEST_TEMPLATE             # Plantilla de Pull Requests
│
├── assets/                               # Logos, íconos e imágenes (UI y README)
│   ├── logo.png
│   └── icons/
│
├── db_scripts/                           # Scripts SQL (idempotentes, con pruebas comentadas)
│   ├── 01_CrearBD_y_Tablas-mejorado.sql
│   ├── 02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
│   ├── 03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql
│   ├── 04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql
│   ├── 05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql
│   ├── 06_CrearProcedimiento_de_Modificar_de_Usuario-mejorado.sql
│   ├── 07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
│   ├── 08_TablasDelAplicativo-mejorado.sql
│   ├── 09_ProcedimientosAplicativo-mejorado.sql
│   ├── 10_Mantenimiento_Reseed_Perfiles.sql
│   └── 11_Clientes_CRUD-mejorado.sql
│
├── docs/                                 # Documentación, capturas y diagramas
│   ├── capturas/
│   │   ├── frmAcceso.png
│   │   ├── frmMDI.png
│   │   └── ...
│   └── diagramas/
│       └── ...
│
├── src/                                  # Solución y proyecto de Visual Studio (WinForms .NET 4.8)
│   └── App/                              
│   ├── Assets                            # Recursos internos del proyecto (íconos, imágenes)
│   ├── Datos/                            # ClsConexion y acceso a datos (SqlClient, SPs)
│   ├── Negocio/                          # Servicios/Procesos (CRUD, lógica)
│   ├── Presentacion/                     # Formularios (MDI, Acceso, Usuarios, Clientes, etc.)
│   ├── Properties/                       # AssemblyInfo, Recursos
│   ├── Soporte/                          # Globales, ThemeHelper y utilidades
│   ├── Program.cs                        # Punto de entrada (arranca MDI y Acceso)
│   └── App.config.template.config        # Plantilla (NO versionar App.config real)
│
├── tools/                                # Utilidades (scripts auxiliares)
│
├── .gitattributes                        # Normaliza fin de línea y tipos de archivo
├── .gitignore                            # Ignora src/**/App.config, bin/ obj/, etc.
├── CHANGELOG.md                          # Historial de cambios
├── CONTRIBUTING.md                       # Guía para contribuir (issues, PRs, estilo)
├── LICENSE                               # MIT (bilingüe)
├── README.md                             # Este archivo
└── SECURITY.md                           # Política de seguridad y manejo de secretos
```

> 🔒 **No se versiona** ningún `App.config` real; solo `App.config.template.config` (con placeholders).

<a id="es-requisitos"></a>
### ✅ Requisitos

- Windows + **Visual Studio 2022** (Español ok)
- **.NET Framework 4.8**
- **Docker** + SQL Server 2022 (host `127.0.0.1,2333`)
- **SSMS** (SQL Server Management Studio)
- **GitHub Desktop** (flujo entre PCs)
- **SSH** configurado para commits/tags *Verified*

<a id="es-configuracion"></a>
### 🛠️ Configuración

1. **Clonar con SSH** en GitHub Desktop:  
   `git@github.com/<tu-usuario>/SuiteMDI-EduSQL.git` → `C:\GitHub Repositories\SuiteMDI-EduSQL\`
2. (Cuando exista el proyecto) Copia `src/App/App.config.template.config` → **`App.config`**  
   y coloca tu **contraseña real** de SQL (Docker/Local).
3. Asegúrate que el contenedor **SQL Server 2022** está arriba (puerto `2333`).

<a id="es-bd"></a>
### 🧩 Base de Datos (SQL)

Ejecuta en **SSMS** conectando a `127.0.0.1,2333` con tu `sa` (o usuario elegido).  
**Orden recomendado:**
1) `01_CrearBD_y_Tablas-mejorado.sql`  
2) `02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql`  
3) `03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql`  
4) `04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql`  
5) `05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql`  
6) `06_CrearProcedimiento_de_Modificar_de_Usuario-modificado.sql`  
7) `07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql`  
8) `08_TablasDelAplicativo-mejorado.sql`  
9) `09_ProcedimientosAplicativo-mejorado.sql`  
10) `10_Mantenimiento_Reseed_Perfiles.sql` *(DEV opcional)*  
11) `11_Clientes_CRUD-mejorado.sql`  

> Cada script incluye **pruebas comentadas** (descoméntalas para validar en tu entorno).

<a id="es-seguridad"></a>
### 🔐 Seguridad

- ❌ No subir `App.config` real (está bloqueado por `.gitignore`).
- ✅ Firmar **commits y tags con SSH** → *Verified* en GitHub.
- 🏭 Producción: usuarios distintos de `sa`, mínimos permisos, secretos **fuera** del repo.

<a id="es-ejecucion"></a>
## ▶️ Ejecutar y Probar

- **CI (Actions)**: el workflow **detecta** la `.sln` en `src/`.  
  - Si no existe aún, **no falla** (salta build).  
  - Si existe, crea un **App.config temporal** en el runner y compila **Release**.
- **Local**: en VS 2022 (Español)  
  - Compilar: `Compilar → Compilar solución`  
  - Ejecutar: `Depurar → Iniciar sin depuración (Ctrl+F5)`

<a id="es-flujo"></a>
## 🔄 Flujo de Trabajo

- Commits en español, atómicos, con **mensajes claros**.
- Vincular issues en commits/PRs: `Closes #N`.
- (Cuando se active) PRs a `main` con checklist y build verde.

<a id="es-convenciones"></a>
## 🧭 Convenciones y Calidad

- **Capas**: `Presentacion`, `Negocio`, `Datos`, `Soporte`.
- **UI sin diseñador**: formularios construidos por **código**.
- **DataGridView** con **columnas manuales** (`DataPropertyName` exacto a los SP).
- **SPs** delgados, idempotentes, con `RETURN @@ROWCOUNT` cuando aplica.
- **Errores**: mensajes con código y descripción (SQL/Negocio/UI).
- **Docs**: comentarios en SQL y C# donde haya decisiones no triviales.

<a id="es-problemas"></a>
## 🧰 Problemas Comunes

- ⏱️ **Timeout / no conecta**: verifica contenedor Docker (puerto `2333` mapeado).  
- 🔑 **Login failed for user 'sa' (18456)**: credenciales o políticas de contraseña.  
- ❓ **SP no encontrado**: ejecuta scripts **en orden** y revisa `USE`/`OBJECT_ID`.  
- 🧩 **Diseñador WinForms**: no se usa; todo es **por código**.  
- 🔒 **Commit sin Verified**: asegúrate de que `ssh-agent` cargó tu clave (`ssh-add C:\Keys\id_ed25519`) y tienes `gpg.format ssh` configurado.

<a id="es-roadmap"></a>
## 🗺️ Roadmap & Releases

> El número de releases dependerá del avance real (iterativo).

- **v0.1.x** — Base de repo + Parte A mínima (Acceso + MDI + SELECT 1)  
- **v0.2.x** — Usuarios CRUD (SP 03–06)  
- **v0.3.x** — Password (07) + Clientes (08–11 relacionados)  
- **v0.4.x** — Solicitudes (maestro–detalle) + consultas avanzadas  

Cada release incluye **CHANGELOG**, assets si aplica, y **capturas** en `/docs/capturas`.

<a id="es-licencia"></a>
## 📄 License / Licencia

**MIT** — ver [`LICENSE`](./LICENSE).

---

## 🇺🇸 English

<a id="en-overview"></a>
### 📌 Overview

SuiteMDI-EduSQL is an educational WinForms app featuring an MDI shell, stored-procedure-backed login, and CRUD over SQL Server. Docker-first, clean code (no designer), strong repo hygiene: idempotent SQL scripts, stable CI, secured configuration and a pragmatic Issues/PR/Releases flow.

<a id="en-structure"></a>
### 📁 Structure

> See the tree above for full layout and comments.
> 🔒 **No actual** `App.config` is versioned; only `App.config.template.config` (with placeholders).

<a id="en-requirements"></a>
### ✅ Requirements

- Windows + **Visual Studio 2022**
- **.NET Framework 4.8**
- **Docker** + SQL Server 2022 (`127.0.0.1,2333`)
- **SSMS**
- **GitHub Desktop**
- **SSH** configured for *Verified* commits/tags

<a id="en-setup"></a>
### 🛠️ Setup

1. Clone via SSH in GitHub Desktop:  
   `git@github.com/<your-user>/SuiteMDI-EduSQL.git` → `C:\GitHub Repositories\SuiteMDI-EduSQL\`
2. (Once the project exists) Copy `src/App/App.config.template.config` → **`App.config`** and set your **real** password.
3. Ensure **SQL Server 2022 (Docker)** is running (port `2333`).

<a id="en-database"></a>
### 🧩 Database

Run the scripts in **/db_scripts** with **SSMS** (host `127.0.0.1,2333`).  
**Order:** 01 → 11 (see Spanish section). Each script includes **commented tests**.

<a id="en-security"></a>
### 🔐 Security

- Never commit a real `App.config` (template only).
- Sign **commits/tags with SSH** → GitHub **Verified**.
- For production: avoid `sa`, least-privilege accounts, secrets **outside** the repo.

<a id="en-run"></a>
### ▶️ Run & Test

- **CI** auto-detects `*.sln` under `src/`.  
  - No solution? It **skips** build (green).  
  - Found a solution? Creates a **temporary App.config** and builds **Release**.
- **Local** (VS 2022):
  - Build: `Build → Build solution`
  - Run: `Debug → Start Without Debugging (Ctrl+F5)`

<a id="en-workflow"></a>
### 🔄 Workflow

- Spanish, atomic, clear commit messages.
- Link issues in commits/PRs: `Closes #N`.
- PRs to `main` once branch protection is enabled.

<a id="en-conventions"></a>
### 🧭 Conventions & Quality

- Layers: Presentation, Business, Data, Support.
- UI **built in code** (no designer).
- DataGridView with **manual columns** (`DataPropertyName` matches SP fields).
- SPs are idempotent and return `@@ROWCOUNT` when appropriate.
- Errors surface SQL codes and messages.

<a id="en-troubleshooting"></a>
### 🧰 Troubleshooting

- Timeout / no connection → check Docker mapping and port.
- Login failed for user 'sa' → credentials/policy.
- Missing SPs → run scripts in order; verify `USE`/`OBJECT_ID`.
- Commit not Verified → ensure `ssh-agent` has your key (`ssh-add C:\Keys\id_ed25519`) and `gpg.format ssh` is set.

<a id="en-roadmap"></a>
### 🗺️ Roadmap & Releases

- **v0.1.x** — Repo base + Part A (Login shell + SELECT 1)  
- **v0.2.x** — Users CRUD (SP 03–06)  
- **v0.3.x** — Password (07) + Clients (08–11)  
- **v0.4.x** — Requests (master–detail) & advanced queries  

Each release updates **CHANGELOG**, captures in `/docs/capturas`, and CI status.

<a id="en-license"></a>
### 📄 License

**MIT** — see [`LICENSE`](./LICENSE).