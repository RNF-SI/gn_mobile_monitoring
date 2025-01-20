import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';

abstract class NomenclaturesApi {
  Future<List<NomenclatureEntity>> getNomenclatures();
}
