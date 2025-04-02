import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

Future<void> migration20(Migrator m, AppDatabase db) async {
  await m.addColumn(db.tNomenclatures, db.tNomenclatures.codeType);
}