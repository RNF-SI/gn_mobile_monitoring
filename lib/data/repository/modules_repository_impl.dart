import 'dart:convert';

import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/bib_type_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final GlobalApi globalApi;
  final ModulesApi api;
  final TaxonApi taxonApi;
  final ModulesDatabase database;
  final NomenclaturesDatabase nomenclaturesDatabase;
  final DatasetsDatabase datasetsDatabase;
  final TaxonDatabase? taxonDatabase;

  ModulesRepositoryImpl(
    this.globalApi,
    this.api,
    this.taxonApi,
    this.database,
    this.nomenclaturesDatabase,
    this.datasetsDatabase,
    this.taxonDatabase,
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

      // Update existing modules
      for (final moduleToUpdate in modulesToUpdate) {
        await database.updateModule(moduleToUpdate);
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
  Future<void> downloadModuleData(int moduleId) async {
    try {
      final moduleCode = await database
          .getModuleCodeFromIdModule(moduleId); // Fetch module name

      // 1. Fetch nomenclatures and datasets
      final data = await globalApi.getNomenclaturesAndDatasets(moduleCode);

      // Process nomenclatures
      final nomenclatures = (data['nomenclatures'] as List<NomenclatureEntity>)
          .map((e) => e.toDomain())
          .toList();

      // Insert nomenclatures with duplicate handling
      await nomenclaturesDatabase.insertNomenclatures(nomenclatures);

      // Process nomenclature types - extract from the nomenclatures
      if (data.containsKey('nomenclatureTypes')) {
        final typesData = data['nomenclatureTypes'] as List<dynamic>;
        final nomenclatureTypes = typesData
            .map((typeData) => NomenclatureType(
                  idType: typeData['idType'] as int,
                  mnemonique: typeData['mnemonique'] as String,
                ))
            .toList();

        // Don't clear existing types, just add new ones, avoiding duplicates
        // The insertNomenclatureTypes method will handle duplicate prevention
        await nomenclaturesDatabase.insertNomenclatureTypes(nomenclatureTypes);
      }

      // Process datasets
      final datasets = (data['datasets'] as List<DatasetEntity>)
          .map((e) => e.toDomain())
          .toList();

      await datasetsDatabase.clearDatasets();
      await datasetsDatabase.insertDatasets(datasets);

      // 2. Fetch and store module configuration
      final config = await globalApi.getModuleConfiguration(moduleCode);

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

            // Store the nomenclature info if it's not already in the nomenclatures list
            final nomenclatureInfo = siteTypeData;
            if (!nomenclatures.any((n) => n.id == int.parse(siteTypeId))) {
              final nomenclature = Nomenclature(
                id: int.parse(siteTypeId),
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

        // Save the site types to the database
        // if (relevantSiteTypes.isNotEmpty) {
        //   await nomenclaturesDatabase.clearBibTypeSites();
        //   await nomenclaturesDatabase.insertBibTypeSites(relevantSiteTypes);
        // }
      }

      // 4. Download module taxons if available
      try {
        // Check if the module has a taxonomy list associated with it
        final moduleComplement =
            await database.getModuleComplementById(moduleId);
        if (moduleComplement != null &&
            moduleComplement.idListTaxonomy != null &&
            taxonDatabase != null) {
          final idListTaxonomy = moduleComplement.idListTaxonomy!;

          // Get taxons from API
          final taxons = await taxonApi.getTaxonsByList(idListTaxonomy);

          // Save taxons in local database
          await taxonDatabase!.saveTaxons(taxons);

          // Get and save the taxon list
          final taxonList = await taxonApi.getTaxonList(idListTaxonomy);
          await taxonDatabase!.saveTaxonLists([taxonList]);

          // Link taxons to the list
          final cdNoms = taxons.map((t) => t.cdNom).toList();
          await taxonDatabase!.saveTaxonsToList(idListTaxonomy, cdNoms);

          print('Taxons downloaded and saved successfully.');
        } else if (moduleComplement?.idListTaxonomy != null) {
          print(
              'Module has taxonomy list (ID: ${moduleComplement!.idListTaxonomy}) but TaxonDatabase is not available.');
        }
      } catch (taxonError) {
        // Log error but don't fail the whole download - taxons are optional
        print('Error downloading taxons for module $moduleId: $taxonError');
      }

      // Mark module as downloaded
      await database.markModuleAsDownloaded(moduleId);
    } catch (e) {
      throw Exception('Failed to download module data: $e');
    }
  }

  @override
  Future<Module> getModuleWithConfig(int moduleId) async {
    // Fetch module and complement from database
    final module = await database.getModuleById(moduleId);
    final complement = await database.getModuleComplementById(moduleId);

    // If module is null, throw an exception
    if (module == null) {
      throw Exception('Module not found with ID: $moduleId');
    }

    // Return module with complement if it exists
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
