# Security Policy / Política de Seguridad

> ES/EN side-by-side. Keep reports private until coordinated disclosure completes.

---

## 🎯 Scope / Alcance

**EN:** Security issues affecting this repo (source code, build/CI, SQL scripts, configuration templates).  
**ES:** Problemas de seguridad que afecten este repositorio (código fuente, build/CI, scripts SQL, plantillas de configuración).

> Not in scope / Fuera de alcance:
> - Usage questions / preguntas de uso (abrir como Issue normal).
> - Feature requests / solicitudes de mejora (Issue “feature”).
> - Third-party bugs without a direct impact here / fallos de terceros sin impacto directo aquí.

---

## 🔐 Supported Versions / Versiones con soporte

**EN:** We apply security fixes to the **latest minor** (SemVer). Older versions may receive best-effort guidance only.  
**ES:** Se aplican correcciones de seguridad a la **última versión menor** (SemVer). Versiones antiguas reciben solo guía “best-effort”.

Examples / Ejemplos:
- `vX.Y.Z` → fixes go to `vX.Y+1` (latest minor).  
- Backports only if risk is high and feasible / Backports solo si el riesgo es alto y es viable.

---

## 📣 Reporting a Vulnerability / Reporte de vulnerabilidad

**Please keep reports private**. / **Mantén los reportes en privado**.

1) **Open a private Security Issue**  
   - EN: Use GitHub **Issues → Security** (or mark as *private* if available).  
   - ES: Usa **Issues → Security** (o márcalo *privado* si está disponible).

2) **Email fallback (optional)**  
   - If you need an email channel, redact personal/secret data.  
   - Si necesitas correo, elimina datos sensibles antes de enviar.

### Include / Incluir
- Impact + component (code area, SQL script, CI, config template).  
- Steps to reproduce (minimal PoC).  
- Affected version(s) / ramas.  
- Environment (OS, VS 2022 ES, Docker SQL 2022, etc.).  
- Suggested mitigation (if any).

### Do **NOT** include / **NO** incluir
- Real passwords, connection strings with secrets.  
- Live database snapshots or production data.  
- API keys, tokens, personal data (PII).

---

## 🧪 Safe Repro Guidelines / Reproducción segura

**EN:**
- Use `App.config.template.config` with placeholders (do not share real `App.config`).  
- Prefer Docker SQL with an **isolated** test DB.  
- Sanitize logs/traces before sharing.  
- If you must show data, use synthetic examples.

**ES:**
- Usa `App.config.template.config` con *placeholders* (no compartir `App.config` real).  
- Prefiere Docker SQL con una BD de **pruebas aislada**.  
- Sanear logs/trazas antes de compartir.  
- Si debes mostrar datos, usa ejemplos sintéticos.

---

## 🔄 Coordinated Disclosure / Divulgación coordinada

**Timeline / Plazos (objetivo):**
- **Acknowledgement / Acuse:** 3–5 días hábiles.  
- **Triage:** 7–10 días hábiles (repro, alcance, severidad).  
- **Fix ETA:** comunicado tras triage (depende de complejidad).  
- **Advisory:** publicado con el fix (CHANGELOG + Release Notes).

We may ask for more time if complexity/risk is high.  
Podríamos requerir más tiempo si la complejidad/riesgo es alto.

---

## 🧭 Severity Guidance / Guía de severidad (orientativa)

- **Critical**: RCE, credential disclosure, auth bypass.  
- **High**: Privilege escalation, SQL injection con impacto real.  
- **Medium**: Info leak limitada, CS misconfig (secrets en logs).  
- **Low**: Hardening/documentation gaps.

Mitigations, environment isolation, and user interaction lower severity.  
Las mitigaciones, aislamiento del entorno e interacción del usuario reducen severidad.

---

## 🗃️ Secrets Handling / Manejo de secretos

- We **never** version real secrets. Use `App.config.template.config`.  
- Docker/SQL credentials must be local only; do not paste into Issues/PRs.  
- CI uses a **temporary** App.config on runner (not committed).

**Nunca** versionamos secretos reales. Credenciales Docker/SQL solo locales; no pegarlas en Issues/PRs.  
CI usa un App.config **temporal** en el runner (no se *commitea*).

---

## 📄 Credit & Bounty / Créditos y recompensas

- Credit is optional and granted upon request in Release Notes.  
- No formal bug bounty program at this time.

Crédito opcional (si se solicita) en Release Notes.  
No existe programa formal de *bug bounty* por el momento.