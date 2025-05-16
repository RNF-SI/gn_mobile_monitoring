import 'dart:convert';

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
  final HiddenExpressionEvaluator _expressionEvaluator =
      HiddenExpressionEvaluator();

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
    debugPrint(
        'Traitement des données: ${formData.length} entrées, clés: ${formData.keys.join(', ')}');

    // Copier les données pour ne pas modifier l'original
    final processedData = Map<String, dynamic>.from(formData);

    // TRAITEMENT DES NOMENCLATURES
    // Rechercher TOUS les champs de nomenclature (commençant par id_nomenclature_)
    final nomenclatureFields = processedData.keys
        .where((key) => key.startsWith('id_nomenclature_'))
        .toList();

    debugPrint('Champs de nomenclature trouvés: ${nomenclatureFields.length}');

    // Pour chaque champ de nomenclature, s'assurer qu'il est converti en entier
    for (final fieldName in nomenclatureFields) {
      final fieldValue = processedData[fieldName];

      debugPrint(
          'Traitement du champ $fieldName: valeur=$fieldValue, type=${fieldValue?.runtimeType}');

      // Cas 1: Valeur déjà au format entier
      if (fieldValue is int) {
        debugPrint('  $fieldName: Déjà au format entier ($fieldValue)');
        continue;
      }

      // Cas 2: Valeur au format chaîne mais représentant un entier
      if (fieldValue is String) {
        final parsedInt = int.tryParse(fieldValue);
        if (parsedInt != null) {
          processedData[fieldName] = parsedInt;
          debugPrint('  $fieldName: Converti de String à int ($parsedInt)');
          continue;
        }
      }

      // Cas 3: Valeur au format Map
      if (fieldValue is Map<String, dynamic>) {
        debugPrint(
            '  $fieldName: Valeur au format Map: ${fieldValue.keys.join(', ')}');

        // Version 1: Si l'ID est directement disponible dans l'objet (version la plus fiable)
        if (fieldValue.containsKey('id') && fieldValue['id'] != null) {
          final id = fieldValue['id'];
          final parsedId = id is int ? id : int.tryParse(id.toString()) ?? 0;
          processedData[fieldName] = parsedId;
          debugPrint('  $fieldName: Extrait id=$parsedId depuis Map');
          continue;
        }

        // Version 2: Utiliser le code de nomenclature pour rechercher l'ID
        final codeType = fieldValue['code_nomenclature_type'] as String?;
        final cdNomenclature = fieldValue['cd_nomenclature'] as String?;

        if (codeType != null && cdNomenclature != null) {
          debugPrint(
              '  $fieldName: Recherche par codeType=$codeType, cdNomenclature=$cdNomenclature');

          // Récupérer les nomenclatures pour ce type
          final nomenclatureService =
              ref.read(nomenclatureServiceProvider.notifier);
          final nomenclatures =
              await nomenclatureService.getNomenclaturesByTypeCode(codeType);

          debugPrint(
              '  $fieldName: ${nomenclatures.length} nomenclatures trouvées pour le type $codeType');

          try {
            // Rechercher la nomenclature correspondante
            final nomenclature = nomenclatures.firstWhere(
              (n) =>
                  n.cdNomenclature == cdNomenclature && n.codeType == codeType,
            );

            // Utiliser l'ID de la nomenclature trouvée
            processedData[fieldName] = nomenclature.id;
            debugPrint(
                '  $fieldName: Nomenclature trouvée avec id=${nomenclature.id}');
          } catch (e) {
            // En cas d'erreur, essayer de récupérer l'ID numérique depuis cd_nomenclature
            debugPrint(
                '  $fieldName: Erreur lors de la recherche de la nomenclature: $e');

            final numericId = int.tryParse(cdNomenclature);
            if (numericId != null) {
              processedData[fieldName] = numericId;
              debugPrint(
                  '  $fieldName: Utilisation de cdNomenclature comme ID: $numericId');
            } else {
              // Conserver une valeur par défaut (0)
              processedData[fieldName] = 0;
              debugPrint('  $fieldName: Utilisation de la valeur par défaut 0');
            }
          }
        } else {
          // Si nous n'avons pas les informations nécessaires, utiliser 0 comme valeur par défaut
          processedData[fieldName] = 0;
          debugPrint(
              '  $fieldName: Informations insuffisantes pour la nomenclature, utilisation de 0');
        }
      }

      // Cas 4: Valeur nulle ou d'un autre type
      if (fieldValue == null ||
          (fieldValue is! int && fieldValue is! Map && fieldValue is! String)) {
        // Utiliser 0 comme valeur par défaut ou null selon votre convention
        processedData[fieldName] = 0;
        debugPrint(
            '  $fieldName: Valeur de nomenclature non reconnue, utilisation de 0');
      }
    }

    // TRAITEMENT DES TAXONS
    // Pour le champ cd_nom, s'assurer qu'il contient juste la valeur numérique
    if (processedData.containsKey('cd_nom')) {
      final value = processedData['cd_nom'];
      debugPrint(
          'Traitement du champ cd_nom: valeur=$value, type=${value?.runtimeType}');

      if (value is Map<String, dynamic> && value.containsKey('cd_nom')) {
        final cdNom = value['cd_nom'];
        // Si c'est un objet taxon complet, extraire juste le cd_nom
        processedData['cd_nom'] = cdNom;
        debugPrint('  cd_nom: Extrait la valeur $cdNom depuis Map');
      } else if (value is String) {
        // Si c'est une chaîne, essayer de la convertir en entier
        final parsedInt = int.tryParse(value);
        if (parsedInt != null) {
          processedData['cd_nom'] = parsedInt;
          debugPrint('  cd_nom: Converti de String à int ($parsedInt)');
        }
      }
      // Si c'est déjà un entier, le laisser tel quel
    }

    // Vérifier une dernière fois que toutes les valeurs sont sérialisables en JSON
    _validateJsonData(processedData);

    // Afficher les données traitées
    debugPrint('Données traitées: ${processedData.length} entrées');

    return processedData;
  }

  /// Vérifie que toutes les valeurs du Map sont sérialisables en JSON
  void _validateJsonData(Map<String, dynamic> data) {
    try {
      // Tenter de sérialiser les données
      final jsonString = jsonEncode(data);
      debugPrint('Validation JSON réussie: ${jsonString.length} caractères');
    } catch (e) {
      debugPrint(
          'ERREUR: Les données ne peuvent pas être sérialisées en JSON: $e');

      // Identifier les champs problématiques
      for (final entry in data.entries) {
        try {
          final json = jsonEncode({entry.key: entry.value});
          // Pas de problème avec cette entrée
        } catch (entryError) {
          debugPrint(
              'Champ problématique: ${entry.key}, valeur: ${entry.value}, type: ${entry.value.runtimeType}');

          // Corriger les valeurs problématiques - Chaque cas particulier
          if (entry.value == null) {
            // Les valeurs nulles sont acceptables en JSON, ce n'est probablement pas le problème
            continue;
          }

          // Transformer les objets complexes en chaînes si nécessaire
          if (entry.value is! num &&
              entry.value is! bool &&
              entry.value is! String &&
              entry.value is! List &&
              entry.value is! Map) {
            // Type non supporté par JSON, le convertir en chaîne
            data[entry.key] = entry.value.toString();
            debugPrint(
                'Correction: ${entry.key} converti en String: ${data[entry.key]}');
          }
        }
      }
    }
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
          (processedData[key] is String &&
              int.tryParse(processedData[key] as String) != null)) {
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
  bool isFieldHidden(String fieldId, Map<String, dynamic> context,
      {Map<String, dynamic>? fieldConfig}) {
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
    if (hiddenValue is String &&
        (hiddenValue.trim().startsWith('({') ||
            hiddenValue.trim().startsWith('('))) {
      try {
        // Détecter les expressions complexes qui pourraient causer des problèmes
        // plutôt que d'avoir des cas spéciaux codés en dur
        final String normalizedExpression =
            _normalizeHiddenExpression(hiddenValue, context);

        // Si l'expression a été normalisée, l'évaluer directement
        if (normalizedExpression != hiddenValue) {
          return _evaluateNormalizedExpression(normalizedExpression, context);
        }

        // Évaluation normale de l'expression
        final result =
            _expressionEvaluator.evaluateExpression(hiddenValue, context);

        // Si l'évaluation échoue, ne pas masquer le champ par défaut
        return result ?? false;
      } catch (e) {
        debugPrint(
            'Erreur lors de l\'évaluation de l\'expression pour $fieldId: $e');
        return false;
      }
    }

    // Par défaut, ne pas masquer le champ
    return false;
  }

  /// Analyse et prétraite les expressions de masquage pour éviter les boucles infinies et
  /// améliorer les performances d'évaluation
  ///
  /// Parameters:
  /// - expression: L'expression de masquage à analyser
  /// - context: Le contexte d'évaluation
  ///
  /// Returns:
  /// - L'expression originale, ou une version normalisée permettant une évaluation plus directe
  String _normalizeHiddenExpression(
      String expression, Map<String, dynamic> context) {
    // Préparation de l'expression (supprimer les espaces superflus)
    final String cleanExpr = expression.trim();

    // Récupérer la map des valeurs
    final valueMap = context['value'] as Map<String, dynamic>;

    // Cas 1: Expression simple en fonction d'un seul champ
    // Format: (value) => value['champ']
    if (cleanExpr.startsWith('(value)') &&
        cleanExpr.contains("value['") &&
        !cleanExpr.contains('&&') &&
        !cleanExpr.contains('||') &&
        !cleanExpr.contains('!')) {
      // Extraire le nom du champ entre guillemets simples
      final startIndex = cleanExpr.indexOf("['") + 2;
      final endIndex = cleanExpr.indexOf("']", startIndex);

      if (startIndex >= 2 && endIndex > startIndex) {
        final fieldName = cleanExpr.substring(startIndex, endIndex);
        return "NORMALIZED:SIMPLE:$fieldName";
      }
    }

    // Cas 2: Négation d'un champ
    // Format: (value) => !value['champ']
    if (cleanExpr.startsWith('(value)') &&
        cleanExpr.contains("!value['") &&
        !cleanExpr.contains('&&') &&
        !cleanExpr.contains('||')) {
      // Extraire le nom du champ entre guillemets simples
      final startIndex = cleanExpr.indexOf("['", cleanExpr.indexOf('!')) + 2;
      final endIndex = cleanExpr.indexOf("']", startIndex);

      if (startIndex >= 2 && endIndex > startIndex) {
        final fieldName = cleanExpr.substring(startIndex, endIndex);
        return "NORMALIZED:NOT:$fieldName";
      }
    }

    // Cas 3: Condition avec deux champs et opérateur AND
    // Format: (value) => value['champ1'] && value['champ2']
    if (cleanExpr.startsWith('(value)') &&
        cleanExpr.contains('&&') &&
        cleanExpr.indexOf("value['") >= 0 &&
        cleanExpr.indexOf("value['", cleanExpr.indexOf('&&')) > 0) {
      // Extraire le nom du premier champ
      final startIndex1 = cleanExpr.indexOf("['") + 2;
      final endIndex1 = cleanExpr.indexOf("']", startIndex1);

      // Extraire le nom du deuxième champ
      final startIndex2 = cleanExpr.indexOf("['", endIndex1) + 2;
      final endIndex2 = cleanExpr.indexOf("']", startIndex2);

      if (startIndex1 >= 2 &&
          endIndex1 > startIndex1 &&
          startIndex2 >= 2 &&
          endIndex2 > startIndex2) {
        final field1 = cleanExpr.substring(startIndex1, endIndex1);
        final field2 = cleanExpr.substring(startIndex2, endIndex2);

        // Vérifier s'il y a une négation sur l'un des champs
        if (cleanExpr.contains('!' +
            cleanExpr.substring(cleanExpr.indexOf("value"), startIndex1 - 2))) {
          // Premier champ nié
          return "NORMALIZED:NOTAND:$field1:$field2";
        } else if (cleanExpr.contains('!' +
            cleanExpr.substring(
                cleanExpr.indexOf("value", endIndex1), startIndex2 - 2))) {
          // Deuxième champ nié
          return "NORMALIZED:ANDNOT:$field1:$field2";
        } else {
          // Pas de négation
          return "NORMALIZED:AND:$field1:$field2";
        }
      }
    }

    // Cas 4: Condition spéciale pour test_detectabilite et presence_tgb_hors_placette
    // Cette partie est généralisée et ne contient pas de noms spécifiques
    if (cleanExpr.contains("!value['") &&
        cleanExpr.contains("&&") &&
        cleanExpr.contains("value['")) {
      // Parcourir tous les champs du formulaire à la recherche d'une correspondance de motif
      for (final key1 in valueMap.keys) {
        for (final key2 in valueMap.keys) {
          if (key1 != key2 &&
              cleanExpr.contains("!value['$key1']") &&
              cleanExpr.contains("value['$key2']")) {
            return "NORMALIZED:NOTAND:$key1:$key2";
          } else if (key1 != key2 &&
              cleanExpr.contains("value['$key1']") &&
              cleanExpr.contains("!value['$key2']")) {
            return "NORMALIZED:ANDNOT:$key1:$key2";
          }
        }
      }
    }

    // Aucun motif connu n'a été trouvé, renvoyer l'expression originale
    return expression;
  }

  /// Évalue une expression normalisée pour produire un résultat booléen
  ///
  /// Parameters:
  /// - normalizedExpression: L'expression normalisée à évaluer
  /// - context: Le contexte d'évaluation contenant les valeurs du formulaire
  ///
  /// Returns:
  /// - true si le champ doit être masqué, false sinon
  bool _evaluateNormalizedExpression(
      String normalizedExpression, Map<String, dynamic> context) {
    // Récupérer la map des valeurs du formulaire
    final Map<String, dynamic> valueMap =
        context['value'] as Map<String, dynamic>;

    // Vérifier le type d'expression normalisée
    if (normalizedExpression.startsWith("NORMALIZED:SIMPLE:")) {
      // Cas simple: le champ doit être masqué si la valeur du champ référencé est true
      final String fieldName =
          normalizedExpression.substring("NORMALIZED:SIMPLE:".length);
      return valueMap[fieldName] == true;
    }

    if (normalizedExpression.startsWith("NORMALIZED:NOT:")) {
      // Négation: le champ doit être masqué si la valeur du champ référencé est false
      final String fieldName =
          normalizedExpression.substring("NORMALIZED:NOT:".length);
      return valueMap[fieldName] != true;
    }

    if (normalizedExpression.startsWith("NORMALIZED:AND:")) {
      // Condition ET: le champ doit être masqué si les deux valeurs sont true
      final String fieldsStr =
          normalizedExpression.substring("NORMALIZED:AND:".length);
      final List<String> fields = fieldsStr.split(':');

      if (fields.length == 2) {
        final bool field1Value = valueMap[fields[0]] == true;
        final bool field2Value = valueMap[fields[1]] == true;
        return field1Value && field2Value;
      }
    }

    if (normalizedExpression.startsWith("NORMALIZED:NOTAND:")) {
      // Condition NON-ET: le champ doit être masqué si !field1 && field2
      final String fieldsStr =
          normalizedExpression.substring("NORMALIZED:NOTAND:".length);
      final List<String> fields = fieldsStr.split(':');

      if (fields.length == 2) {
        final bool field1Value =
            valueMap[fields[0]] != true; // Négation de field1
        final bool field2Value = valueMap[fields[1]] == true;
        return field1Value && field2Value;
      }
    }

    if (normalizedExpression.startsWith("NORMALIZED:ANDNOT:")) {
      // Condition ET-NON: le champ doit être masqué si field1 && !field2
      final String fieldsStr =
          normalizedExpression.substring("NORMALIZED:ANDNOT:".length);
      final List<String> fields = fieldsStr.split(':');

      if (fields.length == 2) {
        final bool field1Value = valueMap[fields[0]] == true;
        final bool field2Value =
            valueMap[fields[1]] != true; // Négation de field2
        return field1Value && field2Value;
      }
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
