import 'package:drift/drift.dart';

Future<void> migration4(Migrator m, GeneratedDatabase db) async {
  // Transfer data to core_site_module table
  await db.customStatement('''
    INSERT INTO cor_site_module (id_module, id_base_site)
    SELECT tsc.id_module, tsc.id_base_site
    FROM t_site_complements AS tsc
    LEFT JOIN cor_site_module AS csm
    ON tsc.id_base_site = csm.id_base_site
    WHERE csm.id_base_site IS NULL;
  ''');

  // Drop column id_module from t_site_complements
  await db.customStatement('''
    ALTER TABLE t_site_complements
    DROP COLUMN id_module;
  ''');
}

Future<void> downgrade4(Migrator m, GeneratedDatabase db) async {
  // Re-add the id_module column
  await db.customStatement('''
    ALTER TABLE t_site_complements
    ADD COLUMN id_module INTEGER
    REFERENCES gn_commons.t_modules (id_module)
    ON DELETE CASCADE ON UPDATE CASCADE;
  ''');

  // Set id_module for existing rows using data from cor_site_module
  await db.customStatement('''
    WITH sm AS (
        SELECT min(id_module) AS first_id_module, id_base_site
        FROM cor_site_module AS csm
        GROUP BY id_base_site
    )
    UPDATE t_site_complements sc
    SET id_module = sm.first_id_module
    FROM sm
    WHERE sm.id_base_site = sc.id_base_site;
  ''');

  // Remove rows without a valid id_module
  await db.customStatement('''
    DELETE FROM t_site_complements WHERE id_module IS NULL;
  ''');

  // Set id_module column as NOT NULL
  await db.customStatement('''
    ALTER TABLE t_site_complements
    ALTER COLUMN id_module SET NOT NULL;
  ''');
}
