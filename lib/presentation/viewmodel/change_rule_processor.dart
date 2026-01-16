import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/change_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

/// Provider pour le processeur de règles de changement
final changeRuleProcessorProvider = Provider<ChangeRuleProcessor>((ref) {
  final nomenclatureService = ref.watch(nomenclatureServiceProvider.notifier);
  return ChangeRuleProcessor(
    nomenclatureByIdCache: nomenclatureService.nomenclatureByIdCache,
  );
});

/// Résultat du traitement des règles de changement
class ChangeRuleResult {
  /// Champs à mettre à jour avec leurs nouvelles valeurs
  final Map<String, dynamic> fieldsToUpdate;

  /// Indique si des changements doivent être appliqués
  final bool hasChanges;

  const ChangeRuleResult({
    required this.fieldsToUpdate,
    required this.hasChanges,
  });

  /// Résultat vide (aucun changement)
  factory ChangeRuleResult.empty() => const ChangeRuleResult(
        fieldsToUpdate: {},
        hasChanges: false,
      );
}

/// Service de traitement des règles de changement
///
/// Traite les règles "change" au format JavaScript (tableau de strings)
/// définies au niveau de l'objet (observation, visit, site).
///
/// Format d'entrée:
/// ```json
/// "change": [
///   "({objForm, meta}) => {",
///   "if (objForm.value.presence === 'Non') {",
///   "objForm.patchValue({count_min: 0, count_max: 0})",
///   "}",
///   ...
/// ]
/// ```
class ChangeRuleProcessor {
  /// Flag pour éviter les appels ré-entrants
  bool _isProcessing = false;

  /// Cache des règles parsées pour éviter de re-parser à chaque appel
  List<ParsedChangeRule>? _cachedRules;

  /// Signature du change array pour détecter les changements
  String? _cachedChangeSignature;

  /// Cache des nomenclatures indexé par ID
  final Map<int, Nomenclature> nomenclatureByIdCache;

  ChangeRuleProcessor({
    this.nomenclatureByIdCache = const {},
  });

