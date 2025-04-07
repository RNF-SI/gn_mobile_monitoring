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

  /// Détermine si un champ est de type nomenclature
  /// Prend en compte les différentes façons d'identifier un champ de nomenclature:
  /// 1. Ancienne méthode: type_util: "nomenclature" + type_widget: "datalist"
  /// 2. Nouvelle méthode: type_widget: "nomenclature"
  /// 3. URL dans le champ API: api: "nomenclatures/nomenclature/XXX"
  /// 4. Présence de la propriété code_nomenclature_type
  /// 5. Attribut commençant par id_nomenclature_
  static bool isNomenclatureField(Map<String, dynamic> fieldConfig) {
    // Vérifier la nouvelle méthode en priorité (type_widget: "nomenclature")
    if (fieldConfig['type_widget'] == 'nomenclature') {
      return true;
    }

    // Vérifier l'ancienne méthode (type_util: "nomenclature")
    if (fieldConfig['type_util'] == 'nomenclature') {
      return true;
    }

    // Vérifier si l'URL dans le champ api contient "nomenclatures/nomenclature/"
    final api = fieldConfig['api'] as String?;
    if (api != null && api.contains('nomenclatures/nomenclature/')) {
      return true;
    }

    // Vérifier si le champ possède une propriété code_nomenclature_type
    if (fieldConfig['code_nomenclature_type'] != null) {
      return true;
    }

    // Vérifier si le nom de l'attribut commence par id_nomenclature_
    final attributName = fieldConfig['attribut_name'] as String?;
    if (attributName != null && attributName.startsWith('id_nomenclature_')) {
      return true;
    }

    return false;
  }

  /// Détermine si un champ est de type taxonomie
  /// Prend en compte les différentes façons d'identifier un champ taxonomique:
  /// 1. type_widget: "taxonomy"
  /// 2. type_util: "taxonomy"
  /// 3. Présence de la propriété id_list référençant une liste taxonomique
  static bool isTaxonomyField(Map<String, dynamic> fieldConfig) {
    // Vérifier le type de widget
    if (fieldConfig['type_widget'] == 'taxonomy') {
      return true;
    }

    // Vérifier le type d'utilitaire
    if (fieldConfig['type_util'] == 'taxonomy') {
      return true;
    }

    // Vérifier si le champ contient une référence à une liste taxonomique
    final idList = fieldConfig['id_list'] as String?;
    if (idList != null && idList.contains('ID_LIST_TAXONOMY')) {
      return true;
    }

    // Vérifier si le nom de l'attribut est cd_nom
    final attributName = fieldConfig['attribut_name'] as String?;
    if (attributName == 'cd_nom') {
      return true;
    }

    return false;
  }

  /// Récupère les données de nomenclature depuis la configuration du champ
  /// Prend en compte tous les formats possibles:
  /// 1. Ancienne méthode: avec type_util et value contenant les informations
  /// 2. Nouvelle méthode: avec type_widget et attribut_name pour identifier le code
  /// 3. Avec code_nomenclature_type défini directement dans la configuration
  /// 4. Avec api contenant l'URL de la nomenclature
  static Map<String, dynamic>? getNomenclatureValue(
      Map<String, dynamic> fieldConfig) {
    if (!isNomenclatureField(fieldConfig)) {
      return null;
    }

    // Si la valeur est déjà présente, l'utiliser
    if (fieldConfig['value'] is Map<String, dynamic>) {
      return fieldConfig['value'] as Map<String, dynamic>;
    }

    // Déterminer le code du type de nomenclature en utilisant toutes les méthodes
    String? codeNomenclatureType;

    // 1. Utiliser la propriété code_nomenclature_type si elle existe
    if (fieldConfig['code_nomenclature_type'] != null) {
      codeNomenclatureType = fieldConfig['code_nomenclature_type'] as String?;
    }
    // 2. Sinon, essayer d'extraire depuis l'API
    else if (fieldConfig['api'] != null) {
      codeNomenclatureType = extractMnemonique(fieldConfig);
    }
    // 3. Finalement, essayer d'extraire depuis le nom de l'attribut
    else {
      codeNomenclatureType = _extractNomenclatureTypeFromAttributName(
          fieldConfig['attribut_name']);
    }

    // Pour tous les formats, construire un map avec les informations disponibles
    // Le format complet pourra être rempli lors de la sélection d'une nomenclature
    return {
      'attribut_name': fieldConfig['attribut_name'],
      'code_nomenclature_type': codeNomenclatureType,
      // Les autres valeurs seront remplies lors de la sélection
      'cd_nomenclature': null,
      'label_default': null,
    };
  }

  /// Extrait le code du type de nomenclature à partir du nom de l'attribut
  /// Par exemple: id_nomenclature_abondance_braunblanquet -> abondance_braunblanquet
  static String? _extractNomenclatureTypeFromAttributName(
      String? attributName) {
    if (attributName == null) return null;

    // Format attendu: id_nomenclature_XXXX ou id_nomenclature_XXXX_YYYY
    if (attributName.startsWith('id_nomenclature_')) {
      // Extraire la partie après "id_nomenclature_"
      return attributName.substring('id_nomenclature_'.length);
    }

    return null;
  }

  /// Extrait la mnémonique du type de nomenclature à partir du champ 'api'
  /// Format attendu: "nomenclatures/nomenclature/STADE_VIE" -> retourne "STADE_VIE"
  static String? extractMnemonique(Map<String, dynamic> fieldConfig) {
    final api = fieldConfig['api'] as String?;
    if (api == null || !api.contains('/')) {
      return null;
    }

    // Extraire la dernière partie de l'URL après le dernier '/'
    final parts = api.split('/');
    if (parts.isNotEmpty) {
      return parts.last;
    }

    return null;
  }

  /// Récupère le code du type de nomenclature à partir de la configuration
  /// Fonctionne avec les formats suivants (par ordre de priorité):
  /// 1. Directement à partir de la propriété code_nomenclature_type du champ
  /// 2. À partir de la valeur existante (value) qui contient code_nomenclature_type
  /// 3. À partir de la mnémonique extraite du champ 'api'
  /// 4. À partir du nom de l'attribut (id_nomenclature_XXX)
  static String? getNomenclatureTypeCode(Map<String, dynamic> fieldConfig) {
    // 1. Vérifier si la propriété existe directement dans fieldConfig
    if (fieldConfig['code_nomenclature_type'] != null) {
      return fieldConfig['code_nomenclature_type'] as String?;
    }

    // 2. Vérifier dans la valeur existante
    final value = getNomenclatureValue(fieldConfig);
    if (value != null && value['code_nomenclature_type'] != null) {
      return value['code_nomenclature_type'] as String?;
    }

    // 3. Essayer d'extraire la mnémonique depuis le champ 'api'
    final mnemonique = extractMnemonique(fieldConfig);
    if (mnemonique != null) {
      return mnemonique;
    }

    // 4. Essayer d'extraire le code du type à partir du nom de l'attribut
    if (fieldConfig['attribut_name'] != null) {
      return _extractNomenclatureTypeFromAttributName(
          fieldConfig['attribut_name'] as String);
    }

    return null;
  }

  /// Récupère le code de la nomenclature sélectionnée à partir de la configuration
  static String? getSelectedNomenclatureCode(Map<String, dynamic> fieldConfig) {
    final value = getNomenclatureValue(fieldConfig);
    if (value == null) return null;
    return value['cd_nomenclature'] as String?;
  }

  /// Récupère l'identifiant de la liste taxonomique à partir de la configuration du champ
  static int? getTaxonListId(Map<String, dynamic> fieldConfig) {
    if (!isTaxonomyField(fieldConfig)) {
      return null;
    }

    // Vérifier si c'est une référence à une liste taxonomique MODULE
    final idList = fieldConfig['id_list'] as String?;
    if (idList != null && idList.isNotEmpty) {
      // Si c'est une valeur numérique directe
      final directId = int.tryParse(idList);
      if (directId != null) {
        return directId;
      }

      // Si c'est une référence qui a été substituée
      if (idList.contains('__MODULE.ID_LIST_TAXONOMY')) {
        // Cette valeur devrait déjà être substituée par le bon ID
        return int.tryParse(idList);
      }
    }

    // Cas où l'ID de liste est stocké dans la valeur existante
    final value = fieldConfig['value'] as Map<String, dynamic>?;
    if (value != null && value['id_list'] != null) {
      return value['id_list'] as int?;
    }

    return null;
  }

  /// Récupère le cd_nom du taxon sélectionné à partir de la configuration
  static int? getSelectedTaxonCdNom(Map<String, dynamic> fieldConfig) {
    if (!isTaxonomyField(fieldConfig)) {
      return null;
    }

    // Si la valeur est directement un entier (cd_nom)
    if (fieldConfig['value'] is int) {
      return fieldConfig['value'] as int;
    }

    // Si la valeur est un objet Taxon complet
    final value = fieldConfig['value'] as Map<String, dynamic>?;
    if (value != null && value['cd_nom'] != null) {
      return value['cd_nom'] as int;
    }

    return null;
  }

  /// Récupère le format d'affichage configuré pour les taxons
  static String getTaxonomyDisplayFormat(Map<String, dynamic> fieldConfig) {
    final displayFormat = fieldConfig['taxonomy_display_field_name'] as String?;
    if (displayFormat != null && displayFormat.isNotEmpty) {
      return displayFormat;
    }

    // Valeur par défaut
    return 'nom_vern,lb_nom';
  }

  /// Détermine le type de widget Flutter à utiliser en fonction
  /// de la configuration du champ
  static String determineWidgetType(Map<String, dynamic> fieldConfig) {
    // Vérifier si c'est un champ de type nomenclature
    if (isNomenclatureField(fieldConfig)) {
      // Si le widget_type est déjà défini, l'utiliser (comme dans l'exemple fourni)
      if (fieldConfig['widget_type'] != null) {
        return fieldConfig['widget_type'].toString();
      }
      // Sinon utiliser le widget par défaut pour les nomenclatures
      return 'NomenclatureSelector';
    }

    // Vérifier si c'est un champ de type taxonomie
    if (isTaxonomyField(fieldConfig)) {
      return 'TaxonSelector';
    }

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
        // Vérifier si c'est un champ datalist qui est en fait une nomenclature
        if (fieldConfig['api'] != null &&
            fieldConfig['api']
                .toString()
                .contains('nomenclatures/nomenclature/')) {
          return 'NomenclatureSelector';
        }
        return 'AutocompleteField';
      case 'nomenclature':
        return 'NomenclatureSelector';
      case 'taxonomy':
        return 'TaxonSelector';
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
          // Ajouter les propriétés importantes pour les nomenclatures et taxonomies
          if (fieldConfig['api'] != null) 'api': fieldConfig['api'],
          if (fieldConfig['code_nomenclature_type'] != null)
            'code_nomenclature_type': fieldConfig['code_nomenclature_type'],
          if (fieldConfig['id_list'] != null) 'id_list': fieldConfig['id_list'],
          if (fieldConfig['type_util'] != null)
            'type_util': fieldConfig['type_util'],
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
