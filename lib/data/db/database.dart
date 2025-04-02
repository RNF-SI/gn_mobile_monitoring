import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gn_mobile_monitoring/data/db/dao/bib_nomenclatures_types_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/modules_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/observation_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/observation_detail_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/sites_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/t_dataset_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/t_nomenclatures_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/visites_dao.dart';
import 'package:gn_mobile_monitoring/data/db/migrations/018_add_downloaded_column_in_module_table.dart';
import 'package:gn_mobile_monitoring/data/db/migrations/019_add_configuration_column_in_module_complement.dart';
import 'package:gn_mobile_monitoring/data/db/migrations/020_add_code_type_to_nomenclatures.dart';
import 'package:gn_mobile_monitoring/data/db/tables/bib_nomenclatures_types.dart';
import 'package:gn_mobile_monitoring/data/db/tables/bib_tables_locations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/bib_type_site.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_object_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_type.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_sites_group_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_visit_observer.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_actions.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_sites.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_datasets.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_module_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_modules.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_nomenclatures.dart';
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
  TBaseSites,
  TNomenclatures,
  TDatasets,
  TModuleComplements,
  TSitesGroups,
  TSiteComplements,
  TVisitComplements,
  TObservations,
  TObservationComplements,
  TObservationDetails,
  BibTablesLocations,
  BibNomenclaturesTypesTable,
  BibTypeSitesTable,
  TObjects,
  TActions,
  TPermissionsAvailable,
  TPermissions,
  CorSiteModuleTable,
  CorSitesGroupModuleTable,
  CorObjectModuleTable,
  CorVisitObserver,
  CorSiteTypeTable,
  TBaseVisits,
], daos: [
  ModulesDao,
  TNomenclaturesDao,
  SitesDao,
  TDatasetsDao,
  VisitesDao,
  ObservationDao,
  ObservationDetailDao,
  BibNomenclaturesTypesDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase? _instance;

  // Singleton accessor
  static Future<AppDatabase> getInstance() async {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  // Reset method
  static Future<void> resetInstance() async {
    if (_instance != null) {
      await _instance!.close();
      _instance = null;
    }
  }

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await migration1(m, this);
          await migration2(m, this);
          await migration3(m, this);
          await migration4(m, this);
          await migration5(m, this);
          await migration6(m, this);
          await migration7(m, this);
          await migration8(m, this);
          await migration9(m, this);
          await migration10(m, this);
          await migration11(m, this);
          await migration12(m, this);
          await migration13(m, this);
          await migration14(m, this);
          await migration15(m, this);
          await migration16(m, this);
          await migration17(m, this);
          await migration18(m, this);
          await migration19(m, this);
          await migration20(m, this);
        },
        onUpgrade: (Migrator m, int from, int to) async {
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
              case 18:
                await migration18(m, db);
                break;
              case 19:
                await migration19(m, db);
                break;
              case 20:
                await migration20(m, db);
                break;
              default:
                throw Exception("Unexpected schema version: $i");
            }
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    final file = File(dbPath);

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    return NativeDatabase(file, logStatements: true);
  });
}
