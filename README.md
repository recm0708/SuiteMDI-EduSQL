# SuiteMDI-EduSQL ✨
[![Build](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml/badge.svg)](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml)
[![License: MIT](./LICENSE)](./LICENSE)

**ES — Descripción corta:**  
Aplicación educativa **C# WinForms (.NET Framework 4.8)** con interfaz **MDI** y backend **SQL Server 2022** (Docker primero). Proyecto 100% por **código** (sin diseñador), arquitectura por capas, CI en GitHub Actions y scripts SQL idempotentes (01–11).

**EN — Short description:**  
Educational **C# WinForms (.NET Framework 4.8)** app with **MDI** and **SQL Server 2022** (Docker-first). Pure **code** UI (no designer), layered architecture, GitHub Actions CI, and idempotent SQL scripts (01–11).

---

## 📚 Contents / Contenidos
- [Structure / Estructura](#-structure--estructura)
- [Requirements / Requisitos](#-requirements--requisitos)
- [Setup / Configuración](#-setup--configuración)
- [Database / Base de Datos](#-database--base-de-datos)
- [Security / Seguridad](#-security--seguridad)
- [Run & Test / Ejecutar y Probar](#-run--test--ejecutar-y-probar)
- [Workflow / Flujo de trabajo](#-workflow--flujo-de-trabajo)
- [Roadmap & Releases](#-roadmap--releases)
- [License / Licencia](#-license--licencia)

---

## 📁 Structure / Estructura
```
SuiteMDI-EduSQL/
│
├── .github/                              # Configuración de GitHub (CI, plantillas, dueños de código)
│   ├── ISSUE_TEMPLATE/                   # Plantillas para crear Issues
│   │   ├── bug_report                    # Reporte de errores (plantilla)
│   │   └── feature_request               # Solicitud de mejoras (plantilla)
│   ├── workflows/
│   │   └── build                         # GitHub Actions: build en Windows
│   ├── CODEOWNERS                        # Responsables por defecto de revisiones (PRs)
│   └── PULL_REQUEST_TEMPLATE             # Plantilla de Pull Requests
│
├── assets/                               # Logos, íconos e imágenes (para UI y README)
│   ├── logo.png
│   └── icons/
│
├── db_scripts/                           # Scripts SQL (01 … 09) con comentarios y pruebas
│   ├── 01_CrearBD_y_Tablas-mejorado.sql
│   ├── 02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
│   ├── 03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql
│   ├── 04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql
│   ├── 05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql
│   ├── 06_CrearProcedimiento_de_Modificar_de_Usuario-mejorado.sql
│   ├── 07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
│   ├── 08_TablasDelAplicativo-mejorado.sql (pendiente)
│   └── 09_ProcedimientosAplicativo-mejorado.sql (pendiente)
│
├── docs/                                 # Documentación, capturas y diagramas
│   ├── capturas/
│   │   ├── frmAcceso.png
│   │   └── frmMDI.png
│   └── diagramas/
│
├── src/                                  # Solución y proyecto de Visual Studio (WinForms .NET 4.8)
│   ├── Assets/                           # Recursos internos del proyecto (iconos, imágenes, etc.)
│   ├── Datos/                            # ClsConexion y acceso a datos (SqlClient, SPs)
│   ├── Negocio/                          # Clases de procesos/servicios (CRUD, lógica)
│   ├── Presentacion/                     # Formularios (MDI, Acceso, Usuarios, etc.)
│   ├── Properties/                       # AssemblyInfo y recursos de WinForms
│   ├── Soporte/                          # Globales, ThemeHelper y utilidades
│   ├── App.config.template.config        # Plantilla (NO versionar App.config real)
│   ├── bd_A7_RubenCanizares.csproj       # Proyecto WinForms
│   ├── bd_A7_RubenCanizares.sln          # Solución principal
│   └── Program.cs                        # Punto de entrada de la app
│
├── tools/                                # Utilidades (opcional)
│
├── .gitattributes                        # Normaliza fin de línea y tipos de archivo
├── .gitignore                            # Ignora src/_gsdata_/ y src/**/App.config, entre otros
├── CHANGELOG.md                          # Historial de cambios
├── CONTRIBUTING.md                       # Guía para contribuir (issues, PRs, estilo)
├── LICENSE                               # MIT (bilingüe)
├── README.md                             # Este archivo
└── SECURITY.md                           # Política de seguridad y manejo de secretos
```


---

## ✅ Requirements / Requisitos
- Windows + **Visual Studio 2022** (Spanish UI ok)
- **.NET Framework 4.8**
- **Docker** + SQL Server 2022 (host: `127.0.0.1,2333`)
- **SSMS** (SQL Server Management Studio)
- **GitHub Desktop** (sincronizar entre PCs)

---

## 🛠️ Setup / Configuración
1) Clonar el repo con **SSH** usando GitHub Desktop.  
2) (Próximo paso) Crear solución WinForms 4.8 en `src/App/` (100% por código).  
3) Configurar `App.config` desde `App.config.template.config` (no se versiona el real).  

---

## 🧩 Database / Base de Datos
- Carpeta **/db_scripts**: scripts **01 → 11** (mejorados, idempotentes).
- Ejecutar en **orden** con SSMS sobre `Ejemplo_SIN_Encripcion`.

---

## 🔐 Security / Seguridad
- No se sube `App.config` real (solo plantilla).
- Commits y tags **firmados por SSH** → *Verified* en GitHub.

---

## ▶️ Run & Test / Ejecutar y Probar
- En CI, el workflow **detecta** si existe `.sln`.  
  Si aún no hay solución, **no falla** (salta build).

---

## 🔄 Workflow / Flujo de trabajo
- Commits en español, vinculando issues (`Closes #N`).
- PRs hacia `main` (cuando activemos protección).

---

## 🗺️ Roadmap & Releases
- v0.1.0 — Base de repo + Parte A mínima (Acceso + MDI)  
- v0.2.0 — Usuarios CRUD  
- v0.3.x — Password + Clientes  
- v0.4.0 — Solicitudes (maestro-detalle)

---

## 📄 License / Licencia
MIT — ver [`LICENSE`](./LICENSE).
