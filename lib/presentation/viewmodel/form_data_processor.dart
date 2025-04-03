import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';

/// Provider pour le service de traitement de données de formulaire
final formDataProcessorProvider = Provider<FormDataProcessor>((ref) {
  return FormDataProcessor(ref);
});

/// Service pour traiter les données des formulaires avant leur enregistrement
class FormDataProcessor {
  final Ref ref;

  FormDataProcessor(this.ref);

  /// Convertit les valeurs de nomenclature au format d'ID attendu par le backend
  ///
  /// Exemple de conversion:
  /// Entrée:
  /// ```json
  /// {
  ///   "id_nomenclature_abondance_braunblanquet": {
  ///     "code_nomenclature_type": "BRAUNBLANQABDOM",
  ///     "cd_nomenclature": "5",
  ///     "id": 694,
  ///     "label": "+"
  ///   }
  /// }
  /// ```
  ///
  /// Sortie:
  /// ```json
  /// {
  ///   "id_nomenclature_abondance_braunblanquet": 694
  /// }
  /// ```
  Future<Map<String, dynamic>> processFormData(
      Map<String, dynamic> formData) async {
    // Copier les données pour ne pas modifier l'original
    final processedData = Map<String, dynamic>.from(formData);

    // TRAITEMENT DES NOMENCLATURES
    // Rechercher les champs de nomenclature (commençant par id_nomenclature_)
    final nomenclatureFields = processedData.keys
        .where((key) =>
            key.startsWith('id_nomenclature_') &&
            processedData[key] is Map<String, dynamic>)
        .toList();

    // Pour chaque champ de nomenclature, extraire l'ID et remplacer l'objet par cet ID
    for (final fieldName in nomenclatureFields) {
      final fieldValue = processedData[fieldName] as Map<String, dynamic>;

      // Version 1: Si l'ID est directement disponible dans l'objet (version la plus fiable)
      if (fieldValue.containsKey('id') && fieldValue['id'] != null) {
        final id = fieldValue['id'];
        // Assurer que c'est un entier
        processedData[fieldName] =
            id is int ? id : int.tryParse(id.toString()) ?? 0;
        continue;
      }

      // Version 2: Utiliser le code de nomenclature pour rechercher l'ID
      final codeType = fieldValue['code_nomenclature_type'] as String?;
      final cdNomenclature = fieldValue['cd_nomenclature'] as String?;

      if (codeType != null && cdNomenclature != null) {
        // Récupérer les nomenclatures pour ce type
        final nomenclatureService =
            ref.read(nomenclatureServiceProvider.notifier);
        final nomenclatures =
            await nomenclatureService.getNomenclaturesByTypeCode(codeType);

        try {
          // Rechercher la nomenclature correspondante
          final nomenclature = nomenclatures.firstWhere(
            (n) => n.cdNomenclature == cdNomenclature && n.codeType == codeType,
          );

          // Utiliser l'ID de la nomenclature trouvée
          processedData[fieldName] = nomenclature.id;
        } catch (e) {
          // Si la nomenclature n'est pas trouvée, laisser l'objet tel quel
          // ou donner une valeur par défaut selon le besoin
          print('Erreur lors de la recherche de la nomenclature: $e');
          // Laisser inchangé par défaut
        }
      }
    }

    // TRAITEMENT DES TAXONS
    // Pour le champ cd_nom, s'assurer qu'il contient juste la valeur numérique
    if (processedData.containsKey('cd_nom')) {
      final value = processedData['cd_nom'];
      if (value is Map<String, dynamic> && value.containsKey('cd_nom')) {
        // Si c'est un objet taxon complet, extraire juste le cd_nom
        processedData['cd_nom'] = value['cd_nom'];
      }
      // Si c'est déjà un entier, le laisser tel quel
    }

    return processedData;
  }

  /// Convertit les IDs de nomenclature au format d'objet pour l'affichage dans les formulaires
  ///
  /// Exemple de conversion:
  /// Entrée:
  /// ```json
  /// {
  ///   "id_nomenclature_abondance_braunblanquet": 694
  /// }
  /// ```
  ///
  /// Sortie:
  /// ```json
  /// {
  ///   "id_nomenclature_abondance_braunblanquet": {
  ///     "id": 694,
  ///     "code_nomenclature_type": "BRAUNBLANQABDOM",
  ///     "cd_nomenclature": "5",
  ///     "label": "+"
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> processFormDataForDisplay(
      Map<String, dynamic> formData) async {
    // Copier les données pour ne pas modifier l'original
    final processedData = Map<String, dynamic>.from(formData);

    // TRAITEMENT DES NOMENCLATURES
    // Récupérer le service de nomenclature
    final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);

    // Rechercher les champs de nomenclature (commençant par id_nomenclature_)
    final nomenclatureFields = processedData.keys
        .where((key) =>
            key.startsWith('id_nomenclature_') && processedData[key] is int)
        .toList();

    // Pour chaque champ de nomenclature, convertir l'ID en objet
    for (final fieldName in nomenclatureFields) {
      final idNomenclature = processedData[fieldName] as int;

      try {
        // Récupérer toutes les nomenclatures disponibles
        final allTypes = [
          'BRAUNBLANQABDOM',
          'STADE_VIE',
          'TYPE_MEDIA',
          'TYPE_SITE',
          // Ajouter d'autres types au besoin
        ];

        // Chercher la nomenclature correspondante parmi tous les types
        Nomenclature? foundNomenclature;
        String? foundType;

        for (final type in allTypes) {
          final nomenclatures =
              await nomenclatureService.getNomenclaturesByTypeCode(type);
          final match =
              nomenclatures.where((n) => n.id == idNomenclature).toList();

          if (match.isNotEmpty) {
            foundNomenclature = match.first;
            foundType = type;
            break;
          }
        }

        if (foundNomenclature != null && foundType != null) {
          // Construire l'objet pour l'affichage
          processedData[fieldName] = {
            'id': foundNomenclature.id,
            'code_nomenclature_type': foundType,
            'cd_nomenclature': foundNomenclature.cdNomenclature,
            'label': foundNomenclature.labelFr ??
                foundNomenclature.labelDefault ??
                foundNomenclature.cdNomenclature,
          };
        }
      } catch (e) {
        print('Erreur lors de la conversion de l\'ID en objet: $e');
        // Laisser inchangé en cas d'erreur
      }
    }

    // TRAITEMENT DES TAXONS
    // Récupérer le service de taxonomie
    final taxonService = ref.read(taxonServiceProvider.notifier);

    // Si le champ cd_nom existe et est un entier
    if (processedData.containsKey('cd_nom') && processedData['cd_nom'] is int) {
      final cdNom = processedData['cd_nom'] as int;

      try {
        // Essayer de récupérer le taxon par son cd_nom
        final taxon = await taxonService.getTaxonByCdNom(cdNom);

        if (taxon != null) {
          // Remplacer la valeur entière par l'objet taxon complet
          // Les formulaires n'ont besoin que de certaines propriétés
          processedData['cd_nom'] = {
            'cd_nom': taxon.cdNom,
            'nom_complet': taxon.nomComplet,
            'lb_nom': taxon.lbNom,
            'nom_vern': taxon.nomVern,
          };
        }
      } catch (e) {
        print('Erreur lors de la récupération du taxon: $e');
        // Laisser la valeur entière inchangée en cas d'erreur
      }
    }

    return processedData;
  }
}
