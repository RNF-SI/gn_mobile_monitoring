import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_module_complement_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_module_dataset.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_sites_group_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_module_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_modules.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

part 'modules_dao.g.dart'; // Updated file name

@DriftAccessor(tables: [
  TModules,
  TModuleComplements,
  CorSiteModuleTable,
  CorSitesGroupModuleTable,
  CorModuleDatasetTable
])
class ModulesDao extends DatabaseAccessor<AppDatabase> with _$ModulesDaoMixin {
  ModulesDao(super.db);

  Future<List<Module>> getAllModules() async {
    final dbModules = await select(tModules).get();

    // Fetch and attach sites for each module
    // Fetch and attach site groups for each module
    final modules = <Module>[];
    for (var dbModule in dbModules) {
      final sites = await db.sitesDao.getSitesByModuleId(dbModule.idModule);
      final siteGroups = await db.sitesDao
          .getGroupsByModuleId(dbModule.idModule); // Access SitesDao
      final complement = await getModuleComplementById(dbModule.idModule);
      final module = dbModule.toDomainWithComplementSitesAndSiteGroups(
          complement, sites, siteGroups);
      modules.add(module);
    }

    return modules;
  }

  Future<void> insertModules(List<Module> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tModules, dbEntities);
    });
  }

  Future<void> updateModule(Module module) async {
    final dbEntity = module.toDatabaseEntity();
    await (update(tModules)..where((tbl) => tbl.idModule.equals(module.id)))
        .write(dbEntity.toCompanion(true));
  }

  Future<void> insertAllModules(List<TModule> modules) async {
    await batch((batch) {
      batch.insertAll(tModules, modules);
    });
  }

  Future<void> clearModules() async {
    try {
      await delete(tModules).go();
    } catch (e) {
      throw Exception("Failed to clear modules: ${e.toString()}");
    }
  }

  /// Récupère un module complet avec tous ses sites et groupes de sites associés
  /// Cette méthode est plus lourde car elle charge toutes les relations
  /// Use case: pages de détail, affichage des sites, navigation
  Future<Module> getModuleWithRelationsById(int moduleId) async {
    final dbModule = await (select(tModules)
          ..where((tbl) => tbl.idModule.equals(moduleId)))
        .getSingle();
    final sites = await db.sitesDao.getSitesByModuleId(moduleId);
    final siteGroups =
        await db.sitesDao.getGroupsByModuleId(moduleId); // Access SitesDao
    final complement = await getModuleComplementById(moduleId);
    return dbModule.toDomainWithComplementSitesAndSiteGroups(
        complement, sites, siteGroups);
  }

  /// Récupère uniquement les informations de base d'un module sans charger ses relations
  /// Cette méthode est plus légère et rapide que getModuleWithRelationsById
  /// Use case: récupération d'un attribut spécifique, vérification d'existence
  Future<Module?> getModuleById(int moduleId) async {
    final query = select(tModules)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  Future<void> markModuleAsDownloaded(int moduleId) async {
    await (update(tModules)..where((tbl) => tbl.idModule.equals(moduleId)))
        .write(const TModulesCompanion(
      downloaded: Value(true),
    ));
  }

  Future<List<Module>> getDownloadedModules() async {
    final dbModules = await (select(tModules)
          ..where((tbl) => tbl.downloaded.equals(true)))
        .get();
    return dbModules.map((e) => e.toDomain()).toList();
  }

  // Module Complement operations
  Future<ModuleComplement?> getModuleComplementById(int moduleId) async {
    final query = select(tModuleComplements)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    var result = await query.getSingleOrNull();
    if (result == null) return null;

    // Handle null configuration by providing empty map
    if (result.configuration == null) {
      result = result.copyWith(configuration: const Value('{}'));
    }

    return result.toDomain();
  }

  Future<List<ModuleComplement>> getAllModuleComplements() async {
    final complements = await select(tModuleComplements).get();

    // Handle null configurations by providing empty maps
    return complements.map((result) {
      if (result.configuration == null) {
        result = result.copyWith(configuration: const Value('{}'));
      }
      return result.toDomain();
    }).toList();
  }

  Future<void> insertModuleComplement(ModuleComplement moduleComplement) async {
    await into(tModuleComplements).insert(moduleComplement.toDatabaseEntity());
  }

  Future<void> updateModuleComplement(ModuleComplement moduleComplement) async {
    await (update(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleComplement.idModule)))
        .write(moduleComplement.toDatabaseEntity().toCompanion(true));
  }

  Future<void> updateModuleComplementConfiguration(
      int moduleId, String configuration) async {
    await (update(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleId)))
        .write(TModuleComplementsCompanion(
      configuration: Value(configuration),
    ));
  }

  Future<void> deleteModuleComplement(int moduleId) async {
    await (delete(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleId)))
        .go();
  }

  // Combined operations
  Future<void> deleteModuleWithComplement(int moduleId) async {
    await transaction(() async {
      await deleteModuleComplement(moduleId);
      await (delete(tModules)..where((tbl) => tbl.idModule.equals(moduleId)))
          .go();
    });
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(tModuleComplements).go();
      await delete(tModules).go();
    });
  }

  // Clear CorSiteModule
  Future<void> clearCorSiteModule(int moduleId) async {
    try {
      await (delete(corSiteModuleTable)
            ..where((t) => t.idModule.equals(moduleId)))
          .go();
    } catch (e) {
      throw Exception("Failed to clear module sites: ${e.toString()}");
    }
  }

  // Insert CorSiteModule
  Future<void> insertCorSiteModule(List<CorSiteModule> sites) async {
    final dbEntities = sites
        .map((e) => CorSiteModuleTableCompanion(
              idBaseSite: Value(e.idBaseSite),
              idModule: Value(e.idModule),
            ))
        .toList();

    await batch((batch) {
      batch.insertAll(corSiteModuleTable, dbEntities);
    });
  }

  // Clear module site groups
  Future<void> clearSitesGroupModules(int moduleId) async {
    try {
      await (delete(corSitesGroupModuleTable)
            ..where((t) => t.idModule.equals(moduleId)))
          .go();
    } catch (e) {
      throw Exception("Failed to clear module site groups: ${e.toString()}");
    }
  }

  // Insert module site groups
  Future<void> insertSitesGroupModules(
      List<SitesGroupModule> siteGroups) async {
    final dbEntities = siteGroups
        .map((e) => CorSitesGroupModuleTableCompanion(
              idSitesGroup: Value(e.idSitesGroup),
              idModule: Value(e.idModule),
            ))
        .toList();

    await batch((batch) {
      batch.insertAll(corSitesGroupModuleTable, dbEntities);
    });
  }

  Future<Module?> getModuleIdByLabel(String moduleLabel) async {
    final query = select(tModules)
      ..where((tbl) => tbl.moduleLabel.equals(moduleLabel));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  Future<Module?> getModuleByCode(String moduleCode) async {
    final query = select(tModules)
      ..where((tbl) => tbl.moduleCode.equals(moduleCode));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  // Méthode d'aide pour convertir différents types de valeurs en int
  int? _parseIdListTaxonomy(dynamic value) {
    if (value == null) return null;

    // Si c'est déjà un int, le retourner directement
    if (value is int) return value;

    // Si c'est une String, essayer de la convertir en int
    if (value is String) {
      try {
        return int.parse(value);
      } catch (_) {
        print('Impossible de convertir "$value" en entier');
        return null;
      }
    }

    // Si c'est un double, le convertir en int
    if (value is double) return value.toInt();

    // Si c'est un Map, vérifier s'il a une propriété 'id' ou 'idListe' ou 'id_liste'
    if (value is Map) {
      if (value.containsKey('id')) return _parseIdListTaxonomy(value['id']);
      if (value.containsKey('idListe'))
        return _parseIdListTaxonomy(value['idListe']);
      if (value.containsKey('id_liste'))
        return _parseIdListTaxonomy(value['id_liste']);
    }

    print(
        'Type de valeur non supporté pour id_list_taxonomy: ${value.runtimeType}');
    return null;
  }

  Future<int?> getModuleTaxonomyListId(int moduleId) async {
    try {
      // Récupérer le module complement
      final moduleComplement = await getModuleComplementById(moduleId);
      if (moduleComplement?.configuration != null) {
        try {
          // La configuration peut être soit une Map<String, dynamic>, soit une chaîne JSON, soit un ModuleConfiguration
          Map<String, dynamic> configJson;

          if (moduleComplement!.configuration is String) {
            // Si c'est déjà une chaîne JSON, la parser
            configJson = jsonDecode(moduleComplement.configuration as String)
                as Map<String, dynamic>;
          } else if (moduleComplement.configuration is Map<String, dynamic>) {
            // Si c'est déjà une Map, l'utiliser directement
            configJson = moduleComplement.configuration as Map<String, dynamic>;
          } else {
            // Si c'est un autre type (comme ModuleConfiguration), on va chercher directement dans la base de données
            final result = await (select(tModuleComplements)
                  ..where((t) => t.idModule.equals(moduleId)))
                .getSingleOrNull();
            if (result?.configuration == null) return null;

            configJson =
                jsonDecode(result!.configuration!) as Map<String, dynamic>;
          }

          // Chercher d'abord dans custom.__MODULE.ID_LIST_TAXONOMY
          if (configJson.containsKey('custom') && configJson['custom'] is Map) {
            final customConfig = configJson['custom'] as Map<String, dynamic>;
            if (customConfig.containsKey('__MODULE.ID_LIST_TAXONOMY')) {
              final idListTaxonomy = customConfig['__MODULE.ID_LIST_TAXONOMY'];
              return _parseIdListTaxonomy(idListTaxonomy);
            }
          }

          // Chercher ensuite dans module.id_list_taxonomy
          if (configJson.containsKey('module') && configJson['module'] is Map) {
            final moduleConfig = configJson['module'] as Map<String, dynamic>;
            if (moduleConfig.containsKey('id_list_taxonomy')) {
              final idListTaxonomy = moduleConfig['id_list_taxonomy'];
              return _parseIdListTaxonomy(idListTaxonomy);
            }
          }

          // Chercher directement dans la racine du JSON (pour les configurations plus simples)
          if (configJson.containsKey('id_list_taxonomy')) {
            final idListTaxonomy = configJson['id_list_taxonomy'];
            return _parseIdListTaxonomy(idListTaxonomy);
          }
        } catch (e) {
          print(
              'Erreur de parsing de la configuration du module $moduleId: $e');
        }
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID de liste taxonomique: $e');
      return null;
    }
  }

  // Module-Dataset relationship operations
  Future<void> associateModuleWithDataset(int moduleId, int datasetId) async {
    try {
      // Using insert with onConflict strategy to handle duplicates
      await into(corModuleDatasetTable).insert(
        CorModuleDatasetTableCompanion(
          idModule: Value(moduleId),
          idDataset: Value(datasetId),
        ),
        onConflict: DoNothing(), // Just ignore duplicates
      );
    } catch (e) {
      throw Exception('Failed to associate module with dataset: $e');
    }
  }

  Future<List<int>> getDatasetIdsForModule(int moduleId) async {
    try {
      final results = await (select(corModuleDatasetTable)
            ..where((tbl) => tbl.idModule.equals(moduleId)))
          .get();

      return results.map((row) => row.idDataset).toList();
    } catch (e) {
      throw Exception('Failed to get datasets for module: $e');
    }
  }
}
