import 'package:gn_mobile_monitoring/data/datasource/implementation/database/modules_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observation_details_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

// ============================================================================
// Mock Global Database
// ============================================================================

class MockGlobalDatabase implements GlobalDatabase {
  @override
  Future<void> initDatabase() async {}
  @override
  Future<void> deleteDatabase() async {}
  @override
  Future<void> resetDatabase() async {}
  @override
  Future<DateTime?> getLastSyncDate(String entityType) async => null;
  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate) async {}
  @override
  Future<int> getPendingItemsCount() async => 0;
  @override
  Future<SyncResult> saveConfiguration(Map<String, dynamic> configData) async =>
      SyncResult.success(
        itemsProcessed: 0,
        itemsAdded: 0,
        itemsUpdated: 0,
        itemsSkipped: 0,
      );
}

// ============================================================================
// Mock Module Database
// ============================================================================

class MockModuleDatabaseImpl extends ModuleDatabaseImpl {
  final List<Module> _modules = [];
  final List<ModuleComplement> _complements = [];

  void seedModules(List<Module> modules) {
    _modules.clear();
    _modules.addAll(modules);
  }

  void seedComplements(List<ModuleComplement> complements) {
    _complements.clear();
    _complements.addAll(complements);
  }

  @override
  Future<void> clearModules() async => _modules.clear();
  @override
  Future<void> insertModules(List<Module> modules) async =>
      _modules.addAll(modules);
  @override
  Future<void> updateModule(Module module) async {
    _modules.removeWhere((m) => m.id == module.id);
    _modules.add(module);
  }

