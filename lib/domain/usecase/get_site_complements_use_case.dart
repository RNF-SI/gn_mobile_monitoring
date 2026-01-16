import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';

/// Use case pour récupérer les compléments de sites
abstract class GetSiteComplementsUseCase {
  /// Récupère tous les compléments de sites
  Future<List<SiteComplement>> execute();

  /// Récupère les compléments pour une liste d'IDs de sites
  Future<Map<int, SiteComplement?>> executeForSites(List<int> siteIds);

  /// Récupère le complément d'un site spécifique
  Future<SiteComplement?> executeForSite(int siteId);
}
