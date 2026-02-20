import 'package:drift/drift.dart';

import '../database.dart';

/// Migration pour ajouter le champ serverSiteGroupId à la table t_sites_groups
/// pour stocker l'ID du groupe de sites sur le serveur après synchronisation
Future<void> migration28(Migrator m, AppDatabase db) async {
  print("Executing migration28: Adding serverSiteGroupId to t_sites_groups");

  try {
    await m.addColumn(
      db.tSitesGroups,
      db.tSitesGroups.serverSiteGroupId,
    );

    print("serverSiteGroupId column added to t_sites_groups successfully");
  } catch (e) {
    print("Error adding serverSiteGroupId column to t_sites_groups: $e");
    rethrow;
  }
}
