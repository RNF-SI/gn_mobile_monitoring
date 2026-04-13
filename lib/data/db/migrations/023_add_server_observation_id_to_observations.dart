import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ server_observation_id à la table t_observations
/// pour permettre le suivi de synchronisation avec le serveur
Future<void> migration23(Migrator m, AppDatabase db) async {
  print("Executing migration23: Adding server_observation_id to t_observations");
  
  try {
    // Ajouter la colonne server_observation_id à la table t_observations
    await m.addColumn(
      db.tObservations,
      db.tObservations.serverObservationId,
    );
    
    print("server_observation_id column added successfully");
  } catch (e) {
    print("Error adding server_observation_id column: $e");
    rethrow;
  }
}