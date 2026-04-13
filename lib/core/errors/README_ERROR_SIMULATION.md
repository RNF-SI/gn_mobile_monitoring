# 🧪 Simulateur d'erreurs de synchronisation

Ce simulateur permet de tester facilement la robustesse de votre système de synchronisation ascendante en provoquant différents types d'erreurs.

## 🚀 Utilisation rapide

### 1. Activation du simulateur

Ouvrez le fichier `sync_error_simulator.dart` et modifiez ces constantes :

```dart
// 🔧 CONFIGURATION DES TESTS
static const bool _enableErrorSimulation = true; // ⚠️ Activer pour les tests
static const ErrorType _currentErrorType = ErrorType.missingCdNom; // Type d'erreur
static const int _errorProbability = 100; // Probabilité (0-100%)
```

### 2. Types d'erreurs disponibles

#### 📋 Erreurs de validation
- `ErrorType.missingCdNom` - Espèce manquante (champ requis)
- `ErrorType.invalidDataTypes` - Types incorrects (string au lieu d'int)
- `ErrorType.malformedJson` - JSON invalide

#### 🔐 Erreurs de permissions
- `ErrorType.permissionDenied` - Permissions insuffisantes (403)

#### 💾 Erreurs de base de données  
- `ErrorType.invalidVisitId` - ID de visite inexistant (99999)
- `ErrorType.duplicateUuid` - UUID déjà existant (409)

#### 🌐 Erreurs réseau/serveur
- `ErrorType.serverTimeout` - Timeout du serveur
- `ErrorType.moduleInactive` - Module inexistant/inactif

### 3. Scénarios de test recommandés

#### Test 1: Champ requis manquant
```dart
static const ErrorType _currentErrorType = ErrorType.missingCdNom;
static const int _errorProbability = 100;
```
**Résultat attendu :** La visite est créée sur le serveur avec `serverVisitId`, mais reste en local. L'observation échoue avec une erreur de validation.

#### Test 2: ID de visite inexistant
```dart
static const ErrorType _currentErrorType = ErrorType.invalidVisitId;
static const int _errorProbability = 100;
```
**Résultat attendu :** L'observation échoue avec une erreur de clé étrangère. La visite est conservée localement pour retry.

#### Test 3: Permissions insuffisantes
```dart
static const ErrorType _currentErrorType = ErrorType.permissionDenied;
static const int _errorProbability = 100;
```
**Résultat attendu :** Erreur 403, l'utilisateur voit un message d'erreur explicite.

#### Test 4: Erreur intermittente
```dart
static const ErrorType _currentErrorType = ErrorType.serverTimeout;
static const int _errorProbability = 30; // 30% de chance d'erreur
```
**Résultat attendu :** Certaines observations passent, d'autres échouent aléatoirement.

## 🔍 Vérification du comportement

### Ce qui doit se passer lors d'une erreur :

1. **✅ Visite créée sur serveur** - `serverVisitId` est enregistré
2. **❌ Observation échoue** - Message d'erreur détaillé
3. **💾 Visite reste en local** - Disponible pour resynchronisation
4. **🔄 Retry possible** - Via synchronisation manuelle dans le module
5. **📱 Interface utilisateur** - Erreur visible dans `SyncStatusWidget`

### Logs à surveiller :

```
[TEST] Simulation d'erreurs activée: Champ cd_nom manquant (espèce obligatoire)
[TEST] Données d'observation corrompues pour simulation
[SYNC_REPO] Visite créée avec succès, ID serveur: 123
[SYNC_REPO] Visite 456 créée sur le serveur (ID: 123) mais observations échouées
```

## ⚠️ Important

- **Toujours désactiver** en production : `_enableErrorSimulation = false`
- **Tester tous les scénarios** pour valider la robustesse
- **Vérifier les logs** pour comprendre le comportement
- **Utiliser différentes probabilités** pour tester les cas intermittents

## 🛠️ Personnalisation

Vous pouvez ajouter de nouveaux types d'erreurs en modifiant l'enum `ErrorType` et en ajoutant les cas correspondants dans les méthodes `corruptObservationData`, `corruptRequestBody` et `throwSimulatedError`.

## 📝 Exemple de session de test

1. Créer une visite avec des observations
2. Activer `ErrorType.missingCdNom` avec probabilité 100%
3. Synchroniser vers le serveur
4. Vérifier que la visite a un `serverVisitId` mais reste en local
5. Vérifier l'affichage de l'erreur dans l'interface
6. Désactiver la simulation (`ErrorType.none`)
7. Resynchroniser → doit réussir avec PATCH au lieu de POST