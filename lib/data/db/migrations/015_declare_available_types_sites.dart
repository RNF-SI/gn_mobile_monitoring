import 'package:drift/drift.dart';

Future<void> migration15(Migrator m, GeneratedDatabase db) async {
  print("Executing migration15: Declare available types sites permissions");

  try {
    // Insert into `t_objects` table
    // await db.customStatement('''
    //   INSERT INTO t_objects (code_object, description_object)
    //   VALUES
    //   ('TYPES_SITES', 'Types de sites à associer aux protocoles du module MONITORINGS');
    // ''');
    // print("Inserted 'TYPES_SITES' into t_objects");

    // // Insert into `t_permissions_available` table using UNION SELECT
    // await db.customStatement('''
    //   INSERT INTO t_permissions_available (
    //     id_module, id_object, id_action, label, scope_filter
    //   )
    //   SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Accéder aux types de site',
    //     0
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'TYPES_SITES'
    //   JOIN bib_actions a ON a.code_action = 'R'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Créer des types de site',
    //     0
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'TYPES_SITES'
    //   JOIN bib_actions a ON a.code_action = 'C'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Modifier des types de site',
    //     0
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'TYPES_SITES'
    //   JOIN bib_actions a ON a.code_action = 'U'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Supprimer des types de site',
    //     0
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'TYPES_SITES'
    //   JOIN bib_actions a ON a.code_action = 'D'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Accéder aux sites',
    //     1
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'MONITORINGS_SITES'
    //   JOIN bib_actions a ON a.code_action = 'R'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Créer des sites',
    //     1
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'MONITORINGS_SITES'
    //   JOIN bib_actions a ON a.code_action = 'C'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Modifier des sites',
    //     1
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'MONITORINGS_SITES'
    //   JOIN bib_actions a ON a.code_action = 'U'
    //   WHERE m.module_code = 'MONITORINGS'

    //   UNION SELECT
    //     m.id_module,
    //     o.id_object,
    //     a.id_action,
    //     'Supprimer des sites',
    //     1
    //   FROM modules m
    //   JOIN t_objects o ON o.code_object = 'MONITORINGS_SITES'
    //   JOIN bib_actions a ON a.code_action = 'D'
    //   WHERE m.module_code = 'MONITORINGS';
    // ''');
    // print("Inserted permissions into t_permissions_available");

    // // Insert 'MONITORINGS_MODULES' into `t_objects`
    // await db.customStatement('''
    //   INSERT INTO t_objects (code_object, description_object)
    //   VALUES
    //   ('MONITORINGS_MODULES', 'Permissions sur les modules')
    //   ON CONFLICT (code_object) DO NOTHING;
    // ''');
    print("Inserted 'MONITORINGS_MODULES' into t_objects if not exists");
  } catch (e) {
    print("Error during migration15: $e");
    rethrow;
  }
}

Future<void> downgrade15(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration15: Removing permissions and objects");

  try {
    // Remove entries from `t_permissions_available`
    await db.customStatement('''
      DELETE FROM t_permissions_available
      WHERE id_module IN (
        SELECT id_module FROM modules WHERE module_code = 'MONITORINGS'
      )
      AND id_object IN (
        SELECT id_object FROM t_objects
        WHERE code_object IN ('TYPES_SITES', 'MONITORINGS_SITES', 'MONITORINGS_GRP_SITES')
      );
    ''');
    print("Removed entries from t_permissions_available");

    // Remove invalid permissions from `t_permissions`
    await db.customStatement('''
      DELETE FROM t_permissions
      WHERE id_object IN (
        SELECT id_object FROM t_objects
        WHERE code_object IN ('TYPES_SITES', 'MONITORINGS_SITES', 'MONITORINGS_GRP_SITES', 'MONITORINGS_MODULES')
      );
    ''');
    print("Removed invalid permissions from t_permissions");

    // Remove entries from `t_objects`
    await db.customStatement('''
      DELETE FROM t_objects
      WHERE code_object IN ('TYPES_SITES', 'MONITORINGS_SITES', 'MONITORINGS_GRP_SITES', 'MONITORINGS_MODULES');
    ''');
    print("Removed entries from t_objects");
  } catch (e) {
    print("Error during downgrade15: $e");
    rethrow;
  }
}
