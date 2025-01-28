# Changements concernant les Fichiers de Prompts (.cursor-prompts)

Afin d’optimiser davantage notre flux de travail avec **Cursor**, nous avons ajouté des fichiers
dans le dossier **`prompts/`**. Chacun contient un “prompt” détaillant comment générer
des classes ou des fonctions spécifiques.
Ces fichiers sont mis dans le gitignore. Les codes sont à copier dans les différents fichiers prompts.

## Nouveaux Fichiers de Prompts

1. **create_model.prompt**

   - Explique à Cursor comment créer un modèle `@freezed` avec un certain nombre de champs.
   - Peut inclure la logique pour générer un fichier .dart dans `domain/model/` ou ailleurs.

# create_model.prompt

You are an expert in Flutter, Dart, and Clean Architecture.

Create a new domain model in the `domain/model/` directory. The model must:

- Use the `freezed` package for immutability.
- Annotate with `@freezed`.
- Include JSON serialization if needed (`with JsonSerializable`).
- Generate a `fromJson` factory constructor if required.

**Template**:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{model_name.snakeCase()}}.freezed.dart';
part '{{model_name.snakeCase()}}.g.dart';

@freezed
class {{model_name.pascalCase()}} with _${{model_name.pascalCase()}} {
  const factory {{model_name.pascalCase()}}({
    // TODO: Add fields
    required int id,
    required String name,
    // ...
  }) = _{{model_name.pascalCase()}};

  factory {{model_name.pascalCase()}}.fromJson(Map<String, dynamic> json) =>
      _${{model_name.pascalCase()}}FromJson(json);
}
```

2. **create_widget.prompt**

   - Génère un nouveau widget (StatelessWidget ou StatefulWidget) en fonction de l’utilisateur.
   - Propose un template de base pour une vue Flutter.

---

## 2. `create_widget.prompt`

**File Name**: `create_widget.prompt`

**Description**: Generates a new widget with a recommended structure.

````md
# create_widget.prompt

You are an expert in Flutter, Dart, and Clean Architecture.

Create a new widget in the `presentation/view/` folder. The widget must:

- Be a stateless or stateful widget (depending on a placeholder).
- Include a constructor with named parameters.
- If the widget has parameters, mark them as `final` in the class.
- Use `const` constructors where possible.

**Template**:

```dart
import 'package:flutter/material.dart';

class {{widget_name.pascalCase()}} extends {{widget_type | default("StatelessWidget")}} {
  const {{widget_name.pascalCase()}}({
    Key? key,
    // TODO: Add parameters here if needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Implement the widget layout
      child: Text('{{widget_name.pascalCase()}}'),
    );
  }
}
```
````

## Utilisation

1. Dans **Cursor**, appuyez sur **Ctrl + I** (Composer) ou allez dans l’interface de prompts.
2. Sélectionnez le prompt désiré (ex: “create_model.prompt”).
3. Répondez aux questions (ex: nom du modèle, champs à inclure).
4. Cursor génère automatiquement le code dans la bonne structure de dossiers (selon vos indications).

## Avantages

- **Moins de répétitions** : plus besoin de copier-coller un vieux modèle ou un widget existant.
- **Qualité** : Cursor utilise également `.cursorrules`, donc le code généré est aligné avec nos conventions.
- **Évolution facile** : on peut créer ou modifier d’autres prompts pour générer par exemple des tests,
  des data sources, etc.

---
