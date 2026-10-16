// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modules_dao.dart';

// ignore_for_file: type=lint
mixin _$ModulesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TModulesTable get tModules => attachedDatabase.tModules;
  $TModuleComplementsTable get tModuleComplements =>
      attachedDatabase.tModuleComplements;
  $CorSiteModuleTableTable get corSiteModuleTable =>
      attachedDatabase.corSiteModuleTable;
  $CorSitesGroupModuleTableTable get corSitesGroupModuleTable =>
      attachedDatabase.corSitesGroupModuleTable;
  $CorModuleDatasetTableTable get corModuleDatasetTable =>
      attachedDatabase.corModuleDatasetTable;
  ModulesDaoManager get managers => ModulesDaoManager(this);
}

class ModulesDaoManager {
  final _$ModulesDaoMixin _db;
  ModulesDaoManager(this._db);
  $$TModulesTableTableManager get tModules =>
      $$TModulesTableTableManager(_db.attachedDatabase, _db.tModules);
  $$TModuleComplementsTableTableManager get tModuleComplements =>
      $$TModuleComplementsTableTableManager(
        _db.attachedDatabase,
        _db.tModuleComplements,
      );
  $$CorSiteModuleTableTableTableManager get corSiteModuleTable =>
      $$CorSiteModuleTableTableTableManager(
        _db.attachedDatabase,
        _db.corSiteModuleTable,
      );
  $$CorSitesGroupModuleTableTableTableManager get corSitesGroupModuleTable =>
      $$CorSitesGroupModuleTableTableTableManager(
        _db.attachedDatabase,
        _db.corSitesGroupModuleTable,
      );
  $$CorModuleDatasetTableTableTableManager get corModuleDatasetTable =>
      $$CorModuleDatasetTableTableTableManager(
        _db.attachedDatabase,
        _db.corModuleDatasetTable,
      );
}
