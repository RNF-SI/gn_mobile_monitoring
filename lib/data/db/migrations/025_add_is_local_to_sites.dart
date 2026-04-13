import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ isLocal à la table t_base_sites
/// pour distinguer les sites créés localement des sites récupérés depuis l'API
Future<void> migration25(Migrator m, AppDatabase db) async {
  print("Executing migration25: Adding isLocal to t_base_sites");
  
  try {
    // Ajouter la colonne isLocal à la table t_base_sites
    // Valeur par défaut: false (les sites existants sont considérés comme non-locaux)
    await m.addColumn(
      db.tBaseSites,
      db.tBaseSites.isLocal,
    );
    
    print("isLocal column added successfully");
  } catch (e) {
    print("Error adding isLocal column: $e");
    rethrow;
  }
}

