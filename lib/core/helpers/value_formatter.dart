/// Classe utilitaire pour formatter les valeurs affichées dans l'interface utilisateur
class ValueFormatter {
  /// Détecte une chaîne ISO date (YYYY-MM-DD seule, ou suivie d'un T et d'une
  /// heure ISO). On reformatte en `dd/MM/yyyy` pour l'affichage côté UI.
  /// Strict pour éviter de reformater une chaîne quelconque qui commencerait
  /// par 4-2-2 chiffres mais qui serait du texte.
  static final RegExp _isoDateRegex =
      RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:T[\d:.\-+Z]+)?$');

  /// Formate une valeur quelconque pour l'affichage dans l'UI
  ///
  /// Gère les cas spéciaux comme les nomenclatures, les listes, les objets complexes, etc.
  static String format(dynamic value) {
    if (value == null) {
      return 'Non renseigné';
    } else if (value is Map) {
      return formatNomenclature(value);
    } else if (value is List) {
      return formatList(value);
    } else if (value is String) {
      // Reformatte les dates ISO (YYYY-MM-DD ou YYYY-MM-DDTHH:mm:ss) en
      // français (dd/MM/yyyy) pour rester homogène avec les `formatDateString`
      // utilisées ailleurs dans l'app.
      final match = _isoDateRegex.firstMatch(value);
      if (match != null) {
        return '${match[3]}/${match[2]}/${match[1]}';
      }
      return value;
    } else {
      return value.toString();
    }
  }

  /// Formate une liste pour l'affichage
  ///
  /// - Si la liste contient des Maps (nomenclatures), affiche leurs labels séparés par des virgules
  /// - Si la liste contient des nombres (IDs de nomenclatures), affiche "X nomenclature(s)"
  /// - Sinon, affiche les valeurs séparées par des virgules
  static String formatList(List<dynamic> value) {
    if (value.isEmpty) {
      return 'Non renseigné';
    }

    // Si la liste contient des Maps (objets nomenclature complets)
    if (value.every((item) => item is Map)) {
      final labels = value.map((item) => formatNomenclature(item as Map)).toList();
      return labels.join(', ');
    }

    // Si la liste contient des nombres (IDs de nomenclatures)
    if (value.every((item) => item is int)) {
      // Note: On ne peut pas charger les labels ici car format() est synchrone
      // Il faudrait un widget asynchrone pour afficher les vrais labels
      return '${value.length} nomenclature${value.length > 1 ? 's' : ''} sélectionnée${value.length > 1 ? 's' : ''} (IDs: ${value.join(', ')})';
    }

    // Pour les autres types de listes, afficher les valeurs séparées par des virgules
    return value.map((item) => item.toString()).join(', ');
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

  /// Formatte un libellé dérivé d'un nom de champ snake_case (utilisé en
  /// fallback quand aucun `attribut_label` n'est défini dans la config).
  /// Applique une casse "phrase" française : on majusculise uniquement la
  /// première lettre, le reste reste en bas de casse pour ne pas torturer
  /// les articles (`d'`, `de`, `du`, `le`, `la`...).
  ///
  /// Exemples :
  /// - `id_nomenclature_type` -> `Id nomenclature type`
  /// - `nombre_d_observations` -> `Nombre d observations`
  /// - `date_min` -> `Date min`
  static String formatLabel(String key) {
    final spaced = key.replaceAll('_', ' ').toLowerCase();
    if (spaced.isEmpty) return spaced;
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}