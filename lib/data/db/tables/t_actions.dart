import 'package:drift/drift.dart';

@DataClassName('TAction')
class TActions extends Table {
  IntColumn get idAction => integer().autoIncrement()();
  TextColumn get codeAction => text().nullable()();
  TextColumn get descriptionAction => text().nullable()();
}
