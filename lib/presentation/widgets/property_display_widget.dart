import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

class PropertyDisplayWidget extends ConsumerWidget {
  final Map<String, dynamic> data;
  final ObjectConfig? config;
  final CustomConfig? customConfig;
  final String title;
  final bool separateEmptyFields;
  final List<String>? displayProperties;

  const PropertyDisplayWidget({
    super.key,
    required this.data,
    this.config,
    this.customConfig,
    this.title = 'Données spécifiques',
    this.separateEmptyFields = false,
    this.displayProperties,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (data.isEmpty)
              const Text('Aucune donnée spécifique disponible')
            else
              FutureBuilder<Map<String, dynamic>>(
                future: _enrichDataWithNomenclatures(data, ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final enrichedData = snapshot.data ?? data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildPropertyRows(enrichedData, config,
                        customConfig, separateEmptyFields, displayProperties),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Enrichit les données en convertissant les IDs de nomenclatures en objets avec labels
  Future<Map<String, dynamic>> _enrichDataWithNomenclatures(
      Map<String, dynamic> data, WidgetRef ref) async {
    final enrichedData = Map<String, dynamic>.from(data);
    final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);

    debugPrint(
        'Données reçues pour enrichissement: ${enrichedData.keys.join(", ")}');

    // Générer le schéma unifié pour identifier les champs de nomenclature
    final Map<String, dynamic> parsedConfig = config != null
        ? FormConfigParser.generateUnifiedSchema(config!, customConfig)
        : {};

    // Identifier les champs de nomenclature et sites_group depuis la configuration
    final List<String> nomenclatureFields = [];
    final List<String> sitesGroupFields = [];

    // 1. Chercher dans la configuration parsée
    for (final entry in parsedConfig.entries) {
      final fieldName = entry.key;
      final fieldConfig = entry.value;

      if (fieldConfig is Map<String, dynamic>) {
        // Vérifier si c'est un champ de nomenclature
        if (FormConfigParser.isNomenclatureField(fieldConfig)) {
          nomenclatureFields.add(fieldName);
        }
        // Vérifier si c'est un champ de type sites_group
        else if (fieldConfig['type_util'] == 'sites_group' ||
            (fieldConfig['type_widget'] == 'datalist' &&
                fieldConfig['keyValue'] == 'id_sites_group')) {
          sitesGroupFields.add(fieldName);
        }
      }
    }

    // 2. Ajouter aussi les champs qui commencent par id_nomenclature_ (pour compatibilité)
    for (final key in enrichedData.keys) {
      if (key.startsWith('id_nomenclature_') &&
          !nomenclatureFields.contains(key)) {
        nomenclatureFields.add(key);
      }
    }

    // 3. Ajouter id_sites_group si présent dans les données (pour compatibilité)
    if (enrichedData.containsKey('id_sites_group') &&
        !sitesGroupFields.contains('id_sites_group')) {
      sitesGroupFields.add('id_sites_group');
    }

    debugPrint('Champs de nomenclature trouvés: ${nomenclatureFields.length}');
    debugPrint('Champs nomenclature: ${nomenclatureFields.join(", ")}');
    debugPrint('Champs sites_group trouvés: ${sitesGroupFields.length}');
    debugPrint('Champs sites_group: ${sitesGroupFields.join(", ")}');

    // Pour chaque champ de nomenclature, convertir l'ID en objet
    for (final fieldName in nomenclatureFields) {
      // Vérifier que le champ existe dans les données
      if (!enrichedData.containsKey(fieldName)) {
        debugPrint('  $fieldName: Champ non présent dans les données');
        continue;
      }

      final fieldValue = enrichedData[fieldName];

      debugPrint(
          'Traitement de $fieldName: valeur=$fieldValue, type=${fieldValue?.runtimeType}');

      // Ignorer si null ou vide
      if (fieldValue == null || fieldValue == '' || fieldValue == 0) {
        debugPrint('  $fieldName: Valeur null/vide, ignoré');
        continue;
      }

      // Convertir en entier si nécessaire
      int? idNomenclature;
      if (fieldValue is int) {
        idNomenclature = fieldValue;
      } else if (fieldValue is String) {
        idNomenclature = int.tryParse(fieldValue);
      } else if (fieldValue is Map) {
        // Si c'est déjà un Map, vérifier s'il contient un ID
        if (fieldValue.containsKey('id')) {
          final id = fieldValue['id'];
          idNomenclature = id is int ? id : int.tryParse(id.toString());
        }
      }

      if (idNomenclature == null || idNomenclature == 0) {
        debugPrint('  $fieldName: Impossible de convertir en ID valide');
        continue;
      }

      debugPrint('  $fieldName: ID trouvé=$idNomenclature');

      try {
        // Récupérer la nomenclature par son ID
        final nomenclatureName =
            await nomenclatureService.getNomenclatureNameById(idNomenclature);

        debugPrint('  $fieldName: Label récupéré=$nomenclatureName');

        // Si on a trouvé un label, créer un objet nomenclature
        if (nomenclatureName != 'Nomenclature $idNomenclature (non trouvée)') {
          // Créer un objet avec le label
          enrichedData[fieldName] = {
            'id': idNomenclature,
            'label': nomenclatureName,
          };
          debugPrint('  $fieldName: Enrichi avec succès');
        } else {
          debugPrint('  $fieldName: Nomenclature non trouvée');
        }
      } catch (e) {
        debugPrint('Erreur lors de l\'enrichissement de $fieldName: $e');
        // En cas d'erreur, conserver l'ID tel quel
      }
    }

    // Traiter les champs de type sites_group
    for (final fieldName in sitesGroupFields) {
      // Vérifier que le champ existe dans les données
      if (!enrichedData.containsKey(fieldName)) {
        debugPrint('  $fieldName: Champ non présent dans les données');
        continue;
      }

      final fieldValue = enrichedData[fieldName];

      debugPrint(
          'Traitement de $fieldName (sites_group): valeur=$fieldValue, type=${fieldValue?.runtimeType}');

      // Ignorer si null ou vide
      if (fieldValue == null || fieldValue == '' || fieldValue == 0) {
        debugPrint('  $fieldName: Valeur null/vide, ignoré');
        continue;
      }

      // Convertir en entier si nécessaire
      int? siteGroupId;
      if (fieldValue is int) {
        siteGroupId = fieldValue;
      } else if (fieldValue is String) {
        siteGroupId = int.tryParse(fieldValue);
      } else if (fieldValue is Map) {
        // Si c'est déjà un Map, vérifier s'il contient un ID
        if (fieldValue.containsKey('id')) {
          final id = fieldValue['id'];
          siteGroupId = id is int ? id : int.tryParse(id.toString());
        }
      }

      if (siteGroupId == null || siteGroupId == 0) {
        debugPrint('  $fieldName: Impossible de convertir en ID valide');
        continue;
      }

      debugPrint('  $fieldName: ID trouvé=$siteGroupId');

      try {
        final sitesDatabase = ref.read(siteDatabaseProvider);
        final allSiteGroups = await sitesDatabase.getAllSiteGroups();
        final siteGroup = allSiteGroups
            .where((sg) => sg.idSitesGroup == siteGroupId)
            .firstOrNull;

        if (siteGroup != null) {
          // Créer un objet avec le nom du groupe
          enrichedData[fieldName] = {
            'id': siteGroupId,
            'label': siteGroup.sitesGroupName ??
                siteGroup.sitesGroupCode ??
                'Groupe $siteGroupId',
          };
          debugPrint(
              '  $fieldName: Enrichi avec succès (${enrichedData[fieldName]['label']})');
        } else {
          debugPrint('  $fieldName: Groupe de sites non trouvé');
        }
      } catch (e) {
        debugPrint('Erreur lors de l\'enrichissement de $fieldName: $e');
        // En cas d'erreur, conserver l'ID tel quel
      }
    }

    return enrichedData;
  }

  static List<Widget> buildPropertyRows(
    Map<String, dynamic> data,
    ObjectConfig? config,
    CustomConfig? customConfig,
    bool separateEmptyFields,
    List<String>? displayProperties,
  ) {
    // Préparer la configuration si disponible
    final Map<String, dynamic> parsedConfig = config != null
        ? FormConfigParser.generateUnifiedSchema(config, customConfig)
        : {};

    // Extraire les libellés des champs
    final Map<String, String> fieldLabels = {};
    for (final entry in parsedConfig.entries) {
      fieldLabels[entry.key] = entry.value['attribut_label'];
    }

    // Filtrer les clés selon displayProperties si défini
    // Si displayProperties est défini, respecter son ordre, sinon utiliser l'ordre alphabétique
    final List<String> keysToShow;
    if (displayProperties != null && displayProperties.isNotEmpty) {
      // Respecter l'ordre de displayProperties
      keysToShow =
          displayProperties.where((key) => data.containsKey(key)).toList();
    } else {
      keysToShow = data.keys.toList()..sort();
    }

    if (!separateEmptyFields) {
      // Affichage simple (sans séparation des champs vides)
      final List<Widget> widgets = [];
      // Utiliser keysToShow tel quel (déjà dans le bon ordre si displayProperties est défini)

      for (final key in keysToShow) {
        final value = data[key];
        // Vérifier si la valeur est valide
        bool isValid = false;

        if (value == null) {
          isValid = false;
        } else if (value is Map) {
          // Un Map enrichi est toujours valide (il contient 'id' et 'label')
          isValid = value.isNotEmpty;
        } else if (value is String) {
          isValid = value.trim().isNotEmpty;
        } else if (value is num) {
          // Pour les nombres, considérer comme valide sauf si c'est 0
          isValid = value != 0;
        } else {
          // Autres types (bool, etc.) sont valides
          isValid = true;
        }

        if (isValid) {
          // Formater le libellé du champ
          String displayLabel = fieldLabels[key] ?? key;
          if (displayLabel == key) {
            displayLabel = _formatLabel(key);
          }

          String displayValue = _formatValue(value);

          widgets.add(_buildPropertyRow(displayLabel, displayValue));
        }
      }

      return widgets;
    } else {
      // Affichage avec séparation des champs vides et non vides
      return _buildSortedProperties(
          data, config, customConfig, displayProperties);
    }
  }

  static List<Widget> _buildSortedProperties(
    Map<String, dynamic> data,
    ObjectConfig? config,
    CustomConfig? customConfig,
    List<String>? displayProperties,
  ) {
    // Séparer les propriétés remplies et vides
    final filledProperties = <MapEntry<String, dynamic>>[];
    final emptyProperties = <MapEntry<String, dynamic>>[];
    final Set<String> allKeys = <String>{};

    debugPrint(
        '_buildSortedProperties - displayProperties: ${displayProperties?.join(", ")}');
    debugPrint(
        '_buildSortedProperties - données disponibles: ${data.keys.join(", ")}');

    // Si displayProperties est défini, utiliser uniquement ces clés
    if (displayProperties != null && displayProperties.isNotEmpty) {
      allKeys.addAll(displayProperties);
      debugPrint(
          '_buildSortedProperties - Utilisation de displayProperties: ${allKeys.join(", ")}');
    } else {
      // Ajouter toutes les clés de data
      allKeys.addAll(data.keys);

      // Ajouter toutes les clés définies dans la configuration
      if (config != null) {
        // Récupérer les clés des propriétés configurées
        if (config.propertiesKeys != null) {
          allKeys.addAll(config.propertiesKeys!);
        }
        // Récupérer les clés de generic
        if (config.generic != null) {
          allKeys.addAll(config.generic!.keys);
        }
        // Récupérer les clés de specific
        if (config.specific != null) {
          allKeys.addAll(config.specific!.keys);
        }
      }
    }

    // Trier les propriétés selon qu'elles sont remplies ou non
    for (var key in allKeys) {
      debugPrint('Vérification du champ: $key');
      if (data.containsKey(key)) {
        final value = data[key];
        debugPrint('  Valeur trouvée: $value (type: ${value.runtimeType})');

        // Vérifier si la valeur est valide
        bool isValid = false;

        if (value == null) {
          isValid = false;
          debugPrint('  -> Invalide: null');
        } else if (value is Map) {
          // Un Map enrichi est toujours valide (il contient 'id' et 'label')
          isValid = value.isNotEmpty;
          debugPrint(
              '  -> Map: isValid=$isValid, contenu: ${value.keys.join(", ")}');
        } else if (value is String) {
          isValid = value.trim().isNotEmpty;
          debugPrint('  -> String: isValid=$isValid');
        } else if (value is num) {
          // Pour les nombres, considérer comme valide sauf si c'est 0
          // (mais certains champs peuvent avoir 0 comme valeur valide)
          isValid = value != 0;
          debugPrint('  -> Num: isValid=$isValid (valeur=$value)');
        } else {
          // Autres types (bool, etc.) sont valides
          isValid = true;
          debugPrint('  -> Autre type: isValid=$isValid');
        }

        if (isValid) {
          filledProperties.add(MapEntry(key, value));
          debugPrint('  -> Ajouté aux champs remplis');
        } else {
          emptyProperties.add(MapEntry(key, null));
          debugPrint('  -> Ajouté aux champs vides');
        }
      } else {
        // Soit la propriété n'existe pas, soit elle est vide
        debugPrint('  Champ non présent dans les données');
        emptyProperties.add(MapEntry(key, null));
      }
    }

    // Trier les propriétés selon l'ordre de displayProperties si défini
    if (displayProperties != null && displayProperties.isNotEmpty) {
      // Respecter l'ordre de displayProperties
      filledProperties.sort((a, b) {
        final indexA = displayProperties.indexOf(a.key);
        final indexB = displayProperties.indexOf(b.key);
        // Si une clé n'est pas dans displayProperties, la mettre à la fin
        if (indexA == -1 && indexB == -1) return a.key.compareTo(b.key);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
      emptyProperties.sort((a, b) {
        final indexA = displayProperties.indexOf(a.key);
        final indexB = displayProperties.indexOf(b.key);
        // Si une clé n'est pas dans displayProperties, la mettre à la fin
        if (indexA == -1 && indexB == -1) return a.key.compareTo(b.key);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
    } else {
      // Trier par ordre alphabétique si displayProperties n'est pas défini
      filledProperties.sort((a, b) => a.key.compareTo(b.key));
      emptyProperties.sort((a, b) => a.key.compareTo(b.key));
    }

    // Construire les widgets pour les propriétés
    final widgets = <Widget>[];

    // Ajouter les propriétés remplies
    if (filledProperties.isNotEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Champs remplis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ),
      );

      for (final entry in filledProperties) {
        final label = _getPropertyLabel(entry.key, config, customConfig);
        final rawValue = entry.value;
        debugPrint(
            'Affichage champ rempli: $label = $rawValue (type: ${rawValue.runtimeType})');
        final value = _formatValue(rawValue);
        debugPrint('  Valeur formatée: $value');
        widgets.add(_buildPropertyRow(label, value));
      }
    }

    // Ajouter les propriétés vides
    if (emptyProperties.isNotEmpty) {
      widgets.add(const SizedBox(height: 16));
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Champs non remplis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );

      for (final entry in emptyProperties) {
        final label = _getPropertyLabel(entry.key, config, customConfig);
        debugPrint('Affichage champ vide: $label');
        // Vérifier si le champ existe dans les données mais a été considéré comme vide
        if (data.containsKey(entry.key)) {
          debugPrint(
              '  ATTENTION: Le champ existe dans les données avec la valeur: ${data[entry.key]}');
        }
        widgets.add(_buildPropertyRow(
          label,
          'Non renseigné',
          isEmptyField: true,
        ));
      }
    }

    return widgets;
  }

  static String _getPropertyLabel(
    String key,
    ObjectConfig? config,
    CustomConfig? customConfig,
  ) {
    if (config != null) {
      // Vérifier dans la configuration parsée
      final parsedConfig =
          FormConfigParser.generateUnifiedSchema(config, customConfig);
      if (parsedConfig.containsKey(key) &&
          parsedConfig[key].containsKey('attribut_label')) {
        return parsedConfig[key]['attribut_label'];
      }

      // Vérifier dans generic
      if (config.generic != null && config.generic!.containsKey(key)) {
        return config.generic![key]!.attributLabel ?? key;
      }
      // Vérifier dans specific
      else if (config.specific != null && config.specific!.containsKey(key)) {
        final specificConfig = config.specific![key] as Map<String, dynamic>;
        if (specificConfig.containsKey('attribut_label')) {
          return specificConfig['attribut_label'];
        }
      }
    }
    return _formatLabel(key);
  }

  static String _formatLabel(String key) {
    return ValueFormatter.formatLabel(key);
  }

  static String _formatValue(dynamic value) {
    return ValueFormatter.format(value);
  }

  static Widget _buildPropertyRow(
    String label,
    String value, {
    bool isEmptyField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isEmptyField ? Colors.grey : null,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isEmptyField ? Colors.grey : null,
                fontStyle: isEmptyField ? FontStyle.italic : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
