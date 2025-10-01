# Contributing / Contribuir

> ES 🇪🇸 · Guía para contribuir a **SuiteMDI-EduSQL**  
> EN 🇺🇸 · Contribution guide for **SuiteMDI-EduSQL**

---

## 🧭 Philosophy / Filosofía

- **Educational & pragmatic**: code that others can learn from and maintain.  
- **Small, reviewed changes**: prefer many small PRs over one huge PR.  
- **Security & privacy first**: *no secrets in the repo*, ever.  
- **Automation helps**: scripts, CI, templates, and checklists are welcome.

---

## 📌 Scope / Alcance

**ES:** El proyecto expone una app WinForms .NET 4.8 (UI por código) y un backend SQL Server (scripts idempotentes).  
**EN:** The project ships a .NET 4.8 WinForms app (code-only UI) and a SQL Server backend (idempotent scripts).

---

## 🧰 Development Setup / Entorno de desarrollo

- Windows + **Visual Studio 2022** (ES ok)
- **.NET Framework 4.8**
- **Docker** + SQL Server 2022 (host `127.0.0.1,2333`)
- **SSMS**
- **SSH** signing for **Verified** commits/tags

**Config (local):**
1. Copy `src/App/App.config.template.config` → **`App.config`** (do **not** commit).
2. Set your **real** Docker/Local connection string(s).
3. Run SQL scripts from `/db_scripts` in order.

---

## 🐞 Issues

- **Use templates** (`Bug`, `Feature`, `Task`) y añade **labels** (`sql`, `backend`, `ui`, `docs`, `infra`, etc.).  
- Provide **steps to reproduce**, expected/actual results, environment (VS, Docker, SQL build).  
- Link screenshots or logs where relevant.

**Good first issues:** labeled `good first issue`.

---

## 🌱 Branching Model / Modelo de ramas

- Default branch: **`main`** (stable).  
- Feature/hotfix branches: `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>`.  
- Optional (when enabled): PRs required to merge into `main`.

---

## 🧪 Commits & PRs

**Commits**
- Messages in **Spanish** preferred, concise and imperative.  
- Examples:  
  - `feat(db): 08 tablas del aplicativo (clientes, servicios, …)`  
  - `fix(ui): mapear DataPropertyName para Direccion`  
  - `docs: README bilingüe + TOC anclado`

**PRs**
- Reference issues: `Closes #N`.  
- Include **what/why/how** (summary, screenshots if UI).  
- Pass CI (Actions) and keep PRs small.

---

## 🧹 Code Style

- **C#**: PascalCase para tipos y métodos; camelCase para variables; comentarios **claro y útil**.  
- **WinForms**: UI por **código**, no diseñador; **DataGridView** con columnas manuales (DataPropertyName exacto).  
- **SQL**: scripts **idempotentes**, `RETURN @@ROWCOUNT` donde aplique, pruebas **comentadas**.  
- **Docs**: ES/EN cuando sea relevante.

---

## 🔐 Security & Secrets / Seguridad y secretos

- **Nunca** subas `App.config` real; usa el **template**.  
- Evita credenciales y tokens en commits, issues, PRs o capturas.  
- Si encuentras una vulnerabilidad, **no abras un issue público**: ver `SECURITY.md`.

---

## 📦 Releases & Versioning

- Keep a Changelog (ver `CHANGELOG.md`).  
- Tags `vX.Y.Z` firmados por **SSH** (*Verified*).  
- Releases incluyen notas en ES/EN cuando el cambio es relevante.

---

## 🧩 Testing matrix (mínima)

- SQL scripts: ejecutar pruebas comentadas y validar objetos (`OBJECT_ID`).  
- App: prueba **SELECT 1**, login real (SP 02), CRUD de usuarios, clientes y cambio de contraseña.  
- CI: build verde en Windows runner.

---

## 🤝 Code of Conduct

Be respectful and constructive. If needed, we can add a formal **CODE_OF_CONDUCT.md**.

---

## 🚀 Getting Started Tasks (for contributors)

- [ ] Read README (ES/EN) and project layout.  
- [ ] Setup Docker SQL and run scripts 01–11.  
- [ ] Build solution locally (when present).  
- [ ] Open a small PR improving docs or a minor bug to get familiar.

---

## 📬 Contact

- Open an Issue for general questions.  
- Security concerns → see `SECURITY.md`.