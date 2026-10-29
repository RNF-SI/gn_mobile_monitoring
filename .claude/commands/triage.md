---
description: Analyse plusieurs issues et propose des lots par fichiers probablement touchés
argument-hint: <numéros d'issues séparés par espace>
allowed-tools: Bash(gh:*), Bash(grep:*), Read
---

Issues à analyser : $ARGUMENTS

Pour chacune : lis-la (`gh issue view <n>`), puis devine les fichiers impactés.
Repères : formulaires = `lib/presentation/widgets/dynamic_form_builder.dart`,
`generic_form_page.dart`, `*_form_wrapper.dart`, `lib/core/helpers/` (parser de
config, interpréteur JS) ; envois = `lib/data/repository/upstream_sync_repository_impl.dart`,
`sync_service.dart` ; modèles = `lib/domain/model/` (Freezed, build_runner).

Rends UNIQUEMENT un plan (ne corrige rien) :
- Lots « mêmes fichiers » → /fix-lot, en SÉQUENTIEL dans une même session ;
- Issues indépendantes → /fix-issue, parallélisables en worktrees ;
- Issues à isoler (bac C probable, needs: discussion) → à ne pas automatiser ;
- pour chaque lot : e2e émulateur à prévoir en fin de lot (oui/non, quel scénario).

Format : tableau lot / issues / fichiers estimés / séquentiel-ou-parallèle / e2e.
