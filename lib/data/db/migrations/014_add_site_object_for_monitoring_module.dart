import 'package:drift/drift.dart';

Future<void> migration14(Migrator m, GeneratedDatabase db) async {
  print("Executing migration14: Adding site object for monitoring module");

  try {
    // // Step 1: Fetch the required id_object and id_module
    // final result = await db.customSelect(
    //   '''
    //   SELECT
    //     (SELECT id_object FROM t_objects WHERE code_object = 'MONITORINGS_SITES') AS id_object,
    //     (SELECT id_module FROM t_modules WHERE module_code = 'MONITORINGS') AS id_module
    //   ''',
    //   readsFrom: {db.attachedDatabase.allTables.first},
    // ).getSingle();

    // final idObject = result.data['id_object'];
    // final idModule = result.data['id_module'];

    // if (idObject != null && idModule != null) {
    //   // Step 2: Insert into cor_object_module table
    //   await db.customStatement('''
    //     INSERT INTO cor_object_module (id_cor_object_module, id_object, id_module)
    //     VALUES (
    //       (SELECT IFNULL(MAX(id_cor_object_module), 0) + 1 FROM cor_object_module),
    //       ?, ?
    //     );
    //   ''', [idObject, idModule]);

    //   print("Site object for monitoring module added successfully");
    // } else {
    //   throw Exception(
    //       "Could not find id_object or id_module for the given parameters");
    // }
  } catch (e) {
    print("Error during migration14: $e");
    rethrow;
  }
}

Future<void> downgrade14(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration14: Removing site object for monitoring module");

  try {
    // Delete from cor_object_module table
    await db.customStatement('''
      DELETE FROM cor_object_module
      WHERE id_object = (SELECT id_object FROM t_objects WHERE code_object = 'MONITORINGS_SITES')
      AND id_module = (SELECT id_module FROM t_modules WHERE module_code = 'MONITORINGS');
    ''');
    print("Site object for monitoring module removed successfully");
  } catch (e) {
    print("Error during downgrade14: $e");
    rethrow;
  }
}
