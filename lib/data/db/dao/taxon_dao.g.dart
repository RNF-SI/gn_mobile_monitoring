// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxon_dao.dart';

// ignore_for_file: type=lint
mixin _$TaxonDaoMixin on DatabaseAccessor<AppDatabase> {
  $TTaxrefsTable get tTaxrefs => attachedDatabase.tTaxrefs;
  $BibListesTableTable get bibListesTable => attachedDatabase.bibListesTable;
  $CorTaxonListeTableTable get corTaxonListeTable =>
      attachedDatabase.corTaxonListeTable;
  TaxonDaoManager get managers => TaxonDaoManager(this);
}

class TaxonDaoManager {
  final _$TaxonDaoMixin _db;
  TaxonDaoManager(this._db);
  $$TTaxrefsTableTableManager get tTaxrefs =>
      $$TTaxrefsTableTableManager(_db.attachedDatabase, _db.tTaxrefs);
  $$BibListesTableTableTableManager get bibListesTable =>
      $$BibListesTableTableTableManager(
        _db.attachedDatabase,
        _db.bibListesTable,
      );
  $$CorTaxonListeTableTableTableManager get corTaxonListeTable =>
      $$CorTaxonListeTableTableTableManager(
        _db.attachedDatabase,
        _db.corTaxonListeTable,
      );
}
