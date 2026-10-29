---
description: Reprend un lot d'issues après retour de test KO, chacune depuis son dernier commentaire (un commit par issue)
argument-hint: <numéros d'issues du lot, ex: "228 229">
allowed-tools: Bash(gh:*), Bash(git:*), Bash(flutter test:*), Bash(flutter analyze:*), Bash(dart run build_runner:*), Bash(scripts/run_device_test.sh:*), Bash(grep:*), Edit, Read, Write, AskUserQuestion
---

Lot à reprendre après retour KO : #$ARGUMENTS

Pour CHAQUE issue, c'est le DERNIER commentaire (pas le body) qui définit le
travail. Un commit et une trace par issue.

Contexte préchargé :
!`for n in $ARGUMENTS; do echo "===== #$n ====="; gh issue view $n --json title,labels,comments --jq '"TITRE: \(.title)\nLABELS: \([.labels[].name]|join(", "))\nDERNIER COMMENTAIRE:\n\(.comments[-1].author.login // "—"): \(.comments[-1].body // "(aucun commentaire)")"'; echo; done`

1. Une fois : `git checkout develop && git pull` ; captures des derniers
   commentaires téléchargées et regardées ; fichiers visés lus.
2. Par issue : décompose le dernier commentaire en points (à corriger ici /
   déjà couvert / hors périmètre → nouvelle issue).
3. Ordonne le lot ; sors les retours flous ; regroupe les questions en UN
   appel AskUserQuestion.
4. Pour chaque issue : points annoncés en une ligne → test du cas KO écrit
   d'abord et vu en ÉCHEC → correction → tests CIBLÉS (`flutter test <fichiers>`)
   → doc si besoin → commit `fix(<scope>): <nouveau symptôme> (#<n>)` →
   `gh issue comment` + `--remove-label "à corriger" --add-label "à tester"`,
   vérifiés, AVANT l'issue suivante. Jamais de fermeture. Hors périmètre →
   `gh issue create`, référencée dans le commentaire.
5. Retour trop flou : question d'abord ; sinon demande de précision en
   commentaire, label `à corriger` laissé, issue suivante.
6. FIN DU LOT, une seule fois : `flutter analyze`, `flutter test` complet, et
   un scénario e2e ciblé sur l'émulateur si navigation/synchro/stockage touchés.
7. RÉCAP :
   | Issue | Ce qui était KO | Fichiers | Commit | Test (vu en échec ?) | Doc | Commenté | Hors-périmètre → issue |
   puis passe de fin, questions en suspens, issues créées. ARRÊTE.
