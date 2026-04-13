import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';

/// Extracteur générique pour les messages d'erreur du serveur
/// Permet de récupérer les détails techniques complets des réponses serveur
class ServerErrorExtractor {
  /// Extrait les détails de l'erreur serveur de manière générique
  /// Prend en charge les formats JSON et HTML
  static String? extractServerDetails(dynamic error) {
    if (error == null) return null;

    // Cas 1: NetworkException avec originalDioException
    if (error is NetworkException && error.originalDioException != null) {
      return _extractFromDioException(error.originalDioException!);
    }

    // Cas 2: DioException directe
    if (error is DioException) {
      return _extractFromDioException(error);
    }

    // Cas 3: Exception avec originalDioException dans le message
    String errorString = error.toString();
    if (errorString.contains('DioException') || errorString.contains('Response')) {
      return _extractFromErrorString(errorString);
    }

    return null;
  }

  /// Extrait les détails d'une DioException
  static String? _extractFromDioException(DioException dioException) {
    final response = dioException.response;
    if (response?.data == null) return null;

    final responseData = response!.data;

    // Cas 1: Réponse JSON
    if (responseData is Map<String, dynamic>) {
      return _extractFromJsonResponse(responseData);
    }

    // Cas 2: Réponse String (peut être JSON encodé ou HTML)
    if (responseData is String) {
      return _extractFromStringResponse(responseData);
    }

    // Cas 3: Autres types - conversion directe
    return responseData.toString();
  }

  /// Extrait les détails d'une réponse JSON
  static String _extractFromJsonResponse(Map<String, dynamic> jsonData) {
    final details = <String>[];

    // Ordre de priorité pour l'extraction des champs JSON
    final priorityFields = [
      'detail',
      'message', 
      'error',
      'description',
      'title',
      'exception',
      'stackTrace'
    ];

    // Extraction prioritaire
    for (final field in priorityFields) {
      final value = jsonData[field];
      if (value != null && value.toString().trim().isNotEmpty) {
        details.add('$field: ${value.toString().trim()}');
      }
    }

    // Si aucun champ prioritaire, inclure tous les champs non-techniques
    if (details.isEmpty) {
      final ignoredFields = {'status', 'code', 'timestamp', 'path', 'type'};
      for (final entry in jsonData.entries) {
        if (!ignoredFields.contains(entry.key.toLowerCase()) && 
            entry.value != null && 
            entry.value.toString().trim().isNotEmpty) {
          details.add('${entry.key}: ${entry.value.toString().trim()}');
        }
      }
    }

    return details.isNotEmpty ? details.join('\n') : jsonData.toString();
  }

  /// Extrait les détails d'une réponse String (JSON encodé ou HTML)
  static String _extractFromStringResponse(String responseData) {
    // Tentative de décodage JSON
    try {
      final jsonDecoded = jsonDecode(responseData);
      if (jsonDecoded is Map<String, dynamic>) {
        return _extractFromJsonResponse(jsonDecoded);
      }
    } catch (e) {
      // Pas du JSON, continuer avec l'extraction HTML
    }

    // Extraction HTML - recherche des patterns d'erreur
    if (responseData.contains('<html') || responseData.contains('<!DOCTYPE')) {
      return _extractFromHtmlResponse(responseData);
    }

    // Réponse texte brute - décoder les entités HTML si nécessaire
    return _decodeHtmlEntities(responseData.trim());
  }

  /// Extrait les détails d'une réponse HTML (page d'erreur)
  static String _extractFromHtmlResponse(String htmlContent) {
    final details = <String>[];

    // Extraction du titre d'erreur
    final titleRegex = RegExp(r'<h1[^>]*>([^<]+)</h1>', caseSensitive: false);
    final titleMatch = titleRegex.firstMatch(htmlContent);
    if (titleMatch != null) {
      details.add('Erreur: ${titleMatch.group(1)?.trim()}');
    }

    // Extraction du message d'erreur principal
    final errorMsgRegex = RegExp(r'<p class="errormsg"[^>]*>([^<]+)</p>', caseSensitive: false);
    final errorMsgMatch = errorMsgRegex.firstMatch(htmlContent);
    if (errorMsgMatch != null) {
      details.add('Message: ${errorMsgMatch.group(1)?.trim()}');
    }

    // Extraction des erreurs PostgreSQL dans HTML encodé
    final postgresPatterns = [
      RegExp(r'ERREUR:\s*([^\\n]+)', caseSensitive: false),
      RegExp(r'DÉTAIL\s*:\s*([^\\n]+)', caseSensitive: false),
      RegExp(r'CONTEXTE\s*:\s*([^\\n]+)', caseSensitive: false),
      RegExp(r'psycopg2\.errors\.([^:]+):\s*([^\\n]+)', caseSensitive: false),
    ];

    for (final pattern in postgresPatterns) {
      final matches = pattern.allMatches(htmlContent);
      for (final match in matches) {
        if (match.groupCount >= 1) {
          final errorText = match.group(match.groupCount)?.trim();
          if (errorText != null && errorText.isNotEmpty) {
            details.add(_decodeHtmlEntities(errorText));
          }
        }
      }
    }

    // Si aucun pattern spécifique trouvé, extraire le contenu text simple
    if (details.isEmpty) {
      final textContent = htmlContent
          .replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (textContent.length > 500) {
        details.add('${textContent.substring(0, 500)}...');
      } else {
        details.add(textContent);
      }
    }

    return details.join('\n');
  }

  /// Extrait les détails depuis une chaîne d'erreur complète
  static String? _extractFromErrorString(String errorString) {
    // Recherche des patterns d'erreurs PostgreSQL
    final postgresPatterns = [
      RegExp(r'ERREUR:\s*(.+?)(?=\n|$)', caseSensitive: false),
      RegExp(r'DÉTAIL\s*:\s*(.+?)(?=\n|$)', caseSensitive: false),
      RegExp(r'CONTEXTE\s*:\s*(.+?)(?=\n|$)', caseSensitive: false),
    ];

    final details = <String>[];
    for (final pattern in postgresPatterns) {
      final matches = pattern.allMatches(errorString);
      for (final match in matches) {
        final errorText = match.group(1)?.trim();
        if (errorText != null && errorText.isNotEmpty) {
          details.add(errorText);
        }
      }
    }

    return details.isNotEmpty ? details.join('\n') : null;
  }

  /// Décode les entités HTML de base
  static String _decodeHtmlEntities(String htmlString) {
    return htmlString
        .replaceAll('&gt;', '>')
        .replaceAll('&lt;', '<')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('\\n', '\n')
        .replaceAll('\\t', '\t');
  }

  /// Vérifie si une erreur contient des détails serveur extractibles
  static bool hasServerDetails(dynamic error) {
    return extractServerDetails(error) != null;
  }

  /// Extrait un résumé court des détails serveur (première ligne)
  static String? extractServerSummary(dynamic error) {
    final details = extractServerDetails(error);
    if (details == null) return null;
    
    final firstLine = details.split('\n').first.trim();
    return firstLine.length > 100 ? '${firstLine.substring(0, 100)}...' : firstLine;
  }
}