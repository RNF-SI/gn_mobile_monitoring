// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_metadata_dao.dart';

// ignore_for_file: type=lint
mixin _$AppMetadataDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppMetadataTableTable get appMetadataTable =>
      attachedDatabase.appMetadataTable;
  AppMetadataDaoManager get managers => AppMetadataDaoManager(this);
}

class AppMetadataDaoManager {
  final _$AppMetadataDaoMixin _db;
  AppMetadataDaoManager(this._db);
  $$AppMetadataTableTableTableManager get appMetadataTable =>
      $$AppMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.appMetadataTable,
      );
}
