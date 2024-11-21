import 'package:drift/drift.dart';

Future<void> migration13(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing migration13: Adding triggers for gn_monitoring synthese cleanup");

  try {
    // Step 1: Drop existing triggers if they exist
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_observations;
    ''');
    await db.customStatement('''
      DROP TRIGGER IF EXISTS trg_delete_synthese_visits;
    ''');

    print("Existing triggers dropped");

    // Step 2: Create trigger for t_observations
    await db.customStatement('''
      CREATE TRIGGER trg_delete_synthese_observations
      AFTER DELETE ON t_observations
      FOR EACH ROW
      BEGIN
          DELETE FROM synthese WHERE unique_id_sinp = OLD.uuid_observation;
      END;
    ''');
    print("Trigger for 't_observations' created");

    // // Step 3: Create trigger for t_base_visits
    // await db.customStatement('''
    //   CREATE TRIGGER trg_delete_synthese_visits
    //   AFTER DELETE ON t_base_visits
    //   FOR EACH ROW
    //   BEGIN
    //       DELETE FROM synthese WHERE unique_id_sinp = OLD.uuid_base_visit;
    //   END;
    // ''');
    // print("Trigger for 't_base_visits' created");
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
