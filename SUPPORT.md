# Soporte / Ayuda

Bienvenido/a. Antes de abrir un Issue de soporte, por favor revisa esta guía para acelerar la respuesta.

## ✅ Checklist previa

- [ ] Leí el [`README`](./README.md) (requisitos, configuración, orden de scripts).
- [ ] Revisé la **Política de Seguridad** [`SECURITY.md`](./SECURITY.md) (no compartir secretos).
- [ ] Verifiqué que **Docker SQL** está arriba (`127.0.0.1,2333`) o mi SQL local responde.
- [ ] Corrí los scripts base en **orden** (01 → 09) en **SSMS** sin errores.
- [ ] Mi `App.config` local se creó desde la **plantilla** y **no está versionado**.
- [ ] Si el problema es de **CI**, confirmé el estado del workflow **Build** en GitHub Actions.
- [ ] (Opcional) Probé los **tests SQL** de `db_test/` y revisé resultados.

## ❓ ¿Dónde abro mi consulta?

- **💬 Soporte / Consulta general:** abre un Issue con la plantilla **Soporte / Consulta**.
- **🐞 Bug real:** usa **Bug report** con **pasos reproducibles** y entorno.
- **✨ Mejora / Feature:** usa **Feature request** (valor, alcance, criterios de aceptación).
- **🔐 Duda de seguridad (NO vulnerabilidad):** usa **Security question**.
- **🛡️ Vulnerabilidad:** usar **Security advisories** (ver [`SECURITY.md`](./SECURITY.md)).  
  _No abras Issues públicos con detalles sensibles._

> Acceso rápido: **Issues → New issue → _Choose a template_**.

## 🧾 Información útil a incluir

Incluye, cuando aplique:

- **Entorno:** Windows (versión), VS 2022, Docker SQL 2022 (puerto `2333`), rama/commit.
- **Pasos exactos** (1, 2, 3), **resultado esperado** vs **resultado obtenido**.
- **Logs / mensajes** (SQL/StackTrace) **sin secretos**.
- **Capturas** (UI/SSMS) en formato imagen.
- **Scripts ejecutados** (nombres/orden) y si probaste `db_test/RUN_ALL.sql` (SQLCMD Mode).

## 🧪 Consejos de autodiagnóstico

- **Conexión SQL:** prueba `SELECT 1` y acceso con el usuario configurado.
- **Orden de scripts:** asegúrate de ejecutar 01 → 11; luego utilitarios/seed si aplica.
- **Reseed DEV:** usa `db_scripts/util/Reseed_All.sql` tras limpiezas masivas.
- **Reset rápido:** `db_test/00_basicas/Reset_Limpio_DEV.sql` (requiere SQLCMD Mode).
- **Integración:** ejecuta `db_test/RUN_ALL.sql` para un smoke end-to-end (SQLCMD Mode).

## 📬 Tiempos y expectativas

- Hacemos el mejor esfuerzo por responder **lo antes posible**.
- Issues bien documentados (plantillas completas) se atienden más rápido.

Gracias por seguir estas pautas — nos ayuda a ayudarte mejor. 🙌