import 'package:drift/drift.dart';

Future<void> migration16(Migrator m, GeneratedDatabase db) async {
  print("Executing migration16: Add site group object for monitoring module");

  try {
    // Insert into `cor_object_module_table` table
    // await db.customStatement('''
    //   INSERT INTO cor_object_module (id_object, id_module)
    //   VALUES
    //   (
    //     (SELECT id_object FROM t_objects WHERE code_object = 'MONITORINGS_GRP_SITES'),
    //     (SELECT id_module FROM modules WHERE module_code = 'MONITORINGS')
    //   );
    // ''');
    print("Inserted MONITORINGS_GRP_SITES into cor_object_module_table");
  } catch (e) {
    print("Error during migration16: $e");
    rethrow;
  }
}

Future<void> downgrade16(Migrator m, GeneratedDatabase db) async {
  print(
      "Downgrading migration16: Remove site group object for monitoring module");

  try {
    // Delete the entry from `cor_object_module`
    await db.customStatement('''
      DELETE FROM cor_object_module_table
      WHERE id_object = (SELECT id_object FROM t_objects WHERE code_object = 'MONITORINGS_GRP_SITES')
      AND id_module = (SELECT id_module FROM modules WHERE module_code = 'MONITORINGS');
    ''');
    print("Removed MONITORINGS_GRP_SITES from cor_object_module_table");
  } catch (e) {
    print("Error during downgrade16: $e");
    rethrow;
  }
}