  @override
  Future<List<Module>> getAllModules() async => List.from(_modules);
  @override
  Future<List<Module>> getModules() async => List.from(_modules);
  @override
  Future<List<Module>> getDownloadedModules() async =>
      _modules.where((m) => m.downloaded == true).toList();
  @override
  Future<Module?> getModuleById(int moduleId) async {
    try {
      return _modules.firstWhere((m) => m.id == moduleId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Module> getModuleWithRelationsById(int moduleId) async {
    final mod = _modules.firstWhere((m) => m.id == moduleId);
    return mod;
  }

  @override
  Future<Module?> getModuleIdByLabel(String moduleLabel) async {
    try {
      return _modules.firstWhere((m) => m.moduleLabel == moduleLabel);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Module?> getModuleByCode(String moduleCode) async {
    try {
      return _modules.firstWhere((m) => m.moduleCode == moduleCode);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> getModuleCodeFromIdModule(int moduleId) async {
    final mod = _modules.firstWhere((m) => m.id == moduleId);
    return mod.moduleCode ?? '';
  }

  @override
  Future<void> markModuleAsDownloaded(int moduleId) async {
    final idx = _modules.indexWhere((m) => m.id == moduleId);
    if (idx >= 0) {
      _modules[idx] = _modules[idx].copyWith(downloaded: true);
    }
  }

  @override
  Future<void> insertModuleComplements(
      List<ModuleComplement> moduleComplements) async {
    _complements.addAll(moduleComplements);
  }

  @override
  Future<ModuleComplement?> getModuleComplementById(int moduleId) async {
    try {
      return _complements.firstWhere((c) => c.idModule == moduleId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ModuleComplement?> getModuleComplementByModuleCode(
      String moduleCode) async {
    return null;
  }

  @override
  Future<List<ModuleComplement>> getAllModuleComplements() async =>
      List.from(_complements);
  @override
  Future<void> updateModuleComplement(
      ModuleComplement moduleComplement) async {}
  @override
  Future<void> updateModuleComplementConfiguration(
      int moduleId, String configuration) async {}
  @override
  Future<void> clearAllData() async {
    _modules.clear();
    _complements.clear();
  }

  @override
  Future<void> deleteModuleWithComplement(int moduleId) async {
    _modules.removeWhere((m) => m.id == moduleId);
    _complements.removeWhere((c) => c.idModule == moduleId);
  }

  @override
  Future<void> clearCorSiteModules(int moduleId) async {}
  @override
  Future<void> clearSitesGroupModules(int moduleId) async {}
  @override
  Future<void> insertSitesGroupModules(
      List<SitesGroupModule> siteGroups) async {}
  @override
  Future<void> associateModuleWithDataset(int moduleId, int datasetId) async {}
  @override
  Future<void> clearDatasetAssociationsForModule(int moduleId) async {}
  @override
  Future<List<int>> getDatasetIdsForModule(int moduleId) async => [];
  @override
  Future<int?> getModuleTaxonomyListId(int moduleId) async => null;
}

// ============================================================================
// Mock Sites Database
// ============================================================================

class MockSitesDatabase implements SitesDatabase {
  final List<BaseSite> _sites = [];
  final List<SiteComplement> _complements = [];
  final List<SiteGroup> _groups = [];
  final List<SiteModule> _siteModules = [];
  final List<SitesGroupModule> _groupModules = [];

  void seedSites(List<BaseSite> sites) {
    _sites.clear();
    _sites.addAll(sites);
  }

  void seedGroups(List<SiteGroup> groups) {
    _groups.clear();
    _groups.addAll(groups);
  }

  @override
  Future<void> clearSites() async => _sites.clear();
  @override
  Future<void> insertSites(List<BaseSite> sites) async => _sites.addAll(sites);
  @override
  Future<void> updateSite(BaseSite site) async {
    _sites.removeWhere((s) => s.idBaseSite == site.idBaseSite);
    _sites.add(site);
  }

  @override
  Future<void> deleteSite(int siteId) async =>
      _sites.removeWhere((s) => s.idBaseSite == siteId);
  @override
  Future<List<BaseSite>> getAllSites() async => List.from(_sites);
  @override
  Future<List<BaseSite>> getSitesForModule(int moduleId) async =>
      _sites.where((s) => _siteModules.any(
          (sm) => sm.idSite == s.idBaseSite && sm.idModule == moduleId)).toList();
  @override
  Future<List<BaseSite>> getSitesByModuleId(int moduleId) async =>
      getSitesForModule(moduleId);
  @override
  Future<List<BaseSite>> getOrphanSitesByModuleId(int moduleId) async {
    final sitesOfModule = await getSitesByModuleId(moduleId);
    return sitesOfModule
        .where((s) =>
            !_complements.any((c) =>
                c.idBaseSite == s.idBaseSite && c.idSitesGroup != null))
        .toList();
  }

  @override
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId) async => _sites;

  @override
  Future<List<BaseSite>> getSitesBySiteGroupAndModule(
          int siteGroupId, int moduleId) async =>
      _sites
          .where((s) => _siteModules.any(
              (sm) => sm.idSite == s.idBaseSite && sm.idModule == moduleId))
          .toList();

  @override
  Future<int> insertSite(BaseSite site) async {
    _sites.add(site);
    return site.idBaseSite;
  }

  @override
  Future<BaseSite?> getSiteById(int siteId) async {
    try {
      return _sites.firstWhere((s) => s.idBaseSite == siteId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BaseSiteEntity?> getSiteEntityById(int siteId) async => null;

  // Complements
  @override
  Future<void> clearSiteComplements() async => _complements.clear();
  @override
  Future<void> insertSiteComplements(List<SiteComplement> complements) async =>
      _complements.addAll(complements);
  @override
  Future<void> deleteSiteComplement(int siteId) async =>
      _complements.removeWhere((c) => c.idBaseSite == siteId);
  @override
  Future<List<SiteComplement>> getAllSiteComplements() async =>
      List.from(_complements);
  @override
  Future<List<SiteComplement>> getSiteComplementsByModuleId(
      int moduleId) async =>
      _complements;
  @override
  Future<SiteComplement?> getSiteComplementBySiteId(int siteId) async {
    try {
      return _complements.firstWhere((c) => c.idBaseSite == siteId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> siteHasOtherModuleReferences(
      int siteId, int excludeModuleId) async => false;
  @override
  Future<bool> siteGroupHasOtherModuleReferences(
      int siteGroupId, int excludeModuleId) async => false;
  @override
  Future<void> deleteSiteCompletely(int siteId) async =>
      _sites.removeWhere((s) => s.idBaseSite == siteId);

  // Groups
  @override
  Future<void> clearSiteGroups() async => _groups.clear();
  @override
  Future<void> insertSiteGroups(List<SiteGroup> siteGroups) async =>
      _groups.addAll(siteGroups);
  @override
  Future<void> updateSiteGroup(SiteGroup siteGroup) async {}
  @override
  Future<void> deleteSiteGroup(int siteGroupId) async =>
      _groups.removeWhere((g) => g.idSitesGroup == siteGroupId);
  @override
  Future<List<SiteGroup>> getAllSiteGroups() async => List.from(_groups);
  @override
  Future<List<SiteGroup>> getSiteGroupsForModule(int moduleId) async =>
      _groups;
  @override
  Future<SiteGroup?> getSiteGroupById(int siteGroupId) async {
    try {
      return _groups.firstWhere((g) => g.idSitesGroup == siteGroupId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> insertSiteGroup(SiteGroup siteGroup) async {
    _groups.add(siteGroup);
    return siteGroup.idSitesGroup;
  }

  @override
  Future<List<SiteGroup>> getSiteGroupsByModuleId(int moduleId) async =>
      _groups;

  // Group-module associations
  @override
  Future<void> clearAllSiteGroupModules() async => _groupModules.clear();
  @override
  Future<void> insertSiteGroupModule(SitesGroupModule sgm) async =>
      _groupModules.add(sgm);
  @override
  Future<void> insertSiteGroupModules(List<SitesGroupModule> modules) async =>
      _groupModules.addAll(modules);
  @override
  Future<void> deleteSiteGroupModule(int siteGroupId, int moduleId) async =>
      _groupModules.removeWhere(
          (m) => m.idSitesGroup == siteGroupId && m.idModule == moduleId);
  @override
  Future<List<SitesGroupModule>> getAllSiteGroupModules() async =>
      List.from(_groupModules);
  @override
  Future<List<SitesGroupModule>> getSiteGroupModulesBySiteGroupId(
      int siteGroupId) async =>
      _groupModules.where((m) => m.idSitesGroup == siteGroupId).toList();

  // Site-module associations
  @override
  Future<void> clearAllSiteModules() async => _siteModules.clear();
  @override
  Future<void> insertSiteModules(List<SiteModule> modules) async =>
      _siteModules.addAll(modules);
  @override
  Future<void> deleteSiteModule(int siteId, int moduleId) async =>
      _siteModules.removeWhere(
          (m) => m.idSite == siteId && m.idModule == moduleId);
  @override
  Future<List<SiteModule>> getAllSiteModules() async =>
      List.from(_siteModules);
  @override
  Future<List<SiteModule>> getSiteModulesBySiteId(int siteId) async =>
      _siteModules.where((m) => m.idSite == siteId).toList();
  @override
  Future<List<SiteModule>> getSiteModulesByModuleId(int moduleId) async =>
      _siteModules.where((m) => m.idModule == moduleId).toList();
  @override
  Future<void> insertSiteModule(SiteModule siteModule) async =>
      _siteModules.add(siteModule);

  @override
  Future<void> updateSiteServerId(int localSiteId, int serverSiteId) async {}
  @override
  Future<void> updateSiteGroupServerId(
      int localSiteGroupId, int serverSiteGroupId) async {}
  @override
  Future<void> updateSiteComplementsGroupId(
      int oldGroupId, int newGroupId) async {}
}

// ============================================================================
// Mock Visits Database
// ============================================================================

class MockVisitesDatabase implements VisitesDatabase {
  final List<TBaseVisit> _visits = [];

  @override
  Future<List<TBaseVisit>> getAllVisits() async => List.from(_visits);
  @override
  Future<List<TBaseVisit>> getVisitsBySiteIdAndModuleId(
      int siteId, int moduleId) async =>
      _visits;
  @override
  Future<TBaseVisit> getVisitById(int id) async =>
      _visits.firstWhere((v) => v.idBaseVisit == id);
  @override
  Future<int> insertVisit(TBaseVisitsCompanion visit) async => 1;
  @override
  Future<bool> updateVisit(TBaseVisitsCompanion visit) async => true;
  @override
  Future<int> deleteVisit(int id) async {
    _visits.removeWhere((v) => v.idBaseVisit == id);
    return 1;
  }

  @override
  Future<TVisitComplement?> getVisitComplementById(int visitId) async => null;
  @override
  Future<int> insertVisitComplement(
      TVisitComplementsCompanion complement) async => 1;
  @override
  Future<bool> updateVisitComplement(
      TVisitComplementsCompanion complement) async => true;
  @override
  Future<int> deleteVisitComplement(int visitId) async => 1;
  @override
  Future<void> deleteVisitWithComplement(int visitId) async =>
      _visits.removeWhere((v) => v.idBaseVisit == visitId);
  @override
  Future<List<CorVisitObserverData>> getVisitObservers(int visitId) async => [];
  @override
  Future<int> insertVisitObserver(
      CorVisitObserverCompanion observer) async => 1;
  @override
  Future<int> deleteVisitObservers(int visitId) async => 0;
  @override
  Future<void> replaceVisitObservers(
      int visitId, List<CorVisitObserverCompanion> observers) async {}
  @override
  Future<List<TBaseVisit>> getVisitsBySite(int siteId) async => _visits;
  @override
  Future<bool> updateVisitServerId(int localVisitId, int serverId) async =>
      true;
}

// ============================================================================
// Mock Observations Database
// ============================================================================

class MockObservationsDatabase implements ObservationsDatabase {
  final List<ObservationEntity> _observations = [];

  @override
  Future<List<ObservationEntity>> getObservationsByVisitId(
      int visitId) async =>
      _observations.where((o) => o.idBaseVisit == visitId).toList();
  @override
  Future<ObservationEntity?> getObservationById(int observationId) async {
    try {
      return _observations.firstWhere((o) => o.idObservation == observationId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> createObservation(ObservationEntity observation) async {
    _observations.add(observation);
    return observation.idObservation;
  }

  @override
  Future<bool> updateObservation(ObservationEntity observation) async => true;
  @override
  Future<bool> deleteObservation(int observationId) async {
    _observations.removeWhere((o) => o.idObservation == observationId);
    return true;
  }

  @override
  Future<bool> updateObservationServerId(
      int localObservationId, int serverObservationId) async => true;
}

// ============================================================================
// Mock Observation Details Database
// ============================================================================

class MockObservationDetailsDatabase implements ObservationDetailsDatabase {
  @override
  Future<List<ObservationDetailEntity>> getObservationDetailsByObservationId(
      int observationId) async => [];
  @override
  Future<ObservationDetailEntity?> getObservationDetailById(
      int detailId) async => null;
  @override
  Future<int> saveObservationDetail(ObservationDetailEntity detail) async => 1;
  @override
  Future<int> deleteObservationDetail(int detailId) async => 1;
  @override
  Future<int> deleteObservationDetailsByObservationId(
      int observationId) async => 0;
}

// ============================================================================
// Mock Nomenclatures Database
// ============================================================================

class MockNomenclaturesDatabase implements NomenclaturesDatabase {
  final List<Nomenclature> _nomenclatures = [];
  final List<NomenclatureType> _types = [];

  @override
  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures) async =>
      _nomenclatures.addAll(nomenclatures);
  @override
  Future<List<Nomenclature>> getAllNomenclatures() async =>
      List.from(_nomenclatures);
  @override
  Future<void> clearNomenclatures() async => _nomenclatures.clear();
  @override
  Future<Nomenclature?> getNomenclatureById(int nomenclatureId) async {
    try {
      return _nomenclatures.firstWhere((n) => n.id == nomenclatureId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteNomenclature(int nomenclatureId) async =>
      _nomenclatures.removeWhere((n) => n.id == nomenclatureId);
  @override
  Future<List<SyncConflict>> checkNomenclatureReferences(
      int nomenclatureId) async => [];

  @override
  Future<void> insertNomenclatureTypes(List<NomenclatureType> types) async =>
      _types.addAll(types);
  @override
  Future<List<NomenclatureType>> getAllNomenclatureTypes() async =>
      List.from(_types);
  @override
  Future<NomenclatureType?> getNomenclatureTypeByMnemonique(
      String mnemonique) async {
    try {
      return _types.firstWhere((t) => t.mnemonique == mnemonique);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearNomenclatureTypes() async => _types.clear();
}

// ============================================================================
// Mock Datasets Database
// ============================================================================

class MockDatasetsDatabase implements DatasetsDatabase {
  final List<Dataset> _datasets = [];

  @override
  Future<void> insertDatasets(List<Dataset> datasets) async =>
      _datasets.addAll(datasets);
  @override
  Future<List<Dataset>> getAllDatasets() async => List.from(_datasets);
  @override
  Future<Dataset?> getDatasetById(int datasetId) async {
    try {
      return _datasets.firstWhere((d) => d.id == datasetId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Dataset>> getDatasetsByIds(List<int> datasetIds) async =>
      _datasets.where((d) => datasetIds.contains(d.id)).toList();
  @override
  Future<void> clearDatasets() async => _datasets.clear();
}

// ============================================================================
// Mock Taxon Database
// ============================================================================

class MockTaxonDatabase implements TaxonDatabase {
  final List<Taxon> _taxons = [];

  void seedTaxons(List<Taxon> taxons) {
    _taxons.clear();
    _taxons.addAll(taxons);
  }

  @override
  Future<List<Taxon>> getAllTaxons() async => List.from(_taxons);
  @override
  Future<List<Taxon>> getTaxonsByListId(int idListe) async =>
      List.from(_taxons);
  @override
  Future<Taxon?> getTaxonByCdNom(int cdNom) async {
    try {
      return _taxons.firstWhere((t) => t.cdNom == cdNom);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Taxon>> searchTaxons(String searchTerm) async =>
      _taxons
          .where((t) =>
              t.nomComplet.toLowerCase().contains(searchTerm.toLowerCase()) ||
              (t.nomVern?.toLowerCase().contains(searchTerm.toLowerCase()) ??
                  false))
          .toList();
  @override
  Future<List<Taxon>> searchTaxonsByListId(
      String searchTerm, int idListe) async =>
      searchTaxons(searchTerm);
  @override
  Future<bool> isTaxonInList(int cdNom, int idListe) async =>
      _taxons.any((t) => t.cdNom == cdNom);
  @override
  Future<List<Taxon>> getSuggestionTaxons(int idListe, {int limit = 10}) async =>
      _taxons.take(limit).toList();
  @override
  Future<void> saveTaxon(Taxon taxon) async => _taxons.add(taxon);
  @override
  Future<void> saveTaxons(List<Taxon> taxons) async => _taxons.addAll(taxons);
  @override
  Future<void> clearTaxons() async => _taxons.clear();

  @override
  Future<List<TaxonList>> getAllTaxonLists() async => [];
  @override
  Future<TaxonList?> getTaxonListById(int idListe) async => null;
  @override
  Future<void> saveTaxonLists(List<TaxonList> lists) async {}
  @override
  Future<void> clearTaxonLists() async {}
  @override
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms) async {}
  @override
  Future<void> clearCorTaxonListe() async {}

  @override
  Future<Set<int>> getAllTaxonCdNoms() async =>
      _taxons.map((t) => t.cdNom).toSet();
  @override
  Future<Set<int>> getCdNomsByListId(int idListe) async =>
      _taxons.map((t) => t.cdNom).toSet();
  @override
  Future<Set<int>> getAllListIds() async => {};

  @override
  Future<SyncResult> saveTaxonsWithSync(
      List<Map<String, dynamic>> taxons) async =>
      SyncResult.success(
        itemsProcessed: taxons.length,
        itemsAdded: taxons.length,
        itemsUpdated: 0,
        itemsSkipped: 0,
      );
  @override
  Future<List<Taxon>> getPendingTaxons() async => [];
  @override
  Future<void> markTaxonSynced(int cdNom, DateTime syncDate) async {}
  @override
  Future<List<SyncConflict>> checkTaxonReferencesInDatabaseObservations(
      int cdNom, {Set<int>? removedFromListIds}) async => [];
  @override
  Future<void> deleteTaxon(int cdNom) async =>
      _taxons.removeWhere((t) => t.cdNom == cdNom);
}
