import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_nomenclature_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

import '../database.dart';
import '../tables/t_nomenclatures.dart';

part 't_nomenclatures_dao.g.dart';

@DriftAccessor(tables: [TNomenclatures])
class TNomenclaturesDao extends DatabaseAccessor<AppDatabase>
    with _$TNomenclaturesDaoMixin {
  TNomenclaturesDao(super.db);

  Future<void> insertNomenclature(Nomenclature nomenclature) async {
    await into(tNomenclatures).insert(nomenclature.toDatabaseEntity());
  }

  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures) async {
    final dbEntities = nomenclatures.map((e) => e.toDatabaseEntity()).toList();

    await batch((batch) {
      batch.insertAll(tNomenclatures, dbEntities);
    });
  }

  Future<List<Nomenclature>> getAllNomenclatures() async {
    final dbNomenclatures = await select(tNomenclatures).get();
    return dbNomenclatures.map((e) => e.toDomain()).toList();
  }

  Future<void> clearNomenclatures() async {
    try {
      await delete(tNomenclatures).go();
    } catch (e) {
      throw Exception("Failed to clear nomenclatures: ${e.toString()}");
    }
  }
}
