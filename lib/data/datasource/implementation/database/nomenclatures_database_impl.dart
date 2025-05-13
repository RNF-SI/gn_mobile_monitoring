import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_type_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_type_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';

/// Implementation of the NomenclaturesDatabase interface focusing only
/// on the nomenclatures and nomenclature types operations.
class NomenclaturesDatabaseImpl implements NomenclaturesDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  // --- Nomenclatures implementation ---

  @override
  Future<void> clearNomenclatures() async {
    final db = await _database;
    await db.tNomenclaturesDao.clearNomenclatures();
  }

  @override
  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures) async {
    final db = await _database;

    debugPrint('Reçu ${nomenclatures.length} nomenclatures à synchroniser');

    if (nomenclatures.isEmpty) {
      debugPrint('Aucune nomenclature à synchroniser');
      return;
    }

    // Get existing nomenclatures to avoid duplicates
    final existingNomenclatures =
        await db.tNomenclaturesDao.getAllNomenclatures();
    final existingNomenclatureIds =
        existingNomenclatures.map((n) => n.id).toSet();

    debugPrint(
        'État actuel: ${existingNomenclatures.length} nomenclatures en base');

    // Filter out nomenclatures that already exist
    final newNomenclatures = nomenclatures
        .where((nomenclature) =>
            !existingNomenclatureIds.contains(nomenclature.id))
        .toList();

    // Update existing nomenclatures
    final nomenclaturesToUpdate = nomenclatures
        .where(
            (nomenclature) => existingNomenclatureIds.contains(nomenclature.id))
        .toList();

    debugPrint('${newNomenclatures.length} nouvelles nomenclatures à insérer');
    debugPrint('${nomenclaturesToUpdate.length} nomenclatures à mettre à jour');

    // Insert new nomenclatures
    if (newNomenclatures.isNotEmpty) {
      await db.tNomenclaturesDao.insertNomenclatures(newNomenclatures);
      debugPrint(
          'Insertion de ${newNomenclatures.length} nouvelles nomenclatures terminée');

      // Log some details about the first few nomenclatures for debugging
      for (var i = 0; i < min(newNomenclatures.length, 3); i++) {
        final n = newNomenclatures[i];
        debugPrint(
            '  Ajouté: ID=${n.id}, Label=${n.labelDefault}, Type=${n.idType}');
      }
    }

    // Update existing nomenclatures
    for (final nomenclature in nomenclaturesToUpdate) {
      await db.tNomenclaturesDao.updateNomenclature(nomenclature);
    }

    if (nomenclaturesToUpdate.isNotEmpty) {
      debugPrint(
          'Mise à jour de ${nomenclaturesToUpdate.length} nomenclatures terminée');
    }
  }

  @override
  Future<List<Nomenclature>> getAllNomenclatures() async {
    final db = await _database;
    return await db.tNomenclaturesDao.getAllNomenclatures();
  }

  @override
  Future<Nomenclature?> getNomenclatureById(int nomenclatureId) async {
    final db = await _database;
    return await db.tNomenclaturesDao.getNomenclatureById(nomenclatureId);
  }

  @override
  Future<void> deleteNomenclature(int nomenclatureId) async {
    final db = await _database;
    await db.tNomenclaturesDao.deleteNomenclature(nomenclatureId);
  }

  @override
  Future<List<SyncConflict>> checkNomenclatureReferences(
      int nomenclatureId) async {
    final db = await _database;
    final conflicts = <SyncConflict>[];
    final nomenclature = await getNomenclatureById(nomenclatureId);

    if (nomenclature == null) {
      debugPrint('Nomenclature with ID $nomenclatureId not found');
      return conflicts;
    }

    try {
      // Vérifier les références dans les observations (data)
      final observations = await db.observationDao
          .getObservationsByNomenclatureId(nomenclatureId);

      for (final observation in observations) {
        final complement = await db.observationDao
            .getObservationComplementById(observation.idObservation);

        if (complement != null && complement.data != null) {
          try {
            final Map<String, dynamic> dataMap = jsonDecode(complement.data!);

            // Récupérer les données de contexte complètes
            final visit =
                await db.visitesDao.getVisitById(observation.idBaseVisit!);
            final site = visit != null
                ? await db.sitesDao.getSiteById(visit.idBaseSite!)
                : null;
            final module = visit?.idModule != null
                ? await db.modulesDao.getModuleById(visit!.idModule!)
                : null;

            // Construire une route avec tous les éléments du contexte
            String navigationPath;
            if (visit != null && site != null && module != null) {
              // Chemin complet avec toutes les informations de contexte
              navigationPath =
                  '/module/${module.id}/site/${site.idBaseSite}/visit/${visit.idBaseVisit}/observation/${observation.idObservation}';
            } else {
              // Chemin de secours si une partie du contexte est manquante
              navigationPath = '/observations/${observation.idObservation}';
            }

            // Ajouter les données de contexte dans localData pour affichage
            Map<String, dynamic> enhancedData = {
              ...dataMap,
              '_context': {
                'module': module?.moduleLabel ?? 'Inconnu',
                'module_id': module?.id ?? 0,
                'site': site?.baseSiteName ?? 'Inconnu',
                'site_id': site?.idBaseSite ?? 0,
                'visit': visit?.idBaseVisit ?? 0,
                'observation': observation.idObservation,
              }
            };

            // Créer un conflit pour cette observation avec plus de contexte
            conflicts.add(SyncConflict(
              entityId: observation.idObservation.toString(),
              entityType: 'observation',
              localData: enhancedData,
              remoteData: {},
              localModifiedAt: DateTime.now(),
              remoteModifiedAt: DateTime.now(),
              resolutionStrategy: ConflictResolutionStrategy.userDecision,
              conflictType: ConflictType.deletedReference,
              referencedEntityType: 'nomenclature',
              referencedEntityId: nomenclatureId.toString(),
              affectedField: 'observationComplement.data',
              navigationPath: navigationPath,
            ));
          } catch (e) {
            debugPrint('Error parsing observation data: $e');
          }
        }
      }

      // Vérifier les références dans les détails d'observations (data)
      final observationDetails = await db.observationDetailDao
          .getObservationDetailsByNomenclatureId(nomenclatureId);

      for (final detail in observationDetails) {
        if (detail.data != null) {
          try {
            final Map<String, dynamic> dataMap = jsonDecode(detail.data!);

            // Récupérer les données de contexte complètes
            final observation = await db.observationDao
                .getObservationById(detail.idObservation!);
            final visit = observation != null
                ? await db.visitesDao.getVisitById(observation.idBaseVisit!)
                : null;
            final site = visit != null
                ? await db.sitesDao.getSiteById(visit.idBaseSite!)
                : null;
            final module = visit?.idModule != null
                ? await db.modulesDao.getModuleById(visit!.idModule!)
                : null;

            // Construire une route avec tous les éléments du contexte
            String navigationPath;
            if (observation != null &&
                visit != null &&
                site != null &&
                module != null) {
              // Chemin complet avec toutes les informations de contexte
              navigationPath =
                  '/module/${module.id}/site/${site.idBaseSite}/visit/${visit.idBaseVisit}/observation/${observation.idObservation}/detail/${detail.idObservationDetail}';
            } else {
              // Chemin de secours si une partie du contexte est manquante
              navigationPath =
                  '/observation-details/${detail.idObservationDetail}';
            }

            // Ajouter les données de contexte dans localData pour affichage
            Map<String, dynamic> enhancedData = {
              ...dataMap,
              '_context': {
                'module': module?.moduleLabel ?? 'Inconnu',
                'module_id': module?.id ?? 0,
                'site': site?.baseSiteName ?? 'Inconnu',
                'site_id': site?.idBaseSite ?? 0,
                'visit': visit?.idBaseVisit ?? 0,
                'observation': observation?.idObservation ?? 0,
                'detail': detail.idObservationDetail,
              }
            };

            conflicts.add(SyncConflict(
              entityId: detail.idObservationDetail.toString(),
              entityType: 'observationDetail',
              localData: enhancedData,
              remoteData: {},
              localModifiedAt: DateTime.now(),
              remoteModifiedAt: DateTime.now(),
              resolutionStrategy: ConflictResolutionStrategy.userDecision,
              conflictType: ConflictType.deletedReference,
              referencedEntityType: 'nomenclature',
              referencedEntityId: nomenclatureId.toString(),
              affectedField: 'observationDetail.data',
              navigationPath: navigationPath,
            ));
          } catch (e) {
            debugPrint('Error parsing observation detail data: $e');
          }
        }
      }

      // Vérifier les références dans les compléments de visite (data)
      final visitComplements = await db.visitesDao
          .getVisitComplementsByNomenclatureId(nomenclatureId);

      for (final complement in visitComplements) {
        if (complement.data != null) {
          try {
            final Map<String, dynamic> dataMap = jsonDecode(complement.data!);

            // Récupérer les données de contexte complètes
            final visit =
                await db.visitesDao.getVisitById(complement.idBaseVisit);
            final site = visit != null
                ? await db.sitesDao.getSiteById(visit.idBaseSite!)
                : null;
            final module = visit?.idModule != null
                ? await db.modulesDao.getModuleById(visit!.idModule!)
                : null;

            // Construire une route avec tous les éléments du contexte
            String navigationPath;
            if (visit != null && site != null && module != null) {
              // Chemin complet avec toutes les informations de contexte
              navigationPath =
                  '/module/${module.id}/site/${site.idBaseSite}/visit/${visit.idBaseVisit}';
            } else {
              // Chemin de secours si une partie du contexte est manquante
              navigationPath = '/visits/${complement.idBaseVisit}';
            }

            // Ajouter les données de contexte dans localData pour affichage
            Map<String, dynamic> enhancedData = {
              ...dataMap,
              '_context': {
                'module': module?.moduleLabel ?? 'Inconnu',
                'module_id': module?.id ?? 0,
                'site': site?.baseSiteName ?? 'Inconnu',
                'site_id': site?.idBaseSite ?? 0,
                'visit': visit.idBaseVisit,
              }
            };

            conflicts.add(SyncConflict(
              entityId: complement.idBaseVisit.toString(),
              entityType: 'visitComplement',
              localData: enhancedData,
              remoteData: {},
              localModifiedAt: DateTime.now(),
              remoteModifiedAt: DateTime.now(),
              resolutionStrategy: ConflictResolutionStrategy.userDecision,
              conflictType: ConflictType.deletedReference,
              referencedEntityType: 'nomenclature',
              referencedEntityId: nomenclatureId.toString(),
              affectedField: 'visitComplement.data',
              navigationPath: navigationPath,
            ));
          } catch (e) {
            debugPrint('Error parsing visit complement data: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking nomenclature references: $e');
    }

    // Log the number of conflicts found before returning
    if (conflicts.isNotEmpty) {
      debugPrint('Found ${conflicts.length} nomenclature reference conflicts');
      for (int i = 0; i < conflicts.length; i++) {
        final conflict = conflicts[i];
        debugPrint(
            'Conflict $i: EntityType=${conflict.entityType}, EntityId=${conflict.entityId}, Path=${conflict.navigationPath}');
      }
    } else {
      debugPrint(
          'No nomenclature reference conflicts found for nomenclature ID $nomenclatureId');
    }

    return conflicts;
  }

  // --- Nomenclature Types implementation ---

  @override
  Future<void> insertNomenclatureTypes(List<NomenclatureType> types) async {
    final database = await _database;

    // Get existing types to avoid duplicates
    final existingTypes =
        await database.bibNomenclaturesTypesDao.getAllNomenclatureTypes();
    final existingTypeIds = existingTypes.map((t) => t.idType).toSet();

    // Filter out types that already exist
    final newTypes =
        types.where((type) => !existingTypeIds.contains(type.idType)).toList();

    if (newTypes.isEmpty) {
      // No new types to insert
      return;
    }

    final entries = newTypes.map((type) {
      // For minimal implementation, we only need idType and mnemonique
      return BibNomenclaturesTypesTableCompanion.insert(
        idType: Value(type.idType),
        mnemonique: Value(type.mnemonique), // This should not be null
        // All other fields are optional
        labelDefault: const Value(null),
        definitionDefault: const Value(null),
        labelFr: const Value(null),
        definitionFr: const Value(null),
        labelEn: const Value(null),
        definitionEn: const Value(null),
        labelEs: const Value(null),
        definitionEs: const Value(null),
        labelDe: const Value(null),
        definitionDe: const Value(null),
        labelIt: const Value(null),
        definitionIt: const Value(null),
        source: const Value(null),
        statut: const Value(null),
        metaCreateDate: const Value(null),
        metaUpdateDate: const Value(null),
      );
    }).toList();

    if (entries.isNotEmpty) {
      await database.bibNomenclaturesTypesDao.insertNomenclatureTypes(entries);
    }
  }

  @override
  Future<List<NomenclatureType>> getAllNomenclatureTypes() async {
    final database = await _database;
    final results =
        await database.bibNomenclaturesTypesDao.getAllNomenclatureTypes();
    return results.map((entity) {
      final entityMap = {
        'id_type': entity.idType,
        'mnemonique': entity.mnemonique,
        'label_default': entity.labelDefault,
        'definition_default': entity.definitionDefault,
        'label_fr': entity.labelFr,
        'definition_fr': entity.definitionFr,
        'label_en': entity.labelEn,
        'definition_en': entity.definitionEn,
        'label_es': entity.labelEs,
        'definition_es': entity.definitionEs,
        'label_de': entity.labelDe,
        'definition_de': entity.definitionDe,
        'label_it': entity.labelIt,
        'definition_it': entity.definitionIt,
        'source': entity.source,
        'statut': entity.statut,
        'meta_create_date': entity.metaCreateDate?.toIso8601String(),
        'meta_update_date': entity.metaUpdateDate?.toIso8601String(),
      };
      return NomenclatureTypeEntity.fromDb(entityMap).toDomain();
    }).toList();
  }

  @override
  Future<NomenclatureType?> getNomenclatureTypeByMnemonique(
      String mnemonique) async {
    final database = await _database;
    final result = await database.bibNomenclaturesTypesDao
        .getNomenclatureTypeByMnemonique(mnemonique);
    if (result == null) return null;

    final entityMap = {
      'id_type': result.idType,
      'mnemonique': result.mnemonique,
      'label_default': result.labelDefault,
      'definition_default': result.definitionDefault,
      'label_fr': result.labelFr,
      'definition_fr': result.definitionFr,
      'label_en': result.labelEn,
      'definition_en': result.definitionEn,
      'label_es': result.labelEs,
      'definition_es': result.definitionEs,
      'label_de': result.labelDe,
      'definition_de': result.definitionDe,
      'label_it': result.labelIt,
      'definition_it': result.definitionIt,
      'source': result.source,
      'statut': result.statut,
      'meta_create_date': result.metaCreateDate?.toIso8601String(),
      'meta_update_date': result.metaUpdateDate?.toIso8601String(),
    };
    return NomenclatureTypeEntity.fromDb(entityMap).toDomain();
  }

  @override
  Future<void> clearNomenclatureTypes() async {
    final database = await _database;
    await database.bibNomenclaturesTypesDao.clearNomenclatureTypes();
  }
}
