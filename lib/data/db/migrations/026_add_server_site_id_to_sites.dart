import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ serverSiteId à la table t_base_sites
/// pour stocker l'ID du site sur le serveur après synchronisation
Future<void> migration26(Migrator m, AppDatabase db) async {
  print("Executing migration26: Adding serverSiteId to t_base_sites");

  try {
    // Ajouter la colonne serverSiteId à la table t_base_sites
    // Cette colonne stocke l'ID du site sur le serveur après synchronisation
    await m.addColumn(
      db.tBaseSites,
      db.tBaseSites.serverSiteId,
    );

    print("serverSiteId column added successfully");
  } catch (e) {
    print("Error adding serverSiteId column: $e");
    rethrow;
  }
}
