# Guía de Contribución

> Esta guía describe el flujo de trabajo, estándares y buenas prácticas para contribuir a **SuiteMDI-EduSQL**.

---

## 🧭 Resumen

Proyecto **WinForms .NET 4.8 sin diseñador** (UI 100% por código), SQL Server (Docker-first), **scripts idempotentes** y **CI en GitHub Actions**.

---

## 1) Issues y planeación

- Antes de empezar, **crea un Issue** con la plantilla adecuada: _bug_, _feature_ o _task_.
- Asigna **labels** (p.ej., `sql`, `backend`, `ui`, `docs`, `infra`, `security`, `good first issue`) y una **milestone** (vX.Y.Z).
- Agrega el Issue al **Project (Roadmap Kanban)** en la columna **To do**.

---

## 2) Ramas

- Rama base: `main`.
- Crea ramas por Issue: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`.
  - Ejemplo: `feat/clientes-crud`, `fix/sql-identity-reseed`.
- Commits/PRs deben referenciar el Issue: `Closes #N`.

---

## 3) Estilo de commits

Usa **Conventional Commits**:
`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `build:`, `ci:`

- Mensajes **claros** y **en español**.
- Firma tus commits con **SSH** (estado *Verified* en GitHub).

**Ejemplos**
- `feat(clientes): alta desde frmClienteNuevo`
- `fix(sql): corregir comparación de Pass (VARBINARY) en prValidarUsuario`
- `docs(readme): agregar tabla de contenidos`

---

## 4) Estándares de código

### C# (WinForms .NET 4.8 – sin diseñador)
- Formularios **por código** (sin diseñador).
- `DataGridView` con **columnas manuales** y `DataPropertyName` exacto a los campos del SP.
- Maneja excepciones y propaga a la UI **CodigoError/MensajeError** desde la capa de Negocio.
- Evita lógica compleja en el form; muévela a **Negocio**.
- Comenta reglas de negocio y decisiones no triviales.

### SQL (idempotente)
- Usa patrones idempotentes (`IF OBJECT_ID(...) ...`, `CREATE OR ALTER` cuando aplique).
- Incluye **pruebas comentadas** al final del script.
- Usa parámetros; evita concatenación de strings.
- Devuelve `@@ROWCOUNT` cuando tenga sentido (CRUD).
- Nomenclatura consistente (ej.: `prInsertarUsuario`, `prModificarUsuarios`).

---

## 5) Pruebas y ejecución local

- **SSMS**: ejecuta `/db_scripts` en orden (01 → 11).
- Verifica Docker SQL (`127.0.0.1,2333`) y crea tu `App.config` local **desde la plantilla**.
- Compila en VS 2022: `Compilar → Compilar solución`.
- Ejecuta: `Depurar → Iniciar sin depuración (Ctrl+F5)`.

---

## 6) Pull Requests (PRs)

**Checklist**
- [ ] Referencia a Issue: `Closes #N`.
- [ ] Descripción del cambio y **pasos de prueba**.
- [ ] Screenshots de UI (si aplica) → `/docs/capturas`.
- [ ] Actualizados `README.md` / `CHANGELOG.md` si corresponde.
- [ ] Sin secretos en diffs (`App.config` real **no** se versiona).
- [ ] CI verde (Actions).

**Revisión**
- Se aplican reglas de **CODEOWNERS**.
- Atiende comentarios solicitados antes del merge.

---

## 7) CI / GitHub Actions

- `build.yml` detecta la `.sln` bajo `src/`.
- Si existe, genera **App.config temporal** en el runner y compila **Release**.
- No expongas secretos en logs.
- Mantén el pipeline **verde**.

---

## 8) Documentación

- Actualiza `README.md`, `CHANGELOG.md` y capturas en `/docs/capturas` cuando haya cambios de UX/flujo.
- Añade comentarios en SQL y C# cuando haya decisiones importantes.

---

## 9) Lanzamientos y tags

- Prepara **draft** de Release y enlaza Issues cerrados.
- Tag firmado con SSH: `git tag -s vX.Y.Z -m "vX.Y.Z"` → **Verified**.
- Publica el Release y adjunta artefactos si aplica.

---

## 10) Seguridad

- Nunca subas `App.config` reales; usa la plantilla con placeholders.
- No compartas credenciales en Issues/PRs.
- Revisa `SECURITY.md` para reporte de vulnerabilidades y hardening.

---

## 11) Conducta (resumen)

- Sé respetuoso, empático y claro. Feedback basado en hechos y pruebas.

---

## Vínculos rápidos
- Roadmap (Project): https://github.com/recm0708/SuiteMDI-EduSQL/projects
- Milestones: https://github.com/recm0708/SuiteMDI-EduSQL/milestones
- Labels: https://github.com/recm0708/SuiteMDI-EduSQL/labels

Gracias por contribuir a **SuiteMDI-EduSQL** 🙌