  /// Traite les règles de changement après modification d'un champ
  ///
  /// [formValues] - Valeurs actuelles du formulaire
  /// [changeConfig] - Configuration "change" (format structuré ou JS legacy)
  /// [triggerFieldName] - Nom du champ qui a déclenché le traitement
  /// [metadata] - Métadonnées additionnelles
  ///
  /// Retourne un [ChangeRuleResult] avec les champs à modifier
  ChangeRuleResult processChangeRules({
    required Map<String, dynamic> formValues,
    required dynamic changeConfig,
    required String triggerFieldName,
    Map<String, dynamic>? metadata,
  }) {
    // Protection contre les appels ré-entrants
    if (_isProcessing) {
      debugPrint('⚠️ [ChangeRuleProcessor] Appel ré-entrant bloqué');
      return ChangeRuleResult.empty();
    }

    // Vérifier que changeConfig est valide
    if (changeConfig == null) {
      return ChangeRuleResult.empty();
    }

    if (changeConfig is! List) {
      debugPrint('⚠️ [ChangeRuleProcessor] changeConfig n\'est pas une liste: ${changeConfig.runtimeType}');
      return ChangeRuleResult.empty();
    }

    if (changeConfig.isEmpty) {
      return ChangeRuleResult.empty();
    }

    _isProcessing = true;

    try {
      // Créer l'évaluateur avec le cache de nomenclatures
      final evaluator = ChangeExpressionEvaluator(
        nomenclatureCache: nomenclatureByIdCache,
      );

      // Récupérer les règles (format structuré ou legacy JS)
      final rules = _getRules(changeConfig, evaluator);

      if (rules.isEmpty) {
        debugPrint('📝 [ChangeRuleProcessor] Aucune règle trouvée');
        return ChangeRuleResult.empty();
      }

      debugPrint('📝 [ChangeRuleProcessor] ${rules.length} règles trouvées');

      // Préparer le contexte d'évaluation
      final context = {
        'value': formValues,
        if (metadata != null) 'meta': metadata,
      };

      final Map<String, dynamic> fieldsToUpdate = {};

      // Évaluer chaque règle
      for (var i = 0; i < rules.length; i++) {
        final rule = rules[i];

        debugPrint('📝 [ChangeRuleProcessor] Évaluation règle $i: ${rule.condition}');

        // Log des valeurs pertinentes pour le debug
        if (rule.condition.contains('count_min') || rule.condition.contains('count_max')) {
          debugPrint('📝 [ChangeRuleProcessor] Valeurs actuelles: count_min=${formValues['count_min']} (${formValues['count_min']?.runtimeType}), count_max=${formValues['count_max']} (${formValues['count_max']?.runtimeType})');
        }

        // Évaluer la condition
        final conditionResult = evaluator.evaluateJsCondition(
          rule.condition,
          context,
        );

        debugPrint('📝 [ChangeRuleProcessor] Résultat condition: $conditionResult');

        if (conditionResult == true) {
          // Résoudre les valeurs patchValue
          final resolvedValues = evaluator.resolvePatchValues(
            rule.patchValues,
            formValues,
          );

          debugPrint('📝 [ChangeRuleProcessor] Valeurs à appliquer: $resolvedValues');

          // Ajouter aux mises à jour
          fieldsToUpdate.addAll(resolvedValues);

          // IMPORTANT: Ne pas break ici car toutes les règles qui matchent
          // doivent être appliquées (comportement du code JS original)
        }
      }

      return ChangeRuleResult(
        fieldsToUpdate: fieldsToUpdate,
        hasChanges: fieldsToUpdate.isNotEmpty,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [ChangeRuleProcessor] Erreur: $e');
      debugPrint('$stackTrace');
      return ChangeRuleResult.empty();
    } finally {
      _isProcessing = false;
    }
  }

  /// Récupère les règles depuis le format structuré ou parse le format JS legacy
  List<ParsedChangeRule> _getRules(
    List<dynamic> changeConfig,
    ChangeExpressionEvaluator evaluator,
  ) {
    // Créer une signature pour détecter les changements (pour le cache)
    final signature = changeConfig.toString();

    if (_cachedRules != null && _cachedChangeSignature == signature) {
      return _cachedRules!;
    }

    // Détecter le format de la configuration
    if (_isStructuredFormat(changeConfig)) {
      // Format structuré (converti au téléchargement)
      _cachedRules = _parseStructuredRules(changeConfig);
    } else {
      // Format legacy JS (tableau de strings) - pour rétrocompatibilité
      _cachedRules = evaluator.parseJavaScriptChangeRules(changeConfig);
    }

    _cachedChangeSignature = signature;
    return _cachedRules!;
  }

  /// Vérifie si le format est structuré (converti) ou legacy JS
  bool _isStructuredFormat(List<dynamic> changeConfig) {
    // Le format structuré contient des Maps avec 'condition' et 'patchValues'
    // Le format legacy contient des strings
    if (changeConfig.isEmpty) return false;
    final firstItem = changeConfig.first;
    return firstItem is Map && firstItem.containsKey('condition');
  }

  /// Parse les règles depuis le format structuré
  List<ParsedChangeRule> _parseStructuredRules(List<dynamic> changeConfig) {
    final List<ParsedChangeRule> rules = [];

    for (final item in changeConfig) {
      if (item is Map<String, dynamic>) {
        final condition = item['condition'] as String? ?? '';
        final patchValues = item['patchValues'];

        if (condition.isNotEmpty && patchValues is Map) {
          rules.add(ParsedChangeRule(
            condition: condition,
            patchValues: Map<String, dynamic>.from(patchValues),
          ));
        }
      }
    }

    return rules;
  }

  /// Efface le cache des règles
  void clearCache() {
    _cachedRules = null;
    _cachedChangeSignature = null;
  }

  /// Réinitialise complètement le processeur
  void reset() {
    _isProcessing = false;
    clearCache();
  }
}
