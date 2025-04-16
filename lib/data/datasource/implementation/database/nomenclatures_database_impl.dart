import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_type_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_type_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';

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

    // Get existing nomenclatures to avoid duplicates
    final existingNomenclatures =
        await db.tNomenclaturesDao.getAllNomenclatures();
    final existingNomenclatureIds =
        existingNomenclatures.map((n) => n.id).toSet();

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

    // Insert new nomenclatures
    if (newNomenclatures.isNotEmpty) {
      await db.tNomenclaturesDao.insertNomenclatures(newNomenclatures);
    }

    // Update existing nomenclatures
    for (final nomenclature in nomenclaturesToUpdate) {
      await db.tNomenclaturesDao.updateNomenclature(nomenclature);
    }
  }

  @override
  Future<List<Nomenclature>> getAllNomenclatures() async {
    final db = await _database;
    return await db.tNomenclaturesDao.getAllNomenclatures();
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
