// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_nomenclatures_dao.dart';

// ignore_for_file: type=lint
mixin _$TNomenclaturesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TNomenclaturesTable get tNomenclatures => attachedDatabase.tNomenclatures;
  TNomenclaturesDaoManager get managers => TNomenclaturesDaoManager(this);
}

class TNomenclaturesDaoManager {
  final _$TNomenclaturesDaoMixin _db;
  TNomenclaturesDaoManager(this._db);
  $$TNomenclaturesTableTableManager get tNomenclatures =>
      $$TNomenclaturesTableTableManager(
        _db.attachedDatabase,
        _db.tNomenclatures,
      );
}
