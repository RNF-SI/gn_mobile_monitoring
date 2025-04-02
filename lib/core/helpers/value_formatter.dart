/// Classe utilitaire pour formatter les valeurs affichées dans l'interface utilisateur
class ValueFormatter {
  /// Formate une valeur quelconque pour l'affichage dans l'UI
  /// 
  /// Gère les cas spéciaux comme les nomenclatures, les listes, les objets complexes, etc.
  static String format(dynamic value) {
    if (value == null) {
      return 'Non renseigné';
    } else if (value is Map) {
      return formatNomenclature(value);
    } else if (value is List) {
      return 'Liste (${value.length} éléments)';
    } else {
      return value.toString();
    }
  }

  /// Formate un objet nomenclature pour l'affichage
  /// 
  /// Affiche en priorité:
  /// 1. Le label si disponible
  /// 2. Le code de nomenclature
  /// 3. L'ID de nomenclature
  static String formatNomenclature(Map<dynamic, dynamic> value) {
    // Si c'est un objet nomenclature avec un label, afficher le label
    if (value.containsKey('label')) {
      return value['label'].toString();
    } 
    // Si c'est un objet nomenclature avec cd_nomenclature et code_nomenclature_type
    else if (value.containsKey('cd_nomenclature') && value.containsKey('code_nomenclature_type')) {
      return value['cd_nomenclature'].toString();
    }
    // Si c'est un objet nomenclature avec id
    else if (value.containsKey('id') && 
            (value.containsKey('cd_nomenclature') || value.containsKey('code_nomenclature_type'))) {
      return value['cd_nomenclature']?.toString() ?? 'Nomenclature ${value['id']}';
    }
    // Format fallback pour les objets qui ne correspondent pas à ces critères
    else {
      return 'Objet complexe';
    }
  }

  /// Formatte un libellé (par exemple pour les en-têtes de colonnes ou les titres de champs)
  /// 
  /// Exemple: "id_nomenclature_type" -> "Id Nomenclature Type"
  static String formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? word[0].toUpperCase() + word.substring(1) 
            : '')
        .join(' ');
  }
}