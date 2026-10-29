---
description: Reprend une issue après un retour de test KO, en partant du dernier commentaire
argument-hint: <numéro d'issue>
allowed-tools: Bash(gh:*), Bash(git:*), Bash(flutter test:*), Bash(flutter analyze:*), Bash(dart run build_runner:*), Bash(scripts/run_device_test.sh:*), Bash(grep:*), Edit, Read, Write, AskUserQuestion
---

Issue à reprendre : #$ARGUMENTS

Contexte :
!`gh issue view $ARGUMENTS --json title,body,labels,comments`

1. Le DERNIER commentaire de retour est ta LISTE DE TRAVAIL. Décompose-le en
   points distincts et liste-les. Pour chacun : à corriger ici / déjà couvert /
   hors périmètre (→ nouvelle issue, pas noyée ici). Les « ↳ Fait » disent ce
   qui a déjà été tenté.
   Les captures du commentaire : télécharge-les et regarde-les.
2. Retour flou ou non reproductible → AskUserQuestion d'abord. Doute levé →
   continue ; sinon commente une demande de précision et ARRÊTE.
3. `git checkout develop && git pull`.
4. Test qui couvre CE cas précis, écrit d'abord, lancé seul, vu en ÉCHEC.
   Puis corrige.
5. Tests ciblés (test de l'étape 4 + fichiers touchés + utilisateurs du code
   modifié, en une commande `flutter test …`), `flutter analyze <fichiers>`.
   E2E émulateur seulement si le retour vient du terrain sur un parcours
   (navigation, synchro) qu'aucun test widget ne reproduit : un scénario ciblé.
   Doc `docs/*.md` si le comportement décrit change.
6. Commit atomique `fix(<scope>): <nouveau symptôme> (#$ARGUMENTS)`.
7. `gh issue comment` (ce qui était KO, ce qui change, « À vérifier ») puis
   `gh issue edit $ARGUMENTS --remove-label "à corriger" --add-label "à tester"`.
   Vérifie les deux. Ne ferme pas. Hors périmètre → propose une issue dédiée.
8. Récap : KO, correction, test (vu en échec ?), tests lancés, e2e, doc,
   questions, commentaire posté.
