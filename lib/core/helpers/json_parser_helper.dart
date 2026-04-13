import 'dart:convert';

/// Classe utilitaire pour le parsing JSON robuste
/// Permet de gérer les formats JSON malformés ou non-standards
class JsonParserHelper {
  /// Analyse une chaîne JSON potentiellement malformée et renvoie une Map
  /// Gère plusieurs cas spéciaux dont :
  /// - Format Python-style avec 'key: value' au lieu de "key": value
  /// - Booléens avec espaces comme ': true' au lieu de ':true'
  /// - Dictionnaires de style Python comme {no_data: false, guano_presency: false}
  static Map<String, dynamic>? parseRobust(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    
    final trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return null;
    }
    
    // Cas spécial: dictionnaire Python exact comme dans l'erreur signalée
    if (trimmed.contains('no_data:') || trimmed.contains('guano_presency:')) {
      // Format Python-like connu, traiter directement
      return _parsePythonDict(trimmed);
    }
    
    // Tenter le parsing JSON standard
    try {
      final result = jsonDecode(trimmed) as Map<String, dynamic>;
      // Vérifier et convertir les valeurs qui sont des strings mais qui devraient être des arrays
      _deepConvertArrayStrings(result);
      return result;
    } catch (e) {
      
      try {
        // 1. Correction pour les booléens avec espaces
        String fixedJson = trimmed
            .replaceAll(': false', ':false')
            .replaceAll(': true', ':true');
            
        // 2. Remplacer les apostrophes par des guillemets
        fixedJson = fixedJson.replaceAll("'", '"');
        
        // 3. Ajouter des guillemets autour des clés non-quotées
        fixedJson = fixedJson.replaceAllMapped(
            RegExp(r'(\{|\,)\s*(\w+)\s*:'), 
            (match) => '${match.group(1)}"${match.group(2)}":');
        
        // Tenter le parsing avec les corrections
        try {
          return jsonDecode(fixedJson) as Map<String, dynamic>;
        } catch (e) {
          
          // 4. Si tout échoue, faire un parsing manuel
          return _parseKeyValuePairs(trimmed.substring(1, trimmed.length - 1));
        }
      } catch (e) {
        return null;
      }
    }
  }
  
  /// Analyse spécifiquement un dictionnaire de style Python comme {no_data: false, guano_presency: false}
  static Map<String, dynamic> _parsePythonDict(String pythonDict) {
    final result = <String, dynamic>{};
    
    // Enlever les accolades
    final content = pythonDict.substring(1, pythonDict.length - 1).trim();
    
    // Diviser par virgule
    final pairs = content.split(',');
    
    for (final pair in pairs) {
      final parts = pair.trim().split(':');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final valueStr = parts[1].trim();
        
        // Convertir la valeur
        dynamic value;
        if (valueStr.toLowerCase() == 'true') {
          value = true;
        } else if (valueStr.toLowerCase() == 'false') {
          value = false;
        } else if (valueStr.toLowerCase() == 'null') {
          value = null;
        } else if (RegExp(r'^-?\d+$').hasMatch(valueStr)) {
          value = int.parse(valueStr);
        } else if (RegExp(r'^-?\d+\.\d+$').hasMatch(valueStr)) {
          value = double.parse(valueStr);
        } else {
          // Enlever les guillemets si présents
          if ((valueStr.startsWith('"') && valueStr.endsWith('"')) ||
              (valueStr.startsWith("'") && valueStr.endsWith("'"))) {
            value = valueStr.substring(1, valueStr.length - 1);
          } else {
            value = valueStr;
          }
        }
        
        result[key] = value;
      }
    }
    
    return result;
  }
  
  /// Parse manuellement des paires clé-valeur au format "cle: valeur, cle2: valeur2"
  static Map<String, dynamic> _parseKeyValuePairs(String content) {
    final result = <String, dynamic>{};

    // Diviser par les virgules, en tenant compte des virgules dans les chaînes, tableaux et parenthèses
    List<String> parts = [];
    bool inString = false;
    int bracketDepth = 0;  // Profondeur des crochets []
    int parenDepth = 0;    // Profondeur des parenthèses ()
    int lastIndex = 0;

    for (int i = 0; i < content.length; i++) {
      final char = content[i];

      // Gérer les guillemets doubles uniquement (ignorer les apostrophes françaises)
      if (char == '"') {
        inString = !inString;
      } else if (!inString) {
        if (char == '[') {
          bracketDepth++;
        } else if (char == ']') {
          bracketDepth--;
        } else if (char == '(') {
          parenDepth++;
        } else if (char == ')') {
          parenDepth--;
        } else if (char == ',' && bracketDepth == 0 && parenDepth == 0) {
          // Virgule en dehors des strings, crochets ET parenthèses
          parts.add(content.substring(lastIndex, i).trim());
          lastIndex = i + 1;
        }
      }
    }

    // Ajouter la dernière partie
    if (lastIndex < content.length) {
      parts.add(content.substring(lastIndex).trim());
    }
    
    // Si la division échoue, essayer une approche moins précise
    if (parts.isEmpty) {
      parts = content.split(',');
    }
    
    // Analyser chaque paire clé-valeur
    for (final part in parts) {
      if (part.contains(':')) {
        final keyValue = part.split(':');
        if (keyValue.length >= 2) {
          final key = keyValue[0].trim();
          // Joindre le reste au cas où il y aurait des deux-points dans la valeur
          final rawValue = keyValue.sublist(1).join(':').trim();
          
          // Convertir la valeur au type approprié
          result[key] = _convertStringToValue(rawValue);
        }
      }
    }
    
    return result;
  }
  
  /// Convertit récursivement les strings qui ressemblent à des arrays JSON en vraies listes
  static void _deepConvertArrayStrings(Map<String, dynamic> map) {
    // Utiliser une liste de clés pour éviter les modifications pendant l'itération
    final keys = map.keys.toList();

    for (final key in keys) {
      final value = map[key];

      if (value is String && value.startsWith('[') && value.endsWith(']')) {
        // C'est une string qui ressemble à un array, essayer de la convertir
        try {
          map[key] = jsonDecode(value);
        } catch (e) {
          // Si le parsing JSON échoue, utiliser notre conversion manuelle
          map[key] = _convertStringToValue(value);
        }
      } else if (value is Map<String, dynamic>) {
        // Récursivement convertir les maps imbriquées
        _deepConvertArrayStrings(value);
      }
    }
  }

  /// Convertit une chaîne en sa valeur typée (int, bool, etc.)
  static dynamic _convertStringToValue(String rawValue) {
    final trimmed = rawValue.trim();

    // Retirer les guillemets si présents
    String clean = trimmed;
    if ((clean.startsWith('"') && clean.endsWith('"')) ||
        (clean.startsWith("'") && clean.endsWith("'"))) {
      clean = clean.substring(1, clean.length - 1);
    }

    // Arrays JSON (ex: [1034, 1035, 1036] ou ["a", "b", "c"])
    if (clean.startsWith('[') && clean.endsWith(']')) {
      try {
        // Essayer de parser comme JSON array
        return jsonDecode(clean);
      } catch (e) {
        // Si le parsing JSON échoue, essayer un parsing manuel
        final content = clean.substring(1, clean.length - 1).trim();
        if (content.isEmpty) {
          return []; // Array vide
        }

        // Séparer par virgule et convertir chaque élément
        final elements = content.split(',').map((e) {
          final element = e.trim();
          // Retirer les guillemets si présents
          if ((element.startsWith('"') && element.endsWith('"')) ||
              (element.startsWith("'") && element.endsWith("'"))) {
            return element.substring(1, element.length - 1);
          }
          // Essayer de parser comme nombre
          if (RegExp(r'^-?\d+$').hasMatch(element)) {
            return int.parse(element);
          }
          if (RegExp(r'^-?\d+\.\d+$').hasMatch(element)) {
            return double.parse(element);
          }
          return element;
        }).toList();

        return elements;
      }
    }

    // Booléens
    if (clean.toLowerCase() == 'true') return true;
    if (clean.toLowerCase() == 'false') return false;
    if (clean.toLowerCase() == 'null') return null;

    // Nombres
    if (RegExp(r'^-?\d+$').hasMatch(clean)) {
      return int.parse(clean);
    }
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(clean)) {
      return double.parse(clean);
    }

    // Par défaut, retourner la chaîne
    return clean;
  }
}