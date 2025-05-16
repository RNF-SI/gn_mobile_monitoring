import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';

abstract class NomenclaturesDatabase {
  // Nomenclatures
  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures);
  Future<List<Nomenclature>> getAllNomenclatures();
  Future<void> clearNomenclatures();
  Future<Nomenclature?> getNomenclatureById(int nomenclatureId);
  Future<void> deleteNomenclature(int nomenclatureId);
  Future<List<SyncConflict>> checkNomenclatureReferences(int nomenclatureId);

  // Nomenclature Types
  Future<void> insertNomenclatureTypes(List<NomenclatureType> types);
  Future<List<NomenclatureType>> getAllNomenclatureTypes();
  Future<NomenclatureType?> getNomenclatureTypeByMnemonique(String mnemonique);
  Future<void> clearNomenclatureTypes();
}
