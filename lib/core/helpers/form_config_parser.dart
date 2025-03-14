import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

/// Classe utilitaire pour parser la configuration des formulaires dynamiques
/// basés sur la configuration des modules GeoNature Monitoring
class FormConfigParser {
  /// Fusionne les configurations generiques et spécifiques en un seul schéma
  /// pour un type d'objet donné (visit, site, etc.)
  static Map<String, Map<String, dynamic>> mergeConfigurations(
      ObjectConfig? objectConfig) {
    if (objectConfig == null) {
      return {};
    }

    // Résultat final: un map où chaque clé est un nom de champ
    // et la valeur est la configuration fusionnée du champ
    final Map<String, Map<String, dynamic>> result = {};

    // Traiter d'abord les champs génériques
    if (objectConfig.generic != null) {
      objectConfig.generic!.forEach((key, genericConfig) {
        result[key] = _convertGenericFieldToMap(genericConfig);
      });
    }

    // Ensuite traiter les champs spécifiques (qui peuvent écraser les génériques)
    if (objectConfig.specific != null) {
      objectConfig.specific!.forEach((key, specificConfig) {
        // Si le champ existe déjà (déjà défini dans generic),
        // fusionner les configurations
        if (result.containsKey(key)) {
          result[key]!.addAll(specificConfig as Map<String, dynamic>);
        } else {
          // Sinon, ajouter le nouveau champ
          result[key] = specificConfig as Map<String, dynamic>;
        }
      });
    }

    return result;
  }

  /// Convertit un GenericFieldConfig en Map pour faciliter la fusion
  static Map<String, dynamic> _convertGenericFieldToMap(
      GenericFieldConfig config) {
    return {
      if (config.attributLabel != null) 'attribut_label': config.attributLabel,
      if (config.definition != null) 'definition': config.definition,
      'hidden': config.hidden ?? false,
      if (config.required != null) 'required': config.required,
      if (config.typeWidget != null) 'type_widget': config.typeWidget,
      if (config.typeUtil != null) 'type_util': config.typeUtil,
      if (config.multiSelect != null) 'multi_select': config.multiSelect,
      if (config.api != null) 'api': config.api,
      if (config.application != null) 'application': config.application,
      if (config.keyLabel != null) 'keyLabel': config.keyLabel,
      if (config.keyValue != null) 'keyValue': config.keyValue,
      if (config.multiple != null) 'multiple': config.multiple,
      if (config.values != null) 'values': config.values,
      if (config.default_ != null) 'default': config.default_,
      if (config.designStyle != null) 'designStyle': config.designStyle,
      if (config.dataPath != null) 'data_path': config.dataPath,
    };
  }

  /// Substitue les variables de type __MODULE.XXX par leur valeur dans la configuration
  static Map<String, Map<String, dynamic>> substituteVariables(
      Map<String, Map<String, dynamic>> config, CustomConfig? customConfig) {
    if (customConfig == null) {
      return config;
    }

    final result = Map<String, Map<String, dynamic>>.from(config);

    // Créer un map des variables de substitution
    final substitutions = <String, dynamic>{
      '__MODULE.B_DRAW_SITES_GROUP': customConfig.drawSitesGroup,
      '__MODULE.B_SYNTHESE': customConfig.synthese,
      '__MODULE.ID_LIST_OBSERVER': customConfig.idListObserver,
      '__MODULE.ID_LIST_TAXONOMY': customConfig.idListTaxonomy,
      '__MODULE.ID_MODULE': customConfig.idModule,
      '__MODULE.MODULE_CODE': customConfig.moduleCode,
      '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME':
          customConfig.taxonomyDisplayFieldName,
      '__MONITORINGS_PATH': customConfig.monitoringsPath,
    };

    // Parcourir toutes les configurations de champs
    result.forEach((fieldName, fieldConfig) {
      final updatedConfig = Map<String, dynamic>.from(fieldConfig);

      // Parcourir chaque propriété de la configuration du champ
      updatedConfig.forEach((propName, propValue) {
        if (propValue is String && propValue.contains('__MODULE.')) {
          // Chercher chaque variable à remplacer
          substitutions.forEach((varName, varValue) {
            if (propValue.contains(varName)) {
              // Remplacer la variable par sa valeur
              updatedConfig[propName] =
                  propValue.replaceAll(varName, varValue?.toString() ?? '');
            }
          });
        }
      });

      result[fieldName] = updatedConfig;
    });

    return result;
  }

