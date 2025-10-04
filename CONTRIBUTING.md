# Contribuir

> Proyecto: WinForms .NET 4.8 (UI por código), SQL Server (Docker-first), scripts SQL **idempotentes** y CI en GitHub Actions.  
> Idioma de documentación: **español** (salvo LICENSE y YAML/keys).

---

## 0) Antes de empezar
- Lee el [`README`](./README.md) (estructura, orden de scripts, pruebas).
- Revisa [`SECURITY`](./SECURITY.md) (nunca publicar secretos).
- Consulta [`SUPPORT`](./SUPPORT.md) para dudas de uso/configuración.

---

## 1) Issues y planeación
- Crea un **Issue** usando la plantilla correcta: _bug_, _feature_, _task_, _sql change_, _security question_, _support_.
- Asigna **labels** (`sql`, `backend`, `ui`, `docs`, `infra`, `security`, `ci`, `chore`) y la **milestone** (vX.Y.Z).
- Añádelo al **Project (Roadmap Kanban)** en “To do”.

---

## 2) Ramas
- Rama base: `main`.
- Crea ramas por Issue: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`.
  - Ej.: `feat/clientes-crud`, `fix/sql-identity-reseed`.

---

## 3) Commits
- Estilo recomendado: **Conventional Commits** (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `build:`, `ci:`).
- Mensajes **claros y en español**.
- Recomendado: **firmar con SSH** para estado *Verified* en GitHub.

**Ejemplos**
- `feat(clientes): alta de cliente desde frmClienteNuevo`
- `fix(sql): corregir comparación de Pass (VARBINARY) en prValidarUsuario`
- `docs(readme): agregar tabla de contenidos`

---

## 4) Estándares de código

### C# (WinForms – UI por código)
- Formularios **por código** (sin diseñador).
- `DataGridView` con **columnas manuales**; `DataPropertyName` debe coincidir con los campos devueltos por SP.
- Manejar excepciones propagando `CodigoError`/`MensajeError` desde **Negocio** a la UI.
- Mover la lógica no trivial a **Negocio**.
- Comentar decisiones no triviales o reglas de negocio.

### SQL (idempotente)
- Usar `IF OBJECT_ID(...) IS NOT NULL DROP ...` + `CREATE` **o** `CREATE OR ALTER` cuando aplique.
- **Parámetros** siempre; evitar concatenar strings SQL.
- Devolver `@@ROWCOUNT` en CRUD cuando tenga sentido.
- **Sin** `:setvar`.  
- **Sin pruebas** dentro de `db_scripts/`: las pruebas viven en `db_test/`.
- Encabezado estandarizado en cada script (ver `db_templates/`).

**Nomenclatura sugerida**
- SPs: `pr<Accion><Entidad>` (p.ej., `prInsertarUsuario`, `prConsultarUsuarios`).
- Tablas: singular/plural consistente con el proyecto.
- Archivos: `NN_<Descripcion>-mejorado.sql` para base; `NN_<SP>_Test.sql` para pruebas.

---

## 5) Pruebas y ejecución local
- **Producción (SQL)**: ejecutar `/db_scripts` en orden (01 → 09) sobre `Ejemplo_SIN_Encripcion`.
- **Pruebas (SQL)**: usar `/db_test` (básicas, semillas, unitarias, integración) y el orquestador `db_test/RUN_ALL.sql` con **SQLCMD Mode**.
- Docker SQL en `127.0.0.1,2333`. Crear `App.config` local desde la plantilla.
- VS 2022:
  - Compilar: `Compilar → Compilar solución`
  - Ejecutar: `Depurar → Iniciar sin depuración (Ctrl+F5)`

---

## 6) Pull Requests
- Usa la **plantilla de PR** del repo y **completa el checklist**.
- Referencia el Issue: `Closes #N` (o `Related to #N`).
- Adjunta **evidencia** de UI si aplica (`/docs/capturas`).

**Si hay cambios en SQL**
- Documenta en `db_scripts/` (idempotente, sin pruebas).
- Crea/actualiza pruebas en `db_test/` (con `BEGIN TRAN/ROLLBACK`).
- Actualiza el **orden de ejecución** en el README si varía.
- Si afecta esquema/datos relevantes, abre Issue con plantilla **🧩 SQL change**.

**Seguridad**
- No incluir secretos (`App.config` real, contraseñas).
- Revisa `SECURITY.md` si afecta credenciales o hardening.

> **Breaking change ⚠️**  
> - Añade nota explícita en [`CHANGELOG`](./CHANGELOG.md) y label `breaking-change` o `major`.  
> - Incluye instrucciones de migración y scripts de compatibilidad si aplica.

---

## 7) CI / GitHub Actions
- `build.yml` detecta la `.sln` bajo `src/`.
- Si existe, genera un **App.config temporal** en el runner y compila **Release**.
- Mantener pipeline **verde**; no imprimir secretos en logs.

---

## 8) Documentación
- Actualiza `README`, `CHANGELOG` y capturas en `/docs/capturas` cuando cambie UX/flujo.
- Añade comentarios en SQL/C# cuando haya decisiones importantes.
- Consulta [`CODE OF CONDUCT`](./CODE_OF_CONDUCT.md) y [`SUPPORT`](./SUPPORT.md).

---

## 9) Lanzamientos y tags
- Prepara **draft** en Releases con notas (ES) y Issues cerrados (Release Drafter ayuda).
- Tag **firmado con SSH**: `git tag -s vX.Y.Z -m "vX.Y.Z"` → *Verified*.
- Publica el Release y adjunta artefactos si aplica.

---

## 10) Seguridad
- No subir `App.config` reales; usar la **plantilla** con placeholders.
- No compartir credenciales en Issues/PRs.
- Revisa [`SECURITY`](./SECURITY.md) para reporte de vulnerabilidades y hardening.

---

## 11) Conducta (resumen)
- Sé respetuoso, empático y claro. Feedback basado en evidencias y pruebas.

---

## Enlaces rápidos
- Project (Roadmap): https://github.com/recm0708/SuiteMDI-EduSQL/projects
- Milestones: https://github.com/recm0708/SuiteMDI-EduSQL/milestones
- Labels: https://github.com/recm0708/SuiteMDI-EduSQL/labels