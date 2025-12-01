import 'package:flutter/material.dart';

/// Couleurs centralisées de l'application
/// Toutes les couleurs utilisées dans l'application doivent être définies ici
class AppColors {
  AppColors._(); // Constructeur privé pour empêcher l'instanciation

  // Couleurs principales
  /// Couleur principale de l'application (utilisée pour les boutons, titres, etc.)
  static const Color primary = Color(0xFFF5B027);

  /// Couleur foncée (utilisée pour les overlays, AppBar, etc.)
  static const Color dark = Color(0xFFC8911F);

  /// Couleur pour les bordures (utilisée pour les champs de formulaire)
  static const Color border = Color(0xFFE5A82A);

  // Couleurs de fond
  /// Background (utilisée pour les champs de formulaire)
  static const Color background = Color(0xFFF4F1E4);

  // Couleurs standards
  /// Blanc
  static const Color white = Colors.white;

  /// Rouge (utilisé pour les erreurs)
  static const Color red = Colors.red;
}
