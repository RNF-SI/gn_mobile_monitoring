import 'dart:convert';

import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';

import '../e2e_test_app.dart';

/// Helper class to seed mock databases with realistic test data.
///
/// Provides pre-built test data for modules, sites, visits, etc.
/// that can be used to set up the app state before running E2E tests.
class TestDataSeeder {
  final E2ETestApp testApp;

  TestDataSeeder(this.testApp);

  // ============================================================================
  // Test Data Constants
  // ============================================================================

  static const int testModuleId = 42;
  static const String testModuleCode = 'TEST_MODULE';
  static const String testModuleLabel = 'Module de test E2E';

  static const int testSiteId1 = 101;
  static const int testSiteId2 = 102;
  static const int testSiteGroupId = 201;

  static const int testDatasetId = 301;

  // ============================================================================
  // Module Configuration (minimal but functional)
  // ============================================================================

  /// Creates a minimal but functional module configuration.
  static ModuleConfiguration createModuleConfig() {
    return ModuleConfiguration.fromJson({
      'custom': {
        'id_module': testModuleId,
        'module_code': testModuleCode,
      },
      'module': {
        'children_types': ['site', 'sites_group'],
        'label': 'Module',
        'module_label': testModuleLabel,
        'id_field_name': 'id_module',
        'display_list': ['module_label', 'module_code'],
        'display_properties': ['module_label', 'module_desc'],
        'cruved': {'C': 1, 'R': 1, 'U': 1, 'V': 1, 'E': 1, 'D': 1},
        'generic': {
          'id_module': {
            'type_widget': 'text',
            'attribut_label': 'ID Module',
          },
        },
      },
      'site': {
        'label': 'Site',
        'id_field_name': 'id_base_site',
        'display_list': ['base_site_name', 'base_site_code'],
        'display_properties': ['base_site_name', 'base_site_code'],
        'generic': {
          'base_site_name': {
            'type_widget': 'text',
            'attribut_label': 'Nom du site',
            'required': true,
          },
          'base_site_code': {
            'type_widget': 'text',
            'attribut_label': 'Code du site',
            'required': true,
          },
        },
      },
      'sites_group': {
        'label': 'Groupe de sites',
        'id_field_name': 'id_sites_group',
        'display_list': ['sites_group_name'],
        'display_properties': ['sites_group_name', 'sites_group_code'],
        'generic': {
          'sites_group_name': {
            'type_widget': 'text',
            'attribut_label': 'Nom du groupe',
            'required': true,
          },
        },
      },
      'visit': {
        'label': 'Visite',
        'id_field_name': 'id_base_visit',
        'display_list': ['visit_date_min', 'comments'],
        'display_properties': ['visit_date_min', 'comments'],
        'generic': {
          'visit_date_min': {
            'type_widget': 'date',
            'attribut_label': 'Date de début',
            'required': true,
          },
          'comments': {
            'type_widget': 'textarea',
            'attribut_label': 'Commentaire',
          },
          'id_dataset': {
            'type_widget': 'dataset',
            'attribut_label': 'Jeu de données',
            'required': true,
          },
        },
      },
      'observation': {
        'label': 'Observation',
        'id_field_name': 'id_observation',
        'display_list': ['cd_nom', 'comments'],
        'display_properties': ['cd_nom', 'comments'],
        'generic': {
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Taxon',
            'required': true,
          },
          'comments': {
            'type_widget': 'textarea',
            'attribut_label': 'Commentaire',
          },
        },
      },
      'tree': {
        'module': {
          'children': {
            'site': {
              'children': {
                'visit': {
                  'children': {
                    'observation': {},
                  },
                },
              },
            },
            'sites_group': {
              'children': {
                'site': {
                  'children': {
                    'visit': {
                      'children': {
                        'observation': {},
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    });
  }

  // ============================================================================
  // Seeding Methods
  // ============================================================================

  /// Seed the database with a downloaded module that has sites and groups.
  ///
  /// This prepares the app state as if a module has been downloaded,
  /// allowing navigation from Home → Module Detail.
  Future<void> seedDownloadedModule() async {
    final config = createModuleConfig();

    final sites = [
      const BaseSite(
        idBaseSite: testSiteId1,
        baseSiteName: 'Site de test Alpha',
        baseSiteCode: 'SITE_ALPHA',
        baseSiteDescription: 'Premier site de test pour les E2E',
      ),
      const BaseSite(
        idBaseSite: testSiteId2,
        baseSiteName: 'Site de test Beta',
        baseSiteCode: 'SITE_BETA',
        baseSiteDescription: 'Deuxième site de test pour les E2E',
      ),
    ];

    final siteGroups = [
      const SiteGroup(
        idSitesGroup: testSiteGroupId,
        sitesGroupName: 'Groupe de test',
        sitesGroupCode: 'GRP_TEST',
        sitesGroupDescription: 'Groupe de sites pour les E2E',
      ),
    ];

    final complement = ModuleComplement(
      idModule: testModuleId,
      configuration: config,
      idListObserver: 1,
      idListTaxonomy: 100,
      data: jsonEncode({'test_key': 'test_value'}),
    );

    // Seed the module with embedded sites and groups
    final module = Module(
      id: testModuleId,
      moduleCode: testModuleCode,
      moduleLabel: testModuleLabel,
      moduleDesc: 'Module de test pour les tests E2E',
      downloaded: true,
      complement: complement,
      sites: sites,
      sitesGroup: siteGroups,
    );

    testApp.moduleDatabase.seedModules([module]);
    testApp.moduleDatabase.seedComplements([complement]);

    // Also seed sites in the sites database for site-level queries
    testApp.sitesDatabase.seedSites(sites);
    testApp.sitesDatabase.seedGroups(siteGroups);

    // Seed site-module associations
    for (final site in sites) {
      await testApp.sitesDatabase.insertSiteModule(
        SiteModule(idSite: site.idBaseSite, idModule: testModuleId),
      );
    }
  }

  /// Seed the database with nomenclatures needed by forms.
  Future<void> seedNomenclatures() async {
    final nomenclatures = [
      const Nomenclature(
        id: 1,
        idType: 116,
        cdNomenclature: 'TYPE_SITE_1',
        mnemonique: 'TYPE_SITE_1',
        labelDefault: 'Site standard',
        labelFr: 'Site standard',
        definitionDefault: 'Type de site standard',
        definitionFr: 'Type de site standard',
        hierarchy: '',
        active: true,
      ),
    ];

    final types = [
      const NomenclatureType(
        idType: 116,
        mnemonique: 'TYPE_SITE',
        labelDefault: 'Type de site',
        labelFr: 'Type de site',
        definitionDefault: 'Type de site',
        definitionFr: 'Type de site',
      ),
    ];

    await testApp.nomenclaturesDatabase.insertNomenclatureTypes(types);
    await testApp.nomenclaturesDatabase.insertNomenclatures(nomenclatures);
  }

  /// Seed the database with datasets.
  Future<void> seedDatasets() async {
    final datasets = [
      const Dataset(
        id: testDatasetId,
        datasetName: 'Jeu de données test E2E',
        uniqueDatasetId: 'uuid-dataset-e2e',
        idAcquisitionFramework: 1,
        datasetShortname: 'JDD E2E',
        datasetDesc: 'Jeu de données pour tests E2E',
        idNomenclatureDataType: 1,
        marineDomain: false,
        terrestrialDomain: true,
        idNomenclatureDatasetObjectif: 1,
        idNomenclatureCollectingMethod: 1,
        idNomenclatureDataOrigin: 1,
        idNomenclatureSourceStatus: 1,
        idNomenclatureResourceType: 1,
        active: true,
      ),
    ];

    await testApp.datasetsDatabase.insertDatasets(datasets);
  }

  /// Set localStorage as if user is already logged in.
  Future<void> seedLoggedInUser() async {
    await testApp.localStorage.setIsLoggedIn(true);
    await testApp.localStorage.setToken('mock-e2e-token');
    await testApp.localStorage.setUserId(1);
    await testApp.localStorage.setUserName('testuser');
  }

  /// Seed all common data: logged-in user + downloaded module + nomenclatures + datasets.
  Future<void> seedAll() async {
    await seedLoggedInUser();
    await seedDownloadedModule();
    await seedNomenclatures();
    await seedDatasets();
  }
}
