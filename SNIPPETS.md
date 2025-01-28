# Snippets (VS Code)

Nous avons introduit de nouveaux **snippets** pour faciliter la création rapide de code Flutter/Dart.  
Leur utilisation est facultative, c'est pour cela que le fichier `.vscode/dart.code-snippets` est mis dans le gitignore.

## Snippets

Plusieurs snippets sont disponibles. Vous pouvez copier/coller le code suivant dans votre fichier `.vscode/dart.code-snippets`.
Pour cela ouvrez la palette de commande (Ctrl+Shift+P / Cmd+Shift+P) et sélectionnez “Snippets: Configure Snippets”, puis cliquez sur “New Snippets file for ”. Cela vous permet de créer un fichier avec l’extension .code-snippets dans le dossier .vscode/ de votre projet.

```json
{
  "Create a Use Case Interface": {
    "prefix": "uci",
    "body": [
      "abstract class ${1:UseCaseName}UseCase {",
      "  Future<void> execute(); // or your return type and parameters",
      "}"
    ],
    "description": "Scaffold a new Use Case Interface"
  },
  "Create a Use Case Implementation": {
    "prefix": "uci_impl",
    "body": [
      "import '${1:use_case_name_snake_case}_usecase.dart';",
      "",
      "class ${2:UseCaseName}UseCaseImpl implements ${2:UseCaseName}UseCase {",
      "  // TODO: Inject repository or other dependencies",
      "  ${2:UseCaseName}UseCaseImpl();",
      "",
      "  @override",
      "  Future<void> execute() async {",
      "    // TODO: implement the use case logic",
      "  }",
      "}"
    ],
    "description": "Scaffold a new Use Case Implementation"
  },
  "Create a Model": {
    "prefix": "model_freezed",
    "body": [
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${1:model_name}.freezed.dart';",
      "part '${1:model_name}.g.dart';",
      "",
      "@freezed",
      "class ${2:ModelName} with _$${2:ModelName} {",
      "  const factory ${2:ModelName}({",
      "    required int id,",
      "    required String name,",
      "    // TODO: Add more fields",
      "  }) = _${2:ModelName};",
      "",
      "  factory ${2:ModelName}.fromJson(Map<String, dynamic> json) =>",
      "      _$${2:ModelName}FromJson(json);",
      "}"
    ],
    "description": "Create a new Freezed model class"
  },
  "Create a ViewModel": {
    "prefix": "vm",
    "body": [
      "import 'package:hooks_riverpod/hooks_riverpod.dart';",
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${1:viewmodel_name}_state.freezed.dart';",
      "",
      "@freezed",
      "class ${2:ViewModelName}State with _$${2:ViewModelName}State {",
      "  const factory ${2:ViewModelName}State({",
      "    @Default(false) bool isLoading,",
      "    // TODO: Add more fields",
      "  }) = _${2:ViewModelName}State;",
      "}",
      "",
      "class ${2:ViewModelName} extends StateNotifier<${2:ViewModelName}State> {",
      "  ${2:ViewModelName}() : super(const ${2:ViewModelName}State());",
      "",
      "  // TODO: Inject use cases",
      "",
      "  Future<void> loadSomething() async {",
      "    state = state.copyWith(isLoading: true);",
      "    try {",
      "      // TODO: Implement loading logic",
      "    } finally {",
      "      state = state.copyWith(isLoading: false);",
      "    }",
      "  }",
      "}",
      "",
      "final ${3:viewModelName}Provider =",
      "    StateNotifierProvider<${2:ViewModelName}, ${2:ViewModelName}State>(",
      "  (ref) => ${2:ViewModelName}(),",
      ");"
    ],
    "description": "Create a new ViewModel with Riverpod StateNotifier"
  },
  "Create a Widget": {
    "prefix": "widget",
    "body": [
      "import 'package:flutter/material.dart';",
      "",
      "class ${1:WidgetName} extends StatelessWidget {",
      "  const ${1:WidgetName}({",
      "    Key? key,",
      "    // TODO: Add parameters",
      "  }) : super(key: key);",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return Container(",
      "      // TODO: Implement widget layout",
      "      child: Text('${1:WidgetName}'),",
      "    );",
      "  }",
      "}"
    ],
    "description": "Create a new StatelessWidget"
  },
  "Create a Freezed model": {
    "prefix": "freezedmodel",
    "body": [
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${1:model_name.snakeCase()}.freezed.dart';",
      "part '${1:model_name.snakeCase()}.g.dart';",
      "",
      "@freezed",
      "class ${1:ModelName} with _${1:ModelName} {",
      "  const factory ${1:ModelName}({",
      "    // TODO: add fields here",
      "    required int id,",
      "    required String name,",
      "  }) = _${1:ModelName};",
      "",
      "  factory ${1:ModelName}.fromJson(Map<String, dynamic> json) => _${1:ModelName}FromJson(json);",
      "}",
      ""
    ],
    "description": "Scaffold a new Freezed model class"
  }
}
```

## Comment ça fonctionne

1. Ouvrez un fichier `.dart`.
2. Tapez le préfixe du snippet (ex: `model_freezed`) et appuyez sur **Tab** ou **Entrée** pour insérer le code.
3. Remplacez les placeholders (ex: nom du fichier, nom de la classe) si nécessaire.

## Avantages

- **Gain de temps** : plus besoin de ressaisir le squelette d’une classe ou d’un widget à chaque fois.
- **Cohérence** : tous les modèles respectent le même style et les mêmes conventions de code.
- **Évolutivité** : vous pouvez ajouter ou personnaliser vos propres snippets selon vos besoins.

---
