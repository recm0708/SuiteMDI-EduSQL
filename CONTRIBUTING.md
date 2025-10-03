# Contribuir

> Este proyecto usa WinForms .NET 4.8 (UI por código), SQL Server (Docker-first), scripts SQL idempotentes y CI en GitHub Actions.  
> Idioma de documentación: **español** (salvo LICENSE y YAML/keys).

---

## 1) Issues y planeación

- Antes de empezar, **crea un Issue** usando la plantilla correcta: _bug_, _feature_, _task_.
- Asigna **labels** (`sql`, `backend`, `ui`, `docs`, `infra`, `security`, `good first issue`) y la **milestone** (vX.Y.Z).
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
- (Recomendado) **Firmar con SSH** para obtener estado *Verified* en GitHub.

Ejemplos:
- `feat(clientes): alta de cliente desde frmClienteNuevo`
- `fix(sql): corregir comparación de Pass (VARBINARY) en prValidarUsuario`
- `docs(readme): agregar tabla de contenidos`

---

## 4) Estándares de código

### C# (WinForms – UI por código)
- Formularios **por código** (sin diseñador).
- `DataGridView` con **columnas manuales**; `DataPropertyName` debe coincidir con los campos devueltos por SP.
- Manejar excepciones propagando `CodigoError`/`MensajeError` desde **Negocio** a la UI.
- Mover la lógica no trivial a la capa de **Negocio**.
- Comentar decisiones no triviales o reglas de negocio.

### SQL (idempotente)
- Usar patrones idempotentes (`IF OBJECT_ID` / `CREATE OR ALTER`) cuando aplique.
- **Parámetros** siempre; evitar concatenar strings.
- Devolver `@@ROWCOUNT` en CRUD cuando tenga sentido.
- **Pruebas comentadas** al final de cada script.

---

## 5) Pruebas y ejecución local

- **SSMS**: ejecutar `/db_scripts` en orden (01 → 11).
- Docker SQL en `127.0.0.1,2333`. Crear `App.config` local desde la plantilla.
- VS 2022:
  - Compilar: `Compilar → Compilar solución`
  - Ejecutar: `Depurar → Iniciar sin depuración (Ctrl+F5)`

---

## 6) Pull Requests

- **Obligatorio** usar la **plantilla de PR** del repo y **completar el checklist**.
- Referenciar el Issue: `Closes #N` (o `Related to #N`).
- Adjuntar **evidencia** de UI si aplica (`/docs/capturas`).
- Si hay cambios en SQL:
  - Documentar el script en `db_scripts/`,
  - Incluir **pruebas comentadas**,
  - Actualizar **orden de ejecución** en README.
- **Seguridad**: no incluir secretos (`App.config` real, contraseñas).
- **CI** debe estar en **verde**.

> **Breaking change ⚠️**  
> - Añade nota explícita en `CHANGELOG.md` y label `breaking-change` o `major`.  
> - Incluir instrucciones de migración si aplica.

---

## 7) CI / GitHub Actions

- `build.yml` detecta la `.sln` bajo `src/`.
- Si existe, genera un **App.config temporal** en el runner y compila **Release**.
- No imprimir secretos en logs; mantener pipeline en verde.

---

## 8) Documentación

- Actualizar `README.md`, `CHANGELOG.md` y capturas en `/docs/capturas` cuando cambie UX/flujo.
- Añadir comentarios en SQL/C# cuando haya decisiones importantes.
- Consulta también `CODE_OF_CONDUCT.md` y `SUPPORT.md` para convivencia y canales de ayuda.

---

## 9) Lanzamientos y tags

- Preparar **draft** en Releases con notas (ES) y Issues cerrados.
- Tag **firmado con SSH**: `git tag -s vX.Y.Z -m "vX.Y.Z"` → *Verified*.
- Publicar el Release y adjuntar artefactos si aplica.

---

## 10) Seguridad

- No subir `App.config` reales; usar la **plantilla** con placeholders.
- No compartir credenciales en Issues/PRs.
- Revisar `SECURITY.md` para reporte de vulnerabilidades y hardening.

---

## 11) Conducta (resumen)

- Sé respetuoso, empático y claro. Feedback basado en evidencias y pruebas.

---

## Enlaces rápidos
- Project (Roadmap): https://github.com/recm0708/SuiteMDI-EduSQL/projects
- Milestones: https://github.com/recm0708/SuiteMDI-EduSQL/milestones
- Labels: https://github.com/recm0708/SuiteMDI-EduSQL/labels