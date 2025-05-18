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
}