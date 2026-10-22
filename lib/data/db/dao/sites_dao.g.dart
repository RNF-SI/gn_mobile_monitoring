// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sites_dao.dart';

// ignore_for_file: type=lint
mixin _$SitesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TBaseSitesTable get tBaseSites => attachedDatabase.tBaseSites;
  $TSiteComplementsTable get tSiteComplements =>
      attachedDatabase.tSiteComplements;
  $TSitesGroupsTable get tSitesGroups => attachedDatabase.tSitesGroups;
  $CorSitesGroupModuleTableTable get corSitesGroupModuleTable =>
      attachedDatabase.corSitesGroupModuleTable;
  $CorSiteModuleTableTable get corSiteModuleTable =>
      attachedDatabase.corSiteModuleTable;
  SitesDaoManager get managers => SitesDaoManager(this);
}

class SitesDaoManager {
  final _$SitesDaoMixin _db;
  SitesDaoManager(this._db);
  $$TBaseSitesTableTableManager get tBaseSites =>
      $$TBaseSitesTableTableManager(_db.attachedDatabase, _db.tBaseSites);
  $$TSiteComplementsTableTableManager get tSiteComplements =>
      $$TSiteComplementsTableTableManager(
        _db.attachedDatabase,
        _db.tSiteComplements,
      );
  $$TSitesGroupsTableTableManager get tSitesGroups =>
      $$TSitesGroupsTableTableManager(_db.attachedDatabase, _db.tSitesGroups);
  $$CorSitesGroupModuleTableTableTableManager get corSitesGroupModuleTable =>
      $$CorSitesGroupModuleTableTableTableManager(
        _db.attachedDatabase,
        _db.corSitesGroupModuleTable,
      );
  $$CorSiteModuleTableTableTableManager get corSiteModuleTable =>
      $$CorSiteModuleTableTableTableManager(
        _db.attachedDatabase,
        _db.corSiteModuleTable,
      );
}