  /// Détermine le type de widget Flutter à utiliser en fonction
  /// de la configuration du champ
  static String determineWidgetType(Map<String, dynamic> fieldConfig) {
    final String typeWidget = fieldConfig['type_widget']?.toString() ?? 'text';

    switch (typeWidget) {
      case 'text':
        return 'TextField';
      case 'textarea':
        return 'TextField_multiline';
      case 'date':
        return 'DatePicker';
      case 'time':
        return 'TimePicker';
      case 'number':
        return 'NumberField';
      case 'select':
        return 'DropdownButton';
      case 'datalist':
        return 'AutocompleteField';
      case 'bool_checkbox':
      case 'checkbox':
        return 'Checkbox';
      case 'observers':
        return 'ObserverField';
      case 'medias':
        return 'MediaUploadField';
      default:
        return 'TextField'; // Type par défaut
    }
  }

  /// Détermine les validations à appliquer au champ
  static Map<String, dynamic> determineValidations(
      Map<String, dynamic> fieldConfig) {
    final validations = <String, dynamic>{};

    // Validation required
    if (fieldConfig['required'] == true) {
      validations['required'] = true;
    }

    // Validation min/max pour les nombres
    if (fieldConfig['min'] != null) {
      validations['min'] = fieldConfig['min'];
    }
    if (fieldConfig['max'] != null) {
      validations['max'] = fieldConfig['max'];
    }

    return validations;
  }

  /// Détermine si un champ doit être masqué ou affiché conditionnellement
  static Map<String, dynamic> determineVisibility(
      Map<String, dynamic> fieldConfig) {
    final visibility = <String, dynamic>{};

    // Champ caché
    if (fieldConfig['hidden'] == true) {
      visibility['hidden'] = true;
    } else if (fieldConfig['hidden'] is String) {
      // Expression conditionnelle (à interpréter dans l'UI)
      visibility['hiddenCondition'] = fieldConfig['hidden'];
    }

    return visibility;
  }

  /// Génère un schéma unifié complet pour le formulaire
  static Map<String, dynamic> generateUnifiedSchema(
      ObjectConfig objectConfig, CustomConfig? customConfig) {
    // Fusionner les configurations generic et specific
    final mergedConfig = mergeConfigurations(objectConfig);

    // Substituer les variables
    final configWithSubstitutions =
        substituteVariables(mergedConfig, customConfig);

    // Schéma final unifié
    final unifiedSchema = <String, dynamic>{};

    // Liste des champs à exclure (comme dans l'application web)
    final fieldsToExclude = [
      'id_dataset',
      'uuid_base_visit',
      'nb_observations',
      // 'medias', // Le champ media doit être affiché
      'id_module',
      'id_digitiser',
      'observers_txt',
      'id_base_site', // Exclure le champ Site qui n'apparaît pas dans l'application web
    ];

    // Pour chaque champ, générer sa configuration complète
    configWithSubstitutions.forEach((fieldName, fieldConfig) {
      // Vérifier si le champ doit être caché
      // Si hidden est explicitement défini à true, on cache le champ
      // Si hidden est null ou false, on affiche le champ
      final bool isHidden = fieldConfig['hidden'] == true;

      // Vérifier si le type de widget est html (à exclure comme dans l'application web)
      final bool isHtmlWidget = fieldConfig['type_widget'] == 'html';

      // Vérifier si le champ est dans la liste des champs à exclure
      final bool isExcludedField = fieldsToExclude.contains(fieldName);

      // Ne pas inclure les champs cachés, html ou exclus dans le schéma final
      if (!isHidden && !isHtmlWidget && !isExcludedField) {
        unifiedSchema[fieldName] = {
          'attribut_label': fieldConfig['attribut_label'] ?? fieldName,
          'type_widget': fieldConfig['type_widget'] ?? 'text',
          'widget_type': determineWidgetType(fieldConfig),
          'required': fieldConfig['required'] == true,
          // Ajouter la propriété hidden pour référence future
          'hidden': fieldConfig['hidden'] ?? false,
          // Ajouter le nom du champ pour faciliter le tri ultérieur
          'attribut_name': fieldName,
          if (fieldConfig['description'] != null)
            'description': fieldConfig['description'],
          if (fieldConfig['default'] != null) 'default': fieldConfig['default'],
          if (fieldConfig['values'] != null) 'values': fieldConfig['values'],
          'validations': determineValidations(fieldConfig),
          'visibility': determineVisibility(fieldConfig),
        };
      }
    });

    return unifiedSchema;
  }

