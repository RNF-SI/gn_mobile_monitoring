# Compatibilité des formats CRUVED

## Problème identifié

L'API GeoNature retourne les permissions CRUVED dans deux formats différents selon l'endpoint :

### Format booléen (endpoints spécifiques)
- **Endpoint**: `/monitorings/object/{module_code}/site/{id}`
- **Format**: `{"C": true, "R": false, "U": true, ...}`
- **Usage**: Permissions pour un objet spécifique (site, visite, etc.)

### Format numérique (endpoints globaux)
- **Endpoints**: `/monitorings/modules`, `/monitorings/object/{module_code}/module`
- **Format**: `{"C": 0, "R": 3, "U": 1, ...}`
- **Usage**: Permissions avec scope au niveau module/configuration globale

Les valeurs numériques correspondent aux scopes de permissions :
- `0` = Aucun accès (`scopeNone`)
- `1` = Mes données (`scopeMyData`)
- `2` = Mon organisme (`scopeMyOrganisme`)
- `3` = Toutes les données (`scopeAllData`)

## Solution implémentée

### 1. Convertisseur personnalisé `CruvedJsonConverter`

Créé dans `/lib/domain/model/cruved_response.dart` :

```dart
class CruvedJsonConverter implements JsonConverter<bool, Object> {
  const CruvedJsonConverter();

  @override
  bool fromJson(Object json) {
    if (json is bool) {
      return json;  // Format booléen direct
    }
    if (json is int) {
      return json > 0;  // Format numérique : >0 = accès, 0 = pas d'accès
    }
    if (json is String) {
      return json.toLowerCase() == 'true';  // Format string robuste
    }
    return false; // Par défaut
  }

  @override
  Object toJson(bool object) => object;
}
```

### 2. Intégration dans `CruvedResponse`

Le modèle `CruvedResponse` utilise maintenant ce convertisseur :

```dart
@freezed
class CruvedResponse with _$CruvedResponse {
  const factory CruvedResponse({
    @JsonKey(name: 'C') @CruvedJsonConverter() @Default(false) bool create,
    @JsonKey(name: 'R') @CruvedJsonConverter() @Default(false) bool read,
    // ...
  }) = _CruvedResponse;
}
```

### 3. Méthodes utilitaires supplémentaires

#### Factory `fromScope`
```dart
factory CruvedResponse.fromScope(Map<String, dynamic> scopeData) {
  return CruvedResponse(
    create: (scopeData['C'] as int? ?? 0) > 0,
    read: (scopeData['R'] as int? ?? 0) > 0,
    // ...
  );
}
```

#### Extension `toScopeMap`
```dart
extension CruvedResponseExtension on CruvedResponse {
  Map<String, int> toScopeMap() {
    return {
      'C': create ? 3 : 0,
      'R': read ? 3 : 0,
      // ...
    };
  }
}
```

## Usage

### Parsing automatique
```dart
// Fonctionne avec les deux formats
final cruvedBoolean = CruvedResponse.fromJson({"C": true, "R": false});
final cruvedNumeric = CruvedResponse.fromJson({"C": 0, "R": 3});

// Résultat identique pour l'utilisation
if (cruved.create) {
  // L'utilisateur peut créer
}
```

### Factory explicite pour format numérique
```dart
final scopeData = {"C": 0, "R": 3, "U": 1};
final cruved = CruvedResponse.fromScope(scopeData);
```

### Conversion vers format numérique
```dart
final cruved = CruvedResponse(create: true, read: false);
final scopeMap = cruved.toScopeMap(); // {"C": 3, "R": 0, ...}
```

## Tests

Fichier complet de tests : `/test/domain/model/cruved_response_format_test.dart`

### Couverture des cas de test :
- ✅ Format booléen pur
- ✅ Format numérique pur
- ✅ Différents niveaux de scope (0, 1, 2, 3)
- ✅ Format mixte (booléen + numérique)
- ✅ Format string (robustesse)
- ✅ Valeurs manquantes avec defaults
- ✅ Intégration avec les responses d'API réelles

### Exemple de test
```dart
test('should parse numeric scope format from module API', () {
  const jsonString = '''
  {
    "C": 0,
    "D": 0,
    "E": 3,
    "R": 3,
    "U": 3,
    "V": 0
  }
  ''';

  final Map<String, dynamic> json = jsonDecode(jsonString);
  final cruved = CruvedResponse.fromJson(json);

  expect(cruved.create, false);     // 0 = pas d'accès
  expect(cruved.export, true);      // 3 = accès complet
  expect(cruved.read, true);        // 3 = accès complet
});
```

## Compatibilité

### Rétrocompatibilité
- ✅ 100% compatible avec le code existant
- ✅ Tous les tests existants continuent de passer
- ✅ Aucun changement requis dans le code utilisant `CruvedResponse`

### Robustesse
- ✅ Gère gracieusement les formats mixtes
- ✅ Résistant aux erreurs de format API
- ✅ Valeurs par défaut appropriées

## Exemples visuels

Voir `/lib/presentation/view/example_cruved_format_compatibility.dart` pour une démonstration interactive des différents formats.

## Impacts sur l'architecture

### Avant (problématique)
```
API Endpoint A -> Format booléen -> ✅ CruvedResponse.fromJson()
API Endpoint B -> Format numérique -> ❌ Échec du parsing
```

### Après (solution)
```
API Endpoint A -> Format booléen -> ✅ CruvedResponse.fromJson() -> CruvedJsonConverter
API Endpoint B -> Format numérique -> ✅ CruvedResponse.fromJson() -> CruvedJsonConverter
API Endpoint C -> Format mixte -> ✅ CruvedResponse.fromJson() -> CruvedJsonConverter
```

## Recommandations d'usage

1. **Usage normal** : Continuer à utiliser `CruvedResponse.fromJson()` - la conversion est automatique
2. **Format numérique explicite** : Utiliser `CruvedResponse.fromScope()` si vous savez que les données sont au format numérique
3. **Conversion** : Utiliser `cruved.toScopeMap()` si vous devez renvoyer des valeurs numériques à l'API

Cette solution garantit une compatibilité totale avec les deux formats d'API tout en maintenant la simplicité d'usage pour les développeurs.