import 'package:drift/drift.dart';

Future<void> migration3(Migrator m, GeneratedDatabase db) async {
  print("Executing migration3");
  // Perform the `UPDATE` statement using custom SQL
  // await db.customStatement('''
  //   UPDATE t_modules AS tm
  //   SET type = 'monitoring_module'
  //   WHERE EXISTS (
  //     SELECT 1
  //     FROM t_module_complements AS tmc
  //     WHERE tm.id_module = tmc.id_module
  //   );
  // ''');
}

// Downgrade migration for rollback
Future<void> downgrade3(Migrator m, GeneratedDatabase db) async {
  await db.customStatement('''
    UPDATE t_modules AS tm 
    SET type = ''
    WHERE EXISTS (
      SELECT 1 
      FROM t_module_complements AS tmc 
      WHERE tm.id_module = tmc.id_module
    );
  ''');
}
