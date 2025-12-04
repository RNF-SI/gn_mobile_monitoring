import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

Future<void> migration25(Migrator m, AppDatabase db) async {
  print("Executing migration25: Creating cor_individual_module_table");

  try {
    await m.createTable(db.tIndividuals);
    print("t_individuals created successfully");
  } catch (e) {
    print("Error creating t_individuals: $e");
    rethrow;
  }

  try {
    await m.createTable(db.corIndividualModuleTable);
    print("cor_individual_module_table created successfully");
  } catch (e) {
    print("Error creating cor_individual_module_table: $e");
    rethrow;
  }
}