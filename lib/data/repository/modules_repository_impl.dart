import 'dart:convert';

import 'package:gn_mobile_monitoring/core/helpers/ts_to_dart_converter.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/bib_type_site.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final GlobalApi globalApi;
  final ModulesApi api;
  final TaxonApi taxonApi;
  final ModulesDatabase database;
  final NomenclaturesDatabase nomenclaturesDatabase;
  final DatasetsDatabase datasetsDatabase;
  final TaxonDatabase? taxonDatabase;
  final TaxonRepository taxonRepository;
  final SitesRepository sitesRepository;

  ModulesRepositoryImpl(
    this.globalApi,
    this.api,
    this.taxonApi,
    this.database,
    this.nomenclaturesDatabase,
    this.datasetsDatabase,
    this.taxonDatabase,
    this.taxonRepository,
    this.sitesRepository,
  );

  @override
  Future<List<Module>> getModulesFromLocal() async {
    // Fetch from the database and return as domain models
    return await database.getAllModules();
  }

  @override
  Future<void> fetchAndSyncModulesFromApi(String token) async {
    try {
      // Fetch both modules and complements from API
      final (apiModules, apiModuleComplements) = await api.getModules(token);

      // Map to domain models
      final modules = apiModules.map((e) => e.toDomain()).toList();
      final moduleComplements =
          apiModuleComplements.map((e) => e.toDomain()).toList();

      // Clear existing database entries
      await database.clearAllData();

      // Insert new data
      await database.insertModules(modules);
      await database.insertModuleComplements(moduleComplements);
    } catch (e) {
      throw Exception("Failed to sync modules: ${e.toString()}");
    }
  }

  @override
  Future<void> incrementalSyncModulesFromApi(String token) async {
    try {
      // Fetch data from API
      final (apiModules, apiModuleComplements) = await api.getModules(token);

      // Map to domain models
      final remoteModules = apiModules.map((e) => e.toDomain()).toList();
      final remoteModuleComplements =
          apiModuleComplements.map((e) => e.toDomain()).toList();

      // Get existing modules from local database
      final existingModules = await database.getAllModules();
      final existingModuleIds = existingModules.map((m) => m.id).toSet();
      final remoteModuleIds = remoteModules.map((m) => m.id).toSet();

      // 1. Identify modules to ADD (exist remotely but not locally)
      final modulesToAdd = remoteModules
          .where((m) => !existingModuleIds.contains(m.id))
          .toList();

      // 2. Identify modules to DELETE (exist locally but not remotely)
      final modulesToRemove = existingModules
          .where((m) => !remoteModuleIds.contains(m.id))
          .toList();

      // 3. Identify modules to UPDATE (exist both locally and remotely)
      final remoteModulesMap = {for (var m in remoteModules) m.id: m};
      final modulesToUpdate = existingModules
          .where((m) => remoteModuleIds.contains(m.id))
          .map((existingModule) => remoteModulesMap[existingModule.id]!)
          .toList();

      // 4. Process module complements similarly
      final existingComplements = await database.getAllModuleComplements();
      final existingComplementModuleIds =
          existingComplements.map((c) => c.idModule).toSet();
      final remoteComplementModuleIds =
          remoteModuleComplements.map((c) => c.idModule).toSet();

      final complementsToAdd = remoteModuleComplements
          .where((c) => !existingComplementModuleIds.contains(c.idModule))
          .toList();

      final complementsToRemove = existingComplements
          .where((c) => !remoteComplementModuleIds.contains(c.idModule))
          .toList();

      final remoteComplementsMap = {
        for (var c in remoteModuleComplements) c.idModule: c
      };
      final complementsToUpdate = existingComplements
          .where((c) => remoteComplementModuleIds.contains(c.idModule))
          .map((existingComplement) =>
              remoteComplementsMap[existingComplement.idModule]!)
          .toList();

      // 5. Perform database operations

      // Remove modules and complements that are no longer available to the user
      for (final moduleToRemove in modulesToRemove) {
        await database.deleteModuleWithComplement(moduleToRemove.id);
      }

      // Add new modules
      if (modulesToAdd.isNotEmpty) {
        await database.insertModules(modulesToAdd);
        print('Added ${modulesToAdd.length} new modules to the database');
      }

      // Update existing modules but preserve downloaded status
      for (final moduleToUpdate in modulesToUpdate) {
        // Récupérer le module existant pour connaître son statut 'downloaded'
        final existingModule = await database.getModuleById(moduleToUpdate.id);

        if (existingModule != null && existingModule.downloaded == true) {
          // Si le module était déjà marqué comme téléchargé, préserver ce statut
          final updatedModule = moduleToUpdate.copyWith(downloaded: true);
          await database.updateModule(updatedModule);
          print(
              'Preserved downloaded status for module ${moduleToUpdate.moduleCode ?? moduleToUpdate.id}');
        } else {
          // Sinon, mettre à jour normalement
          await database.updateModule(moduleToUpdate);
        }
      }

      // Add new module complements
      if (complementsToAdd.isNotEmpty) {
        await database.insertModuleComplements(complementsToAdd);
        print(
            'Added ${complementsToAdd.length} new module complements to the database');
      }

      // Update existing module complements
      for (final complementToUpdate in complementsToUpdate) {
        await database.updateModuleComplement(complementToUpdate);
      }

      print('Removed ${modulesToRemove.length} modules no longer available');
      print('Updated ${modulesToUpdate.length} existing modules');
      print(
          'Updated ${complementsToUpdate.length} existing module complements');
    } catch (e) {
      throw Exception("Failed to incrementally sync modules: ${e.toString()}");
    }
  }

  @override
  Future<void> downloadCompleteModule(int moduleId, String token) async {
    try {
      final moduleCode = await database
          .getModuleCodeFromIdModule(moduleId); // Fetch module name

      // 1. Fetch nomenclatures and datasets
      final data = await globalApi.getNomenclaturesAndDatasets(moduleCode);

      // Convert nomenclature entities to domain models
      final nomenclatures =
          data.nomenclatures.map((e) => e.toDomain()).toList();

      // Insert nomenclatures with duplicate handling
      await nomenclaturesDatabase.insertNomenclatures(nomenclatures);

      // Process nomenclature types
      if (data.nomenclatureTypes.isNotEmpty) {
        final nomenclatureTypes = data.nomenclatureTypes
            .map((typeData) => NomenclatureType(
                  idType: typeData['idType'] as int,
                  mnemonique: typeData['mnemonique'] as String,
                ))
            .toList();

        // Don't clear existing types, just add new ones, avoiding duplicates
        await nomenclaturesDatabase.insertNomenclatureTypes(nomenclatureTypes);
      }

      // Convert dataset entities to domain models
      final datasets = data.datasets.map((e) => e.toDomain()).toList();

      // Ne pas effacer les datasets existants, juste insérer/mettre à jour
      await datasetsDatabase.insertDatasets(datasets);

      // Associate each dataset with this module
      for (final dataset in datasets) {
        await database.associateModuleWithDataset(moduleId, dataset.id);
      }

      // 2. Fetch and store module configuration
      final config = await globalApi.getModuleConfiguration(moduleCode);

      // Prétraiter les expressions hidden en JavaScript et les convertir en Dart directement dans la configuration
      try {
        // Variable pour compter le nombre total de fonctions converties
        int totalConverted = 0;

        // Fonction pour remplacer les fonctions hidden de JavaScript par du Dart
        void replaceHiddenFunctions(Map<String, dynamic> configSection) {
          // Pour les champs génériques
          if (configSection.containsKey('generic') &&
              configSection['generic'] is Map) {
            final generic = configSection['generic'] as Map<String, dynamic>;

            for (final entry in generic.entries) {
              final fieldId = entry.key;
              final fieldConfig = entry.value;

              if (fieldConfig is Map<String, dynamic> &&
                  fieldConfig.containsKey('hidden') &&
                  fieldConfig['hidden'] is String &&
                  fieldConfig['hidden'].toString().startsWith('({')) {
                try {
                  final jsFunction = fieldConfig['hidden'].toString();
                  final dartFunction =
                      TsToDartConverter.convertToDart(jsFunction);

                  // Remplacer la fonction JS par la fonction Dart directement dans la configuration
                  fieldConfig['hidden'] = dartFunction;
                  totalConverted++;
                  print(
                      'Converted hidden function for field $fieldId: $jsFunction -> $dartFunction');
                } catch (e) {
                  print(
                      'Error converting hidden function for field $fieldId: $e');
                }
              }
            }
          }

          // Pour les champs spécifiques
          if (configSection.containsKey('specific') &&
              configSection['specific'] is Map) {
            final specific = configSection['specific'] as Map<String, dynamic>;

            for (final entry in specific.entries) {
              final fieldId = entry.key;
              final fieldConfig = entry.value;

              if (fieldConfig is Map<String, dynamic> &&
                  fieldConfig.containsKey('hidden') &&
                  fieldConfig['hidden'] is String &&
                  fieldConfig['hidden'].toString().startsWith('({')) {
                try {
                  final jsFunction = fieldConfig['hidden'].toString();
                  final dartFunction =
                      TsToDartConverter.convertToDart(jsFunction);

                  // Remplacer la fonction JS par la fonction Dart directement dans la configuration
                  fieldConfig['hidden'] = dartFunction;
                  totalConverted++;
                  print(
                      'Converted hidden function for specific field $fieldId: $jsFunction -> $dartFunction');
                } catch (e) {
                  print(
                      'Error converting hidden function for specific field $fieldId: $e');
                }
              }
            }
          }
        }

        // Parcourir les sections principales du module pour remplacer les fonctions hidden
        final objectTypes = [
          'module',
          'site',
          'sites_group',
          'visit',
          'observation',
          'observation_detail'
        ];

        for (final objectType in objectTypes) {
          if (config.containsKey(objectType) &&
              config[objectType] is Map<String, dynamic>) {
            final prevCount = totalConverted;
            replaceHiddenFunctions(config[objectType] as Map<String, dynamic>);
            final convertedInSection = totalConverted - prevCount;

            if (convertedInSection > 0) {
              print(
                  'Converted $convertedInSection hidden functions in $objectType section');
            }
          }
        }

        print(
            'Total hidden functions converted in module configuration: $totalConverted');
      } catch (e) {
        print('Erreur lors de la conversion des fonctions hidden: $e');
        // Continuer malgré les erreurs de conversion
      }

      // Convert the Map to a properly formatted JSON string
      final jsonConfig = json.encode(config);

      // Store the JSON string in the database
      await database.updateModuleComplementConfiguration(moduleId, jsonConfig);

      // 3. Fetch Site Types
      final siteTypesData = await globalApi.getSiteTypes();

      // Extract the site types that are related to this module from the configuration
      final moduleConfig = ModuleConfiguration.fromJson(config);
      final moduleTypesSite = moduleConfig.module?.typesSite;

      if (moduleTypesSite != null && moduleTypesSite.isNotEmpty) {
        final List<BibTypeSite> relevantSiteTypes = [];
        final List<Map<String, dynamic>> siteTypeConfigs = [];

        // For each site type in the module configuration, find the corresponding site type data
        for (final siteTypeId in moduleTypesSite.keys) {
          try {
            // Fetch specific site type information
            final siteTypeData =
                await globalApi.getSiteTypeById(int.parse(siteTypeId));

            // Create BibTypeSite domain object
            final typeSiteConfig = moduleTypesSite[siteTypeId];
            final config = typeSiteConfig != null
                ? {
                    'display_properties': typeSiteConfig.displayProperties,
                    'name': typeSiteConfig.name,
                  }
                : null;

            final bibTypeSite = BibTypeSite(
              idNomenclatureTypeSite: int.parse(siteTypeId),
              config: config,
            );

            relevantSiteTypes.add(bibTypeSite);

            // Find if this nomenclature already exists in the database
            final existingNomenclatures =
                await nomenclaturesDatabase.getAllNomenclatures();
            bool nomenclatureExists = existingNomenclatures.any((n) =>
                n.id == siteTypeData['id_nomenclature'] ||
                (n.idType == 116 &&
                    n.cdNomenclature == siteTypeData['cd_nomenclature']));

            if (!nomenclatureExists) {
              // Create and add the nomenclature if it doesn't exist
              final nomenclatureInfo = siteTypeData['nomenclature'];
              final nomenclature = Nomenclature(
                id: siteTypeData['id_nomenclature'],
                idType: 116, // TYPE_SITE
                cdNomenclature:
                    nomenclatureInfo['cd_nomenclature'] as String? ?? '',
                labelDefault: nomenclatureInfo['label_default'] as String?,
                definitionDefault:
                    nomenclatureInfo['definition_default'] as String?,
                labelFr: nomenclatureInfo['label_fr'] as String?,
                definitionFr: nomenclatureInfo['definition_fr'] as String?,
                labelEn: nomenclatureInfo['label_en'] as String?,
                definitionEn: nomenclatureInfo['definition_en'] as String?,
                labelEs: nomenclatureInfo['label_es'] as String?,
                definitionEs: nomenclatureInfo['definition_es'] as String?,
                labelDe: nomenclatureInfo['label_de'] as String?,
                definitionDe: nomenclatureInfo['definition_de'] as String?,
                labelIt: nomenclatureInfo['label_it'] as String?,
                definitionIt: nomenclatureInfo['definition_it'] as String?,
                source: nomenclatureInfo['source'] as String?,
                statut: nomenclatureInfo['statut'] as String?,
                active: nomenclatureInfo['active'] as bool? ?? true,
              );

              // Add the nomenclature to the database
              await nomenclaturesDatabase.insertNomenclatures([nomenclature]);
            }
          } catch (e) {
            print('Error fetching site type $siteTypeId: $e');
            // Continue with other site types
          }
        }

        // Si vous avez besoin de sauvegarder les types de sites dans la base de données,
        // décommentez le code ci-dessous :
        /*
        if (relevantSiteTypes.isNotEmpty) {
          await nomenclaturesDatabase.clearBibTypeSites();
          await nomenclaturesDatabase.insertBibTypeSites(relevantSiteTypes);
        }
        */
      }

      // 4. Download module taxons from configuration
      try {
        if (taxonDatabase != null) {
          await taxonRepository.downloadTaxonsFromConfig(config);
          print('Taxons downloaded from configuration successfully.');
        }
      } catch (taxonError) {
        print('Error processing taxonomy lists: $taxonError');
      }

      // Les fonctions hidden sont maintenant traitées directement lors du rendu
      // des formulaires, nous n'avons plus besoin de les extraire ici

      // Mark module as downloaded
      await database.markModuleAsDownloaded(moduleId);

      // 5. Download sites for the module
      await sitesRepository.fetchSitesForModule(moduleCode, token);

      // 6. Download site groups for the module
      await sitesRepository.fetchSiteGroupsForModule(moduleCode, token);
    } catch (e) {
      throw Exception('Failed to download module data: $e');
    }
  }

  @override
  Future<Module> getCompleteModule(int moduleId) async {
    // Récupère le module complet avec ses relations depuis la base de données
    // La méthode getModuleWithRelationsById récupère automatiquement :
    // - Le module de base
    // - Les sites associés
    // - Les groupes de sites
    // - Les compléments de module (configuration de base)
    final module = await database.getModuleWithRelationsById(moduleId);
    final complement = await database.getModuleComplementById(moduleId);

    // Retourner le module avec ses compléments mis à jour si disponibles
    // Le module a déjà un complément, mais on veut s'assurer qu'il a la dernière version
    return module.copyWith(complement: complement);
  }

  @override
  Future<List<Nomenclature>> getNomenclatures() async {
    try {
      return await nomenclaturesDatabase.getAllNomenclatures();
    } catch (e) {
      throw Exception('Failed to get nomenclatures: $e');
    }
  }

  @override
  Future<Map<String, int>> getNomenclatureTypeMapping() async {
    try {
      // Récupère les types de nomenclature depuis la base de données
      final types = await nomenclaturesDatabase.getAllNomenclatureTypes();
      final mapping = <String, int>{};

      // Construire le mapping à partir des types
      for (final type in types) {
        if (type.mnemonique != null) {
          mapping[type.mnemonique!] = type.idType;
        }
      }

      // Si aucune donnée n'est disponible, utiliser des valeurs par défaut
      if (mapping.isEmpty) {
        return {
          'TYPE_MEDIA': 117,
          'TYPE_SITE': 116,
          'TYPE_OBSERVATION': 118,
          'TYPE_VISIT': 119,
          'TYPE_PERMISSION': 120,
        };
      }

      return mapping;
    } catch (e) {
      // En cas d'erreur, retourner les valeurs par défaut
      return {
        'TYPE_MEDIA': 117,
        'TYPE_SITE': 116,
        'TYPE_OBSERVATION': 118,
        'TYPE_VISIT': 119,
        'TYPE_PERMISSION': 120,
      };
    }
  }

  @override
  Future<int?> getNomenclatureTypeIdByMnemonique(String mnemonique) async {
    try {
      // Chercher le type par mnémonique dans la base de données
      final type = await nomenclaturesDatabase
          .getNomenclatureTypeByMnemonique(mnemonique);
      return type?.idType;
    } catch (e) {
      // Essayer avec le mapping statique en fallback
      final mapping = await getNomenclatureTypeMapping();
      return mapping[mnemonique];
    }
  }

  @override
  Future<List<int>> getDatasetIdsForModule(int moduleId) async {
    try {
      return await database.getDatasetIdsForModule(moduleId);
    } catch (e) {
      throw Exception('Failed to get datasets for module: $e');
    }
  }

  @override
  Future<List<Dataset>> getDatasetsByIds(List<int> datasetIds) async {
    try {
      return await datasetsDatabase.getDatasetsByIds(datasetIds);
    } catch (e) {
      throw Exception('Failed to get datasets by ids: $e');
    }
  }

  @override
  Future<Module> getModuleById(int moduleId) async {
    try {
      final module = await database.getModuleById(moduleId);

      if (module == null) {
        throw Exception('Module not found with ID: $moduleId');
      }

      return module;
    } catch (e) {
      throw Exception('Failed to get module by id: $e');
    }
  }

  @override
  Future<Module> getModuleWithRelationsById(int moduleId) async {
    try {
      // Cette méthode charge le module avec toutes ses relations (sites et groupes de sites)
      return await database.getModuleWithRelationsById(moduleId);
    } catch (e) {
      throw Exception('Failed to get module with relations by id: $e');
    }
  }

  @override
  Future<Module?> getModuleByCode(String moduleCode) async {
    try {
      return await database.getModuleByCode(moduleCode);
    } catch (e) {
      throw Exception('Failed to get module by code: $e');
    }
  }

  @override
  Future<int?> getModuleTaxonomyListId(int moduleId) async {
    try {
      return await database.getModuleTaxonomyListId(moduleId);
    } catch (e) {
      throw Exception('Failed to get taxonomy list ID for module: $e');
    }
  }

  @override
  Future<ModuleConfiguration> getModuleConfiguration(String moduleCode) async {
    try {
      // Récupérer la configuration depuis l'API globale
      final moduleComplement =
          await database.getModuleComplementByModuleCode(moduleCode);

      // Si le module complement existe et a une configuration
      if (moduleComplement != null && moduleComplement.data != null) {
        // Convertir la configuration JSON en objet ModuleConfiguration
        Map<String, dynamic> configJson;

        try {
          configJson =
              json.decode(moduleComplement.data!) as Map<String, dynamic>;
          return ModuleConfiguration.fromJson(configJson);
        } catch (parseError) {
          throw Exception('Error parsing module configuration: $parseError');
        }
      } else {
        // Si aucune configuration n'est trouvée, récupérer depuis l'API
        final apiResponse = await globalApi.getModuleConfiguration(moduleCode);

        // Convertir la réponse de l'API en ModuleConfiguration
        try {
          return ModuleConfiguration.fromJson(apiResponse);
        } catch (parseError) {
          throw Exception(
              'Error parsing module configuration from API: $parseError');
        }
      }
    } catch (e) {
      throw Exception('Failed to get module configuration: $e');
    }
  }
}
