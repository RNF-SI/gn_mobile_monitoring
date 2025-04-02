import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

/// Service pour manipuler les nomenclatures
class NomenclatureUtils {
  /// Convertit un id_nomenclature en un objet pour l'affichage dans les formulaires
  ///
  /// Exemple:
  /// ```
  /// {
  ///   'code_nomenclature_type': 'TYPE_MEDIA',
  ///   'cd_nomenclature': '2',
  ///   'label': 'Photo',
  /// }
  /// ```
  static Map<String, dynamic>? idToFormValue(
    int? idNomenclature,
    List<Nomenclature> nomenclatures,
    Map<int, String> typeMapping, // Map inversée de idType à code_type
  ) {
    if (idNomenclature == null) return null;

    try {
      // Rechercher la nomenclature par ID
      final nomenclature = nomenclatures.firstWhere(
        (n) => n.id == idNomenclature,
      );

      // Récupérer le code du type de nomenclature
      final codeType = typeMapping[nomenclature.idType];
      if (codeType == null) return null;

      // Construire l'objet pour l'affichage
      return {
        'code_nomenclature_type': codeType,
        'cd_nomenclature': nomenclature.cdNomenclature,
        'label': nomenclature.labelDefault ?? nomenclature.cdNomenclature,
      };
    } catch (e) {
      // Si la nomenclature n'est pas trouvée
      return null;
    }
  }

  /// Convertit un objet formulaire en id_nomenclature pour le stockage
  ///
  /// Exemple:
  /// ```
  /// // Objet d'entrée
  /// {
  ///   'code_nomenclature_type': 'TYPE_MEDIA',
  ///   'cd_nomenclature': '2',
  /// }
  /// // Retourne: 467 (id_nomenclature)
  /// ```
  static int? formValueToId(
    Map<String, dynamic>? formValue,
    List<Nomenclature> nomenclatures,
    Map<String, int> typeMapping, // Map de code_type à idType
  ) {
    if (formValue == null) return null;

    // Extraire les données
    final codeType = formValue['code_nomenclature_type'] as String?;
    final cdNomenclature = formValue['cd_nomenclature'] as String?;

    if (codeType == null || cdNomenclature == null) return null;

    // Récupérer l'ID du type
    final idType = typeMapping[codeType];
    if (idType == null) return null;

    try {
      // Rechercher la nomenclature correspondante
      final nomenclature = nomenclatures.firstWhere(
        (n) => n.idType == idType && n.cdNomenclature == cdNomenclature,
      );

      return nomenclature.id;
    } catch (e) {
      // Si la nomenclature n'est pas trouvée
      return null;
    }
  }

  /// Construit la table de mapping inverse (idType -> codeType)
  static Map<int, String> buildInverseTypeMapping(
      Map<String, int> typeMapping) {
    final result = <int, String>{};
    typeMapping.forEach((codeType, idType) {
      result[idType] = codeType;
    });
    return result;
  }

  /// Récupère le label correspondant au code de nomenclature
  static String? getLabel(String codeNomenclatureType, String cdNomenclature,
      List<Nomenclature> nomenclatures, Map<String, int> typeMapping) {
    try {
      // Récupérer l'ID du type
      final idType = typeMapping[codeNomenclatureType];
      if (idType == null) return null;

      // Rechercher la nomenclature correspondante
      final nomenclature = nomenclatures.firstWhere(
        (n) => n.idType == idType && n.cdNomenclature == cdNomenclature,
      );

      // Retourner le label français ou par défaut
      return nomenclature.labelFr ??
          nomenclature.labelDefault ??
          nomenclature.cdNomenclature;
    } catch (e) {
      return null;
    }
  }

  /// Récupère une liste de nomenclatures pour un type donné, formatée pour les widgets de sélection
  static List<Map<String, dynamic>> getNomenclatureValuesForWidget(
      String codeNomenclatureType,
      List<Nomenclature> nomenclatures,
      Map<String, int> typeMapping) {
    try {
      // Récupérer l'ID du type
      final idType = typeMapping[codeNomenclatureType];
      if (idType == null) return [];

      // Filtrer les nomenclatures par type
      final nomenclaturesOfType =
          nomenclatures.where((n) => n.idType == idType).toList();

      // Mapper en format utilisable par les widgets (label/value)
      return nomenclaturesOfType
          .map((n) => {
                'label': n.labelFr ?? n.labelDefault ?? n.cdNomenclature,
                'value': n.cdNomenclature,
                'id': n.id,
              })
          .toList();
    } catch (e) {
      return [];
    }
  }
}
