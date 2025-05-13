import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
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
  final HiddenExpressionEvaluator _expressionEvaluator = HiddenExpressionEvaluator();

  FormDataProcessor(this.ref);

  /// Convertit les valeurs de nomenclature au format d'ID attendu par le backend
  ///
  /// Garantit que toutes les nomenclatures (id_nomenclature_*) sont stockées comme des entiers.
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
    // Rechercher TOUS les champs de nomenclature (commençant par id_nomenclature_)
    final nomenclatureFields = processedData.keys
        .where((key) => key.startsWith('id_nomenclature_'))
        .toList();

    // Pour chaque champ de nomenclature, s'assurer qu'il est converti en entier
    for (final fieldName in nomenclatureFields) {
      final fieldValue = processedData[fieldName];
      
      // Cas 1: Valeur déjà au format entier
      if (fieldValue is int) {
        // Rien à faire, déjà au bon format
        continue;
      }
      
      // Cas 2: Valeur au format chaîne mais représentant un entier
      if (fieldValue is String) {
        final parsedInt = int.tryParse(fieldValue);
        if (parsedInt != null) {
          processedData[fieldName] = parsedInt;
          continue;
        }
      }
      
      // Cas 3: Valeur au format Map
      if (fieldValue is Map<String, dynamic>) {
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
            // En cas d'erreur, utiliser une valeur par défaut
            processedData[fieldName] = 0;
            print('Erreur lors de la recherche de la nomenclature: $e');
          }
        } else {
          // Si nous n'avons pas les informations nécessaires, utiliser 0 comme valeur par défaut
          processedData[fieldName] = 0;
          print('Informations insuffisantes pour la nomenclature $fieldName');
        }
      }
      
      // Cas 4: Valeur nulle ou d'un autre type
      if (fieldValue == null || (!(fieldValue is int) && !(fieldValue is Map) && !(fieldValue is String))) {
        // Utiliser 0 comme valeur par défaut ou null selon votre convention
        processedData[fieldName] = 0;
        print('Valeur de nomenclature non reconnue pour $fieldName: $fieldValue');
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
    
    // Rechercher tous les champs de type taxonomie qui ne commencent pas par cd_nom
    // (pour traiter d'autres champs de taxonomie, comme ceux des boutons radio)
    final taxonFields = processedData.keys
        .where((key) => key != 'cd_nom' && int.tryParse(processedData[key].toString()) != null)
        .toList();
        
    // Pour ces champs, aucune conversion n'est nécessaire car ils contiennent 
    // déjà directement le cd_nom (valeur entière)

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

    // Traiter tous les champs qui contiennent des valeurs de cd_nom
    for (final key in processedData.keys.toList()) {
      // Vérifier si la valeur est un entier (cd_nom)
      if (processedData[key] is int || 
          (processedData[key] is String && int.tryParse(processedData[key] as String) != null)) {
        
        // Convertir en entier si nécessaire
        final cdNom = processedData[key] is int 
            ? processedData[key] as int 
            : int.parse(processedData[key] as String);

        // Ne pas traiter les champs qui ne sont pas des cd_nom (par exemple, id_nomenclature_*)
        if (key != 'cd_nom' && !key.contains('cd_nom')) {
          // Vérifier si c'est un taxonomie avec boutons radio en recherchant un champ de config
          // Pour simplifier, nous préservons la valeur entière pour ces champs
          continue;
        }

        try {
          // Essayer de récupérer le taxon par son cd_nom
          final taxon = await taxonService.getTaxonByCdNom(cdNom);

          if (taxon != null) {
            // Remplacer la valeur entière par l'objet taxon complet
            // Les formulaires n'ont besoin que de certaines propriétés
            processedData[key] = {
              'cd_nom': taxon.cdNom,
              'nom_complet': taxon.nomComplet,
              'lb_nom': taxon.lbNom,
              'nom_vern': taxon.nomVern,
            };
          }
        } catch (e) {
          print('Erreur lors de la récupération du taxon pour $key: $e');
          // Laisser la valeur entière inchangée en cas d'erreur
        }
      }
    }

    return processedData;
  }
  
  /// Évalue si un champ doit être masqué en fonction des règles définies
  /// 
  /// Parameters:
  /// - fieldId: L'identifiant du champ à évaluer
  /// - context: Les données contextuelles (valeurs du formulaire, métadonnées, etc.)
  /// - fieldConfig: La configuration du champ contenant potentiellement une règle 'hidden'
  /// 
  /// Returns:
  /// - true si le champ doit être masqué, false sinon
  bool isFieldHidden(String fieldId, Map<String, dynamic> context, {Map<String, dynamic>? fieldConfig}) {
    // Si aucune configuration n'est fournie, le champ n'est pas masqué
    if (fieldConfig == null) {
      return false;
    }
    
    // Vérifier si le champ a une règle 'hidden'
    final hiddenValue = fieldConfig['hidden'];
    
    // Si la valeur est un booléen, l'utiliser directement
    if (hiddenValue is bool) {
      return hiddenValue;
    }
    
    // Si la valeur est une chaîne commençant par (, c'est une expression à évaluer
    // Note: La syntaxe peut être soit JS `({value}) => ...` ou Dart `(value) => ...`
    if (hiddenValue is String && (
        hiddenValue.trim().startsWith('({') || 
        hiddenValue.trim().startsWith('('))) {
      // Debug: Afficher l'expression et le contexte pour le dépannage
      debugPrint('Evaluating hidden expression for $fieldId: $hiddenValue');
      debugPrint('Context: $context');
      
      final result = _expressionEvaluator.evaluateExpression(hiddenValue, context);
      
      // Debug: Afficher le résultat
      debugPrint('Result for $fieldId: $result');
      
      // Si l'évaluation échoue, ne pas masquer le champ par défaut
      return result ?? false;
    }
    
    // Par défaut, ne pas masquer le champ
    return false;
  }

  /// Prépare un contexte d'évaluation pour les fonctions hidden
  /// 
  /// Cette méthode normalise le contexte en s'assurant que les clés attendues sont présentes
  /// 
  /// Parameters:
  /// - values: Les valeurs actuelles du formulaire
  /// - metadata: Les métadonnées complémentaires (module, site, etc.)
  /// 
  /// Returns:
  /// - Un Map normalisé contenant les données de contexte
  Map<String, dynamic> prepareEvaluationContext({
    required Map<String, dynamic> values,
    Map<String, dynamic>? metadata,
  }) {
    // Créer un contexte de base avec les valeurs du formulaire dans 'value'
    // Ce format correspond à celui attendu par les fonctions hidden
    // qui viennent de TypeScript: ({value}) => value.prop
    final context = <String, dynamic>{
      'value': Map<String, dynamic>.from(values),
    };
    
    // Ajouter les métadonnées si elles sont fournies
    if (metadata != null) {
      context['meta'] = Map<String, dynamic>.from(metadata);
    } else {
      context['meta'] = <String, dynamic>{};
    }
    
    return context;
  }
}
