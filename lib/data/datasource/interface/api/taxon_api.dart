import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

abstract class TaxonApi {
  Future<List<Taxon>> getTaxonsByList(int idListe);
  Future<TaxonList> getTaxonList(int idListe);

  /// Retourne une page de taxons pour une liste donnée.
  /// hasMore = result.length >= limit.
  Future<List<Taxon>> fetchTaxonPage(int idListe,
      {required int page, int limit = 5000});
}
