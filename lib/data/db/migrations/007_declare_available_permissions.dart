import 'package:drift/drift.dart';

Future<void> migration7(Migrator m, GeneratedDatabase db) async {
  print("Executing migration7");

  // Step 1: Insert permissions into t_permissions_available
  await db.customStatement('''
    INSERT INTO t_permissions_available (
      id_module, id_object, id_action, label, scope_filter
    )
    SELECT
      m.id_module,
      o.id_object,
      a.id_action,
      'Accéder au module' AS label,
      0 AS scope_filter -- SQLite uses 0/1 for Boolean
    FROM
      (
        SELECT 'MONITORINGS' AS module_code, 'ALL' AS object_code, 'R' AS action_code
      ) AS v
    JOIN t_modules m ON m.module_code = v.module_code
    JOIN t_objects o ON o.code_object = v.object_code
    JOIN bib_actions a ON a.code_action = v.action_code;
  ''');

  // Step 2: Remove invalid permissions from t_permissions
  await db.customStatement('''
    DELETE FROM t_permissions
    WHERE id_permission IN (
      SELECT p.id_permission
      FROM t_permissions p
      JOIN t_modules m USING (id_module)
      WHERE m.module_code = 'MONITORINGS'
      EXCEPT
      SELECT p.id_permission
      FROM t_permissions p
      JOIN t_permissions_available pa ON (
        p.id_module = pa.id_module
        AND p.id_object = pa.id_object
        AND p.id_action = pa.id_action
      )
    );
  ''');

  // Step 3: Add new object 'GNM_MODULES' into t_objects
  await db.customStatement('''
    INSERT INTO t_objects (code_object, description_object)
    VALUES ('GNM_MODULES', 'Permissions sur les modules')
    ON CONFLICT (code_object) DO NOTHING;
  ''');
}

// Downgrade Migration
Future<void> downgrade7(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration7");

  // Step 1: Remove entries from t_permissions_available related to 'MONITORINGS'
  await db.customStatement('''
    DELETE FROM t_permissions_available
    WHERE id_module IN (
      SELECT id_module
      FROM t_modules
      WHERE module_code = 'MONITORINGS'
    );
  ''');
}
