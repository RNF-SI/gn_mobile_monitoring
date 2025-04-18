/// Helper pour convertir des expressions TypeScript en Dart
class TsToDartConverter {
  /// Convertit une fonction TypeScript en fonction Dart
  ///
  /// Exemple:
  /// - TS: `({value}) => value.test_detectabilite`
  /// - Dart: `(value) => value['test_detectabilite'] as bool`
  static String convertToDart(String tsExpression) {
    // Extraire les paramètres et le corps de la fonction
    final RegExp arrowFnPattern = RegExp(r'^\(\{(.+)\}\)\s*=>\s*(.+)$');
    final Match? match = arrowFnPattern.firstMatch(tsExpression);

    if (match == null) {
      throw FormatException(
          'Format de fonction TypeScript non reconnu: $tsExpression');
    }

    final String paramName = match.group(1)!.trim();
    final String body = match.group(2)!.trim();

    // Convertir le corps de l'expression
    final String dartBody = _convertExpressionToDart(body);

    return '($paramName) => $dartBody';
  }

  /// Convertit une expression TS en Dart en appliquant des transformations
  static String _convertExpressionToDart(String expr) {
    // Transformer les accès aux propriétés d'objet (obj.prop -> obj['prop'])
    expr = _convertPropertyAccess(expr);

    // Transformer Object.keys(obj).length en (obj as Map).keys.length
    expr = _convertObjectKeys(expr);

    // Ajouter les conversions de type appropriées (as bool, as int, etc.)
    expr = _addTypeConversions(expr);

    return expr;
  }

  /// Convertit les accès aux propriétés d'objet dans le style TypeScript
  /// obj.prop -> obj['prop']
  static String _convertPropertyAccess(String expr) {
    // Regexp pour trouver les accès aux propriétés: identifier.property
    final propertyAccessRegex = RegExp(r'(\w+)\.(\w+)');

    return expr.replaceAllMapped(propertyAccessRegex, (match) {
      final String object = match.group(1)!;
      final String property = match.group(2)!;

      // Ne pas transformer certains cas spéciaux comme Object.keys
      if (object == 'Object') {
        return '${match.group(0)}';
      }

      return "$object['$property']";
    });
  }

  /// Convertit Object.keys(obj).length en (obj as Map).keys.length
  static String _convertObjectKeys(String expr) {
    final objectKeysRegex = RegExp(r'Object\.keys\((\w+)\)\.length');

    return expr.replaceAllMapped(objectKeysRegex, (match) {
      final String obj = match.group(1)!;
      return "($obj as Map).keys.length";
    });
  }

  /// Ajoute les conversions de type appropriées à l'expression
  static String _addTypeConversions(String expr) {
    // Pour les expressions qui semblent être des booléens, ajouter "as bool"
    if (_isBooleanExpression(expr)) {
      if (!expr.contains(" as ")) {
        // Éviter d'ajouter si déjà présent
        return "$expr as bool";
      }
    }

    return expr;
  }

  /// Détermine si une expression semble être une expression booléenne
  static bool _isBooleanExpression(String expr) {
    // Recherche des comparaisons, négations ou valeurs booléennes littérales
    final patterns = [
      '==', '!=', '>=', '<=', '>', '<', // Comparaisons
      '!', // Négations
      '&&', '||', // Opérateurs logiques
      'true', 'false' // Littéraux booléens
    ];

    // Si l'expression accède à une propriété sans autre opérateur
    if (RegExp(r'\w+\[.*?\]').hasMatch(expr)) {
      return true;
    }

    return patterns.any((pattern) => expr.contains(pattern));
  }
}

