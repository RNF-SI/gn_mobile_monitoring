import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ isLocal à la table t_sites_groups
/// pour distinguer les groupes de sites créés localement des groupes récupérés depuis l'API
Future<void> migration27(Migrator m, AppDatabase db) async {
  print("Executing migration27: Adding isLocal to t_sites_groups");

  try {
    await m.addColumn(
      db.tSitesGroups,
      db.tSitesGroups.isLocal,
    );

    print("isLocal column added to t_sites_groups successfully");
  } catch (e) {
    print("Error adding isLocal column to t_sites_groups: $e");
    rethrow;
  }
}