  /// Trie les champs du formulaire selon l'ordre défini dans display_properties
  static Map<String, dynamic> sortFormFields(
      Map<String, dynamic> unifiedSchema, List<String>? displayProperties) {
    if (displayProperties == null || displayProperties.isEmpty) {
      return unifiedSchema;
    }

    // Créer une liste des entrées du schéma pour pouvoir les trier
    final List<MapEntry<String, dynamic>> entries =
        unifiedSchema.entries.toList();

    // Trier les entrées selon l'ordre défini dans displayProperties
    entries.sort((a, b) {
      final indexA = displayProperties.indexOf(a.key);
      final indexB = displayProperties.indexOf(b.key);

      // Si un champ n'est pas dans displayProperties, le placer à la fin
      if (indexA == -1 && indexB == -1) {
        return 0; // Garder l'ordre original pour les champs non listés
      } else if (indexA == -1) {
        return 1; // Placer a après b
      } else if (indexB == -1) {
        return -1; // Placer a avant b
      } else {
        return indexA - indexB; // Trier selon l'ordre dans displayProperties
      }
    });

    // Reconstruire le Map trié
    final sortedSchema = <String, dynamic>{};
    for (final entry in entries) {
      sortedSchema[entry.key] = entry.value;
    }

    return sortedSchema;
  }

  /// Génère une liste de propriétés d'affichage par défaut
  /// en incluant tous les champs non cachés du schéma
  static List<String> generateDefaultDisplayProperties(
      Map<String, dynamic> unifiedSchema) {
    // Créer une liste de tous les champs non cachés
    final List<String> defaultDisplayProperties = [];

    // Ajouter d'abord les champs génériques importants
    final List<String> priorityFields = [
      'observers',
      'visit_date_min',
      'visit_date_max',
    ];

    // Ajouter les champs prioritaires s'ils existent dans le schéma
    for (final field in priorityFields) {
      if (unifiedSchema.containsKey(field) &&
          !(unifiedSchema[field]['hidden'] == true)) {
        defaultDisplayProperties.add(field);
      }
    }

    // Ajouter tous les autres champs non cachés et non prioritaires
    for (final entry in unifiedSchema.entries) {
      final fieldName = entry.key;
      final fieldConfig = entry.value;

      // Ne pas ajouter les champs déjà ajoutés ou cachés
      if (!defaultDisplayProperties.contains(fieldName) &&
          !(fieldConfig['hidden'] == true)) {
        // Placer les commentaires et médias à la fin
        if (fieldName == 'comments' || fieldName == 'medias') {
          continue; // On les ajoutera à la fin
        }
        defaultDisplayProperties.add(fieldName);
      }
    }

    // Ajouter les commentaires et médias à la fin
    if (unifiedSchema.containsKey('comments') &&
        !(unifiedSchema['comments']['hidden'] == true)) {
      defaultDisplayProperties.add('comments');
    }

    if (unifiedSchema.containsKey('medias') &&
        !(unifiedSchema['medias']['hidden'] == true)) {
      defaultDisplayProperties.add('medias');
    }

    return defaultDisplayProperties;
  }
}
