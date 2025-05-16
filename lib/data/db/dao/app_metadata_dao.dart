import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/app_metadata.dart';

part 'app_metadata_dao.g.dart';

@DriftAccessor(tables: [AppMetadataTable])
class AppMetadataDao extends DatabaseAccessor<AppDatabase> with _$AppMetadataDaoMixin {
  AppMetadataDao(AppDatabase db) : super(db);

  Future<String?> getValue(String key) async {
    final query = select(appMetadataTable)
      ..where((tbl) => tbl.key.equals(key));
    
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  Future<void> setValue(String key, String value) async {
    await into(appMetadataTable).insertOnConflictUpdate(
      AppMetadataTableCompanion.insert(
        key: key,
        value: value,
      ),
    );
  }

  Future<void> deleteValue(String key) async {
    final query = delete(appMetadataTable)
      ..where((tbl) => tbl.key.equals(key));
    
    await query.go();
  }

  Future<Map<String, String>> getAllWithPrefix(String prefix) async {
    final query = select(appMetadataTable)
      ..where((tbl) => tbl.key.like('$prefix%'));
    
    final results = await query.get();
    return {for (var item in results) item.key: item.value};
  }
}
