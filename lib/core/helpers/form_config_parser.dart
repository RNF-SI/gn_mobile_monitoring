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
      if (config.change != null) 'change': config.change,
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

    // Vérifier si le champ contient une référence ou valeur de liste taxonomique
    final dynamic idList = fieldConfig['id_list'];
    
    // Si c'est une référence chaîne à une liste taxonomique
    if (idList is String && idList.contains('ID_LIST_TAXONOMY')) {
      return true;
    }
    
    // Si c'est une valeur entière directe (id_list numérique)
    if (idList is int || (idList is String && int.tryParse(idList) != null)) {
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

    // Vérifier si c'est une liste taxonomique définie en tant qu'entier directement
    final dynamic rawIdList = fieldConfig['id_list'];
    if (rawIdList != null) {
      // Si c'est directement un entier
      if (rawIdList is int) {
        return rawIdList;
      }
      
      // Si c'est une chaîne
      if (rawIdList is String && rawIdList.isNotEmpty) {
        // Si c'est une valeur numérique sous forme de chaîne
        final directId = int.tryParse(rawIdList);
        if (directId != null) {
          return directId;
        }

        // Si c'est une référence qui a été substituée
        if (rawIdList.contains('__MODULE.ID_LIST_TAXONOMY')) {
          // Cette valeur devrait déjà être substituée par le bon ID
          return int.tryParse(rawIdList);
        }
      }
    }

    // Essayer d'extraire l'ID de liste depuis le champ 'api'
    final api = fieldConfig['api'] as String?;
    if (api != null && api.contains('allnamebylist/')) {
      // Format attendu: "taxref/allnamebylist/100" -> retourne 100
      final parts = api.split('/');
      if (parts.length > 2 && parts[parts.length - 2] == 'allnamebylist') {
        final listIdStr = parts.last;
        final listId = int.tryParse(listIdStr);
        if (listId != null) {
          return listId;
        }
      }
    }

    // Cas où l'ID de liste est stocké dans la valeur existante
    final value = fieldConfig['value'];
    if (value is Map<String, dynamic> && value['id_list'] != null) {
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

    // Vérifier si c'est un champ de dataset (par nom ou par type_util)
    if (fieldConfig['attribut_name'] == 'id_dataset' || 
        fieldConfig['type_util'] == 'dataset') {
      return 'DatasetSelector';
    }

    // Vérifier si type_util est "date" (pour les champs comme last_visit)
    if (fieldConfig['type_util'] == 'date') {
      return 'DatePicker';
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
      case 'dataset':
        return 'DatasetSelector';
      case 'datalist':
        // Vérifier si c'est un champ datalist qui est en fait une nomenclature
        if (fieldConfig['api'] != null &&
            fieldConfig['api']
                .toString()
                .contains('nomenclatures/nomenclature/')) {
          return 'NomenclatureSelector';
        }
        // Sinon utiliser le widget datalist générique
        return 'DatalistField';
      case 'nomenclature':
        return 'NomenclatureSelector';
      case 'taxonomy':
        return 'TaxonSelector';
      case 'bool_checkbox':
      case 'checkbox':
        return 'Checkbox';
      case 'radio':
        return 'RadioButton';
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
  /// 
  /// [objectType] permet de spécifier le type d'objet pour appliquer des exclusions
  /// spécifiques (ex: 'site', 'sites_group', 'visit', 'observation')
  static Map<String, dynamic> generateUnifiedSchema(
      ObjectConfig objectConfig, CustomConfig? customConfig,
      {String? objectType}) {
    // Fusionner les configurations generic et specific
    final mergedConfig = mergeConfigurations(objectConfig);
    
    // Debug: vérifier si les champs problématiques sont dans mergedConfig
    if (objectType == 'site') {
      print('🔍 DEBUG mergedConfig pour site:');
      print('  - Champs dans mergedConfig: ${mergedConfig.keys.toList()}');
      print('  - last_visit présent: ${mergedConfig.containsKey('last_visit')}');
      print('  - nb_visits présent: ${mergedConfig.containsKey('nb_visits')}');
      if (mergedConfig.containsKey('last_visit')) {
        print('  - last_visit config: ${mergedConfig['last_visit']}');
      }
      if (mergedConfig.containsKey('nb_visits')) {
        print('  - nb_visits config: ${mergedConfig['nb_visits']}');
      }
    }

    // Substituer les variables
    final configWithSubstitutions =
        substituteVariables(mergedConfig, customConfig);

    // Schéma final unifié
    final unifiedSchema = <String, dynamic>{};

    // Liste des champs à exclure globalement (champs techniques gérés automatiquement)
    // Ces champs sont toujours exclus car ils sont gérés automatiquement
    final globalFieldsToExclude = [
      'uuid_base_visit',
      'uuid_observation',
      'uuid_base_site', 
      'uuid_sites_group',
      'uuid_module_complement',
      'nb_observations',
      'id_module',
      'id_digitiser',
      'observers_txt',
      'id_base_site',
    ];

    // Liste des champs à exclure spécifiquement pour les groupes de sites
    final sitesGroupSpecificFieldsToExclude = [
      'id_inventor', // Le champ id_inventor n'existe pas dans la configuration des groupes de sites
    ];

    // Récupérer display_form, display_properties et display_list de la configuration pour filtrer les champs
    // display_form a la priorité sur display_properties (comme dans la version web)
    final displayForm = objectConfig.displayForm;
    final displayProperties = objectConfig.displayProperties;
    final displayList = objectConfig.displayList;
    final hasDisplayForm = displayForm != null && displayForm.isNotEmpty;
    final hasDisplayProperties = displayProperties != null && displayProperties.isNotEmpty;
    final hasDisplayList = displayList != null && displayList.isNotEmpty;

    // Déterminer la liste finale des champs à exclure (uniquement les champs globaux)
    final List<String> fieldsToExclude;
    if (objectType == 'sites_group') {
      // Pour les groupes de sites, exclure les champs globaux + les champs spécifiques aux groupes de sites
      fieldsToExclude = [...globalFieldsToExclude, ...sitesGroupSpecificFieldsToExclude];
    } else {
      // Pour les autres types (site, visit, etc.), exclure uniquement les champs globaux
      // Les champs spécifiques aux sites (altitude_min, altitude_max, nb_visits, etc.) 
      // seront exclus automatiquement s'ils ne sont pas dans display_properties
      fieldsToExclude = globalFieldsToExclude;
    }

    // Pour chaque champ, générer sa configuration complète
    configWithSubstitutions.forEach((fieldName, fieldConfig) {
      // Debug: vérifier les champs problématiques
      final bool isDebugField = fieldName == 'last_visit' || fieldName == 'nb_visits';
      
      // Vérifier si le champ doit être caché
      // Si hidden est explicitement défini à true, on cache le champ
      // Si hidden est null ou false, on affiche le champ
      final bool isHidden = fieldConfig['hidden'] == true;

      // Vérifier si le type de widget est html (à exclure comme dans l'application web)
      final bool isHtmlWidget = fieldConfig['type_widget'] == 'html';

      // Vérifier si le champ est dans la liste des champs à exclure globalement
      final bool isExcludedField = fieldsToExclude.contains(fieldName);

      // Vérifier si le champ est dans specific (configuration explicite)
      // Les champs dans specific doivent toujours être inclus (sauf s'ils sont cachés/exclus)
      final bool isInSpecific = objectConfig.specific?.containsKey(fieldName) ?? false;
      
      // Debug pour les champs problématiques
      if (isDebugField) {
        print('🔍 DEBUG $fieldName:');
        print('  - isHidden: $isHidden');
        print('  - isHtmlWidget: $isHtmlWidget');
        print('  - isExcludedField: $isExcludedField');
        print('  - isInSpecific: $isInSpecific');
        print('  - fieldConfig: $fieldConfig');
      }

      // Si display_form, display_properties ou display_list est défini, vérifier si le champ doit être inclus
      // Règle (comme dans la version web - initObjFormDefiniton) : 
      // - Les champs dans specific sont TOUJOURS inclus (car explicitement configurés)
      // - display_form a la priorité sur display_properties
      // - Si un champ n'a pas de type_widget, il est automatiquement exclu du formulaire
      //   (comme last_visit, nb_visits qui sont calculés automatiquement par le backend)
      final bool isInDisplayProperties;
      
      // Vérifier d'abord si le champ a un type_widget (comme dans la version web)
      // Si pas de type_widget, le champ est calculé automatiquement et ne doit pas être dans le formulaire
      final bool hasNoWidget = fieldConfig['type_widget'] == null || 
                               fieldConfig['type_widget'] == '';
      
      if (isInSpecific) {
        // Les champs dans specific sont toujours inclus (sauf s'ils sont cachés/exclus)
        // Même s'ils n'ont pas de type_widget, ils sont explicitement configurés
        isInDisplayProperties = true;
      } else if (hasNoWidget) {
        // Pas de type_widget = champ calculé automatiquement (comme last_visit, nb_visits)
        // Exclure du formulaire (comme dans initObjFormDefiniton de la version web)
        isInDisplayProperties = false;
      } else if (displayForm != null && displayForm.isNotEmpty) {
        // display_form est défini et non vide - utiliser uniquement display_form
        isInDisplayProperties = displayForm.contains(fieldName);
      } else if (hasDisplayProperties && displayProperties != null) {
        // display_form est vide ou non défini, utiliser display_properties
        final bool inDisplayProperties = displayProperties.contains(fieldName);
        final bool inDisplayList = hasDisplayList && displayList != null && displayList.contains(fieldName);
        isInDisplayProperties = inDisplayProperties || inDisplayList;
      } else if (hasDisplayList && displayList != null) {
        // Si display_form et display_properties ne sont pas définis mais display_list l'est, utiliser display_list
        isInDisplayProperties = displayList.contains(fieldName);
      } else {
        // Si aucun n'est défini, inclure tous les champs configurés (qui ont un type_widget)
        isInDisplayProperties = true;
      }

      // Un champ est inclus si :
      // 1. Il n'est pas caché (hidden != true)
      // 2. Il n'est pas un widget HTML
      // 3. Il n'est pas dans la liste d'exclusion globale
      // 4. Soit il est dans specific, soit il est dans display_properties, soit display_properties n'est pas défini
      final bool shouldInclude = !isHidden && 
          !isHtmlWidget && 
          !isExcludedField &&
          isInDisplayProperties;

      // Debug pour les champs problématiques
      if (isDebugField) {
        print('  - isInDisplayProperties: $isInDisplayProperties');
        print('  - shouldInclude: $shouldInclude');
        print('  - hasDisplayForm: $hasDisplayForm');
        print('  - hasDisplayProperties: $hasDisplayProperties');
        print('  - hasDisplayList: $hasDisplayList');
        if (displayForm != null) {
          print('  - displayForm: $displayForm');
          print('  - in displayForm: ${displayForm.contains(fieldName)}');
        }
        if (displayProperties != null) {
          print('  - displayProperties: $displayProperties');
          print('  - in displayProperties: ${displayProperties.contains(fieldName)}');
        }
        if (displayList != null) {
          print('  - displayList: $displayList');
          print('  - in displayList: ${displayList.contains(fieldName)}');
        }
      }

      // Ne pas inclure les champs cachés, html, exclus ou non listés dans display_properties
      if (shouldInclude) {
        // Déterminer le type_widget : utiliser type_widget si présent, sinon déduire de type_util
        String? inferredTypeWidget;
        if (fieldConfig['type_util'] == 'date') {
          inferredTypeWidget = 'date';
        }
        final String typeWidget = fieldConfig['type_widget']?.toString() ?? inferredTypeWidget ?? 'text';
        
        // Créer une copie de fieldConfig avec le type_widget inféré pour determineWidgetType
        final Map<String, dynamic> fieldConfigForWidgetType = Map<String, dynamic>.from(fieldConfig);
        if (inferredTypeWidget != null && fieldConfig['type_widget'] == null) {
          fieldConfigForWidgetType['type_widget'] = inferredTypeWidget;
        }
        
        unifiedSchema[fieldName] = {
          'attribut_label': fieldConfig['attribut_label'] ?? fieldName,
          'type_widget': typeWidget,
          'widget_type': determineWidgetType(fieldConfigForWidgetType),
          // IMPORTANT: Préserver la valeur originale de 'required' (booléen OU expression)
          'required': fieldConfig['required'] ?? false,
          // Ajouter la propriété hidden pour référence future
          'hidden': fieldConfig['hidden'] ?? false,
          // Ajouter le nom du champ pour faciliter le tri ultérieur
          'attribut_name': fieldName,
          if (fieldConfig['description'] != null)
            'description': fieldConfig['description'],
          if (fieldConfig['default'] != null) 'default': fieldConfig['default'],
          if (fieldConfig['value'] != null) 'value': fieldConfig['value'],
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
          // Ajouter la propriété multiple pour les sélections multiples
          if (fieldConfig['multiple'] != null) 'multiple': fieldConfig['multiple'],
          // Ajouter la configuration des règles de changement automatique
          if (fieldConfig['change'] != null) 'change': fieldConfig['change'],
        };
      }
    });

    // IMPORTANT: Inclure les champs de specific qui ne sont pas dans configWithSubstitutions
    // Cela peut arriver si ces champs ne sont pas dans generic et n'ont pas été fusionnés correctement
    if (objectConfig.specific != null) {
      objectConfig.specific!.forEach((fieldName, specificConfig) {
        // Si le champ n'est pas déjà dans unifiedSchema et n'est pas dans configWithSubstitutions
        if (!unifiedSchema.containsKey(fieldName) && !configWithSubstitutions.containsKey(fieldName)) {
          // Vérifier que le champ n'est pas exclu globalement
          final bool isExcludedField = fieldsToExclude.contains(fieldName);
          
          // Convertir specificConfig en Map si nécessaire
          final Map<String, dynamic> fieldConfig = specificConfig is Map<String, dynamic>
              ? specificConfig
              : <String, dynamic>{};
          
          final bool isHidden = fieldConfig['hidden'] == true;
          final bool isHtmlWidget = fieldConfig['type_widget'] == 'html';
          
          // Inclure le champ s'il n'est pas caché, html ou exclus
          if (!isHidden && !isHtmlWidget && !isExcludedField) {
            // Déterminer le type_widget : utiliser type_widget si présent, sinon déduire de type_util
            String? inferredTypeWidget;
            if (fieldConfig['type_util'] == 'date') {
              inferredTypeWidget = 'date';
            }
            final String typeWidget = fieldConfig['type_widget']?.toString() ?? inferredTypeWidget ?? 'text';
            
            // Créer une copie de fieldConfig avec le type_widget inféré pour determineWidgetType
            final Map<String, dynamic> fieldConfigForWidgetType = Map<String, dynamic>.from(fieldConfig);
            if (inferredTypeWidget != null && fieldConfig['type_widget'] == null) {
              fieldConfigForWidgetType['type_widget'] = inferredTypeWidget;
            }
            
            print('🔍 DEBUG: Ajout du champ $fieldName depuis specific (non présent dans configWithSubstitutions)');

            unifiedSchema[fieldName] = {
              'attribut_label': fieldConfig['attribut_label'] ?? fieldName,
              'type_widget': typeWidget,
              'widget_type': determineWidgetType(fieldConfigForWidgetType),
              'required': fieldConfig['required'] ?? false,
              'hidden': fieldConfig['hidden'] ?? false,
              'attribut_name': fieldName,
              if (fieldConfig['description'] != null)
                'description': fieldConfig['description'],
              if (fieldConfig['default'] != null) 'default': fieldConfig['default'],
              if (fieldConfig['value'] != null) 'value': fieldConfig['value'],
              if (fieldConfig['values'] != null) 'values': fieldConfig['values'],
              'validations': determineValidations(fieldConfig),
              'visibility': determineVisibility(fieldConfig),
              if (fieldConfig['api'] != null) 'api': fieldConfig['api'],
              if (fieldConfig['code_nomenclature_type'] != null)
                'code_nomenclature_type': fieldConfig['code_nomenclature_type'],
              if (fieldConfig['id_list'] != null) 'id_list': fieldConfig['id_list'],
              if (fieldConfig['type_util'] != null)
                'type_util': fieldConfig['type_util'],
              if (fieldConfig['multiple'] != null) 'multiple': fieldConfig['multiple'],
              // Ajouter la configuration des règles de changement automatique
              if (fieldConfig['change'] != null) 'change': fieldConfig['change'],
            };
          }
        }
      });
    }

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
