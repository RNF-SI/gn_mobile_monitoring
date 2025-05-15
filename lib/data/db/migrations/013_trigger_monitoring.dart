import 'package:drift/drift.dart';

Future<void> migration13(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing migration13: Removing triggers for gn_monitoring synthese cleanup (not needed in mobile app)");

  try {
    // Drop existing triggers if they exist
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_observations;
    ''');
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_visits;
    ''');

    print("Triggers dropped (no longer needed in mobile app)");
    
    // Les triggers ne sont pas nécessaires dans l'application mobile
    // et causent des erreurs lors de la suppression d'observations
    
  } catch (e) {
    print("Error during migration13: $e");
    rethrow;
  }
}

Future<void> downgrade13(Migrator m, GeneratedDatabase db) async {
  print(
      "Downgrading migration13: Removing triggers for gn_monitoring synthese cleanup");

  try {
    // Step 1: Drop the triggers
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_observations;
    ''');
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_visits;
    ''');
    print("Triggers dropped during downgrade");
  } catch (e) {
    print("Error during downgrade13: $e");
    rethrow;
  }
}
