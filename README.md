# SuiteMDI-EduSQL ✨
[![Build](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml/badge.svg)](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Aplicación educativa en **C# WinForms (.NET Framework 4.8)** con interfaz **MDI** y backend **SQL Server 2022** (prioridad **Docker**). El proyecto está construido **100% por código (sin diseñador)** con arquitectura por capas y prácticas profesionales: **scripts SQL idempotentes (01–11)**, **CI en GitHub Actions**, control de secretos (sin `App.config` real en el repo) y guía de trabajo con **Issues/PR/Releases**. Ideal para aprender a estructurar una solución WinForms con SPs, flujos de autenticación y **CRUD** reales, manteniendo calidad y mantenibilidad desde el día uno.

---

## 🧭 Tabla de Contenido

- [Descripción](#descripcion)
- [Estructura](#estructura)
- [Requisitos](#requisitos)
- [Configuración](#configuracion)
- [Base de Datos](#bd)
- [Seguridad](#seguridad)
- [Ejecución y Pruebas](#ejecucion)
- [Flujo de Trabajo](#flujo)
- [Convenciones y Calidad](#convenciones)
- [Problemas Comunes](#problemas)
- [Roadmap y Releases](#roadmap)
- [Licencia](#licencia)

---

<a id="descripcion"></a>
## 📌 Descripción

**SuiteMDI-EduSQL** es una aplicación WinForms con **MDI** que implementa inicio de sesión y **CRUD** respaldados por **Stored Procedures** en SQL Server. El enfoque es **Docker-first** (con fallback a Local), **UI generada por código** (sin diseñador) y una organización de repositorio pensada para aprender buenas prácticas de ingeniería de software en .NET:

- **Arquitectura por capas**: `Presentacion`, `Negocio`, `Datos`, `Soporte`.
- **Acceso a datos** con `System.Data.SqlClient` y **SPs idempotentes** (scripts 01–11).
- **Configuración segura**: se versiona solo `App.config.template.config`; el `App.config` real queda fuera del control de versiones.
- **CI estable**: GitHub Actions (Windows/VS 2022) que detecta la `.sln`, crea un `App.config` **temporal** en el runner y compila en **Release**.
- **Experiencia educativa completa**: guía para **Issues**, **PRs**, **Milestones**, **Releases** y **Roadmap**, con documentación incremental.

### 🎯 Objetivos
- Mostrar una **base sólida** para proyectos WinForms con lógica real de negocio.
- Practicar **scripts SQL** con orden de ejecución, pruebas comentadas y mantenimiento (reseed opcional).
- Aplicar **patrones de trabajo** en GitHub (plantillas de issues/PR, etiquetas, changelog y releases).

### 🧱 Alcance (primeras iteraciones)
- **Parte A**: Shell MDI + Acceso básico y prueba de conexión.
- **Parte B**: Validación real de usuario + CRUD Usuarios (SP 03–07).
- **Parte C**: Catálogo **Clientes** y **Solicitudes** (maestro–detalle) con consultas avanzadas (SP 08–11).

> El proyecto prioriza **claridad** y **mantenibilidad** sobre efectos visuales; más adelante se incorporarán mejoras de UI (temas, íconos, branding) sin comprometer la estructura.

---

<a id="estructura"></a>
## 📁 Estructura

```
SuiteMDI-EduSQL/
│
├── .github/                              # Configuración de GitHub (CI, plantillas, revisiones)
│   ├── ISSUE_TEMPLATE/                   # Plantillas para Issues (bug, feature, task)
│   │   ├── bug_report.yml                # Reporte de errores
│   │   ├── feature_request.yml           # Solicitud de mejora/feature
│   │   └── task.yml                      # Tarea técnica/mantenimiento
│   │
│   │── workflows/                        # GitHub Actions (CI y automatizaciones)
│   │   ├── build.yml                     # CI: build Windows (detecta .sln, App.config temporal y compila)
│   │   ├── labeler.yml                   # Autoetiquetado de PRs según rutas
│   │   └── release-drafter.yml           # Borradores automáticos de Releases
│   │
│   ├── CODEOWNERS                        # Responsables por defecto en PRs
│   ├── dependabot.yml                    # Actualizaciones automáticas (Actions/NuGet)
│   ├── labeler.yml                       # Reglas de etiquetado (referencia del árbol, ya listado arriba)
│   ├── PULL_REQUEST_TEMPLATE.md          # Plantilla de Pull Requests
│   └── release-drafter.yml               # Config de Release Drafter (referencia del árbol, ya listado arriba)
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
│   └── App/                              # Proyecto principal (todo por código, sin diseñador)
│       ├── Assets                        # Recursos internos del proyecto (íconos, imágenes)
│       ├── Datos/                        # ClsConexion y acceso a datos (SqlClient, SPs)
│       ├── Negocio/                      # Servicios/Procesos (CRUD, lógica)
│       ├── Presentacion/                 # Formularios (MDI, Acceso, Usuarios, Clientes, etc.)
│       ├── Properties/                   # AssemblyInfo, Recursos
│       ├── Soporte/                      # Globales, ThemeHelper y utilidades
│       ├── Program.cs                    # Punto de entrada (arranca MDI y Acceso)
│       └── App.config.template.config    # Plantilla (NO versionar App.config real)
│
├── tools/                                # Utilidades (scripts auxiliares)
│
├── .editorconfig                         # Estilo y convenciones (C#, espacios, EOL)
├── .gitattributes                        # Normaliza fin de línea y tipos de archivo
├── .gitignore                            # Ignora src/**/App.config, bin/ obj/, etc.
├── CHANGELOG.md                          # Historial de cambios
├── CONTRIBUTING.md                       # Guía para contribuir (issues, PRs, estilo)
├── LICENSE                               # MIT (bilingüe)
├── README.md                             # Este archivo
└── SECURITY.md                           # Política de seguridad y manejo de secretos
```
> 🔒 **No se versiona** ningún `App.config` real; solo `App.config.template.config` (con placeholders).

---

<a id="requisitos"></a>
## ✅ Requisitos

- **Windows 10/11** + **Visual Studio 2022** (Español ok)
- **.NET Framework 4.8 Developer Pack**
- **Docker Desktop** con **SQL Server 2022 Linux container**
- **SSMS** (SQL Server Management Studio)
- **Git** + **GitHub Desktop** (opcional)
- **SSH** configurado para commits/tags *Verified*

> 💡 **Contenedor SQL 2022 (puerto 2333)**  
> Ejecuta en PowerShell/Terminal (ajusta `<TU_PASSWORD_SA>`):
> ```bash
> docker pull mcr.microsoft.com/mssql/server:2022-latest
> docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<TU_PASSWORD_SA>" ^
>   -p 2333:1433 --name mssql2022 -d mcr.microsoft.com/mssql/server:2022-latest
> ```
> Conexión: `Server=127.0.0.1,2333; User ID=sa; Password=<TU_PASSWORD_SA>;`

---

<a id="configuracion"></a>
## 🛠️ Configuración

1) **Clona por SSH** en GitHub Desktop:  
   `git@github.com/<tu-usuario>/SuiteMDI-EduSQL.git` → `C:\GitHub Repositories\SuiteMDI-EduSQL\`

2) **Crea tu App.config local (no se versiona)**  
   Copia `src/App/App.config.template.config` → **`src/App/App.config`** y ajusta:
   - `appSettings:ActiveDb` = `Docker` o `Local`
   - `connectionStrings:SqlDocker` / `SqlLocal` con tus credenciales
   > Guía detallada en **`docs/config/guia-app-config.md`**.

3) **Arranca SQL Server en Docker (puerto 2333)**  
   Ver pasos en **`docs/config/guia-docker-sql.md`**.

4) **Verifica conexión desde SSMS**  
   Servidor: `127.0.0.1,2333` · Usuario: `sa` · Password: la tuya.

---

<a id="bd"></a>
## 🧩 Base de Datos (SQL)

Ejecuta los scripts de **`/db_scripts`** en **este orden** (con SSMS conectado a `127.0.0.1,2333`):

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

> ✅ **Pruebas rápidas**: usa **`db_scripts/utils/00_smoke_test.sql`** para validar objetos clave tras la ejecución.
>
> 📘 Detalles de cada script y pruebas comentadas: **`db_scripts/README.md`**.

---

<a id="seguridad"></a>
## 🔐 Seguridad

- ❌ No subir `App.config` real (está bloqueado por `.gitignore`).
- ✅ Firmar **commits y tags con SSH** → *Verified* en GitHub.
- 🏭 Producción: usuarios distintos de `sa`, mínimos permisos, secretos **fuera** del repo.

---

<a id="ejecucion"></a>
## ▶️ Ejecutar y Probar

### A) CI (GitHub Actions)
- El workflow detecta la solución en `src/`.  
- Si no existe, **omite** el build (no falla).  
- Si existe, genera **App.config temporal** en el runner y compila **Release**.

### B) Local (Visual Studio 2022)
1. Abre la solución (cuando esté creada) en `src/App/`.
2. **Compilar**: `Compilar → Compilar solución`.
3. **Ejecutar**: `Depurar → Iniciar sin depuración (Ctrl+F5)`.

### C) Comprobaciones funcionales
- **Login** con usuario de prueba insertado por SP (ver `db_scripts/README.md`).
- **Usuarios/Clientes**: refrescar, buscar, editar/guardar y eliminar según estén habilitados.

> 🔎 **Checklist de verificación** paso a paso: **`docs/run/quick-checks.md`**.

### 💡 Tips Docker/SSMS (resumen)
- Reiniciar contenedor: `docker restart mssql2022`
- Ver logs: `docker logs mssql2022`
- Restablecer contraseña `sa`: parar/eliminar y recrear el contenedor (ver `docs/config/guia-docker-sql.md`).
- Backup/Restore: usa SSMS (Tasks → Back Up / Restore) con ruta de contenedor mapeada (ver guía).

---

<a id="flujo"></a>
## 🔄 Flujo de Trabajo

- Commits en español, atómicos, con **mensajes claros**.
- Vincular issues en commits/PRs: `Closes #N`.
- (Cuando se active) PRs a `main` con checklist y build verde.

---

<a id="convenciones"></a>
## 🧭 Convenciones y Calidad

- **Capas**: `Presentacion`, `Negocio`, `Datos`, `Soporte`.
- **UI sin diseñador**: formularios construidos por **código**.
- **DataGridView** con **columnas manuales** (`DataPropertyName` exacto a los SP).
- **SPs** delgados, idempotentes, con `RETURN @@ROWCOUNT` cuando aplica.
- **Errores**: mensajes con código y descripción (SQL/Negocio/UI).
- **Docs**: comentarios en SQL y C# donde haya decisiones no triviales.
- **Mensajería de errores**: en C# propaga `CodigoError`/`MensajeError` desde Negocio a la UI para mensajes consistentes.

---

<a id="problemas"></a>
## 🧰 Problemas Comunes

- ⏱️ **Timeout / no conecta**: verifica contenedor Docker (puerto `2333` mapeado).  
- 🔑 **Login failed for user 'sa' (18456)**: credenciales o políticas de contraseña.  
- ❓ **SP no encontrado**: ejecuta scripts **en orden** y revisa `USE`/`OBJECT_ID`.  
- 🧩 **Diseñador WinForms**: no se usa; todo es **por código**.  
- 🔒 **Commit sin Verified**: asegúrate de que `ssh-agent` cargó tu clave (`ssh-add C:\Keys\id_ed25519`) y tienes `gpg.format ssh` configurado.

---

<a id="roadmap"></a>
## 🗺️ Roadmap & Releases

> El número de releases dependerá del avance real (iterativo).

- **v0.1.x** — Base de repo + Parte A mínima (Acceso + MDI + SELECT 1)  
- **v0.2.x** — Usuarios CRUD (SP 03–06)  
- **v0.3.x** — Password (07) + Clientes (08–11 relacionados)  
- **v0.4.x** — Solicitudes (maestro–detalle) + consultas avanzadas  

Cada release incluye **CHANGELOG**, assets si aplica, y **capturas** en `/docs/capturas`.

---

<a id="licencia"></a>
## 📄 Licencia

**MIT** — ver [`LICENSE`](./LICENSE).