import 'package:drift/drift.dart';
import '../database.dart';

Future<void> migration24(Migrator m, AppDatabase db) async {
  await m.createTable(db.tModulePermissions);
}