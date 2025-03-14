import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';

class CorVisitObserver extends Table {
  // Définition de la table
  @override
  String get tableName => 'cor_visit_observer';

  // Colonnes de la table
  IntColumn get idBaseVisit => integer().references(TBaseVisits, #idBaseVisit)();
  IntColumn get idRole => integer()();
  TextColumn get uniqueIdCoreVisitObserver => text().withDefault(
        const CustomExpression(
            "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))"),
      )();

  @override
  Set<Column> get primaryKey => {idBaseVisit, idRole};
}