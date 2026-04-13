import 'package:flutter/material.dart';

/// Classe utilitaire pour gérer les noms et icônes des entités
class EntityNameHelper {
  /// Retourne le nom du type d'entité, au pluriel par défaut (pour les statistiques et conflits)
  static String getEntityTypeName(String entityType, bool plural) {
    switch (entityType.toLowerCase()) {
      case 'module':
        return plural ? 'modules' : 'Module';
      case 'site':
        return plural ? 'sites' : 'Site';
      case 'sitegroup':
        return plural ? 'groupes de sites' : 'Groupe de sites';
      case 'visit':
        return plural ? 'visites' : 'Visite';
      case 'observation':
        return plural ? 'observations' : 'Observation';
      case 'taxon':
        return plural ? 'taxons' : 'Taxon';
      case 'detail':
      case 'détail':
        return plural ? 'détails' : 'Détail';
      default:
        return entityType;
    }
  }

  /// Retourne une icône en fonction du type d'entité
  static IconData getEntityIcon(String entityType) {
    switch (entityType.toLowerCase()) {
      case 'module':
        return Icons.grid_view;
      case 'site':
        return Icons.place;
      case 'sitegroup':
        return Icons.folder;
      case 'visit':
        return Icons.calendar_today;
      case 'observation':
        return Icons.visibility;
      case 'taxon':
        return Icons.eco;
      case 'detail':
      case 'détail':
        return Icons.description;
      default:
        return Icons.data_object;
    }
  }
}