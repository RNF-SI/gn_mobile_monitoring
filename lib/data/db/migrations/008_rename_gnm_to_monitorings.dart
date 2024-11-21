import 'package:drift/drift.dart';

Future<void> migration8(Migrator m, GeneratedDatabase db) async {
  print("Executing migration8");

  // Update `code_object` from 'GNM_' to 'MONITORINGS_'
  await db.customStatement('''
    UPDATE t_objects
    SET code_object = REPLACE(code_object, 'GNM_', 'MONITORINGS_')
    WHERE code_object LIKE 'GNM_%';
  ''');
}

// Downgrade Migration
Future<void> downgrade8(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration8");

  // Revert `code_object` from 'MONITORINGS_' back to 'GNM_'
  await db.customStatement('''
    UPDATE t_objects
    SET code_object = REPLACE(code_object, 'MONITORINGS_', 'GNM_')
    WHERE code_object LIKE 'MONITORINGS_%';
  ''');
}
