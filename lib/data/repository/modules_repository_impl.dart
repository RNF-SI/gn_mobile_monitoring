import 'dart:convert';

import 'package:gn_mobile_monitoring/core/errors/exceptions/version_incompatible_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/version_api.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/domain/utils/version_utils.dart';
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
import 'package:gn_mobile_monitoring/domain/model/module_uninstall_stats.dart';
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
  final VersionApi versionApi;

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
    this.versionApi,
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
  Future<void> downloadCompleteModule(
    int moduleId,
    String token, {
    Function(double)? onProgressUpdate,
    Function(String)? onStepUpdate,
  }) async {
    try {
      // 0. Vérification de la version du module monitoring sur le serveur
      onStepUpdate?.call('Vérification de la version du serveur');
      onProgressUpdate?.call(0.05);
      final versionString = await versionApi.fetchMonitoringVersion(token);
      final serverVersion = MonitoringVersion.tryParse(versionString);
      final requiredVersion = VersionRequirements.minimumMonitoring;

      if (serverVersion == null || serverVersion < requiredVersion) {
        throw VersionIncompatibleException(
          detectedVersion: versionString,
          requiredVersion: requiredVersion,
          serverUrl: Config.baseUrl,
        );
      }

      final moduleCode = await database
          .getModuleCodeFromIdModule(moduleId); // Fetch module name

      // 1. Fetch nomenclatures, datasets ET configuration en une seule fois
      // Cette méthode optimisée récupère tout et évite les appels redondants
      onStepUpdate?.call('Nomenclatures, datasets et configuration');
      onProgressUpdate?.call(0.15);
      // Passer le token pour les requêtes authentifiées
      final data = await globalApi.getNomenclaturesAndDatasets(moduleId, token: token);

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

      // Clear old module-dataset associations before inserting new ones
      await database.clearDatasetAssociationsForModule(moduleId);

      // Associate each dataset with this module
      for (final dataset in datasets) {
        await database.associateModuleWithDataset(moduleId, dataset.id);
      }

      // 2. Utiliser la configuration déjà récupérée (pas besoin de refaire l'appel API)
      onStepUpdate?.call('Configuration du module');
      onProgressUpdate?.call(0.30);
      final config = data.configuration;

      // Stocker la configuration telle que servie par le module web : les
      // expressions (hidden, required, change) sont évaluées à l'exécution
      // par JsExpressionInterpreter, sans conversion préalable.
      final jsonConfig = json.encode(config);
      await database.updateModuleComplementConfiguration(moduleId, jsonConfig);

      // 3. Fetch Site Types
      onStepUpdate?.call('Types de sites');
      onProgressUpdate?.call(0.45);
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
      onStepUpdate?.call('Taxons');
      onProgressUpdate?.call(0.60);
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
      onStepUpdate?.call('Sites');
      onProgressUpdate?.call(0.80);
      await sitesRepository.fetchSitesForModule(moduleCode, token);

      // 6. Download site groups for the module.
      // On tente systématiquement l'appel : l'API renvoie une liste vide (ou
      // 403 pour les modules qui ne supportent pas les groupes) et
      // fetchSiteGroupsForModule gère ces cas. L'ancien gating par
      // bDrawSitesGroup était buggy — un complément local avec cette colonne
      // à false (héritage d'une sync antérieure) skippait définitivement le
      // téléchargement, même si le serveur avait bien des groupes à fournir.
      // Le flux "Mettre à jour les données" n'a jamais eu ce check, d'où
      // l'asymétrie observée en prod.
      onStepUpdate?.call('Groupes de sites');
      onProgressUpdate?.call(0.95);
      try {
        await sitesRepository.fetchSiteGroupsForModule(moduleCode, token);
      } catch (e) {
        // Fallback gracieux : si les groupes de sites échouent, continuer sans
        print('Warning: Could not fetch site groups for module $moduleCode: $e');
      }
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
  Future<void> clearDatasetAssociationsForModule(int moduleId) async {
    await database.clearDatasetAssociationsForModule(moduleId);
  }

  @override
  Future<void> associateModuleWithDataset(int moduleId, int datasetId) async {
    await database.associateModuleWithDataset(moduleId, datasetId);
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

  @override
  Future<void> refreshModuleConfiguration(int moduleId, Map<String, dynamic> configuration) async {
    final jsonConfig = json.encode(configuration);
    await database.updateModuleComplementConfiguration(moduleId, jsonConfig);
  }

  @override
  Future<ModuleUninstallStats> getUninstallStats(int moduleId) {
    return database.getUninstallStats(moduleId);
  }

  @override
  Future<void> uninstallModule(int moduleId) {
    return database.uninstallModule(moduleId);
  }
}
