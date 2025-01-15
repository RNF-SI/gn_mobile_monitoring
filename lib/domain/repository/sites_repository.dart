abstract class SitesRepository {
  Future<void> fetchSites(String token);
  Future<void> fetchSiteGroups(String token);
}
