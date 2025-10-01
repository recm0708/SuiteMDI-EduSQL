# Security Policy / Política de Seguridad

> ES 🇪🇸 · Cómo reportar vulnerabilidades o incidentes de seguridad  
> EN 🇺🇸 · How to report vulnerabilities or security incidents

---

## 🔐 Supported Versions / Versiones con soporte

We support the **latest minor** for each active branch (e.g., `v0.3.x`).  
Soportamos la **última minor** por rama activa (ej.: `v0.3.x`).

---

## 📣 Reporting a Vulnerability / Reportar vulnerabilidades

**Do NOT open public issues for security problems.**  
**NO** abras issues públicos por problemas de seguridad.

1. Email (private): **ruben_sten0708@outlook.com**
2. Provide:
   - Affected version / commit hash
   - Environment (OS, VS version, Docker, SQL)
   - Steps to reproduce (PoC if possible)
   - Impact assessment (data exposure, RCE, etc.)
   - Workaround (if any)

We’ll acknowledge within **72h** and coordinate a fix timeline and disclosure window.  
Confirmaremos recepción en **72h** y coordinaremos tiempos de fix y divulgación responsable.

---

## 🔑 Secrets & Config / Secretos y configuración

- Never commit real secrets (`App.config`, tokens, passwords).  
- Use `App.config.template.config` locally and keep secrets out of the repo.  
- For production, use secret stores (env vars, Key Vault-like solutions) and least privilege users.

---

## 🧪 Hardening Guidelines / Recomendaciones

- Enforce `TrustServerCertificate=True` only for DEV; prefer encrypted channels.  
- Use non-`sa` users in non-DEV environments.  
- Regularly rotate passwords and review DB roles.  
- Keep Docker images up to date (SQL Server cumulative updates).  
- Signed commits and tags (**SSH Verified**) recommended.

---

## 📝 Disclosure Policy / Política de divulgación

- Private reporting → confirm in 72h → coordinate fix → publish security notes in **Releases** and **CHANGELOG**.  
- We credit reporters if they agree.

---

## 📦 Dependencies / Dependencias

- .NET Framework 4.8  
- SQL Server 2022 (Docker)  
- NuGet packages (when applicable) should be updated with minor/patch on a regular basis.