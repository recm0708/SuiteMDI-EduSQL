# Security Policy / Política de Seguridad

> Bilingual file / Archivo bilingüe (ES/EN)

---

## ✅ Supported Versions / Versiones con soporte

We apply security updates to the **latest minor** release within each active series (SemVer).  
Aplicamos actualizaciones de seguridad a la **última versión menor** dentro de cada serie activa (SemVer).

| Version | Supported |
|--------:|:---------:|
| v0.x    | ✅        |
| < v0.x  | ❌        |

---

## 🚨 Reporting a Vulnerability / Reporte de vulnerabilidades

**Please DO NOT open public issues for security reports.**  
**Por favor NO abras issues públicos para reportes de seguridad.**

- ES: Usa **GitHub → Security advisories** (o contacto privado si aplica). En último caso, crea un issue usando la plantilla **Security** sin incluir datos sensibles y pide un canal privado.  
- EN: Use **GitHub → Security advisories** (or private contact if applicable). As a last resort, open an issue with the **Security** template, include **no secrets**, and request a private channel.

**What to include / Qué incluir**
- Affected version(s) / Versión(es) afectada(s).  
- Reproduction steps, PoC or minimal scenario / Pasos de repro, PoC o escenario mínimo.  
- Impact assessment (confidentiality, integrity, availability) / Impacto (confidencialidad, integridad, disponibilidad).  
- Environment details (OS, Docker/SQL setup) / Entorno (SO, configuración Docker/SQL).

**Response timeline / Plazos de respuesta**
- Acknowledgement within **72h**.  
- Triage & initial assessment within **7 days**.  
- Fix window depends on severity & scope (see below).  
- Acuse de recibo en **72h**.  
- Triage y evaluación inicial en **7 días**.  
- La ventana de corrección depende de severidad y alcance (ver abajo).

---

## 🔒 Coordinated Disclosure / Divulgación coordinada

We follow **responsible disclosure**: we’ll work privately with you, prepare a fix, then publish release notes crediting you (if you agree).  
Seguimos **divulgación responsable**: trabajaremos en privado, prepararemos el fix y publicaremos notas del release acreditándote (si estás de acuerdo).

---

## 🧭 Severity Guidance / Guía de severidad

- **Critical**: remote code execution, auth bypass, credential disclosure.  
- **High**: privilege escalation, data exfiltration, SQLi affecting core data.  
- **Medium**: unauthorized actions with limited scope, info disclosure (non-sensitive).  
- **Low**: best-practice deviations, hardening gaps without immediate exploit.

- **Crítico**: ejecución remota, bypass de autenticación, fuga de credenciales.  
- **Alto**: escalamiento de privilegios, exfiltración, SQLi en datos núcleo.  
- **Medio**: acciones no autorizadas de alcance limitado, exposición no sensible.  
- **Bajo**: desviaciones de buenas prácticas, endurecimiento pendiente sin exploit inmediato.

---

## 🔑 Secrets & Config / Secretos y configuración

**Never commit real secrets.**  
**No commitees secretos reales.**

- `App.config` **must not** be versioned. Use `src/App/App.config.template.config` with placeholders.  
- Use different accounts than `sa` for prod; least privilege.  
- Prefer secret stores or environment variables (Docker, CI).  
- Rotate credentials after incidents or suspected exposure.  
- In Actions, never echo secrets. Use encrypted secrets.

- `App.config` **no** debe versionarse. Usa `src/App/App.config.template.config` con placeholders.  
- En prod evita `sa`; **mínimos privilegios**.  
- Prefiere gestores de secretos o variables de entorno (Docker, CI).  
- Rota credenciales ante incidentes/exposición sospechada.  
- En Actions, nunca imprimas secretos. Usa **secrets** cifrados.

---

## 🧱 Hardening Checklist / Lista de endurecimiento

**App (WinForms .NET 4.8)**
- Validate all inputs; trim/normalize; avoid string concatenation for SQL.  
- Use parameterized queries (SqlCommand with parameters).  
- Surface errors sanitized to UI; log detailed errors locally only in DEV.  
- Keep dependencies up to date.

**SQL Server / Docker**
- Expose only required port (e.g., `127.0.0.1,2333` locally).  
- Strong `sa` password; disable `sa` in non-DEV if possible.  
- Separate DB users/roles per environment; no `db_owner` in prod.  
- Backups encrypted, at-rest & in-transit protection when applicable.

**CI/CD (GitHub Actions)**
- Principle of least privilege for tokens.  
- Do not download untrusted artifacts.  
- Use pinned action versions or verified publishers.

**App (WinForms .NET 4.8)**
- Valida entradas; trim/normaliza; evita concatenar SQL.  
- Usa parámetros en SqlCommand.  
- Errores sanitizados a la UI; detalle solo en DEV.  
- Mantén dependencias al día.

**SQL Server / Docker**
- Expón solo el puerto necesario (p.ej., `127.0.0.1,2333`).  
- Contraseña fuerte para `sa`; deshabilita `sa` fuera de DEV si es posible.  
- Usuarios/roles por entorno; evita `db_owner` en prod.  
- Backups cifrados; protección en reposo y tránsito si aplica.

**CI/CD (GitHub Actions)**
- Mínimos privilegios para tokens.  
- No descargues artefactos no confiables.  
- Usa versiones fijadas o publishers verificados.

---

## 🖊️ Signed Commits & Tags / Commits y tags firmados

We encourage **SSH-signed** commits/tags for **Verified** status on GitHub.  
Recomendamos **firmar con SSH** commits/tags para estado **Verified** en GitHub.

- Ensure `git config --global gpg.format ssh` and `user.signingkey` are set.  
- Start the agent and add your key: `ssh-agent & ssh-add C:\Keys\id_ed25519`.  
- Prefer `git tag -s -m "vX.Y.Z" vX.Y.Z`.

- Asegura `git config --global gpg.format ssh` y `user.signingkey`.  
- Inicia el agente y añade tu clave: `ssh-agent & ssh-add C:\Keys\id_ed25519`.  
- Prefiere `git tag -s -m "vX.Y.Z" vX.Y.Z`.

---

## 🎯 In/Out of Scope / Alcance

**In scope / Dentro**
- Vulnerabilities in repo code, SQL scripts, CI workflows.  
- Misconfigurations that can lead to compromise.

**Out of scope / Fuera**
- Social engineering, physical attacks.  
- Findings that require root/admin on tester’s own machine.  
- Issues in third-party services beyond our control.

---

## 🛡️ Safe Harbor / Puerto seguro

If you follow this policy (good faith, no data destruction, limited testing, prompt reporting), we will not pursue legal action.  
Si sigues esta política (buena fe, sin destrucción de datos, pruebas limitadas, reporte oportuno), no emprenderemos acciones legales.

---

## 🤝 Credits / Créditos

We credit reporters in release notes if you want attribution.  
Acreditamos a quienes reportan en las notas del release si así lo desean.