# Suivi des tâches GN Mobile Monitoring (Flutter)

## Liste des tâches

### 1. Insérer les nomenclatures dans l'application

- **Description** : Charger et gérer les nomenclatures via SQLite et Riverpod.
- **Prompt Claude** : "Créer et tester les entités SQLite et Riverpod pour gérer les nomenclatures."
- **Plan de test** : Vérifier insertion, mise à jour, et récupération des nomenclatures.
- **Statut** : À faire

### 2. Ajouter lien Geonature à la connexion

- **Description** : Permettre à l'utilisateur de spécifier l'URL Geonature lors de la connexion, avec option QR code.
- **Prompt Claude** : "Créer un champ URL configurable et optionnellement un générateur de QR Code pour Flutter."
- **Plan de test** : Vérifier stockage URL, génération QR code, lecture QR code.
- **Statut** : À faire

### 3. Développer fonctions de resynchronisation

- **Description** : Resynchroniser manuellement ou automatiquement les objets (sites, taxons, nomenclatures).
- **Prompt Claude** : "Créer et tester les fonctions de resynchronisation périodique et manuelle pour chaque objet."
- **Plan de test** : Vérifier synchronisation initiale, manuelle, périodique (tous les 7 jours).
- **Statut** : À faire

### 4. Synchroniser les saisies au clic bouton

- **Description** : Envoyer les données (visite, observation, observations_details) puis les supprimer du mobile.
- **Prompt Claude** : "Créer et tester l’envoi et suppression locale des données sur clic bouton."
- **Plan de test** : Vérifier envoi correct des données et suppression locale après envoi réussi.
- **Statut** : À faire

### 5. Menu configuration présentation

- **Description** : Menu permettant à l'utilisateur de personnaliser l'affichage dans l'application.
- **Prompt Claude** : "Créer un menu de configuration permettant de personnaliser l'affichage des données."
- **Plan de test** : Vérifier modification et persistance des préférences utilisateur.
- **Statut** : À faire

### 6. Tester performance avec grandes données

- **Description** : Tester et optimiser les performances de l'application avec beaucoup de données.
- **Prompt Claude** : "Créer des tests automatisés évaluant les performances avec une grande quantité de données et proposer des optimisations."
- **Plan de test** : Vérifier temps de chargement, fluidité, gestion mémoire.
- **Statut** : À faire

### 7. Ajouter une carte des sites

- **Description** : Afficher les sites sur une carte interactive.
- **Prompt Claude** : "Créer une carte interactive avec Flutter montrant les sites depuis SQLite/Riverpod."
- **Plan de test** : Vérifier affichage correct des sites, zoom, interaction utilisateur.
- **Statut** : À faire

### 8. Afficher sites selon proximité géographique

- **Description** : Trier et afficher les sites selon leur distance de l'utilisateur.
- **Prompt Claude** : "Créer et tester une fonction de tri géographique des sites en Flutter."
- **Plan de test** : Vérifier calcul distance et tri correct.
- **Statut** : À faire

### 9. Créer APK disponible pour les Écrins

- **Description** : Générer une APK et la rendre disponible spécifiquement pour le Parc des Écrins.
- **Prompt Claude** : "Créer un build APK optimisé pour distribution spécifique (Écrins)."
- **Plan de test** : Vérifier génération APK, tests d'installation.
- **Statut** : À faire

### 10. Tester l'application avec instance Geonature

- **Description** : Tests fonctionnels en conditions réelles avec diverses instances Geonature.
- **Prompt Claude** : "Créer des tests d'intégration utilisant différentes instances réelles de Geonature."
- **Plan de test** : Vérifier compatibilité, synchronisation, stabilité.
- **Statut** : À faire

Ajouter logo LIFE

Gérer les nomenclatures et voir si solutionne les infos non affichées

Version On Changed

Tunnel pb:

- mauvais chargement observation detail (voir si tout apparait)
- Factorisation du code.
- Test à faire passer
