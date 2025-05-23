import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ server_visit_id à la table t_base_visits
/// pour permettre le suivi de synchronisation avec le serveur
Future<void> migration22(Migrator m, AppDatabase db) async {
  print("Executing migration22: Adding server_visit_id to t_base_visits");
  
  try {
    // Ajouter la colonne server_visit_id à la table t_base_visits
    await m.addColumn(
      db.tBaseVisits,
      db.tBaseVisits.serverVisitId,
    );
    
    print("server_visit_id column added successfully");
  } catch (e) {
    print("Error adding server_visit_id column: $e");
    rethrow;
  }
}