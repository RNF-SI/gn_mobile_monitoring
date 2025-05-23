import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/nomenclature_selector_widget.dart';
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
  });

  @override
  ConsumerState<DynamicFormBuilder> createState() => DynamicFormBuilderState();
}

class DynamicFormBuilderState extends ConsumerState<DynamicFormBuilder> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formValues;
  late Map<String, TextEditingController> _textControllers;
  late Map<String, dynamic> _unifiedSchema;

  /// Returns the onSubmit callback from the widget
  Function(Map<String, dynamic>)? get onSubmit => widget.onSubmit;

  @override
  void initState() {
    super.initState();
    _textControllers = {};
    _formValues = widget.initialValues ?? {};

    // Générer le schéma unifié
    _unifiedSchema = FormConfigParser.generateUnifiedSchema(
      widget.objectConfig,
      widget.customConfig,
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
      final dynamic initialValue = _formValues[fieldName];
      final String widgetType = fieldConfig['widget_type'];

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
          break;
        case 'TimePicker':
          _textControllers[fieldName] = TextEditingController(
            text: initialValue?.toString() ?? '',
          );
          break;
        // Les autres types de widgets n'utilisent pas de contrôleurs
      }
    });
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
    return Map<String, dynamic>.from(_formValues);
  }

  // Méthode pour mettre à jour une valeur et forcer le recalcul de la visibilité
  void updateFormValue(String fieldName, dynamic value) {
    debugPrint('Updating form value: $fieldName = $value');
    
    // Déterminer dynamiquement si c'est un champ critique en analysant le schéma
    final isCriticalField = _isCriticalField(fieldName);
    
    setState(() {
      if (value == null) {
        _formValues.remove(fieldName);
      } else {
        _formValues[fieldName] = value;
      }
      
      if (isCriticalField) {
        debugPrint('Critical field changed: $fieldName = $value');
        
        // Vérification des conditions de visibilité pour les champs qui pourraient être affectés
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
        
        // Ne débogue qu'un nombre limité de champs pour éviter une boucle infinie de logs
        int debuggedFields = 0;
        for (final entry in _unifiedSchema.entries) {
          if (entry.value.containsKey('hidden') && entry.value['hidden'] != false) {
            if (debuggedFields < 5) { // Limiter à 5 champs maximum
              final isHidden = formDataProcessor.isFieldHidden(
                entry.key, 
                evaluationContext,
                fieldConfig: entry.value
              );
              debugPrint('Field ${entry.key} hidden condition = $isHidden');
              debuggedFields++;
            }
          }
        }
      }
      
      // Les conditions de visibilité seront réévaluées lors de la prochaine construction
    });
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
    // Débogage: limiter les logs pour éviter la surcharge
    // debugPrint('Building form with values: $_formValues');
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Option de basculement pour l'enchaînement des saisies
          if (widget.objectConfig.chained == true && widget.chainInput != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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
  
  /// Identifie tous les champs critiques qui pourraient affecter la visibilité
  Set<String> _getAllCriticalFields() {
    final Set<String> criticalFields = {};
    
    // 1. Les champs de taxonomie sont toujours critiques
    for (final key in _formValues.keys) {
      if (key == 'cd_nom' || key.contains('cd_nom') || key.contains('espece')) {
        criticalFields.add(key);
      }
    }
    
    // 2. Analyser le schéma pour trouver tous les champs qui sont référencés 
    // dans les expressions 'hidden' d'autres champs
    for (final entry in _unifiedSchema.entries) {
      if (entry.value.containsKey('hidden') && entry.value['hidden'] is String) {
        final String hiddenExpr = entry.value['hidden'] as String;
        
        // Analyser l'expression pour trouver les noms de champs référencés
        // Pattern: value['nom_du_champ']
        final RegExp fieldRefPattern = RegExp(r"value\['([^']+)'\]");
        final matches = fieldRefPattern.allMatches(hiddenExpr);
        
        for (final match in matches) {
          if (match.groupCount >= 1) {
            criticalFields.add(match.group(1)!);
          }
        }
      }
    }
    
    return criticalFields;
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

    // Évaluer si le champ doit être masqué
    if (formDataProcessor.isFieldHidden(fieldName, evaluationContext,
        fieldConfig: fieldConfig)) {
      return const SizedBox.shrink(); // Ne pas afficher ce champ
    }

    // Si le champ n'est pas masqué, construire le widget approprié
    return _buildFieldWidget(fieldName, fieldConfig);
  }

  // Méthode qui construit le widget approprié pour le champ
  Widget _buildFieldWidget(String fieldName, Map<String, dynamic> fieldConfig) {
    final String widgetType = fieldConfig['widget_type'];
    final String label = fieldConfig['attribut_label'];
    final bool isRequired = fieldConfig['validations']['required'] == true;
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
      case 'Checkbox':
        return _buildCheckboxField(fieldName, label, description: description);
      case 'AutocompleteField':
        return _buildAutocompleteField(
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: maxLines,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onChanged: (value) {
              _formValues[fieldName] = value;
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              hintText: 'Sélectionner une date',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _formValues[fieldName] ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _textControllers[fieldName]!.text =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  _formValues[fieldName] = date;
                });
              }
            },
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              hintText: 'Sélectionner une heure',
              suffixIcon: Icon(Icons.access_time),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldName],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
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
              _formValues[fieldName] = int.tryParse(value) ?? value;
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            isExpanded: true,
            value: _formValues[fieldName]?.toString(),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option.key,
                child: Text(
                  option.value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            validator: required
                ? (value) => value == null ? 'Ce champ est requis' : null
                : null,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _formValues[fieldName] = value;
                });
              }
            },
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
      padding: const EdgeInsets.only(bottom: 16.0),
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

  // Pour les champs de type "datalist" (généralement des APIs externes)
  Widget _buildAutocompleteField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {
    // Note: Pour une implémentation réelle, il faudrait connecter à l'API source
    // Ce qui nécessite plus de code et une gestion réseau
    // Ici, nous proposons une version simplifiée

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
          if (fieldConfig['api'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Source: ${fieldConfig['api']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Version simplifiée - Dans une implémentation réelle,
          // on utiliserait un vrai widget Autocomplete avec API
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Rechercher...',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onChanged: (value) {
              // Simulation: en réalité, on devrait faire une requête à l'API
              setState(() {
                _formValues[fieldName] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Pour les champs de type "observers"
  Widget _buildObserverField(String fieldName, String label, bool required,
      {String? description}) {
    // Initialiser la valeur si elle n'existe pas ou n'est pas une liste
    if (_formValues[fieldName] == null || _formValues[fieldName] is! List) {
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          // Afficher les observateurs sélectionnés
          if (_formValues[fieldName] is List &&
              (_formValues[fieldName] as List).isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  (_formValues[fieldName] as List<int>).map<Widget>((observer) {
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
          const SizedBox(height: 8),
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
    
    // Vérifier et corriger les valeurs de nomenclature
    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];
      
      // Si la valeur est un entier, la convertir en map
      if (value is int) {
        _formValues[fieldName] = {'id': value};
      }
    }
    
    // Construire un widget de sélection de nomenclature
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
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

  // Pour les champs de type taxonomie
  Widget _buildTaxonField(String fieldName, String label, bool required,
      Map<String, dynamic> fieldConfig,
      {String? description}) {
    // Déterminer la valeur initiale (cd_nom)
    int? initialValue;

    if (_formValues.containsKey(fieldName)) {
      final value = _formValues[fieldName];
      if (value is int) {
        initialValue = value;
      } else if (value is Map<String, dynamic> && value.containsKey('cd_nom')) {
        initialValue = value['cd_nom'] as int?;
      }
    } else {
      // Essayer de récupérer depuis la configuration
      initialValue = FormConfigParser.getSelectedTaxonCdNom(fieldConfig);
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
        padding: const EdgeInsets.only(bottom: 16.0),
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
            const SizedBox(height: 8),
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
          TaxonSelectorWidget(
            label: label,
            moduleId: moduleId,
            fieldConfig: mergedConfig,
            value: initialValue,
            isRequired: required,
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
          const SizedBox(height: 8),
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
                value: initialValue,
                hint: Text('Sélectionner un jeu de données'),
                items: datasets.map((dataset) {
                  return DropdownMenuItem<int>(
                    value: dataset.id,
                    child: Text(dataset.datasetName),
                  );
                }).toList(),
                validator: required
                    ? (value) => value == null ? 'Ce champ est requis' : null
                    : null,
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
