## Resumen
<!-- Breve descripción del cambio: qué hace y por qué. -->

## Tipo de cambio
- [ ] Bugfix
- [ ] Feature / Mejora
- [ ] Refactor
- [ ] Docs
- [ ] Infra / CI
- [ ] Chore / Mantenimiento
- [ ] Breaking change ⚠️ (requiere nota en CHANGELOG y plan de migración)

## Contexto
<!-- ¿Qué problema resuelve? Referencia al Issue. -->
Closes #<número>  <!-- o -->  Related to #<número>

## Alcance del cambio
- [ ] C# (código)
- [ ] UI (WinForms)
- [ ] SQL (scripts en `db_scripts/`)
- [ ] Pruebas SQL (archivos en `db_test/`)
- [ ] CI/CD (Actions)
- [ ] Documentación

## Evidencia (si aplica)
<!-- Capturas o GIFs breves de la UI, logs relevantes, etc. -->

## SQL / Migraciones (si aplica)
- [ ] Nuevos/actualizados SP/tablas/índices documentados en `db_scripts/`
- [ ] Pruebas en `db_test/` (unitarias/integración) con `BEGIN TRAN/ROLLBACK`
- [ ] Orden de ejecución actualizado en `README`
- [ ] Nota en `CHANGELOG` si cambia comportamiento o contrato

## Seguridad (si aplica)
- [ ] No se exponen secretos (sin `App.config` real, contraseñas, etc.)
- [ ] Revisado `SECURITY.md` si afecta a credenciales/secretos
- [ ] Permisos mínimos en SQL (evitar `db_owner` en PROD)

## Plan de pruebas
<!-- Pasos para probar localmente: entorno, datos semilla, comandos, resultados esperados. -->

## Checklist
- [ ] Probado localmente (build OK)
- [ ] CI verde (Actions)
- [ ] README / CHANGELOG actualizados si aplica
- [ ] Cumple estilo (`.editorconfig`) y convenciones
- [ ] `DataPropertyName` consistente con campos de SPs (si hay grillas)
- [ ] Sin archivos generados ni `App.config` real en el diff
- [ ] Labels y milestone asignados

## Breaking change (solo si aplica)
<!-- Impacto, plan de migración, pasos de downgrade/rollback. -->

## Riesgos / Rollback
<!-- Riesgos conocidos y plan de reversión (p. ej. revert PR / script de undo). -->

## Notas adicionales
<!-- Consideraciones extra para reviewers / release. -->