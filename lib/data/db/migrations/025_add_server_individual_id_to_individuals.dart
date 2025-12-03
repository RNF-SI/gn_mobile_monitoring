import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ server_individual_id à la table t_individuals
/// pour permettre le suivi de synchronisation avec le serveur
Future<void> migration25(Migrator m, AppDatabase db) async {
  print("Executing migration25: Adding server_individual_id to t_individuals");
  
  try {
    // Ajouter la colonne server_individual_id à la table t_individuals
    await m.addColumn(
      db.tIndividuals,
      db.tIndividuals.serverIndividualId,
    );
    
    print("server_individual_id column added successfully");
  } catch (e) {
    print("Error adding server_individual_id column: $e");
    rethrow;
  }
}