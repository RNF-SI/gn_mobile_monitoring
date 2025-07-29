import 'package:drift/drift.dart';

/// Migration pour ajouter la colonne id_digitiser à la table t_observations
/// Cette colonne stocke l'ID de l'utilisateur qui a créé l'observation
const String migration024AddIdDigitiserToObservations = '''
  ALTER TABLE t_observations ADD COLUMN id_digitiser INTEGER;
''';