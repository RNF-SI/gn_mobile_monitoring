import 'package:drift/drift.dart';

@DataClassName('TVisitComplement')
class TVisitComplements extends Table {
  IntColumn get idBaseVisit => integer().autoIncrement()();
  TextColumn get data => text().nullable()();
}
