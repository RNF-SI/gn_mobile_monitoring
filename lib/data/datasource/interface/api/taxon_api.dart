import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

abstract class TaxonApi {
  Future<List<Taxon>> getTaxonsByList(int idListe, String token);
  Future<TaxonList> getTaxonList(int idListe, String token);
  Future<Taxon> getTaxonByCdNom(int cdNom, String token);
}
