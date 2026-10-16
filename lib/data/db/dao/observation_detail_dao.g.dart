// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_detail_dao.dart';

// ignore_for_file: type=lint
mixin _$ObservationDetailDaoMixin on DatabaseAccessor<AppDatabase> {
  $TObservationDetailsTable get tObservationDetails =>
      attachedDatabase.tObservationDetails;
  ObservationDetailDaoManager get managers => ObservationDetailDaoManager(this);
}

class ObservationDetailDaoManager {
  final _$ObservationDetailDaoMixin _db;
  ObservationDetailDaoManager(this._db);
  $$TObservationDetailsTableTableManager get tObservationDetails =>
      $$TObservationDetailsTableTableManager(
        _db.attachedDatabase,
        _db.tObservationDetails,
      );
}
