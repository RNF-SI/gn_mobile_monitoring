// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visites_dao.dart';

// ignore_for_file: type=lint
mixin _$VisitesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TBaseVisitsTable get tBaseVisits => attachedDatabase.tBaseVisits;
  $TVisitComplementsTable get tVisitComplements =>
      attachedDatabase.tVisitComplements;
  $CorVisitObserverTable get corVisitObserver =>
      attachedDatabase.corVisitObserver;
  $TSiteComplementsTable get tSiteComplements =>
      attachedDatabase.tSiteComplements;
  $TObservationsTable get tObservations => attachedDatabase.tObservations;
  VisitesDaoManager get managers => VisitesDaoManager(this);
}

class VisitesDaoManager {
  final _$VisitesDaoMixin _db;
  VisitesDaoManager(this._db);
  $$TBaseVisitsTableTableManager get tBaseVisits =>
      $$TBaseVisitsTableTableManager(_db.attachedDatabase, _db.tBaseVisits);
  $$TVisitComplementsTableTableManager get tVisitComplements =>
      $$TVisitComplementsTableTableManager(
        _db.attachedDatabase,
        _db.tVisitComplements,
      );
  $$CorVisitObserverTableTableManager get corVisitObserver =>
      $$CorVisitObserverTableTableManager(
        _db.attachedDatabase,
        _db.corVisitObserver,
      );
  $$TSiteComplementsTableTableManager get tSiteComplements =>
      $$TSiteComplementsTableTableManager(
        _db.attachedDatabase,
        _db.tSiteComplements,
      );
  $$TObservationsTableTableManager get tObservations =>
      $$TObservationsTableTableManager(_db.attachedDatabase, _db.tObservations);
}
