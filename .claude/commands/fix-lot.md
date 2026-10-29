---
description: Traite un lot d'issues « mêmes fichiers » en séquentiel (un commit par issue, tests complets une seule fois à la fin)
argument-hint: <numéros d'issues du lot, ex: "228 229 233">
allowed-tools: Bash(gh:*), Bash(git:*), Bash(flutter test:*), Bash(flutter analyze:*), Bash(dart run build_runner:*), Bash(scripts/run_device_test.sh:*), Bash(grep:*), Edit, Read, Write, AskUserQuestion
---

Lot à traiter : #$ARGUMENTS

Issues regroupées parce qu'elles touchent les MÊMES fichiers : traitement
séquentiel dans une session, un commit et une trace par issue.

Contexte préchargé :
!`for n in $ARGUMENTS; do echo "===== #$n ====="; gh issue view $n --json title,body,labels,comments,createdAt --jq '"TITRE: \(.title)\nOUVERTE LE: \(.createdAt)\nLABELS: \([.labels[].name]|join(", "))\nBODY:\n\(.body)\nCOMMENTAIRES: \(.comments|length)"'; echo; done`

1. PRÉPARE la session une fois : `git checkout develop && git pull` ; lis les
   fichiers communs du lot ; pour chaque issue, vérifie qu'elle n'est pas déjà
   faite (`git log --all --oneline --grep="#<n>"`). Déjà faite → aucun commit,
   commentaire « ↳ Déjà fait — commit <sha> » + label `à tester`.

2. CLASSE chaque issue (A / B / C, comme /fix-issue) ; le DERNIER commentaire de
   retour de test, s'il existe, définit le travail.

3. ORDONNE le lot pour que les corrections ne se marchent pas dessus ; signale
   les dépendances ; sors les bac C du flux. Regroupe tes questions en UN appel
   AskUserQuestion (cherche d'abord dans le code, le module web
   `~/GeoNature/contrib/gn_module_monitoring` et `~/protocoles_suivi`).

4. Pour CHAQUE issue A/B, en boucle :
   a. Plan en une ligne si non trivial.
   b. Bac A : test écrit AVANT la correction, lancé seul, vu en ÉCHEC.
   c. Correction (build_runner si modèle Freezed/Drift modifié ; ne committe
      jamais `android/gradle.properties` / `pubspec.lock` par accident).
   d. Tests CIBLÉS seulement : le test de b + les tests des fichiers touchés +
      ceux qui utilisent le code modifié (`grep -rl … test`), en une commande
      `flutter test <fichiers>`. PAS de suite complète, PAS d'e2e à ce stade.
   e. Doc (`docs/*.md`) dans le commit si le comportement décrit change.
   f. Commit atomique `fix(<scope>): <résumé> (#<n>)` — jamais deux issues dans
      un commit.
   g. OBLIGATOIRE avant l'issue suivante : `gh issue comment <n>` (résumé +
      « À vérifier ») et `gh issue edit <n> --add-label "à tester"`, vérifiés.
   h. Ne ferme jamais l'issue.

5. Bac C : questions d'abord ; si l'ambiguïté persiste → commentaire +
   `needs: discussion`, puis issue suivante.

6. FIN DU LOT — la seule passe lourde :
   - `flutter analyze` ;
   - `flutter test` (suite complète, une fois) ;
   - si une issue du lot touche navigation, synchro ou stockage : UN scénario
     e2e ciblé sur l'émulateur (`scripts/run_device_test.sh <scénario>`).
   Un échec → corrige dans le commit de l'issue responsable (fixup) ou un commit
   dédié qui cite l'issue.

7. RÉCAP en tableau :
   | Issue | Bac | Fichiers | Commit | Test (vu en échec ?) | Doc | Commenté | Statut |
   puis le résultat de la passe de fin (analyze, suite, e2e), les validations
   manuelles (bac B) et les questions en suspens. ARRÊTE.
