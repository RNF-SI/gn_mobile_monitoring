---
description: Traite une issue GitHub de bout en bout (classe, corrige, teste, commente)
argument-hint: <numéro d'issue>
allowed-tools: Bash(gh:*), Bash(git:*), Bash(flutter test:*), Bash(flutter analyze:*), Bash(dart run build_runner:*), Bash(scripts/run_device_test.sh:*), Bash(grep:*), Edit, Read, Write, AskUserQuestion
---

Issue à traiter : #$ARGUMENTS

Contexte préchargé :
!`gh issue view $ARGUMENTS --json title,body,labels,comments,createdAt`

Procédure :

0. VÉRIFIE D'ABORD QUE CE N'EST PAS DÉJÀ FAIT :
   `git log --all --oneline --grep="#$ARGUMENTS"`, puis les commits postérieurs
   à l'ouverture (`createdAt`) sur les fichiers probablement concernés.
   Déjà fait → AUCUN commit : vérifie le comportement (test existant), puis
   passe à l'étape 7 avec « ↳ Déjà fait — commit <sha> » et ce que tu as vérifié.

1. CLASSE l'issue :
   - A = assertion vérifiable par un test unitaire ou widget (valeur envoyée,
     règle de formulaire, parsing de config, navigation, texte affiché) ;
   - B = visuel / terrain (mise en page sur petit écran, carte, GPS, clavier
     du téléphone) : validation à l'œil sur l'émulateur ;
   - C = ambigu, trop large, décision produit, ou `needs: discussion`.
   S'il y a des commentaires de retour de test, le DERNIER définit le travail
   à faire (l'historique = contexte).

2. POSE-MOI DES QUESTIONS (AskUserQuestion) dès qu'un choix change le résultat :
   deux lectures possibles, écart avec le module web, protocole introuvable,
   bug non reproductible. Cherche d'abord dans le code, l'historique, le module
   web (`~/GeoNature/contrib/gn_module_monitoring`) et les protocoles
   (`~/protocoles_suivi`) ; ne me demande que ce qu'ils ne disent pas.
   - Bac C : ne corrige pas avant mes réponses. Ambiguïté levée → reclasse A/B.
     Sinon → commente tes questions sur l'issue, pose `needs: discussion`, ARRÊTE.

3. Travaille sur `develop` : `git checkout develop && git pull`.
   Ne committe jamais `android/gradle.properties` ni `pubspec.lock` sans raison
   (le migrateur Flutter les modifie tout seul).

4. Plan court (fichiers + approche) si la correction n'est pas triviale.
   Alignement : le module web fait référence pour le comportement des
   formulaires et des envois ; un écart volontaire se documente.

5. Bac A : ÉCRIS LE TEST AVANT LA CORRECTION et lance-le seul
   (`flutter test <fichier_de_test>`) : il doit ÉCHOUER pour la bonne raison.
   S'il passe déjà → le bug est ailleurs, ou déjà corrigé (étape 0).
   Puis corrige. Modèle Freezed/Drift ou mock modifié →
   `dart run build_runner build --delete-conflicting-outputs`, et ne committe
   que les fichiers générés liés à ton changement.

6. TESTS — BUDGET CIBLÉ. Ne lance PAS toute la suite pour une issue :
   - le test de l'étape 5 + les tests du ou des fichiers modifiés ;
   - les autres tests qui utilisent ce que tu as changé :
     `grep -rl "<classe ou fonction>" test integration_test`, lancés en une
     seule commande `flutter test <f1> <f2> …` ;
   - `flutter analyze <fichiers modifiés>` ;
   - e2e sur l'émulateur (`scripts/run_device_test.sh <scénario>`) SEULEMENT si
     la correction touche la navigation, la synchro ou le stockage local et
     qu'aucun test widget ne le couvre. Un seul scénario ciblé, pas la batterie.
   - Bac B : pas de test auto ; décris la validation manuelle dans le
     commentaire (étape 7).
   - DOC : si le comportement décrit change, mets à jour dans le même commit
     `docs/FEATURES_OVERVIEW.md`, `docs/MODULES_COMPATIBILITY.md`,
     `docs/JAVASCRIPT_EXPRESSIONS.md` ou `docs/API_ROUTES.md`. Sinon note
     « doc : RAS » dans le récap.

7. Commit atomique : `fix(<scope>): <résumé> (#$ARGUMENTS)` (ou `feat(...)`),
   tests et doc compris. Puis, OBLIGATOIRE et vérifié :
   a. `gh issue comment $ARGUMENTS --body "..."` : résumé + section
      « À vérifier » (module/protocole à utiliser, étapes sur l'appli) ;
   b. `gh issue edit $ARGUMENTS --add-label "à tester"`.
   Ne FERME JAMAIS l'issue.

8. Récap compact : bac ; fichiers ; test auto (vu en échec : oui/non) ; autres
   tests lancés ; e2e lancé (lequel) ou non ; doc ; questions posées ;
   confirmation que le commentaire est posté.
