import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class NomenclaturesDatabase {
  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures);
  Future<List<Nomenclature>> getAllNomenclatures();
  Future<void> clearNomenclatures();
}
