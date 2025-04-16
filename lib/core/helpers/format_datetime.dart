import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Formate un objet DateTime en format ISO avec UTC
String formatDateTime(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  return "${utcDateTime.year.toString().padLeft(4, '0')}-"
      "${utcDateTime.month.toString().padLeft(2, '0')}-"
      "${utcDateTime.day.toString().padLeft(2, '0')} "
      "${utcDateTime.hour.toString().padLeft(2, '0')}:"
      "${utcDateTime.minute.toString().padLeft(2, '0')}:"
      "${utcDateTime.second.toString().padLeft(2, '0')}."
      "${utcDateTime.millisecond.toString().padLeft(3, '0')}";
}

/// Formate une date au format standard "YYYY-MM-DD"
String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

/// Formate une chaîne de date (comme "2024-03-21") en format localisé
String formatDateString(String dateString) {
  try {
    // Si la chaîne contient un T (format ISO), extraire seulement la partie date
    final datePart =
        dateString.contains('T') ? dateString.split('T')[0] : dateString;

    final date = DateTime.parse(datePart);
    final formatter = DateFormat.yMd();
    return formatter.format(date);
  } catch (e) {
    // En cas d'erreur, retourner la chaîne originale
    debugPrint('Erreur lors du parsing de la date: $e');
    return dateString;
  }
}

/// Formate une heure au format standard "HH:MM"
String formatTime(DateTime time) {
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}

/// Normalise une chaîne d'heure en format standard "HH:MM"
String normalizeTimeFormat(String timeValue) {
  // Si la chaîne est vide, la retourner telle quelle
  if (timeValue.isEmpty) {
    return timeValue;
  }

  try {
    // Cas spécial pour le format problématique ""16": 32" avec doubles guillemets
    final malformedRegex = RegExp(r'""(\d+)""\s*:\s*(\d+)');
    final malformedMatch = malformedRegex.firstMatch(timeValue);
    if (malformedMatch != null) {
      final hours = malformedMatch.group(1);
      final minutes = malformedMatch.group(2);
      if (hours != null && minutes != null) {
        return "$hours:$minutes";
      }
    }

    // Cas pour le format "16": 32 avec un seul jeu de guillemets
    final semiMalformedRegex = RegExp(r'"(\d+)"\s*:\s*(\d+)');
    final semiMalformedMatch = semiMalformedRegex.firstMatch(timeValue);
    if (semiMalformedMatch != null) {
      final hours = semiMalformedMatch.group(1);
      final minutes = semiMalformedMatch.group(2);
      if (hours != null && minutes != null) {
        return "$hours:$minutes";
      }
    }

    // Cas général pour tout format "nombre:nombre"
    final colonFormat = RegExp(r'(\d+)\s*:\s*(\d+)');
    final colonMatch = colonFormat.firstMatch(timeValue);
    if (colonMatch != null) {
      final hours = colonMatch.group(1);
      final minutes = colonMatch.group(2);
      if (hours != null && minutes != null) {
        // Formater proprement avec des zéros au début si nécessaire
        final formattedHours = hours.padLeft(2, '0');
        final formattedMinutes = minutes.padLeft(2, '0');
        return "$formattedHours:$formattedMinutes";
      }
    }

    // Nettoyer la chaîne (supprimer les guillemets et espaces)
    String cleanTime = timeValue.replaceAll('"', '').trim();

    // Vérifier si c'est déjà au format HH:MM
    final standardFormat = RegExp(r'^(\d{1,2}):(\d{1,2})$');
    if (standardFormat.hasMatch(cleanTime)) {
      final match = standardFormat.firstMatch(cleanTime)!;
      final hours = match.group(1)!.padLeft(2, '0');
      final minutes = match.group(2)!.padLeft(2, '0');
      return "$hours:$minutes"; // Assurer le format HH:MM
    }

    // Essayer d'extraire les heures et minutes de tout autre format
    final extractFormat = RegExp(r'(\d{1,2})[^0-9]+(\d{1,2})');
    final match = extractFormat.firstMatch(cleanTime);
    if (match != null) {
      final hours = match.group(1)!.padLeft(2, '0');
      final minutes = match.group(2)!.padLeft(2, '0');
      return "$hours:$minutes";
    }

    // En dernier recours, retourner la chaîne nettoyée
    return cleanTime;
  } catch (e) {
    debugPrint('Erreur lors de la normalisation de l\'heure: $e');
    return timeValue;
  }
}
