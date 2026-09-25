import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
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

      // Cas 1 bis: Nomenclature à choix multiple (liste d'IDs), envoyée
      // telle quelle comme sur le web. Chaque élément est normalisé en int
      // (int, chaîne numérique ou Map avec 'id'), les éléments invalides
      // sont écartés.
      if (fieldValue is List) {
        processedData[fieldName] = fieldValue
            .map(_nomenclatureIdOf)
            .whereType<int>()
            .toList();
        debugPrint(
            '  $fieldName: Liste de nomenclatures (${processedData[fieldName]})');
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
          final parsedId = id is int ? id : int.tryParse(id.toString());
          if (parsedId != null && parsedId != 0) {
            processedData[fieldName] = parsedId;
            debugPrint('  $fieldName: Extrait id=$parsedId depuis Map');
          } else {
            processedData.remove(fieldName);
            debugPrint(
                '  $fieldName: ID invalide ($id), champ supprimé');
          }
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
            // En cas d'erreur, conserver la valeur originale (ne pas modifier)
            debugPrint(
                '  $fieldName: Erreur lors de la recherche de la nomenclature: $e');
            debugPrint('  $fieldName: Conservation de la valeur originale');
            // Ne pas modifier processedData[fieldName], garder la valeur originale
          }
        } else {
          // Si nous n'avons pas les informations nécessaires, supprimer le champ
          // pour laisser le serveur utiliser sa valeur par défaut
          processedData.remove(fieldName);
          debugPrint(
              '  $fieldName: Informations insuffisantes pour la nomenclature, champ supprimé');
        }
      }

      // Cas 4: Valeur nulle ou d'un autre type
      if (fieldValue == null ||
          (fieldValue is! int && fieldValue is! Map && fieldValue is! String)) {
        // Supprimer le champ pour laisser le serveur utiliser sa valeur par défaut
        processedData.remove(fieldName);
        debugPrint(
            '  $fieldName: Valeur de nomenclature non reconnue, champ supprimé');
      }
    }

    // TRAITEMENT DES NOMENCLATURES AVEC NOMS NON-STANDARD
    // Certains modules utilisent des noms de champs qui ne commencent pas par id_nomenclature_
    // mais dont la valeur est un Map contenant cd_nomenclature (ex: champ "enceinte" dans petite_chouette)
    final nonStandardNomenclatureFields = processedData.keys
        .where((key) =>
            !key.startsWith('id_nomenclature_') &&
            processedData[key] is Map<String, dynamic> &&
            (processedData[key] as Map<String, dynamic>)
                .containsKey('cd_nomenclature'))
        .toList();

    for (final fieldName in nonStandardNomenclatureFields) {
      final fieldValue = processedData[fieldName] as Map<String, dynamic>;

      // Priorité 1 : utiliser l'ID directement s'il est présent
      if (fieldValue.containsKey('id') && fieldValue['id'] != null) {
        final id = fieldValue['id'];
        final parsedId = id is int ? id : int.tryParse(id.toString());
        if (parsedId != null && parsedId != 0) {
          processedData[fieldName] = parsedId;
          debugPrint(
              '  $fieldName: Nomenclature non-standard - extrait id=$parsedId depuis Map');
          continue;
        }
      }

      // Priorité 2 : rechercher par cd_nomenclature + code_nomenclature_type
      final codeType = fieldValue['code_nomenclature_type'] as String?;
      final cdNomenclature = fieldValue['cd_nomenclature'] as String?;

      if (codeType != null && cdNomenclature != null) {
        debugPrint(
            '  $fieldName: Nomenclature non-standard - recherche par codeType=$codeType, cdNomenclature=$cdNomenclature');
        final nomenclatureService =
            ref.read(nomenclatureServiceProvider.notifier);
        final nomenclatures =
            await nomenclatureService.getNomenclaturesByTypeCode(codeType);

        try {
          final nomenclature = nomenclatures.firstWhere(
            (n) =>
                n.cdNomenclature == cdNomenclature && n.codeType == codeType,
          );
          processedData[fieldName] = nomenclature.id;
          debugPrint(
              '  $fieldName: Nomenclature non-standard trouvée avec id=${nomenclature.id}');
        } catch (e) {
          debugPrint(
              '  $fieldName: Nomenclature non-standard non trouvée, conservation de la valeur originale');
        }
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

    // TRAITEMENT DES CHAMPS NUMÉRIQUES GÉNÉRAUX
    // Convertir les champs numériques connus (altitude, etc.) de String en int si nécessaire
    final numericFields = ['altitude_min', 'altitude_max', 'id_inventor', 'id_digitiser', 'id_sites_group', 'id_module'];
    for (final fieldName in numericFields) {
      if (processedData.containsKey(fieldName)) {
        final value = processedData[fieldName];
        if (value is String && value.isNotEmpty) {
          final parsedInt = int.tryParse(value);
          if (parsedInt != null) {
            processedData[fieldName] = parsedInt;
            debugPrint('  $fieldName: Converti de String à int ($parsedInt)');
          }
        } else if (value is num && value is! int) {
          processedData[fieldName] = value.toInt();
          debugPrint('  $fieldName: Converti de num à int (${value.toInt()})');
        }
      }
    }

    // Vérifier une dernière fois que toutes les valeurs sont sérialisables en JSON
    _validateJsonData(processedData);

    // Afficher les données traitées
    debugPrint('Données traitées: ${processedData.length} entrées');

    return processedData;
  }

  /// Extrait l'ID d'un élément de nomenclature multiple (int, chaîne
  /// numérique ou Map avec 'id'). Retourne null si l'élément est invalide.
  static int? _nomenclatureIdOf(dynamic item) {
    final raw = item is Map ? item['id'] : item;
    final id = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    return id != null && id != 0 ? id : null;
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
          if (entry.value is DateTime) {
            // Convertir DateTime en format ISO string
            data[entry.key] = (entry.value as DateTime).toIso8601String();
            debugPrint(
                'Correction: ${entry.key} DateTime converti en ISO String: ${data[entry.key]}');
          } else if (entry.value is! num &&
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
    // Résolution directe via l'id : on récupère la nomenclature complète
    // (label, cd_nomenclature, code_type) en une seule requête DAO, ce qui
    // fonctionne pour TOUS les types — y compris SEXE et ceux qui n'étaient
    // pas codés en dur dans l'ancienne boucle.
    final getNomenclatureByIdUseCase =
        ref.read(getNomenclatureByIdUseCaseProvider);

    final nomenclatureFields = processedData.keys
        .where((key) =>
            key.startsWith('id_nomenclature_') && processedData[key] is int)
        .toList();

    for (final fieldName in nomenclatureFields) {
      final idNomenclature = processedData[fieldName] as int;

      try {
        final nomenclature =
            await getNomenclatureByIdUseCase.execute(idNomenclature);

        if (nomenclature != null) {
          processedData[fieldName] = {
            'id': nomenclature.id,
            if (nomenclature.codeType != null)
              'code_nomenclature_type': nomenclature.codeType,
            'cd_nomenclature': nomenclature.cdNomenclature,
            'label': nomenclature.labelFr ??
                nomenclature.labelDefault ??
                nomenclature.cdNomenclature,
          };
        }
        // Si aucune nomenclature n'est trouvée, conserver l'ID tel quel
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
          // Vérifier si c'est un taxon avec boutons radio en recherchant un champ de config
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

  /// Évalue si un champ doit être masqué en fonction des règles définies avec support des cascades
  ///
  /// Parameters:
  /// - fieldId: L'identifiant du champ à évaluer
  /// - context: Les données contextuelles (valeurs du formulaire, métadonnées, etc.)
  /// - fieldConfig: La configuration du champ contenant potentiellement une règle 'hidden'
  /// - allFieldsConfig: conservé pour compatibilité, non utilisé (les cascades
  ///   découlent directement de l'évaluation de chaque champ)
  ///
  /// Returns:
  /// - true si le champ doit être masqué, false sinon
  bool isFieldHidden(String fieldId, Map<String, dynamic> context,
      {Map<String, dynamic>? fieldConfig, Map<String, dynamic>? allFieldsConfig}) {
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

    // Expression JavaScript `({value, meta}) => …` (ou forme convertie
    // `(value) => …` des modules installés avant 09/2026). Une expression
    // invalide ou qui lève une erreur n'entraîne pas le masquage.
    if (hiddenValue is String) {
      return _expressionEvaluator.evaluateExpression(hiddenValue, context) ??
          false;
    }

    // Par défaut, ne pas masquer le champ
    return false;
  }

  /// Évalue si un champ est requis en fonction des règles définies
  ///
  /// Parameters:
  /// - fieldId: L'identifiant du champ à évaluer
  /// - context: Les données contextuelles (valeurs du formulaire, métadonnées, etc.)
  /// - fieldConfig: La configuration du champ contenant potentiellement une règle 'required'
  ///
  /// Returns:
  /// - true si le champ est requis, false sinon
  bool isFieldRequired(String fieldId, Map<String, dynamic> context,
      {Map<String, dynamic>? fieldConfig}) {
    // Si aucune configuration n'est fournie, le champ n'est pas requis
    if (fieldConfig == null) {
      return false;
    }

    // Vérifier si le champ a une règle 'required'
    final requiredValue = fieldConfig['required'];

    // Si la valeur est un booléen, l'utiliser directement
    if (requiredValue is bool) {
      return requiredValue;
    }

    // Si la valeur est une chaîne commençant par (, c'est une expression à évaluer
    // Note: La syntaxe peut être soit JS `({value}) => ...` ou Dart `(value) => ...`
    if (requiredValue is String &&
        (requiredValue.trim().startsWith('({') ||
            requiredValue.trim().startsWith('('))) {
      try {
        // Évaluer l'expression avec le contexte fourni
        final result = _expressionEvaluator.evaluateExpression(requiredValue, context);

        // Si l'évaluation échoue, le champ n'est pas requis par défaut
        return result ?? false;
      } catch (e) {
        // En cas d'erreur, ne pas rendre le champ requis par défaut
        debugPrint('Erreur lors de l\'évaluation de required pour $fieldId: $e');
        return false;
      }
    }

    // Vérifier également dans validations (format alternatif)
    final validations = fieldConfig['validations'] as Map<String, dynamic>?;
    if (validations != null && validations.containsKey('required')) {
      final validationRequired = validations['required'];

      if (validationRequired is bool) {
        return validationRequired;
      }

      // Si c'est une expression dans validations
      if (validationRequired is String &&
          (validationRequired.trim().startsWith('({') ||
              validationRequired.trim().startsWith('('))) {
        try {
          final result = _expressionEvaluator.evaluateExpression(validationRequired, context);
          return result ?? false;
        } catch (e) {
          debugPrint('Erreur lors de l\'évaluation de validations.required pour $fieldId: $e');
          return false;
        }
      }
    }

    // Par défaut, le champ n'est pas requis
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
