## Resumen
<!-- Breve descripción del cambio. Qué hace y por qué. -->

## Tipo de cambio
- [ ] Bugfix
- [ ] Feature / Mejora
- [ ] Refactor
- [ ] Docs
- [ ] Infra / CI
- [ ] Chore / Mantenimiento
- [ ] Breaking change ⚠️ (requiere nota en CHANGELOG)

## Contexto
<!-- ¿Qué problema resuelve? Referencia al Issue. -->
Closes #<número>  <!-- o -->  Related to #<número>

## Evidencia (si aplica)
<!-- Capturas o GIFs breves de la UI. -->

## SQL / Migraciones (si aplica)
- [ ] Nuevos SP/tablas/índices documentados en `db_scripts/`
- [ ] Pruebas comentadas incluidas en el script
- [ ] Orden de ejecución actualizado en README

## Seguridad (si aplica)
- [ ] No se exponen secretos (sin `App.config` real, contraseñas, etc.)
- [ ] Revisado `SECURITY.md` si afecta a credenciales/secretos

## Checklist
- [ ] Probado localmente (build OK)
- [ ] CI verde (Actions)
- [ ] README / CHANGELOG actualizados si aplica
- [ ] Cumple estilo (`.editorconfig`) y convenciones
- [ ] `DataPropertyName` consistente con resultados de SPs (si hay grillas)
- [ ] Sin archivos generados ni `App.config` real en el diff
- [ ] Labels y milestone asignados
- [ ] Nuevos SP/tablas/índices documentados en `db_scripts/` y **pruebas** en `db_test/`

## Riesgos / Rollback
<!-- Riesgos conocidos y plan de reversión. -->

## Notas adicionales
<!-- Consideraciones extra para reviewers / release. -->