import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/change_rule_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/nomenclature_selector_widget.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/multiple_nomenclature_selector_widget.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/taxon_selector_widget.dart';

/// Un widget qui génère un formulaire dynamique
/// basé sur la configuration d'un module GeoNature Monitoring
class DynamicFormBuilder extends ConsumerStatefulWidget {
  /// La configuration de l'objet (visite, site, etc.)
  final ObjectConfig objectConfig;

  /// La configuration personnalisée du module
  final CustomConfig? customConfig;

  /// Les valeurs initiales du formulaire (pour l'édition)
  final Map<String, dynamic>? initialValues;

  /// Callback appelé lors de la soumission du formulaire
  final Function(Map<String, dynamic> values)? onSubmit;

  /// Flag indiquant si on doit activer l'enchaînement des saisies
  final bool? chainInput;

  /// Callback pour modifier l'état d'enchaînement des saisies
  final Function(bool)? onChainInputChanged;

  /// Liste des propriétés à afficher dans l'ordre
  final List<String>? displayProperties;

  /// ID de la liste taxonomique du module
  final int? idListTaxonomy;

  /// Type d'objet pour appliquer des exclusions spécifiques (ex: 'site', 'sites_group', 'visit', 'observation')
  final String? objectType;

  const DynamicFormBuilder({
    super.key,
    required this.objectConfig,
    this.customConfig,
    this.initialValues,
    this.onSubmit,
    this.chainInput,
    this.onChainInputChanged,
    this.displayProperties,
    this.idListTaxonomy,
    this.objectType,
  });

  @override
  ConsumerState<DynamicFormBuilder> createState() => DynamicFormBuilderState();
}

