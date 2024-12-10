import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GlobalDatabaseImpl implements GlobalDatabase {
  AppDatabase? _appDatabase;

  @override
  Future<void> initDatabase() async {
    try {
      print("Initializing database...");
      _appDatabase = await DB.instance.database;

      if (_appDatabase != null) {
        print("Database initialized successfully");

        // Force database to open and verify it is operational
        await _appDatabase!.customSelect('SELECT 1;').get();
        print("Database connection verified");
      } else {
        print("Database initialization failed");
      }
    } catch (e) {
      print("Error during database initialization: $e");
    }
  }

  Future<AppDatabase?> get database async {
    if (_appDatabase == null) {
      await initDatabase();
    }
    return _appDatabase;
  }

  @override
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    final file = File(dbPath);

    if (await file.exists()) {
      await file.delete();
      print("Database deleted at: $dbPath");
    } else {
      print("Database file not found at: $dbPath");
    }

    _appDatabase = null; // Reset the database instance
  }

  Future<void> importAllCsvFiles(String csvFolderPath) async {
    final db = (_appDatabase ??= await DB.instance.database);

    final csvDirectory = Directory(csvFolderPath);

    if (!csvDirectory.existsSync()) {
      print("Directory $csvFolderPath does not exist");
      return;
    }

    final csvFiles = csvDirectory.listSync().where((file) {
      return file is File && file.path.endsWith('.csv');
    });

    for (final file in csvFiles) {
      final fileName = p.basenameWithoutExtension(file.path);
      await importCsv(fileName, file.path);
    }

    print("All CSV files imported successfully.");
  }

  @override
  Future<void> importCsv(String tableName, String assetPath) async {
    final db = (_appDatabase ??= await DB.instance.database);

    try {
      // Load the CSV content from the Flutter assets
      final csvContent = await rootBundle.loadString(assetPath);

      // Parse the CSV content
      final fields = const CsvToListConverter(eol: '\n').convert(csvContent);

      if (fields.isEmpty || fields.length < 2) {
        print('No data found or invalid CSV file for table: $tableName');
        return;
      }

      // Extract headers and data rows
      final headers = fields.first.map((e) => e.toString().trim()).toList();
      final rows = fields.skip(1); // Skip the header row

      print("Headers: $headers");
      print("Rows: $rows");

      // Perform the batch operation
      await db.batch((batch) {
        for (final row in rows) {
          if (row.length != headers.length) {
            print('Skipping invalid row in table: $tableName -> $row');
            continue;
          }

          switch (tableName) {
            case 'bib_tables_locations':
              batch.insert(
                db.bibTablesLocations,
                BibTablesLocationsCompanion(
                  idTableLocation: Value(
                    row[headers.indexOf('id_table_location')] is int
                        ? row[headers.indexOf('id_table_location')]
                        : int.parse(row[headers.indexOf('id_table_location')]),
                  ),
                  tableDesc:
                      Value(row[headers.indexOf('table_desc')].toString()),
                  schemaName:
                      Value(row[headers.indexOf('schema_name')].toString()),
                  tableNameLabel:
                      Value(row[headers.indexOf('table_name')].toString()),
                  pkField: Value(row[headers.indexOf('pk_field')].toString()),
                  uuidFieldName:
                      Value(row[headers.indexOf('uuid_field_name')].toString()),
                ),
              );
              break;

            default:
              print('Unknown table: $tableName. Skipping...');
          }
        }
      });

      print('CSV import completed for table: $tableName');
    } catch (e) {
      print('Error importing CSV for table: $tableName. Error: $e');
    }
  }
}
