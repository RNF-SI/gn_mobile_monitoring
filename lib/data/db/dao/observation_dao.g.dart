// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_dao.dart';

// ignore_for_file: type=lint
mixin _$ObservationDaoMixin on DatabaseAccessor<AppDatabase> {
  $TObservationsTable get tObservations => attachedDatabase.tObservations;
  $TObservationComplementsTable get tObservationComplements =>
      attachedDatabase.tObservationComplements;
  ObservationDaoManager get managers => ObservationDaoManager(this);
}

class ObservationDaoManager {
  final _$ObservationDaoMixin _db;
  ObservationDaoManager(this._db);
  $$TObservationsTableTableManager get tObservations =>
      $$TObservationsTableTableManager(_db.attachedDatabase, _db.tObservations);
  $$TObservationComplementsTableTableManager get tObservationComplements =>
      $$TObservationComplementsTableTableManager(
        _db.attachedDatabase,
        _db.tObservationComplements,
      );
}
