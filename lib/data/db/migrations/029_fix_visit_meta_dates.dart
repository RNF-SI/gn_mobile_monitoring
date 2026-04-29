import 'package:drift/drift.dart';

import '../database.dart';

/// Corrige les visites locales dont `meta_create_date` / `meta_update_date`
/// valent la chaîne littérale "CURRENT_TIMESTAMP". Cause :
/// `withDefault(Constant('CURRENT_TIMESTAMP'))` insérait la string au lieu
/// d'évaluer la fonction SQL. À partir de cette version, le mapper Dart
/// fournit toujours une vraie date ISO ; on remplace les valeurs polluées
/// par `visit_date_min` (proxy raisonnable de la date de création).
Future<void> migration29(Migrator m, AppDatabase db) async {
  print(
      "Executing migration29: fixing meta_create_date / meta_update_date polluted with 'CURRENT_TIMESTAMP'");

  try {
    await db.customStatement(
      "UPDATE t_base_visits "
      "SET meta_create_date = visit_date_min "
      "WHERE meta_create_date = 'CURRENT_TIMESTAMP'",
    );
    await db.customStatement(
      "UPDATE t_base_visits "
      "SET meta_update_date = visit_date_min "
      "WHERE meta_update_date = 'CURRENT_TIMESTAMP'",
    );

    print("meta dates fixed on existing visits");
  } catch (e) {
    print("Error fixing meta dates on t_base_visits: $e");
    rethrow;
  }
}
