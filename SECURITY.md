**Reportar vía GitHub (Security Advisories)**: https://github.com/recm0708/SuiteMDI-EduSQL/security/advisories/new

# Política de Seguridad

## Versiones con soporte
Aplicamos actualizaciones de seguridad a la **última versión menor** dentro de cada serie activa (SemVer).

| Versión | Soporte |
|--------:|:-------:|
| v0.x    | ✅      |
| < v0.x  | ❌      |

---

## Reporte de vulnerabilidades

**No abras issues públicos para temas de seguridad.**

- Usa **GitHub → Security advisories** (o contacto privado si aplica).
- En última instancia, crea un Issue con la plantilla **Security** sin incluir datos sensibles y solicita un canal privado.

**Incluye (si es posible):**
- Versión(es) afectada(s) y alcance.
- Pasos de reproducción / PoC o escenario mínimo.
- Impacto (confidencialidad, integridad, disponibilidad).
- Entorno (SO, Docker/SQL, versiones de herramientas).

**Plazos de respuesta (objetivo):**
- Acuse de recibo en **72 h**.
- Triage y evaluación inicial en **7 días**.
- La ventana de corrección depende de severidad y alcance.

---

## Divulgación coordinada
Seguimos **divulgación responsable**: trabajaremos en privado, prepararemos el fix y publicaremos notas del release acreditándote (si lo autorizas).

---

## Guía de severidad (orientativa)
- **Crítica**: ejecución remota, bypass de autenticación, exposición de credenciales.
- **Alta**: escalamiento de privilegios, exfiltración, SQLi en datos núcleo.
- **Media**: acciones no autorizadas de alcance limitado, exposición no sensible.
- **Baja**: desviaciones de buenas prácticas, hardening pendiente sin exploit inmediato.

---

## Secretos y configuración

- **Nunca** publiques secretos reales.
- `App.config` **no** debe versionarse. Usa `src/App/App.config.template.config` con placeholders.
- En producción evita `sa`; aplica **mínimos privilegios**.
- Prefiere gestores de secretos o variables de entorno (Docker/CI).
- Rota credenciales si hay incidente o exposición sospechada.
- En Actions, **no** imprimas secretos; usa **secrets** cifrados.

---

## Lista de endurecimiento (hardening)

**Aplicación (WinForms .NET 4.8)**
- Validar entradas (trim/normalizar). Nada de concatenar SQL.
- Siempre **parámetros** en `SqlCommand`.
- Mensajes de error sanitizados en UI; detalle solo en DEV.
- Mantener dependencias actualizadas.

**SQL Server / Docker**
- Exponer solo el puerto necesario (p. ej., `127.0.0.1,2333`).
- Contraseña fuerte para `sa`; deshabilitar `sa` fuera de DEV si es posible.
- Usuarios/roles por entorno; evitar `db_owner` en prod.
- Backups cifrados; proteger datos en reposo y tránsito cuando aplique.

**CI/CD (GitHub Actions)**
- Tokens con mínimos privilegios.
- No descargar artefactos no confiables.
- Usar versiones fijadas o publishers verificados.

---

## Commits y tags firmados (Verified)
Recomendamos **firmar con SSH** para estado **Verified** en GitHub.

- Configura: `git config --global gpg.format ssh` y `user.signingkey`.
- Inicia el agente y añade tu clave: `ssh-agent & ssh-add C:\Keys\id_ed25519`.
- Etiquetado: `git tag -s -m "vX.Y.Z" vX.Y.Z`.

---

## Alcance

**Dentro de alcance**
- Vulnerabilidades en el código del repositorio, scripts SQL, workflows de CI.
- Misconfiguraciones que puedan derivar en compromiso.

**Fuera de alcance**
- Ingeniería social, ataques físicos.
- Hallazgos que requieran root/admin en la máquina del probador.
- Problemas en servicios de terceros fuera de nuestro control.

---

## Puerto seguro (Safe Harbor)
Si sigues esta política (buena fe, sin destrucción de datos, pruebas limitadas y reporte oportuno), no emprenderemos acciones legales.

---

## Créditos
Acreditamos a quienes reportan en las notas del release si así lo desean.