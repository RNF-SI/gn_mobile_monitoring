import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

abstract class TaxonApi {
  Future<List<Taxon>> getTaxonsByList(int idListe);
  Future<TaxonList> getTaxonList(int idListe);
  Future<Taxon> getTaxonByCdNom(int cdNom);

  // Methods added for synchronization

  /// Récupère les taxons modifiés depuis la dernière synchronisation
  Future<SyncResult> syncTaxons(
      String token, List<String> downloadedModuleCodes,
      {DateTime? lastSync});

  /// Recherche des taxons correspondant à un terme
  Future<List<Taxon>> searchTaxons(String token, String searchTerm,
      {int? idListe});
}
