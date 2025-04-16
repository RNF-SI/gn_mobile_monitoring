import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

abstract class TaxonApi {
  Future<List<Taxon>> getTaxonsByList(int idListe);
  Future<TaxonList> getTaxonList(int idListe);
  Future<Taxon> getTaxonByCdNom(int cdNom);
}
