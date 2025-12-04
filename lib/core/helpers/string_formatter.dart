/// Classe utilitaire pour le formatage des chaînes de caractères
class StringFormatter {
  /// Formater le nom d'un champ pour l'affichage
  static String formatFieldName(String? fieldName) {
    if (fieldName == null) return 'Non spécifié';
    
    // Enlever le suffixe _id ou Id
    String displayName = fieldName;
    if (displayName.endsWith('_id')) {
      displayName = displayName.substring(0, displayName.length - 3);
    } else if (displayName.endsWith('Id')) {
      displayName = displayName.substring(0, displayName.length - 2);
    }
    
    // Remplacer les underscores par des espaces
    displayName = displayName.replaceAll('_', ' ');
    
    // Capitaliser chaque mot
    displayName = displayName.split(' ').map((word) => 
      word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
    
    return displayName;
  }

  /// Capitaliser la première lettre d'une chaîne
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Formatte une date pour l'affichage
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne l'article défini approprié (ce/cette/cet) selon le genre et la première lettre
  /// 
  /// - [label] : Le label à utiliser (ex: "Aire", "Groupe de sites")
  /// - [genre] : Le genre ('M' pour masculin, 'F' pour féminin)
  /// 
  /// Exemples:
  /// - getArticleForLabel("Aire", "F") → "cette"
  /// - getArticleForLabel("Groupe de sites", "M") → "ce"
  /// - getArticleForLabel("Élément", "M") → "cet" (voyelle)
  static String getArticleForLabel(String label, String? genre) {
    final lowerLabel = label.toLowerCase().trim();
    if (lowerLabel.isEmpty) return 'ce';
    
    const vowels = ['a', 'e', 'i', 'o', 'u', 'y', 'à', 'é', 'è', 'ê', 'ë', 'î', 'ï', 'ô', 'ö', 'ù', 'û', 'ü'];
    final isVowel = lowerLabel.isNotEmpty && vowels.contains(lowerLabel[0]);
    
    if (genre == 'F') {
      return "cette";
    } else {
      return isVowel ? "cet" : "ce";
    }
  }

  /// Retourne l'article indéfini approprié (un/une) selon le genre
  /// 
  /// - [label] : Le label à utiliser (ex: "Aire", "Groupe de sites")
  /// - [genre] : Le genre ('M' pour masculin, 'F' pour féminin)
  /// 
  /// Exemples:
  /// - getIndefiniteArticleForLabel("Aire", "F") → "une"
  /// - getIndefiniteArticleForLabel("Groupe de sites", "M") → "un"
  static String getIndefiniteArticleForLabel(String label, String? genre) {
    if (genre == 'F') {
      return "une";
    } else {
      return "un";
    }
  }
}

/// Extension pour les opérations sur les chaînes de caractères
extension StringFormatterExtension on String {
  /// Capitalise la première lettre d'une chaîne
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}