/// Analyse récursivement un objet JSON pour trouver tous les champs hidden
Map<String, String> extractHiddenFunctions(Map<String, dynamic> config) {
  Map<String, String> hiddenFunctions = {};

  // Parcourir récursivement tous les objets du JSON
  void processObject(String prefix, Map<String, dynamic> obj) {
    for (final entry in obj.entries) {
      final key = entry.key;
      final value = entry.value;

      // Si la clé est 'hidden' et la valeur est une chaîne commençant par ({
      if (key == 'hidden' && value is String && value.startsWith('({')) {
        try {
          // Extraire l'ID du champ à partir du préfixe
          final String fieldId = prefix.isEmpty ? '' : prefix;
          if (fieldId.isNotEmpty) {
            final String dartFunction = TsToDartConverter.convertToDart(value);
            hiddenFunctions[fieldId] = dartFunction;
          }
        } catch (e) {
          // Erreur lors de la conversion de la fonction hidden
        }
      }

      // Traiter récursivement les objets imbriqués
      if (value is Map<String, dynamic>) {
        String newPrefix = prefix.isEmpty ? key : '$prefix.$key';
        processObject(newPrefix, value);
      } else if (value is List) {
        // Traiter les éléments de la liste s'ils sont des objets
        for (var i = 0; i < value.length; i++) {
          if (value[i] is Map<String, dynamic>) {
            String newPrefix = '$prefix.$key[$i]';
            processObject(newPrefix, value[i] as Map<String, dynamic>);
          }
        }
      }
    }
  }

  // Traiter les sections spécifiques du JSON qui contiennent des configurations de champs
  void processConfigSection(String objectType) {
    if (config.containsKey(objectType)) {
      final objSection = config[objectType];

      // Traiter les champs génériques
      if (objSection is Map<String, dynamic> &&
          objSection.containsKey('generic') &&
          objSection['generic'] is Map<String, dynamic>) {
        final generic = objSection['generic'] as Map<String, dynamic>;
        for (final fieldEntry in generic.entries) {
          final fieldId = fieldEntry.key;
          final fieldConfig = fieldEntry.value;

          if (fieldConfig is Map<String, dynamic>) {
            if (fieldConfig.containsKey('hidden') &&
                fieldConfig['hidden'] is String &&
                fieldConfig['hidden'].toString().startsWith('({')) {
              try {
                final String dartFunction = TsToDartConverter.convertToDart(
                    fieldConfig['hidden'].toString());
                hiddenFunctions[fieldId] = dartFunction;
              } catch (e) {
                // Erreur lors de la conversion de la fonction hidden
              }
            }
          }
        }
      }

      // Traiter les champs spécifiques
      if (objSection is Map<String, dynamic> &&
          objSection.containsKey('specific') &&
          objSection['specific'] is Map<String, dynamic>) {
        final specific = objSection['specific'] as Map<String, dynamic>;
        for (final fieldEntry in specific.entries) {
          final fieldId = fieldEntry.key;
          final fieldConfig = fieldEntry.value;

          if (fieldConfig is Map<String, dynamic>) {
            if (fieldConfig.containsKey('hidden') &&
                fieldConfig['hidden'] is String &&
                fieldConfig['hidden'].toString().startsWith('({')) {
              try {
                final String dartFunction = TsToDartConverter.convertToDart(
                    fieldConfig['hidden'].toString());
                hiddenFunctions[fieldId] = dartFunction;
              } catch (e) {
                // Erreur lors de la conversion de la fonction hidden
              }
            }
          }
        }
      }
    }
  }

  // Traiter les sections principales du JSON
  final objectTypes = [
    'module',
    'site',
    'sites_group',
    'visit',
    'observation',
    'observation_detail'
  ];
  for (final objectType in objectTypes) {
    processConfigSection(objectType);
  }

  // Parcourir également le reste du JSON de façon récursive
  processObject('', config);

  return hiddenFunctions;
}

/// Génère le contenu du fichier field_hidden.dart avec les fonctions extraites
String generateHiddenFunctionsFile(Map<String, String> functions) {
  final buffer = StringBuffer();

  // Écrire l'en-tête du fichier
  buffer.writeln(
      '/// FICHIER GÉNÉRÉ AUTOMATIQUEMENT - NE PAS MODIFIER MANUELLEMENT');
  buffer.writeln('/// Généré le ${DateTime.now()}');
  buffer.writeln();
  buffer.writeln(
      '/// Type définissant une fonction pour évaluer si un champ doit être masqué');
  buffer.writeln(
      'typedef HiddenFn = bool Function(Map<String, dynamic> context);');
  buffer.writeln();
  buffer
      .writeln('/// Map contenant les fonctions de masquage pour chaque champ');
  buffer.writeln(
      '/// Les clés sont les identifiants des champs et les valeurs sont des fonctions');
  buffer.writeln(
      '/// qui prennent en paramètre un contexte et retournent un booléen');
  buffer.writeln('final Map<String, HiddenFn> hiddenFunctions = {');

  // Écrire chaque fonction
  for (final entry in functions.entries) {
    buffer.writeln("  '${entry.key}': ${entry.value},");
  }

  // Fermer la map
  buffer.writeln('};');

  return buffer.toString();
}