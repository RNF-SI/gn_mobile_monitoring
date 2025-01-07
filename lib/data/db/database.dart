import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gn_mobile_monitoring/data/db/dao/t_modules_dao.dart';
import 'package:gn_mobile_monitoring/data/db/tables/bib_tables_locations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_object_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_actions.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_module_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_modules.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_objects.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observation_details.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_permissions.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_permissions_available.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_groups.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_visit_complements.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'migrations/001_create_monitoring_schema.dart';
import 'migrations/002_create_geonature_table.dart';
import 'migrations/003_add_type_to_gn_modules.dart';
import 'migrations/004_remove_id_module_from_sites_complements.dart';
import 'migrations/005_remove_id_module_from_sites_groups.dart';
import 'migrations/006_correction_t_observation_detail.dart';
import 'migrations/007_declare_available_permissions.dart';
import 'migrations/008_rename_gnm_to_monitorings.dart';
import 'migrations/009_upgrade_existing_permissions.dart';
import 'migrations/010_delete_object_all.dart';
import 'migrations/011_add_digitiliser_to_t_sites_groups.dart';
import 'migrations/012_add_geom_column_to_sites_group.dart';
import 'migrations/013_trigger_monitoring.dart';
import 'migrations/014_add_site_object_for_monitoring_module.dart';
import 'migrations/015_declare_available_types_sites.dart';
import 'migrations/016_add_site_group_object_for_monitoring.dart';
import 'migrations/017_add_observation_details_entry_in_bib.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  TModules,
  TModuleComplements,
  TSitesGroups,
  TSiteComplements,
  TVisitComplements,
  TObservations,
  TObservationComplements,
  TObservationDetails,
  BibTablesLocations,
  TObjects,
  TActions,
  TPermissionsAvailable,
  TPermissions,
  CorSiteModules,
  CorObjectModules,
], daos: [
  TModulesDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    print("Database initialized");
  }

  @override
  int get schemaVersion => 17; // Update schema version to 17

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          print("Executing onCreate migrations...");
          await migration1(m, this);
          print("Migration 1 completed");
          await migration2(m, this);
          print("Migration 2 completed");
          await migration3(m, this);
          print("Migration 3 completed");
          await migration4(m, this);
          print("Migration 4 completed");
          await migration5(m, this);
          print("Migration 5 completed");
          await migration6(m, this);
          print("Migration 6 completed");
          await migration7(m, this);
          print("Migration 7 completed");
          await migration8(m, this);
          print("Migration 8 completed");
          await migration9(m, this);
          print("Migration 9 completed");
          await migration10(m, this);
          print("Migration 10 completed");
          await migration11(m, this);
          print("Migration 11 completed");
          await migration12(m, this);
          print("Migration 12 completed");
          await migration13(m, this);
          print("Migration 13 completed");
          await migration14(m, this);
          print("Migration 14 completed");
          await migration15(m, this);
          print("Migration 15 completed");
          await migration16(m, this);
          print("Migration 16 completed");
          await migration17(m, this);
          print("Migration 17 completed");
        },
        onUpgrade: (Migrator m, int from, int to) async {
          print("Upgrading database from $from to $to...");
          final db = this; // Access the database instance
          for (int i = from + 1; i <= to; i++) {
            switch (i) {
              case 2:
                await migration2(m, db);
                break;
              case 3:
                await migration3(m, db);
                break;
              case 4:
                await migration4(m, db);
                break;
              case 5:
                await migration5(m, db);
                break;
              case 6:
                await migration6(m, db);
                break;
              case 7:
                await migration7(m, db);
                break;
              case 8:
                await migration8(m, db);
                break;
              case 9:
                await migration9(m, db);
                break;
              case 10:
                await migration10(m, db);
                break;
              case 11:
                await migration11(m, db);
                break;
              case 12:
                await migration12(m, db);
                break;
              case 13:
                await migration13(m, db);
                break;
              case 14:
                await migration14(m, db);
                break;
              case 15:
                await migration15(m, db);
                break;
              case 16:
                await migration16(m, db);
                break;
              case 17:
                await migration17(m, db);
                break;
              default:
                throw Exception("Unexpected schema version: $i");
            }
            print("Migration $i applied");
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    return NativeDatabase(File(dbPath));
  });
}

Future<void> deleteDatabaseFile() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dbFolder.path, 'app.sqlite');
  final file = File(dbPath);
  if (await file.exists()) {
    await file.delete();
    print("Database file deleted");
  }
}
