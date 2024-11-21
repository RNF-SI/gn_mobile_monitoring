import 'package:drift/drift.dart';

Future<void> migration10(Migrator m, GeneratedDatabase db) async {
  print("Executing migration10: No operations performed for upgrade.");
}

// Downgrade Migration
Future<void> downgrade10(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration10: Recreating permissions for 'ALL'");

  try {
    // Insert permissions available for 'ALL'
    await db.customStatement('''
      INSERT INTO permissions_available
      (id_module, id_object, id_action, label, scope_filter, sensitivity_filter)
      SELECT
          tp.id_module,
          (SELECT id_object FROM objects WHERE code_object = 'ALL') AS id_object,
          tp.id_action,
          tp.label,
          tp.scope_filter,
          tp.sensitivity_filter
      FROM permissions_available AS tp
      JOIN modules AS tm
      ON tm.id_module = tp.id_module AND tm.type = 'monitoring_module'
      JOIN objects AS o
      ON o.id_object = tp.id_object AND code_object = 'MONITORINGS_MODULES';
    ''');

    print("Recreated permissions available for 'ALL'");

    // Insert permissions for 'ALL'
    await db.customStatement('''
      INSERT INTO permissions
      (id_role, id_action, id_module, id_object, scope_value, sensitivity_filter)
      SELECT
          tp.id_role,
          tp.id_action,
          tp.id_module,
          (SELECT id_object FROM objects WHERE code_object = 'ALL') AS id_object,
          tp.scope_value,
          tp.sensitivity_filter
      FROM permissions AS tp
      JOIN modules AS tm
      ON tm.id_module = tp.id_module AND tm.type = 'monitoring_module'
      JOIN objects AS o
      ON o.id_object = tp.id_object AND code_object = 'MONITORINGS_MODULES';
    ''');

    print("Recreated permissions for 'ALL'");
  } catch (e) {
    print("Error during downgrade10: $e");
    rethrow;
  }
}