class DynamicFormBuilderState extends ConsumerState<DynamicFormBuilder> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formValues;
  late Map<String, TextEditingController> _textControllers;
  late Map<String, dynamic> _unifiedSchema;
  final Set<String> _userClearedFields = <String>{};
  late Set<String> _criticalFields;

  /// Flag pour éviter les boucles infinies lors de l'application des règles de changement
  bool _isApplyingChangeRules = false;

  /// Champs qui ont été définis par les règles de changement
  /// Ces champs doivent être préservés à la sauvegarde même s'ils sont cachés
  final Set<String> _fieldsSetByChangeRules = <String>{};

  /// Returns the onSubmit callback from the widget
  Function(Map<String, dynamic>)? get onSubmit => widget.onSubmit;

  @override
  void initState() {
    super.initState();
    _textControllers = {};
    _formValues = Map<String, dynamic>.from(widget.initialValues ?? {});

    // Générer le schéma unifié
    _unifiedSchema = FormConfigParser.generateUnifiedSchema(
      widget.objectConfig,
      widget.customConfig,
      objectType: widget.objectType,
    );


    // Trier les champs selon l'ordre défini dans displayProperties
    if (widget.displayProperties != null &&
        widget.displayProperties!.isNotEmpty) {
      _unifiedSchema = FormConfigParser.sortFormFields(
        _unifiedSchema,
        widget.displayProperties,
      );
    } else {
      // Si aucune propriété d'affichage n'est spécifiée, générer une liste par défaut
      final defaultDisplayProperties =
          FormConfigParser.generateDefaultDisplayProperties(_unifiedSchema);

      _unifiedSchema = FormConfigParser.sortFormFields(
        _unifiedSchema,
        defaultDisplayProperties,
      );
    }

    // Identifier les champs critiques qui affectent la visibilité/validation d'autres champs
    _criticalFields = _getAllCriticalFields();

    _initControllers();

    // Précharger les nomenclatures nécessaires pour ce formulaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadNomenclatures();
    });
  }

  @override
  void dispose() {
    // Libérer les contrôleurs
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initControllers() {
    // Initialiser les contrôleurs pour chaque champ
    _unifiedSchema.forEach((fieldName, fieldConfig) {
      final String widgetType = fieldConfig['widget_type'];

      // Initialiser les valeurs par défaut de manière intelligente
      // (champs visibles + champs cachés si explicitement requis)
      _initializeDefaultValue(fieldName, fieldConfig);

      // Récupérer la valeur après initialisation par défaut
      final dynamic initialValue = _formValues[fieldName];

      switch (widgetType) {
        case 'TextField':
        case 'TextField_multiline':
        case 'NumberField':
          _textControllers[fieldName] = TextEditingController(
            text: initialValue?.toString() ?? '',
          );
          break;
        case 'DatePicker':
          _textControllers[fieldName] = TextEditingController(
            text: initialValue != null
                ? (initialValue is DateTime)
                    ? '${initialValue.day.toString().padLeft(2, '0')}/${initialValue.month.toString().padLeft(2, '0')}/${initialValue.year}'
                    : initialValue.toString()
                : '',
          );
          // S'assurer que la valeur est stockée au format string pour la sérialisation JSON
          if (initialValue is DateTime) {
            _formValues[fieldName] = initialValue.toIso8601String().split('T')[0];
          }
          break;
        case 'TimePicker':
          _textControllers[fieldName] = TextEditingController(
            text: initialValue?.toString() ?? '',
          );
          break;
        // Les autres types de widgets n'utilisent pas de contrôleurs mais leurs valeurs
        // par défaut sont déjà initialisées par _initializeDefaultValue ci-dessus
      }
    });
  }

  /// Initialise la valeur par défaut pour un champ si elle n'existe pas déjà
  /// 
  /// Cette méthode applique une logique nuancée :
  /// - Initialise toujours les champs visibles
  /// - Initialise les champs cachés SEULEMENT si explicitement demandé ou nécessaire
  void _initializeDefaultValue(String fieldName, Map<String, dynamic> fieldConfig) {
    // Si le champ a déjà une valeur, ne pas l'écraser
    if (_formValues.containsKey(fieldName)) {
      return;
    }

    // Si l'utilisateur a explicitement supprimé ce champ, ne pas le réinitialiser
    if (_userClearedFields.contains(fieldName)) {
      if (fieldName == 'cd_nom') {
        debugPrint('🐛 [DEBUG] cd_nom ignoré car supprimé par l\'utilisateur');
      }
      return;
    }

    final dynamic defaultValue = fieldConfig['default'] ?? fieldConfig['value'];
    if (defaultValue == null) {
      return; // Aucune valeur par défaut à initialiser
    }

    // IMPORTANT: Selon les spécifications de persistance des valeurs cachées,
    // TOUS les champs avec des valeurs par défaut doivent être initialisés,
    // qu'ils soient cachés ou visibles. hidden = propriété d'affichage uniquement.
    
    // La logique précédente qui évitait d'initialiser les champs cachés
    // est supprimée pour respecter le principe fondamental :
    // "hidden = propriété d'affichage uniquement, PAS de traitement des données"

    // Procéder à l'initialisation
    _setDefaultValueByType(fieldName, fieldConfig, defaultValue);
  }

  /// Détermine si un champ caché doit être initialisé avec sa valeur par défaut
  /// 
  /// Critères d'initialisation pour les champs cachés :
  /// 1. Annotation explicite 'initialize_when_hidden': true
  /// 2. Champs requis avec 'required': true (logique métier)
  /// 3. Champs avec 'always_initialize': true
  bool _shouldInitializeHiddenField(String fieldName, Map<String, dynamic> fieldConfig) {
    // Critère 1: Annotation explicite
    if (fieldConfig['initialize_when_hidden'] == true) {
      return true;
    }
    
    // Critère 2: Champs requis avec 'always_initialize'
    if (fieldConfig['always_initialize'] == true) {
      return true;
    }
    
    // Critère 3: Champs requis pour la logique métier (cas spéciaux)
    // Par exemple, facteurs de correction, coefficients, etc.
    if (_isMetadataField(fieldName, fieldConfig)) {
      return true;
    }
    
    return false;
  }

  /// Détermine si un champ est un champ de métadonnées nécessaire même quand caché
  bool _isMetadataField(String fieldName, Map<String, dynamic> fieldConfig) {
    // Exemples de champs métadonnées qui pourraient être nécessaires
    final metadataPatterns = [
      'facteur_correction',
      'coefficient_',
      '_metadata',
      'version_',
      'default_'
    ];
    
    return metadataPatterns.any((pattern) => fieldName.contains(pattern));
  }

  /// Prépare un contexte d'évaluation initial basé sur les valeurs initiales et par défaut
  Map<String, dynamic> _prepareInitialEvaluationContext() {
    final formDataProcessor = ref.read(formDataProcessorProvider);
    
    // Utiliser les valeurs initiales du widget + valeurs déjà présentes
    final initialValues = Map<String, dynamic>.from(widget.initialValues ?? {});
    initialValues.addAll(_formValues);
    
    return formDataProcessor.prepareEvaluationContext(
      values: initialValues,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );
  }

  /// Définit la valeur par défaut en fonction du type de widget
  void _setDefaultValueByType(String fieldName, Map<String, dynamic> fieldConfig, dynamic defaultValue) {
    final String widgetType = fieldConfig['widget_type'];

    // Debug pour cd_nom
    if (fieldName == 'cd_nom') {
      debugPrint('🐛 [DEBUG] _setDefaultValueByType pour cd_nom: defaultValue=$defaultValue, type=${defaultValue.runtimeType}');
    }

    switch (widgetType) {
      case 'RadioButton':
        _formValues[fieldName] = defaultValue.toString();
        break;
      case 'TaxonSelector':
        if (defaultValue is int) {
          _formValues[fieldName] = defaultValue;
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom défini à: $defaultValue');
          }
        } else if (defaultValue is Map && defaultValue['cd_nom'] != null) {
          _formValues[fieldName] = defaultValue['cd_nom'];
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom extrait de Map: ${defaultValue['cd_nom']}');
          }
        }
        break;
      case 'NomenclatureSelector':
        if (defaultValue is Map) {
          _formValues[fieldName] = defaultValue;
        } else if (defaultValue is int) {
          _formValues[fieldName] = {'id': defaultValue};
        }
        break;
      case 'Checkbox':
        _formValues[fieldName] = defaultValue == true || defaultValue == 'true';
        break;
      case 'DatasetSelector':
        if (defaultValue is int) {
          _formValues[fieldName] = defaultValue;
        }
        break;
      default:
        // Pour les autres types, stocker la valeur directement
        _formValues[fieldName] = defaultValue;
        break;
    }
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _formValues.clear();
    _textControllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {});

    // Remonter en haut du formulaire après réinitialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Précharge toutes les nomenclatures nécessaires pour ce formulaire
  void _preloadNomenclatures() {
    try {
      // Identifie tous les champs de nomenclature dans le formulaire
      final nomenclatureFields = _unifiedSchema.entries
          .where((entry) => FormConfigParser.isNomenclatureField(entry.value))
          .toList();

      // Si aucun champ de nomenclature n'est trouvé, on s'arrête
      if (nomenclatureFields.isEmpty) return;

      // Récupére tous les types de nomenclature uniques
      final Set<String> typeCodes = {};

      for (final field in nomenclatureFields) {
        final typeCode = FormConfigParser.getNomenclatureTypeCode(field.value);
        if (typeCode != null && typeCode.isNotEmpty) {
          typeCodes.add(typeCode);
        }
      }

      // Précharger les nomenclatures
      if (typeCodes.isNotEmpty) {
        // Récupérer le service de nomenclature
        final nomenclatureService =
            ref.read(nomenclatureServiceProvider.notifier);

        // Précharger les nomenclatures pour tous les types identifiés
        nomenclatureService.preloadNomenclatures(typeCodes.toList());
      }
    } catch (e) {
      print('Erreur lors du préchargement des nomenclatures: $e');
    }
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getFormValues() {
    // LOGIQUE DE FILTRAGE DES CHAMPS CACHÉS :
    // - Champs required + cachés → CONSERVER (nécessaires pour la BDD)
    // - Champs non-required + cachés → SUPPRIMER (données non-pertinentes)
    // - Champs visibles → CONSERVER toujours
    
    final Map<String, dynamic> filteredValues = {};
    
    // Préparer le contexte d'évaluation pour déterminer la visibilité
    final formDataProcessor = ref.read(formDataProcessorProvider);
    final evaluationContext = formDataProcessor.prepareEvaluationContext(
      values: _formValues,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );
    
    // Examiner chaque champ pour décider s'il doit être inclus
    _unifiedSchema.forEach((fieldName, fieldConfig) {
      if (!_formValues.containsKey(fieldName)) {
        return; // Pas de valeur pour ce champ
      }
      
      final fieldValue = _formValues[fieldName];
      
      // Ignorer les valeurs explicitement null (champs supprimés par l'utilisateur)
      if (fieldValue == null) {
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] cd_nom ignoré car null (supprimé par utilisateur)');
        }
        return;
      }
      
      // Déterminer si le champ est caché
      final isHidden = formDataProcessor.isFieldHidden(
        fieldName,
        evaluationContext,
        fieldConfig: fieldConfig,
        allFieldsConfig: _unifiedSchema,
      );
      
      if (!isHidden) {
        // Champ visible → toujours inclure
        filteredValues[fieldName] = fieldValue;
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] cd_nom inclus (visible): $fieldValue');
        }
      } else {
        // Champ caché → vérifier s'il est required
        // Gérer les deux formats possibles : fieldConfig['required'] ou fieldConfig['validations']['required']
        bool isRequired = false;
        
        // Format 1: required directement dans fieldConfig (ex: configuration serveur)
        if (fieldConfig.containsKey('required')) {
          isRequired = fieldConfig['required'] == true;
        }
        
        // Format 2: required dans validations (ex: configuration locale)
        if (!isRequired && fieldConfig.containsKey('validations')) {
          final validations = fieldConfig['validations'] as Map<String, dynamic>? ?? {};
          isRequired = validations['required'] == true;
        }
        
        if (isRequired) {
          // Champ caché mais required → conserver pour éviter erreur BDD
          filteredValues[fieldName] = fieldValue;
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom inclus (caché mais required): $fieldValue');
          }
        } else if (_fieldsSetByChangeRules.contains(fieldName)) {
          // Champ caché mais défini par une règle de changement → conserver
          // C'est le comportement voulu : ex. présence="Non" → cd_nom="Amphibia"
          filteredValues[fieldName] = fieldValue;
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom inclus (caché mais défini par règle de changement): $fieldValue');
          }
        } else {
          // Champ caché et non-required et non défini par règle → supprimer
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom SUPPRIMÉ (caché et non-required): $fieldValue');
          }
        }
      }
    });
    
    return filteredValues;
  }

  /// Retourne toutes les valeurs du formulaire (y compris les champs cachés)
  /// Utilisé principalement pour les tests et le debug
  @visibleForTesting
  Map<String, dynamic> getAllFormValues() {
    return Map<String, dynamic>.from(_formValues);
  }

  // Méthode pour mettre à jour une valeur et forcer le recalcul de la visibilité
  void updateFormValue(String fieldName, dynamic value) {
    // Debug pour cd_nom
    if (fieldName == 'cd_nom') {
      debugPrint('🐛 [DEBUG] updateFormValue appelée pour cd_nom: value=$value, type=${value.runtimeType}');
      debugPrint('🐛 [DEBUG] Valeur actuelle dans _formValues: ${_formValues[fieldName]}');
      debugPrint('🐛 [DEBUG] Stack trace: ${StackTrace.current}');
    }

    setState(() {
      // Si l'utilisateur modifie manuellement un champ (pas via règle de changement),
      // retirer ce champ de la liste des champs définis par règle
      if (!_isApplyingChangeRules && _fieldsSetByChangeRules.contains(fieldName)) {
        _fieldsSetByChangeRules.remove(fieldName);
        debugPrint('📝 [ChangeRule] Champ "$fieldName" retiré des règles (modification manuelle)');
      }

      if (value == null) {
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] ⚠️ SUPPRESSION de cd_nom car value=null !');
        }
        // NE PAS supprimer le champ, mais le mettre à null pour éviter
        // que _buildTaxonField aille chercher la valeur par défaut dans la config
        _formValues[fieldName] = null;
        // Marquer ce champ comme explicitement supprimé par l'utilisateur
        _userClearedFields.add(fieldName);
      } else {
        _formValues[fieldName] = value;
        // Supprimer de la liste des champs supprimés car l'utilisateur a défini une nouvelle valeur
        _userClearedFields.remove(fieldName);
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] cd_nom mis à jour: $value');
        }
      }
    });

    // Traiter les règles de changement si on n'est pas déjà en train de les appliquer
    if (!_isApplyingChangeRules) {
      _processChangeRules(fieldName);
    }

    // Si c'est un champ critique (qui affecte la visibilité/validation d'autres champs),
    // forcer un rafraîchissement supplémentaire pour mettre à jour les labels et validations
    if (_criticalFields.contains(fieldName)) {
      setState(() {});
    }
  }

  /// Traite les règles de changement après modification d'un champ
  void _processChangeRules(String triggerFieldName) {
    // Récupérer la configuration "change" depuis l'objectConfig
    final changeConfig = widget.objectConfig.change;

    // Si pas de configuration change, rien à faire
    if (changeConfig == null || changeConfig.isEmpty) {
      return;
    }

    final processor = ref.read(changeRuleProcessorProvider);

    final result = processor.processChangeRules(
      formValues: _formValues,
      changeConfig: changeConfig,
      triggerFieldName: triggerFieldName,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );

    if (result.hasChanges) {
      _applyChangeRuleResults(result);
    }
  }

  /// Applique les résultats des règles de changement
  void _applyChangeRuleResults(ChangeRuleResult result) {
    _isApplyingChangeRules = true;
    try {
      setState(() {
        // Appliquer les nouvelles valeurs
        result.fieldsToUpdate.forEach((fieldName, newValue) {
          _formValues[fieldName] = newValue;

          // Marquer ce champ comme défini par une règle de changement
          // pour qu'il soit préservé même s'il est caché
          _fieldsSetByChangeRules.add(fieldName);
          debugPrint('📝 [ChangeRule] Champ "$fieldName" marqué comme défini par règle de changement');

          // Mettre à jour le TextEditingController si nécessaire
          if (_textControllers.containsKey(fieldName)) {
            final controller = _textControllers[fieldName]!;
            final newText = newValue?.toString() ?? '';
            if (controller.text != newText) {
              controller.text = newText;
            }
          }

          // Supprimer des champs effacés par l'utilisateur puisqu'on définit une nouvelle valeur
          _userClearedFields.remove(fieldName);
        });
      });
    } finally {
      _isApplyingChangeRules = false;
    }
  }
  
  /// Détermine si un champ est critique (peut affecter la visibilité d'autres champs)
  bool _isCriticalField(String fieldName) {
    // 1. Les champs de taxonomie sont toujours critiques
    if (fieldName == 'cd_nom' || fieldName.contains('cd_nom')) {
      return true;
    }
    
    // 2. Analyser le schéma pour trouver tous les champs qui sont référencés 
    // dans les expressions 'hidden' d'autres champs
    final Set<String> referencedFields = {};
    
    for (final entry in _unifiedSchema.entries) {
      if (entry.value.containsKey('hidden') && entry.value['hidden'] is String) {
        final String hiddenExpr = entry.value['hidden'] as String;
        
        // Analyser l'expression pour trouver les noms de champs référencés
        // Pattern: value['nom_du_champ']
        final RegExp fieldRefPattern = RegExp(r"value\['([^']+)'\]");
        final matches = fieldRefPattern.allMatches(hiddenExpr);
        
        for (final match in matches) {
          if (match.groupCount >= 1) {
            referencedFields.add(match.group(1)!);
          }
        }
      }
    }
    
    // 3. Vérifier si le champ courant est référencé dans des expressions hidden
    return referencedFields.contains(fieldName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Option de basculement pour l'enchaînement des saisies
          if (widget.objectConfig.chained == true && widget.chainInput != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 13.0),
              child: Row(
                children: [
                  const Text('Enchaîner les saisies'),
                  Switch(
                    value: widget.chainInput!,
                    onChanged: widget.onChainInputChanged,
                  ),
                ],
              ),
            ),

          // Construire le formulaire dynamiquement - la clé ValueKey force la reconstruction
          // lorsque les valeurs critiques changent
          ...buildFormFieldsWithKey(),
        ],
      ),
    );
  }
  
  // Construire les champs avec une clé basée sur les valeurs
  List<Widget> buildFormFieldsWithKey() {
    // Utiliser une clé basée sur un hash des valeurs des champs critiques
    // Cette approche force la reconstruction quand ces valeurs changent
    final keyValues = <String, dynamic>{};
    
    // Identifier tous les champs critiques qui pourraient affecter la visibilité
    final Set<String> criticalFields = _getAllCriticalFields();
    
    // Collecter les valeurs des champs critiques pour la clé
    for (final fieldName in criticalFields) {
      if (_formValues.containsKey(fieldName)) {
        keyValues[fieldName] = _formValues[fieldName];
      }
    }
    
    // Ajouter la valeur actuelle du chainInput
    keyValues['chainInput'] = widget.chainInput;
    
    // Construire les champs normalement
    final formFields = _buildFormFields();
    
    // Clé unique basée sur les valeurs importantes
    // Convertir en string de manière déterministe pour éviter les rebuilds inutiles
    final entriesList = keyValues.entries.toList();
    entriesList.sort((a, b) => a.key.compareTo(b.key));
    final keyString = entriesList
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    
    // Envelopper dans un widget avec clé
    return [
      KeyedSubtree(
        key: ValueKey(keyString),
        child: Column(children: formFields),
      ),
    ];
  }
  
  /// Identifie tous les champs critiques qui pourraient affecter la visibilité ou validation
  Set<String> _getAllCriticalFields() {
    final Set<String> criticalFields = {};

    // 1. Les champs de taxonomie sont toujours critiques
    for (final key in _formValues.keys) {
      if (key == 'cd_nom' || key.contains('cd_nom') || key.contains('espece')) {
        criticalFields.add(key);
      }
    }

    // 2. Analyser le schéma pour trouver tous les champs qui sont référencés
    // dans les expressions 'hidden' ou 'required' d'autres champs
    for (final entry in _unifiedSchema.entries) {
      // Analyser les expressions 'hidden'
      if (entry.value.containsKey('hidden') && entry.value['hidden'] is String) {
        final String hiddenExpr = entry.value['hidden'] as String;

        // Analyser l'expression pour trouver les noms de champs référencés
        // Pattern: value['nom_du_champ'] ou value.nom_du_champ
        final RegExp fieldRefPattern = RegExp(r"value\['([^']+)'\]|value\.(\w+)");
        final matches = fieldRefPattern.allMatches(hiddenExpr);

        for (final match in matches) {
          if (match.groupCount >= 1) {
            final fieldName = match.group(1) ?? match.group(2);
            if (fieldName != null) {
              criticalFields.add(fieldName);
            }
          }
        }
      }

      // Analyser les expressions 'required'
      if (entry.value.containsKey('required') && entry.value['required'] is String) {
        final String requiredExpr = entry.value['required'] as String;

        // Analyser l'expression pour trouver les noms de champs référencés
        final RegExp fieldRefPattern = RegExp(r"value\['([^']+)'\]|value\.(\w+)");
        final matches = fieldRefPattern.allMatches(requiredExpr);

        for (final match in matches) {
          if (match.groupCount >= 1) {
            final fieldName = match.group(1) ?? match.group(2);
            if (fieldName != null) {
              criticalFields.add(fieldName);
            }
          }
        }
      }
    }

    return criticalFields;
  }

  /// Vérifie si un champ est actuellement caché
  bool _isFieldCurrentlyHidden(String fieldName) {
    final formDataProcessor = ref.read(formDataProcessorProvider);

    // Préparer le contexte d'évaluation
    final evaluationContext = formDataProcessor.prepareEvaluationContext(
      values: _formValues,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );

    // Vérifier si le champ est caché
    final fieldConfig = _unifiedSchema[fieldName];
    if (fieldConfig == null) {
      return false;
    }

    return formDataProcessor.isFieldHidden(
      fieldName,
      evaluationContext,
      fieldConfig: fieldConfig,
      allFieldsConfig: _unifiedSchema,
    );
  }

  List<Widget> _buildFormFields() {
    final List<Widget> formFields = [];

    // Créer une liste de tous les champs sans distinction de groupe
    final List<MapEntry<String, dynamic>> allFields =
        _unifiedSchema.entries.toList();

    // Créer une seule carte pour tous les champs
    if (allFields.isNotEmpty) {
      formFields.add(
        Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...allFields
                    .map((field) => _buildField(field.key, field.value)),
                // Note: Pour utiliser la version asynchrone, il faudrait utiliser un FutureBuilder par champ,
                // ce qui complexifierait le code. Nous gardons la version synchrone pour le moment.
                // À terme, on pourrait envisager de retravailler cette partie pour utiliser la version asynchrone.
              ],
            ),
          ),
        ),
      );
    }

    return formFields;
  }

  // Méthode pour vérifier et construire un champ de formulaire
  Widget _buildField(String fieldName, Map<String, dynamic> fieldConfig) {
    // Vérifier si le champ doit être masqué selon la configuration
    final formDataProcessor = ref.read(formDataProcessorProvider);

    // Préparer le contexte d'évaluation avec les valeurs actuelles du formulaire
    // et les métadonnées disponibles
    final Map<String, dynamic> evaluationContext =
        formDataProcessor.prepareEvaluationContext(
      values: _formValues,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );

    // Évaluer si le champ doit être masqué (avec support des cascades)
    final isHidden = formDataProcessor.isFieldHidden(fieldName, evaluationContext,
        fieldConfig: fieldConfig, allFieldsConfig: _unifiedSchema);

    if (isHidden) {
      return const SizedBox.shrink(); // Ne pas afficher ce champ
    }

    // Si le champ n'est pas masqué, construire le widget approprié
    return _buildFieldWidget(fieldName, fieldConfig);
  }

  // Méthode qui construit le widget approprié pour le champ
  Widget _buildFieldWidget(String fieldName, Map<String, dynamic> fieldConfig) {
    final String widgetType = fieldConfig['widget_type'];
    final String label = fieldConfig['attribut_label'];

    // Évaluer si le champ est requis (supporte les expressions conditionnelles)
    final formDataProcessor = ref.read(formDataProcessorProvider);
    final Map<String, dynamic> evaluationContext =
        formDataProcessor.prepareEvaluationContext(
      values: _formValues,
      metadata: {
        'bChainInput': widget.chainInput ?? false,
        'parents': {
          'site': widget.objectConfig,
          'module': widget.customConfig?.idModule,
        },
        'dataset': widget.customConfig?.idListTaxonomy,
      },
    );

    // Utiliser la nouvelle méthode pour évaluer required (supporte les expressions)
    final bool isRequired = formDataProcessor.isFieldRequired(
      fieldName,
      evaluationContext,
      fieldConfig: fieldConfig,
    );

    final String? description = fieldConfig['description'];

    // Vérifier si c'est le champ des observateurs par son nom
    if (fieldName == 'observers') {
      return _buildObserverField(fieldName, label, isRequired,
          description: description);
    }

    switch (widgetType) {
      case 'TextField':
        return _buildTextField(fieldName, label, isRequired,
            maxLines: 1, description: description);
      case 'TextField_multiline':
        return _buildTextField(fieldName, label, isRequired,
            maxLines: 3, description: description);
      case 'DatePicker':
        return _buildDateField(fieldName, label, isRequired,
            description: description);
      case 'TimePicker':
        return _buildTimeField(fieldName, label, isRequired,
            description: description);
      case 'NumberField':
        return _buildNumberField(
            fieldName, label, isRequired, fieldConfig['validations'],
            description: description);
      case 'DropdownButton':
        return _buildSelectField(
            fieldName, label, isRequired, fieldConfig['values'],
            description: description);
      case 'DatalistField':
        return _buildDatalistField(
            fieldName, label, isRequired, fieldConfig,
            description: description);
      case 'Checkbox':
        return _buildCheckboxField(fieldName, label, description: description);
      case 'RadioButton':
        return _buildRadioField(
            fieldName, label, isRequired, fieldConfig,
            description: description);
      case 'ObserverField':
        return _buildObserverField(fieldName, label, isRequired,
            description: description);
      case 'NomenclatureSelector':
        return _buildNomenclatureField(
            fieldName, label, isRequired, fieldConfig,
            description: description);
      case 'TaxonSelector':
        return _buildTaxonField(fieldName, label, isRequired, fieldConfig,
            description: description);
      case 'DatasetSelector':
        return _buildDatasetField(fieldName, label, isRequired, fieldConfig,
            description: description);
      default:
        return _buildTextField(fieldName, label, isRequired,
            maxLines: 1, description: description);
    }
  }

  Widget _buildTextField(String fieldName, String label, bool required,
      {int maxLines = 1, String? description}) {
    _textControllers[fieldName] ??= TextEditingController(
      text: _formValues[fieldName]?.toString() ?? '',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('${fieldName}_$required'),
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: maxLines,
            validator: (value) {
              // Ne pas valider les champs cachés
              if (_isFieldCurrentlyHidden(fieldName)) {
                return null;
              }
              // Valider si requis
              if (required && (value == null || value.isEmpty)) {
                return 'Ce champ est requis';
              }
              return null;
            },
            onChanged: (value) {
              updateFormValue(fieldName, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String fieldName, String label, bool required,
      {String? description}) {
    _textControllers[fieldName] ??= TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('${fieldName}_$required'),
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              hintText: 'Sélectionner une date',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            validator: (value) {
              // Ne pas valider les champs cachés
              if (_isFieldCurrentlyHidden(fieldName)) {
                return null;
              }
              // Valider si requis
              if (required && (value == null || value.isEmpty)) {
                return 'Ce champ est requis';
              }
              // Validation des dates futures pour les dates de début de visite
              if (value != null && value.isNotEmpty && _isStartDateField(fieldName)) {
                final selectedDate = _formValues[fieldName] is DateTime
                    ? _formValues[fieldName] as DateTime
                    : (_formValues[fieldName] is String)
                        ? DateTime.tryParse(_formValues[fieldName] as String)
                        : null;

                if (selectedDate != null) {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final dateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

                  if (dateOnly.isAfter(today)) {
                    return 'La date ne peut pas être dans le futur';
                  }
                }
              }
              return null;
            },
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _formValues[fieldName] is DateTime
                    ? _formValues[fieldName] as DateTime
                    : (_formValues[fieldName] is String && (_formValues[fieldName] as String).isNotEmpty)
                        ? DateTime.tryParse(_formValues[fieldName] as String) ?? DateTime.now()
                        : DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _textControllers[fieldName]!.text =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  // Stocker la date au format ISO string pour la sérialisation JSON
                  _formValues[fieldName] = date.toIso8601String().split('T')[0]; // Garde seulement la partie date (YYYY-MM-DD)
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// Détermine si un champ de date est une date de début de visite
  bool _isStartDateField(String fieldName) {
    // Liste des noms de champs qui représentent des dates de début de visite
    const startDateFields = [
      'visit_date_min',
    ];
    return startDateFields.contains(fieldName);
  }

  Widget _buildTimeField(String fieldName, String label, bool required,
      {String? description}) {
    // Initialiser le controller avec la valeur existante si disponible
    if (_formValues.containsKey(fieldName) && _formValues[fieldName] != null) {
      final timeValue = _formValues[fieldName].toString();
      _textControllers[fieldName] = TextEditingController(text: timeValue);
    } else {
      _textControllers[fieldName] ??= TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('${fieldName}_$required'),
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              hintText: 'Sélectionner une heure',
              suffixIcon: Icon(Icons.access_time),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            validator: (value) {
              // Ne pas valider les champs cachés
              if (_isFieldCurrentlyHidden(fieldName)) {
                return null;
              }
              // Valider si requis
              if (required && (value == null || value.isEmpty)) {
                return 'Ce champ est requis';
              }
              return null;
            },
            onTap: () async {
              // Initialiser avec la valeur existante si disponible
              TimeOfDay initialTime = TimeOfDay.now();
              if (_textControllers[fieldName]!.text.isNotEmpty) {
                try {
                  final parts = _textControllers[fieldName]!.text.split(':');
                  if (parts.length == 2) {
                    final hour = int.tryParse(parts[0].trim());
                    final minute = int.tryParse(parts[1].trim());
                    if (hour != null && minute != null) {
                      initialTime = TimeOfDay(hour: hour, minute: minute);
                    }
                  }
                } catch (_) {
                  // En cas d'erreur, utiliser l'heure actuelle
                }
              }

              final time = await showTimePicker(
                context: context,
                initialTime: initialTime,
              );
              if (time != null) {
                setState(() {
                  _textControllers[fieldName]!.text =
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  _formValues[fieldName] = _textControllers[fieldName]!.text;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String fieldName, String label, bool required,
      Map<String, dynamic> validations,
      {String? description}) {
    _textControllers[fieldName] ??= TextEditingController(
      text: _formValues[fieldName]?.toString() ??
          (validations['default'] != null
              ? validations['default'].toString()
              : ''),
    );

    // Si une valeur par défaut existe et que le champ n'a pas encore de valeur
    if (validations['default'] != null && !_formValues.containsKey(fieldName)) {
      _formValues[fieldName] = validations['default'];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              // Ne pas valider les champs cachés
              if (_isFieldCurrentlyHidden(fieldName)) {
                return null;
              }
              if (required && (value == null || value.isEmpty)) {
                return 'Ce champ est requis';
              }
              if (value != null && value.isNotEmpty) {
                final number = int.tryParse(value);
                if (number == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                if (validations['min'] != null && number < validations['min']) {
                  return 'La valeur doit être supérieure ou égale à ${validations['min']}';
                }
                if (validations['max'] != null && number > validations['max']) {
                  return 'La valeur doit être inférieure ou égale à ${validations['max']}';
                }
              }
              return null;
            },
            onChanged: (value) {
              final parsedValue = int.tryParse(value);
              updateFormValue(fieldName, parsedValue ?? (value.isEmpty ? null : value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField(
      String fieldName, String label, bool required, List<dynamic>? values,
      {String? description}) {
    // Préparer les options pour le menu déroulant
    final options = <MapEntry<String, String>>[];

    if (values != null) {
      for (final value in values) {
        if (value is String) {
          options.add(MapEntry(value, value));
        } else if (value is Map<String, dynamic>) {
          final keyValue = value['value']?.toString() ?? '';
          final keyLabel =
              value['label']?.toString() ?? value['value']?.toString() ?? '';
          options.add(MapEntry(keyValue, keyLabel));
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            isExpanded: true,
            initialValue: _formValues[fieldName]?.toString(),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option.key,
                child: Text(
                  option.value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            validator: (value) {
              // Ne pas valider les champs cachés
              if (_isFieldCurrentlyHidden(fieldName)) {
                return null;
              }
              if (required && value == null) {
                return 'Ce champ est requis';
              }
              return null;
            },
            onChanged: (value) {
              if (value != null) {
                updateFormValue(fieldName, value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatalistField(
      String fieldName, String label, bool required, Map<String, dynamic> fieldConfig,
      {String? description}) {
    
    // Préparer les données source selon le type (API ou valeurs statiques)
    List<Map<String, dynamic>> dataSource = [];
    
    if (fieldConfig['values'] is List) {
      // Cas 1: Valeurs statiques (values)
      final values = fieldConfig['values'] as List;
      for (final value in values) {
        if (value is String) {
          dataSource.add({
            'value': value,
            'label': value,
          });
        } else if (value is Map<String, dynamic>) {
          dataSource.add({
            'value': value['value']?.toString() ?? '',
            'label': value['label']?.toString() ?? value['value']?.toString() ?? '',
          });
        }
      }
    }
    
    // Pour l'instant, nous gérons seulement les valeurs statiques
    // Les API seront implémentées dans une version ultérieure
    
    final isMultiple = fieldConfig['multiple'] == true;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          isMultiple 
            ? _buildMultiSelectDatalist(fieldName, dataSource, required)
            : _buildSingleSelectDatalist(fieldName, dataSource, required),
        ],
      ),
    );
  }

  /// Widget pour datalist à sélection simple avec recherche/filtrage
  Widget _buildSingleSelectDatalist(String fieldName, List<Map<String, dynamic>> dataSource, bool required) {
    final TextEditingController controller = _textControllers.putIfAbsent(
      fieldName, 
      () => TextEditingController()
    );
    
    // Initialiser l'affichage avec la valeur actuelle
    if (_formValues[fieldName] != null) {
      final currentValue = _formValues[fieldName].toString();
      final item = dataSource.firstWhere(
        (item) => item['value'] == currentValue, 
        orElse: () => {'value': currentValue, 'label': currentValue}
      );
      controller.text = item['label'] ?? '';
    }

    return _AutocompleteField(
      fieldName: fieldName,
      controller: controller,
      dataSource: dataSource,
      required: required,
      isFieldHidden: _isFieldCurrentlyHidden(fieldName),
      onSelected: (option) {
        controller.text = option['label'] ?? '';
        setState(() {
          _formValues[fieldName] = option['value'];
        });
      },
    );
  }

  /// Widget pour datalist à sélection multiple avec checkbox
  Widget _buildMultiSelectDatalist(String fieldName, List<Map<String, dynamic>> dataSource, bool required) {
    // Initialiser la valeur comme une liste si ce n'est pas déjà fait
    if (_formValues[fieldName] == null) {
      _formValues[fieldName] = <String>[];
    } else if (_formValues[fieldName] is Map) {
      _formValues[fieldName] = <String>[];
    } else if (_formValues[fieldName] is! List) {
      // Convertir une valeur unique en liste
      final currentValue = _formValues[fieldName];
      _formValues[fieldName] = currentValue != null ? [currentValue.toString()] : <String>[];
    }

    //final selectedValues = List<String>.from(_formValues[fieldName] as List);
    
    final rawValue = _formValues[fieldName];
    List<String> selectedValues;
    if (rawValue is List) {
      selectedValues = rawValue.map((e) => e.toString()).toList();
    } else {
      // Fallback: si ce n'est toujours pas une List, initialiser à vide
      selectedValues = <String>[];
      _formValues[fieldName] = selectedValues;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // En-tête avec compteur de sélections
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.checklist, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${selectedValues.length} sélection(s)',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Liste des options avec checkbox
          ...dataSource.map((option) {
            final isSelected = selectedValues.contains(option['value']);
            return CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Text(
                option['label'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!selectedValues.contains(option['value'])) {
                      selectedValues.add(option['value'].toString());
                    }
                  } else {
                    selectedValues.remove(option['value']);
                  }
                  _formValues[fieldName] = List<String>.from(selectedValues);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
          // Message de validation
          if (required && selectedValues.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Text(
                'Ce champ est requis',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckboxField(String fieldName, String label,
      {String? description}) {
    // Initialiser la valeur si elle n'existe pas
    _formValues[fieldName] ??= false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _formValues[fieldName] == true,
                onChanged: (value) {
                  setState(() {
                    _formValues[fieldName] = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(label)),
            ],
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioField(String fieldName, String label, bool isRequired,
      Map<String, dynamic> fieldConfig, {String? description}) {
    // Récupérer les valeurs possibles et la valeur par défaut
    final List<dynamic> values = fieldConfig['values'] ?? [];
    final String? defaultValue = 
        fieldConfig['default']?.toString() ?? 
        fieldConfig['value']?.toString();
    
    // Initialiser la valeur si elle n'existe pas
    if (_formValues[fieldName] == null && defaultValue != null) {
      _formValues[fieldName] = defaultValue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: FormField<String>(
        key: ValueKey('${fieldName}_${isRequired}_${_formValues[fieldName]}'),
        initialValue: _formValues[fieldName]?.toString(),
        validator: (value) {
          // Ne pas valider les champs cachés
          if (_isFieldCurrentlyHidden(fieldName)) {
            return null;
          }
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Ce champ est requis';
          }
          return null;
        },
        builder: (FormFieldState<String> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRequired ? '$label *' : label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              _buildRadioOptions(fieldName, values, field),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Construit les options radio avec disposition adaptative (horizontale ou verticale)
  Widget _buildRadioOptions(String fieldName, List<dynamic> values, FormFieldState<String> field) {
    // Déterminer si on doit utiliser une disposition horizontale ou verticale
    final shouldUseHorizontalLayout = _shouldUseHorizontalLayout(values);
    
    if (shouldUseHorizontalLayout) {
      // Disposition horizontale avec Wrap pour gérer le retour à la ligne
      return Wrap(
        spacing: 16.0,
        runSpacing: 8.0,
        children: values.map<Widget>((value) {
          final stringValue = value.toString();
          return _buildCompactRadioTile(fieldName, stringValue, field);
        }).toList(),
      );
    } else {
      // Disposition verticale traditionnelle
      return Column(
        children: values.map<Widget>((value) {
          final stringValue = value.toString();
          return _buildFullRadioTile(fieldName, stringValue, field);
        }).toList(),
      );
    }
  }

  /// Détermine si la disposition horizontale doit être utilisée
  bool _shouldUseHorizontalLayout(List<dynamic> values) {
    // Critères pour la disposition horizontale :
    // 1. Maximum 4 options
    // 2. Chaque option a moins de 15 caractères
    // 3. La somme totale des caractères est raisonnable
    
    if (values.length > 4) return false;
    
    int totalCharacters = 0;
    for (final value in values) {
      final stringValue = value.toString();
      if (stringValue.length > 15) return false;
      totalCharacters += stringValue.length;
    }
    
    // Si le total dépasse 40 caractères, utiliser la disposition verticale
    return totalCharacters <= 40;
  }

  /// Construit un radio tile compact pour la disposition horizontale
  Widget _buildCompactRadioTile(String fieldName, String stringValue, FormFieldState<String> field) {
    return InkWell(
      onTap: () {
        setState(() {
          _formValues[fieldName] = stringValue;
          field.didChange(stringValue);
        });
        updateFormValue(fieldName, stringValue);
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: stringValue,
              groupValue: _formValues[fieldName]?.toString(),
              onChanged: (String? selectedValue) {
                setState(() {
                  _formValues[fieldName] = selectedValue;
                  field.didChange(selectedValue);
                });
                updateFormValue(fieldName, selectedValue);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            Text(
              stringValue,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un radio tile traditionnel pour la disposition verticale
  Widget _buildFullRadioTile(String fieldName, String stringValue, FormFieldState<String> field) {
    return RadioListTile<String>(
      title: Text(stringValue),
      value: stringValue,
      groupValue: _formValues[fieldName]?.toString(),
      onChanged: (String? selectedValue) {
        setState(() {
          _formValues[fieldName] = selectedValue;
          field.didChange(selectedValue);
        });
        updateFormValue(fieldName, selectedValue);
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  // Pour les champs de type "observers"
  Widget _buildObserverField(String fieldName, String label, bool required,
      {String? description}) {
    // Gérer le cas où la valeur initiale est un entier (pour id_inventor par exemple)
    // et la convertir en liste si nécessaire
    if (_formValues[fieldName] != null && _formValues[fieldName] is! List) {
      final value = _formValues[fieldName];
      if (value is int) {
        _formValues[fieldName] = <int>[value];
      } else if (value is String) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          _formValues[fieldName] = <int>[intValue];
        } else {
          _formValues[fieldName] = <int>[];
        }
      } else if (value is num) {
        _formValues[fieldName] = <int>[value.toInt()];
      } else {
        _formValues[fieldName] = <int>[];
      }
    }

    // Initialiser la valeur si elle n'existe pas
    if (_formValues[fieldName] == null) {
      _formValues[fieldName] = <int>[];
    }

    // S'assurer que tous les éléments de la liste sont des entiers
    if (_formValues[fieldName] is List) {
      final List originalList = _formValues[fieldName] as List;
      final List<int> safeList = [];

      for (final item in originalList) {
        if (item is int) {
          safeList.add(item);
        } else if (item is String) {
          // Tenter de convertir les chaînes en entiers
          final intValue = int.tryParse(item);
          if (intValue != null) {
            safeList.add(intValue);
          }
        } else if (item is num) {
          // Convertir les nombres en entiers
          safeList.add(item.toInt());
        }
      }

      _formValues[fieldName] = safeList;
    }

    // Déterminer si on doit afficher les chips ou seulement le message
    // En mode création, on n'affiche pas les chips car l'utilisateur sera ajouté automatiquement
    // On affiche les chips uniquement si la liste contient plusieurs observateurs
    // (ce qui indique qu'on est en mode édition avec des observateurs supplémentaires)
    final List<int> observersList = _formValues[fieldName] is List 
        ? List<int>.from(_formValues[fieldName] as List) 
        : <int>[];
    
    // Ne pas afficher les chips si la liste ne contient qu'un seul observateur
    // (probablement l'utilisateur courant qui sera ajouté automatiquement)
    // Afficher les chips uniquement si la liste contient plusieurs observateurs
    final bool shouldShowChips = observersList.length > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          // Afficher les observateurs sélectionnés uniquement en mode édition
          if (shouldShowChips)
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: observersList.map<Widget>((observer) {
                return Chip(
                  label: Text('Observateur #$observer'),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  deleteIcon: Icon(Icons.close,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  onDeleted: () {
                    setState(() {
                      (_formValues[fieldName] as List).remove(observer);
                    });
                  },
                );
              }).toList(),
            ),
          if (shouldShowChips) const SizedBox(height: 4),
          // Champ désactivé pour indiquer que les observateurs sont déjà sélectionnés
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vous êtes automatiquement ajouté comme observateur',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pour les champs de type nomenclature
  Widget _buildNomenclatureField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {

    // Vérifier si le champ permet la sélection multiple
    final bool isMultiple = fieldConfig['multiple'] == true;

    if (isMultiple) {
      // Utiliser le widget de sélection multiple
      return _buildMultipleNomenclatureField(
        fieldName,
        label,
        required,
        fieldConfig,
        description: description,
      );
    }

    // Vérifier et corriger les valeurs de nomenclature (sélection simple)
    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];

      // Si la valeur est un entier, la convertir en map
      if (value is int) {
        _formValues[fieldName] = {'id': value};
      }
    }

    // Construire un widget de sélection de nomenclature simple
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          NomenclatureSelectorWidget(
            label: label,
            fieldConfig: fieldConfig,
            value: _formValues[fieldName] is Map<String, dynamic>
                ? _formValues[fieldName] as Map<String, dynamic>
                : (_formValues[fieldName] is int
                    ? {'id': _formValues[fieldName]}
                    : null),
            isRequired: required,
            onChanged: (value) {
              setState(() {
                if (value == null) {
                  _formValues.remove(fieldName);
                } else {
                  _formValues[fieldName] = value;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Pour les champs de nomenclature à sélection multiple
  Widget _buildMultipleNomenclatureField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {

    // Préparer la valeur : convertir en List<int> si nécessaire
    List<int>? currentValue;

    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];

      if (value is List) {
        // Convertir tous les éléments en int
        currentValue = value.map((e) {
          if (e is int) return e;
          if (e is Map && e.containsKey('id')) return e['id'] as int;
          return int.tryParse(e.toString());
        }).whereType<int>().toList();
      } else if (value is int) {
        // Convertir un seul int en liste
        currentValue = [value];
      } else if (value is Map && value.containsKey('id')) {
        // Extraire l'ID d'une map
        currentValue = [value['id'] as int];
      }
    }

    return MultipleNomenclatureSelectorWidget(
      label: label,
      fieldConfig: fieldConfig,
      value: currentValue,
      isRequired: required,
      description: description,
      onChanged: (value) {
        setState(() {
          if (value == null || value.isEmpty) {
            _formValues.remove(fieldName);
          } else {
            // Stocker comme liste d'IDs pour être compatible avec le format web
            _formValues[fieldName] = value;
          }
        });
      },
    );
  }

  // Pour les champs de type taxonomie
  Widget _buildTaxonField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {
    // Déterminer la valeur initiale (cd_nom)
    int? initialValue;

    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];
      if (value == null) {
        // La valeur a été explicitement mise à null (supprimée par l'utilisateur)
        initialValue = null;
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] cd_nom explicitement null dans _formValues');
        }
      } else if (value is int) {
        initialValue = value;
      } else if (value is Map<String, dynamic> && value.containsKey('cd_nom')) {
        initialValue = value['cd_nom'] as int?;
      }
    } else {
      // Vérifier si l'utilisateur a explicitement supprimé ce champ
      if (_userClearedFields.contains(fieldName)) {
        initialValue = null;
        if (fieldName == 'cd_nom') {
          debugPrint('🐛 [DEBUG] cd_nom ignoré car supprimé par utilisateur');
        }
      } else {
        // Ne récupérer depuis la configuration QUE si l'utilisateur n'a pas explicitement supprimé le champ
        if (!_userClearedFields.contains(fieldName)) {
          initialValue = FormConfigParser.getSelectedTaxonCdNom(fieldConfig);
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom récupéré depuis config: $initialValue');
          }
        } else {
          initialValue = null;
          if (fieldName == 'cd_nom') {
            debugPrint('🐛 [DEBUG] cd_nom ignoré (supprimé par utilisateur)');
          }
        }
      }
    }

    // Pour obtenir l'ID du module
    final int moduleId = widget.customConfig?.idModule ?? 0;

    // Récupérer la configuration originale du champ depuis l'objectConfig
    final originalFieldConfig = widget.objectConfig.generic?[fieldName];

    // Fusionner les configurations en donnant la priorité à la configuration originale
    final mergedConfig = Map<String, dynamic>.from(fieldConfig);
    if (originalFieldConfig != null) {
      // Convertir GenericFieldConfig en Map<String, dynamic>
      mergedConfig.addAll({
        'attribut_label': originalFieldConfig.attributLabel,
        'type_widget': originalFieldConfig.typeWidget,
        'type_util': originalFieldConfig.typeUtil,
        'required': originalFieldConfig.required,
        'hidden': originalFieldConfig.hidden,
        'id_list': originalFieldConfig.idList,
        // Transférer les valeurs spécifiques pour les boutons radio
        if (originalFieldConfig.value != null)
          'value': originalFieldConfig.value,
        if (originalFieldConfig.values != null)
          'values': originalFieldConfig.values,
      });
    }

    // Cas spécial pour les boutons radio de taxonomie
    if ((mergedConfig['type_widget'] == 'radio' ||
            mergedConfig['typeWidget'] == 'radio') &&
        mergedConfig['values'] is List) {
      final List values = mergedConfig['values'] as List;

      return Padding(
        padding: const EdgeInsets.only(bottom: 13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              required ? '$label *' : label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            ...values.map<Widget>((option) {
              // Extraire la valeur et le libellé
              final int optionValue =
                  option is Map ? (option['value'] as int) : (option as int);
              final String optionLabel = option is Map
                  ? (option['label'] as String)
                  : optionValue.toString();

              return RadioListTile<int>(
                title: Text(optionLabel),
                value: optionValue,
                groupValue: initialValue,
                onChanged: (newValue) {
                  // Utiliser la méthode spécifique pour mettre à jour les valeurs
                  // qui garantit la réévaluation des conditions de visibilité
                  updateFormValue(fieldName, newValue);
                },
                activeColor: Theme.of(context).colorScheme.primary,
                dense: true,
              );
            }),
          ],
        ),
      );
    }

    // Cas standard: utiliser le TaxonSelectorWidget
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TaxonSelectorWidget(
            label: label,
            moduleId: moduleId,
            fieldConfig: mergedConfig,
            value: initialValue,
            isRequired: required,
            userCleared: _userClearedFields.contains(fieldName),
            onChanged: (cdNom) {
              // Utiliser la méthode spécifique pour mettre à jour les valeurs
              // qui garantit la réévaluation des conditions de visibilité
              updateFormValue(fieldName, cdNom);
            },
            idListTaxonomy: widget.idListTaxonomy,
          ),
        ],
      ),
    );
  }

  // Pour les champs de type dataset
  Widget _buildDatasetField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {
    // Récupérer le service de datasets
    final datasetService = ref.read(datasetServiceProvider);

    // Obtenir l'ID du module
    final int moduleId = widget.customConfig?.idModule ?? 0;

    // Déterminer la valeur initiale
    int? initialValue;
    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];
      if (value is int) {
        initialValue = value;
      } else if (value is String && int.tryParse(value) != null) {
        initialValue = int.parse(value);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          const SizedBox(height: 4),
          FutureBuilder<List<Dataset>>(
            future: datasetService.getDatasetsForModule(moduleId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(
                  'Erreur lors du chargement des datasets: ${snapshot.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                );
              }

              final datasets = snapshot.data ?? [];

              if (datasets.isEmpty) {
                return Text(
                  'Aucun dataset disponible pour ce module',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                );
              }

              // Si nous avons une seule valeur et aucune valeur initiale,
              // sélectionner automatiquement cette valeur
              if (datasets.length == 1 && initialValue == null) {
                // Mettre à jour après la construction du widget pour éviter des erreurs
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _formValues[fieldName] = datasets.first.id;
                    });
                  }
                });
              }

              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                initialValue: initialValue,
                hint: Text('Sélectionner un jeu de données'),
                items: datasets.map((dataset) {
                  return DropdownMenuItem<int>(
                    value: dataset.id,
                    child: Text(dataset.datasetName),
                  );
                }).toList(),
                validator: (value) {
                  // Ne pas valider les champs cachés
                  if (_isFieldCurrentlyHidden(fieldName)) {
                    return null;
                  }
                  if (required && value == null) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      _formValues.remove(fieldName);
                    } else {
                      _formValues[fieldName] = value;
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget helper pour gérer la synchronisation des contrôleurs dans Autocomplete
class _AutocompleteField extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  final List<Map<String, dynamic>> dataSource;
  final bool required;
  final bool isFieldHidden;
  final Function(Map<String, dynamic>) onSelected;

  const _AutocompleteField({
    required this.fieldName,
    required this.controller,
    required this.dataSource,
    required this.required,
    required this.isFieldHidden,
    required this.onSelected,
  });

  @override
  State<_AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<_AutocompleteField> {
  TextEditingController? _autocompleteController;
  VoidCallback? _listener;
  bool _isUpdatingFromMain = false;
  bool _isUpdatingFromAutocomplete = false;

  @override
  void initState() {
    super.initState();
    // Synchroniser après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _autocompleteController != null) {
        _syncControllers();
        _setupListener();
      }
    });
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _syncControllers() {
    if (_autocompleteController != null && mounted && !_isUpdatingFromAutocomplete) {
      if (_autocompleteController!.text != widget.controller.text) {
        _isUpdatingFromMain = true;
        _autocompleteController!.text = widget.controller.text;
        _isUpdatingFromMain = false;
      }
    }
  }

  void _setupListener() {
    // Retirer l'ancien listener s'il existe
    _removeListener();
    
    // Ajouter un seul listener sur le contrôleur principal
    _listener = () {
      if (mounted && _autocompleteController != null && !_isUpdatingFromAutocomplete) {
        if (_autocompleteController!.text != widget.controller.text) {
          _isUpdatingFromMain = true;
          _autocompleteController!.text = widget.controller.text;
          _isUpdatingFromMain = false;
        }
      }
    };
    widget.controller.addListener(_listener!);
  }

  void _removeListener() {
    if (_listener != null) {
      widget.controller.removeListener(_listener!);
      _listener = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Map<String, dynamic>>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.dataSource;
        }
        return widget.dataSource.where((option) {
          return option['label']
              .toString()
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (option) => option['label'] ?? '',
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Stocker la référence au contrôleur d'Autocomplete
        if (_autocompleteController != textEditingController) {
          _autocompleteController = textEditingController;
          // Synchroniser après le build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _syncControllers();
              _setupListener();
            }
          });
        }
        
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            suffixIcon: Icon(Icons.arrow_drop_down),
            hintText: 'Rechercher...',
          ),
          validator: (value) {
            // Ne pas valider les champs cachés
            if (widget.isFieldHidden) {
              return null;
            }
            if (widget.required && (value == null || value.isEmpty)) {
              return 'Ce champ est requis';
            }
            return null;
          },
          onChanged: (value) {
            // Synchroniser le contrôleur principal avec celui d'Autocomplete
            // uniquement si la mise à jour ne vient pas du listener principal
            if (!_isUpdatingFromMain && widget.controller.text != value) {
              _isUpdatingFromAutocomplete = true;
              widget.controller.text = value;
              _isUpdatingFromAutocomplete = false;
            }
          },
        );
      },
      onSelected: widget.onSelected,
    );
  }
}
