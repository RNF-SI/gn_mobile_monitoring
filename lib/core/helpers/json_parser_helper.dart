import 'dart:convert';
import 'package:flutter/foundation.dart';

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
      return jsonDecode(trimmed) as Map<String, dynamic>;
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
    
    // Diviser par les virgules, en tenant compte des virgules dans les chaînes
    List<String> parts = [];
    bool inString = false;
    int lastIndex = 0;
    
    for (int i = 0; i < content.length; i++) {
      if (content[i] == '"' || content[i] == "'") {
        inString = !inString;
      } else if (content[i] == ',' && !inString) {
        parts.add(content.substring(lastIndex, i).trim());
        lastIndex = i + 1;
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
  
  /// Convertit une chaîne en sa valeur typée (int, bool, etc.)
  static dynamic _convertStringToValue(String rawValue) {
    final trimmed = rawValue.trim();
    
    // Retirer les guillemets si présents
    String clean = trimmed;
    if ((clean.startsWith('"') && clean.endsWith('"')) ||
        (clean.startsWith("'") && clean.endsWith("'"))) {
      clean = clean.substring(1, clean.length - 1);
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