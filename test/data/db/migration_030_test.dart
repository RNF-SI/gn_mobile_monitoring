import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/migrations/030_nullable_dataset_objectif.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

/// Migration 30 : `t_datasets.id_nomenclature_dataset_objectif` devient
/// nullable (GeoNature 2.18 ne renvoie plus ce champ, #4103).
void main() {
  late AppDatabase db;

  final datasetWithoutObjectif = Dataset(
    id: 2,
    uniqueDatasetId: 'uuid-2',
    idAcquisitionFramework: 1,
    datasetName: 'JDD 2.18',
    datasetShortname: 'JDD',
    datasetDesc: 'desc',
    idNomenclatureDataType: 323,
    marineDomain: false,
    terrestrialDomain: true,
    idNomenclatureCollectingMethod: 396,
    idNomenclatureDataOrigin: 76,
    idNomenclatureSourceStatus: 73,
    idNomenclatureResourceType: 321,
    // Date explicite : le DEFAULT CURRENT_TIMESTAMP de la table stocke du
    // texte, que Drift ne sait pas relire en DateTime.
    metaCreateDate: DateTime(2026, 5, 19),
  );

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('une base neuve accepte un JDD sans objectif', () async {
    await db.tDatasetsDao.insertDatasets([datasetWithoutObjectif]);

    final stored = await db.tDatasetsDao.getDatasetById(2);
    expect(stored, isNotNull);
    expect(stored!.idNomenclatureDatasetObjectif, isNull);
  });

  test('la migration conserve les JDD existants et lève le NOT NULL', () async {
    // Remet t_datasets dans son état d'avant migration 30 (colonne NOT NULL)
    await db.customStatement('DROP TABLE t_datasets;');
    await db.customStatement('''
      CREATE TABLE t_datasets (
        id_dataset INTEGER PRIMARY KEY AUTOINCREMENT,
        unique_dataset_id TEXT NOT NULL,
        id_acquisition_framework INTEGER NOT NULL,
        dataset_name TEXT NOT NULL,
        dataset_shortname TEXT NOT NULL,
        dataset_desc TEXT NOT NULL,
        id_nomenclature_data_type INTEGER NOT NULL,
        keywords TEXT,
        marine_domain BOOLEAN NOT NULL,
        terrestrial_domain BOOLEAN NOT NULL,
        id_nomenclature_dataset_objectif INTEGER NOT NULL,
        bbox_west REAL,
        bbox_east REAL,
        bbox_south REAL,
        bbox_north REAL,
        id_nomenclature_collecting_method INTEGER NOT NULL,
        id_nomenclature_data_origin INTEGER NOT NULL,
        id_nomenclature_source_status INTEGER NOT NULL,
        id_nomenclature_resource_type INTEGER NOT NULL,
        active BOOLEAN DEFAULT TRUE,
        validable BOOLEAN DEFAULT TRUE,
        id_digitizer INTEGER,
        id_taxa_list INTEGER,
        meta_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        meta_update_date TIMESTAMP
      );
    ''');
    await db.customStatement('''
      INSERT INTO t_datasets (id_dataset, unique_dataset_id,
        id_acquisition_framework, dataset_name, dataset_shortname,
        dataset_desc, id_nomenclature_data_type, marine_domain,
        terrestrial_domain, id_nomenclature_dataset_objectif,
        id_nomenclature_collecting_method, id_nomenclature_data_origin,
        id_nomenclature_source_status, id_nomenclature_resource_type,
        meta_create_date)
      VALUES (1, 'uuid-1', 1, 'JDD 2.17', 'JDD', 'desc', 323, 0, 1, 408,
        396, 76, 73, 321, 1779148800);
    ''');

    await migration30(db.createMigrator(), db);

    final existing = await db.tDatasetsDao.getDatasetById(1);
    expect(existing, isNotNull);
    expect(existing!.datasetName, 'JDD 2.17');
    expect(existing.idNomenclatureDatasetObjectif, 408);

    await db.tDatasetsDao.insertDatasets([datasetWithoutObjectif]);
    final inserted = await db.tDatasetsDao.getDatasetById(2);
    expect(inserted!.idNomenclatureDatasetObjectif, isNull);
  });
}
