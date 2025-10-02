# Contributing / Contribuir

> Bilingual file / Archivo bilingüe (ES/EN)

---

## 🧭 Overview / Resumen

- ES: Este proyecto usa **WinForms .NET 4.8 sin diseñador**, SQL Server (Docker-first), **scripts idempotentes** y **CI en GitHub Actions**.  
- EN: This project uses **WinForms .NET 4.8 code-only UI**, SQL Server (Docker-first), **idempotent SQL scripts**, and **GitHub Actions CI**.

---

## 1) Issues & Planning / Issues y Planeación

**ES**
- Antes de empezar, **crea un Issue** usando la plantilla correcta: _bug, feature, task_.  
- Asigna **labels** (`sql`, `backend`, `ui`, `docs`, `infra`, `security`, `good first issue`) y una **milestone** (vX.Y.Z).  
- Agrega al **Project (Roadmap Kanban)** en “To do”.

**EN**
- Before starting, **create an Issue** using the right template: _bug, feature, task_.  
- Set **labels** and a **milestone** (vX.Y.Z).  
- Add it to the **Project (Roadmap Kanban)** under “To do”.

---

## 2) Branching / Ramas

**ES**
- Rama base: `main`.  
- Crea ramas por Issue: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`.  
  - Ejemplo: `feat/clientes-crud`, `fix/sql-identity-reseed`.
- Commits y PRs deben referenciar el Issue: `Closes #N`.

**EN**
- Base branch: `main`.  
- Create per-issue branches: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`.  
- Commits & PRs should reference the Issue: `Closes #N`.

---

## 3) Commit Style / Estilo de Commits

**Conventional Commits** (recomendado):  
`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `build:`, `ci:`

**ES**
- Mensajes **claros** y **en español**.  
- Firma tus commits con **SSH** si es posible (estado *Verified*).

**EN**
- **Clear** messages.  
- Prefer **SSH-signed** commits (GitHub *Verified*).

**Ejemplos / Examples**
- `feat(clientes): alta de cliente desde frmClienteNuevo`  
- `fix(sql): corregir comparación de Pass (VARBINARY) en prValidarUsuario`  
- `docs(readme): agregar tabla de contenidos ES/EN`

---

## 4) Coding Standards / Estándares de Código

### C# (WinForms .NET 4.8 – code-only)
**ES**
- Formularios **por código** (sin diseñador).  
- `DataGridView` con **columnas manuales** y `DataPropertyName` exacto a los campos devueltos por SP.  
- Maneja excepciones y propaga a la UI **CodigoError/MensajeError** desde la capa de Negocio.  
- Evita lógica compleja en el form; muévela a **Negocio**.  
- Comentarios donde existan **reglas de negocio** o decisiones no triviales.

**EN**
- **Code-only** forms (no designer).  
- `DataGridView` **manual columns** with exact `DataPropertyName`.  
- Bubble up **CodigoError/MensajeError** from Business to UI.  
- Keep complex logic out of forms; move to **Business** layer.  
- Comment non-trivial business rules.

### SQL (idempotente)
**ES**
- Usa `IF OBJECT_ID(...) IS NOT NULL DROP ...` y `CREATE OR ALTER` cuando aplique.  
- Incluye **pruebas comentadas** al final del script.  
- Usa parámetros en SP; evita concatenación de strings.  
- Devuelve `@@ROWCOUNT` cuando tenga sentido (CRUD).  
- Nombres consistentes con el proyecto (ej.: `prInsertarUsuario`, `prModificarUsuarios`).

**EN**
- Use idempotent patterns and **commented tests**.  
- Parameterized SPs; avoid string concatenation.  
- Return `@@ROWCOUNT` where appropriate.  
- Consistent naming with the project.

---

## 5) Tests & Local Run / Pruebas y ejecución local

**ES**
- **SSMS**: ejecuta los scripts en `/db_scripts` en orden (01 → 11).  
- Verifica Docker SQL (`127.0.0.1,2333`) y configura `App.config` local **desde la plantilla**.  
- Compila en VS 2022: `Compilar → Compilar solución`.  
- Ejecuta: `Depurar → Iniciar sin depuración (Ctrl+F5)`.

**EN**
- **SSMS**: run scripts under `/db_scripts` in order (01 → 11).  
- Ensure Docker SQL (`127.0.0.1,2333`), create local `App.config` from template.  
- Build in VS 2022, then run **without debugging**.

---

## 6) Pull Requests / PRs

**Checklist**
- [ ] Referencia a Issue: `Closes #N`.  
- [ ] Descripción del cambio (ES/EN breve si es posible).  
- [ ] Pasos de prueba (local + SQL si aplica).  
- [ ] Screenshots de UI (si aplica) → `/docs/capturas`.  
- [ ] Afecta `README/CHANGELOG` → **actualizados**.  
- [ ] Sin secretos en diffs (`App.config` real **no** versionado).  
- [ ] CI verde (Actions).

**Review**
- Se aplican reglas de **CODEOWNERS**.  
- Cambios solicitados deben resolverse antes del merge.

---

## 7) CI / GitHub Actions

**ES**
- El workflow `build.yml` detecta la `.sln` bajo `src/`.  
- Si hay solución, genera **App.config temporal** en el runner y compila Release.  
- No expongas secretos en logs.  
- Mantén el pipeline **verde**.

**EN**
- `build.yml` auto-detects the solution under `src/`.  
- If found, creates a **temporary App.config** in the runner and builds Release.  
- Never echo secrets in logs.  
- Keep the pipeline **green**.

---

## 8) Documentation / Documentación

**ES**
- Actualiza `README.md` (ES/EN), `CHANGELOG.md` y capturas en `/docs/capturas` cuando hay cambios de UX/flujo.  
- Añade comentarios en SQL y C# cuando haya decisiones importantes.

**EN**
- Update `README.md` (ES/EN), `CHANGELOG.md`, and screenshots when UX/flow changes.  
- Add comments in SQL/C# for important decisions.

---

## 9) Releases & Tags / Lanzamientos y Tags

**ES**
- Draft en **Releases** con notas (ES/EN), enlaza Issues cerrados.  
- Tag firmado con SSH: `git tag -s vX.Y.Z -m "vX.Y.Z"` → **Verified**.  
- Publica el Release y adjunta artefactos si aplica.

**EN**
- Draft **Releases** with notes (ES/EN) and closed Issues links.  
- SSH-signed tag: `git tag -s vX.Y.Z -m "vX.Y.Z"` → **Verified**.  
- Publish the Release, attach artifacts if needed.

---

## 10) Security / Seguridad

**ES**
- Nunca subas `App.config` reales; usa la plantilla con placeholders.  
- No compartas credenciales en Issues/PRs.  
- Revisa `SECURITY.md` para reporte de vulnerabilidades y hardening.

**EN**
- Never commit real `App.config`; use template placeholders.  
- Do not share credentials in Issues/PRs.  
- Check `SECURITY.md` for reporting and hardening guidelines.

---

## 11) Code of Conduct (short) / Conducta (resumen)

**ES**
- Sé respetuoso, empático y claro. Feedback basado en hechos y tests.

**EN**
- Be respectful, empathetic, and clear. Evidence- and test-based feedback.

---

Gracias por contribuir a **SuiteMDI-EduSQL** 🙌 / Thanks for contributing!