# SuiteMDI-EduSQL ✨
[![Build](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml/badge.svg)](https://github.com/recm0708/SuiteMDI-EduSQL/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Aplicación educativa en **C# WinForms (.NET Framework 4.8)** con interfaz **MDI** y backend **SQL Server 2022** (prioridad **Docker**). El proyecto está construido **100% por código (sin diseñador)** con arquitectura por capas y prácticas profesionales: **scripts SQL idempotentes (01–11)**, **CI en GitHub Actions**, control de secretos (sin `App.config` real en el repo) y guía de trabajo con **Issues/PR/Releases**. Ideal para aprender a estructurar una solución WinForms con SPs, flujos de autenticación y **CRUD** reales, manteniendo calidad y mantenibilidad desde el día uno.

---

## 🧭 Tabla de Contenidos

- [📌 Descripción](#descripcion)
- [📁 Estructura](#estructura)
- [✅ Requisitos](#requisitos)
- [🛠️ Configuración](#configuracion)
- [🧩 Base de Datos (SQL)](#bd)
- [🧪 Pruebas SQL](#pruebas-sql)
- [🔐 Seguridad](#seguridad)
- [▶️ Ejecución y Pruebas](#ejecucion)
- [🔄 Flujo de Trabajo](#flujo)
- [🧭 Convenciones y Calidad](#convenciones)
- [🧰 Problemas Comunes](#problemas)
- [🗺️ Roadmap y Releases](#roadmap)
- [📄 Licencia](#licencia)

---

<a id="descripcion"></a>
## 📌 Descripción

SuiteMDI-EduSQL es una aplicación educativa en WinForms que demuestra un ciclo completo “empresa-lite”: **inicio de sesión por SP**, **CRUD con capas** y **automatización de build**. El objetivo es **aprender buenas prácticas aplicadas** con una base técnica sólida, pero manteniendo el código accesible.

**Principios del proyecto**
- **100% por código (sin diseñador)**: formularios creados en C# para entender la UI a bajo nivel.
- **Docker-first**: SQL Server 2022 en contenedor (`127.0.0.1,2333`) y opción Local como respaldo.
- **SQL idempotente**: scripts 01–11 re‐ejecutables, con *pruebas comentadas*.
- **Capas claras**: Presentación / Negocio / Datos / Soporte.
- **CI estable**: GitHub Actions compila en Windows y genera `App.config` temporal en el runner.

**Qué incluye (alcance actual)**
- **Acceso/Login** validado con `dbo.prValidarUsuario` (Script 02).
- **Usuarios**: insertar, consultar, modificar y eliminar (Scripts 03–06).
- **Cambio de contraseña**: modo normal y *reset* (Script 07).
- **Clientes**: esquema y SPs base (Scripts 08–11).
- **Repositorio profesional**: plantillas de Issues/PR, labeler, Release Drafter, Dependabot, políticas básicas.

**Qué no incluye (por ahora)**
- Cifrado real de contraseñas (se usa `VARBINARY` simple).
- Despliegue MSI/ClickOnce.
- Protección de rama `main` (se activará más adelante).

---

<a id="estructura"></a>
## 📁 Estructura

```
SuiteMDI-EduSQL/
│
├── .github/                              # Configuración de GitHub (CI, plantillas, revisiones)
│   ├── ISSUE_TEMPLATE/                   # Plantillas para Issues (bug, feature, task)
│   │   ├── bug_report.yml                # Reporte de errores
│   │   ├── config.yml                    # Config de issues (deshabilita blank issues, links de soporte)
│   │   ├── feature_request.yml           # Solicitud de mejora/feature
│   │   ├── security_question.yml         # Plantilla de duda/alerta de seguridad
│   │   ├── sql_change.yml                # Plantilla para cambios que afectan SQL
│   │   ├── support.yml                   # Solicitudes de ayuda/soporte
│   │   └── task.yml                      # Tarea técnica/mantenimiento
│   │
│   ├── workflows/                        # GitHub Actions (CI y automatizaciones)
│   │   ├── build.yml                     # CI: compila en Windows (detecta .sln y crea App.config temporal)
│   │   ├── labeler.yml                   # Workflow que aplica labels en PRs
│   │   └── release-drafter.yml           # Workflow que actualiza el borrador de Releases
│   │
│   ├── CODEOWNERS                        # Responsables por defecto en PRs
│   ├── dependabot.yml                    # Actualizaciones automáticas (Actions y NuGet)
│   ├── labeler.yml                       # Mapeo de rutas → labels (usado por el workflow)
│   ├── PULL_REQUEST_TEMPLATE.md          # Plantilla de Pull Requests
│   └── release-drafter.yml               # Plantilla/categorías del Release Drafter
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
├── db_test/                              # Pruebas SQL (separadas de los scripts base)
│   ├── 00_basicas/                       # Smoke tests: existencia de objetos, SELECT mínimos
│   │   ├── T-01-smoke-objetos-principales.sql
│   │   └── ... 
│   ├── 10_datos_semilla/                 # Fixtures de datos para pruebas (opcional)
│   │   └── ... 
│   ├── 20_unitarias/                     # Pruebas por objeto (SP, tabla, índices)
│   │   ├── T-02-identity-perfiles-inicia-1000.sql
│   │   └── ... 
│   ├── 30_integracion/                   # Flujos completos (login, CRUD, etc.)
│   │   └── ... 
│   └── RUN_ALL.sql                       # Orquestador de tests en modo SQLCMD
│
├── docs/                                 # Documentación, capturas y diagramas
│   ├── capturas/                         # Screenshots del aplicativo (para README/Releases)
│   │   └── ...
│   └── diagramas/                        # Diagramas de arquitectura/flujo (opcional)
│       └── ...
│
├── src/                                  # Solución y proyecto de Visual Studio (WinForms .NET 4.8)
│   └── App/                              # Proyecto principal (todo por código, sin diseñador)
│       ├── Assets/                       # Recursos internos del proyecto (íconos, imágenes)
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
├── CODE_OF_CONDUCT.md                    # Código de Conducta del proyecto
├── CONTRIBUTING.md                       # Guía para contribuir (issues, PRs, estilo)
├── LICENSE                               # MIT (bilingüe)
├── README.md                             # Este archivo
├── SECURITY.md                           # Política de seguridad y manejo de secretos
└── SUPPORT.md                            # Cómo pedir ayuda/soporte y canales
```

> 🔒 **No se versiona** ningún `App.config` real; solo `App.config.template.config` (con placeholders).

---

<a id="requisitos"></a>
## ✅ Requisitos

- Windows + **Visual Studio 2022** (Español ok)
- **.NET Framework 4.8**
- **Docker** + SQL Server 2022 (host 127.0.0.1,2333)
- **SSMS** (SQL Server Management Studio)
- **GitHub Desktop** (flujo entre PCs)
- **SSH** configurado para commits/tags *Verified*

---

<a id="configuracion"></a>
## 🛠️ Configuración

1. **Clonar con SSH** en GitHub Desktop:  
   `git@github.com/<tu-usuario>/SuiteMDI-EduSQL.git` → `C:\GitHub Repositories\SuiteMDI-EduSQL\`
2. Copia src/App/App.config.template.config → **App.config** y coloca tu **contraseña real** de SQL (Docker/Local).
3. Asegúrate que el contenedor **SQL Server 2022** está arriba (puerto 2333).

---

<a id="bd"></a>
## 🧩 Base de Datos (SQL)

Ejecuta en **SSMS** conectando a 127.0.0.1,2333 con tu sa (o usuario elegido).

> Usa la base de datos **Ejemplo_SIN_Encripcion** (creada por el Script 01).

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

> ℹ️ **Pruebas SQL separadas**: los scripts de pruebas rápidas, unitarias e integradas ya **no** van dentro de `db_scripts/`.
> Ahora viven en **`/db_tests/`**. Consulta la sección [🧪 Pruebas SQL (db_tests)](#pruebas-sql).

---

<a id="pruebas-sql"></a>
## 🧪 Pruebas SQL

Las pruebas se ejecutan aparte de los scripts de producción.

**Carpetas**
- `db_test/00_basicas/` → smoke tests (existencia de objetos, SELECT mínimos).
- `db_test/10_datos_semilla/` → datos de prueba (opcional).
- `db_test/20_unitarias/` → pruebas por objeto (SP, tabla, índices).
- `db_test/30_integracion/` → flujos completos (login, CRUD, etc.).
- `db_test/RUN_ALL.sql` → orquestador (SQLCMD).

### Cómo ejecutar
1. Abrir **SSMS** sobre la BD `Ejemplo_SIN_Encripcion`.
2. Activar **SQLCMD Mode**: `Query → SQLCMD Mode`.
3. Abrir y ejecutar `db_tests/RUN_ALL.sql`.

> Recomendado: que las pruebas hagan `BEGIN TRAN` + `ROLLBACK` para no dejar datos residuales.
> Los scripts en `db_scripts/` permanecen **idempotentes y sin pruebas**.  
> Cada test usa `BEGIN TRAN/ROLLBACK` para no dejar efectos (salvo que expresamente lo cambies a `COMMIT`).

---

<a id="seguridad"></a>
## 🔐 Seguridad

- ❌ No subir `App.config` real (está bloqueado por `.gitignore`).
- ✅ Firmar **commits y tags con SSH** → *Verified* en GitHub.
- 🏭 Producción: usuarios distintos de `sa`, mínimos permisos, secretos **fuera** del repo.
- Consulta la **Política de Seguridad** (archivo en español): [`SECURITY`](./SECURITY.md).

---

<a id="ejecucion"></a>
## ▶️ Ejecutar y Probar

- **CI (Actions)**: el workflow **detecta** la .sln en src/.
   - Si no existe aún, **no falla** (salta build).
   - Si existe, crea un **App.config temporal** en el runner y compila **Release**.
- **Local**: en VS 2022 (Español)
   - Compilar: Compilar → Compilar solución
   - Ejecutar: Depurar → Iniciar sin depuración (Ctrl+F5)

> Nota: el **login real** usa `dbo.prValidarUsuario` (Script 02) contra la BD `Ejemplo_SIN_Encripcion`.

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
Nota: la licencia válida es la versión en **inglés**; la versión en español es una traducción **no oficial** para conveniencia.

---

**Conducta:** ver [`CODE OF CONDUCT`](./CODE_OF_CONDUCT.md)  
**Soporte:** ver [`SUPPORT`](./SUPPORT.md)