---
description: Trie un lot d'issues pour réduire le backlog (ne corrige rien)
argument-hint: <numéros d'issues OU un label, ex: "domain: pg">
allowed-tools: Bash(gh:*), Bash(git log:*), Read
---

Cible à trier : $ARGUMENTS
(si l'argument ressemble à un label, résous d'abord la liste :
`gh issue list --label "$ARGUMENTS" --state open --json number -q '.[].number'`)

Objectif : RÉDUIRE le backlog. Tu ne modifies AUCUN code.

Pour chaque issue :
1. Lis-la : `gh issue view <n> --comments`.
2. Cherche si elle est DÉJÀ résolue sans être fermée :
   - `git log --oneline --grep "#<n>"` (conventional commits référencent l'issue)
   - `gh pr list --search "<n>" --state all`
   - Si un fichier de revue de session existe dans le repo (`Revue_*.md`,
     `docs/revue*.md`), considère-le comme signal de décision.
3. Compare les issues du lot entre elles pour repérer les DOUBLONS.

Classe chaque issue dans UNE disposition :
- FERMER — déjà résolue (commit/PR existant, ou validée en revue).
- DOUBLON #X — recouvre une autre issue.
- OBSOLÈTE — plus pertinente (fonctionnalité supprimée/refondue).
- À TESTER — implémentée, en attente de validation manuelle → label `à tester`.
- DISCUSSION — ambiguë, feature lourde, arbitrage ou terme à définir
  → label `needs: discussion` (+ liste les questions précises à trancher).
- À CODER — nette, pas encore faite → label `à corriger` (prête pour /fix-issue).

Rends UNIQUEMENT un tableau (mode proposition, AUCUNE action) :
| Issue | Disposition | Justification (1 ligne) | Commande gh proposée |

Puis ARRÊTE et demande validation. Ne ferme, ne commente, ne ré-étiquette
RIEN tant que je n'ai pas écrit « applique » (en bloc, ou en listant les
numéros à appliquer). Les fermetures comme DOUBLON/OBSOLÈTE exigent toujours
ma confirmation explicite, jamais en automatique.
