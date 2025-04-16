import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/data/repository/sites_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

// Define mocks specifically for this test
class MockSitesApi extends Mock implements SitesApi {}
class MockSitesDatabase extends Mock implements SitesDatabase {}
class MockModulesDatabase extends Mock implements ModulesDatabase {}

void main() {
  late SitesRepository repository;
  late MockSitesApi mockSitesApi;
  late MockSitesDatabase mockSitesDatabase;
  late MockModulesDatabase mockModulesDatabase;
  
  // Test data
  final testToken = 'test-token';
  final testModules = [
    Module(
      id: 1,
      moduleCode: 'test_module_1',
      moduleLabel: 'Test Module 1',
      activeFrontend: true,
    ),
    Module(
      id: 2,
      moduleCode: 'test_module_2',
      moduleLabel: 'Test Module 2',
      activeFrontend: true,
    ),
  ];
  
  final testSites = [
    BaseSiteEntity(
      idBaseSite: 1,
      baseSiteName: 'Test Site 1',
      firstUseDate: DateTime.now(),
      baseSiteCode: 'TS1',
    ),
    BaseSiteEntity(
      idBaseSite: 2,
      baseSiteName: 'Test Site 2',
      firstUseDate: DateTime.now(),
      baseSiteCode: 'TS2',
    ),
  ];
  
  final testSiteGroups = [
    SiteGroupsWithModulesLabel(
      siteGroup: SiteGroupEntity(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group 1',
        sitesGroupDescription: 'Description 1',
      ),
      moduleLabelList: [],
    ),
    SiteGroupsWithModulesLabel(
      siteGroup: SiteGroupEntity(
        idSitesGroup: 2,
        sitesGroupName: 'Test Group 2',
        sitesGroupDescription: 'Description 2',
      ),
      moduleLabelList: [],
    ),
  ];
  
  final testBaseSites = [
    BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Test Site 1',
      baseSiteCode: 'TS1',
      firstUseDate: DateTime.now(),
    ),
    BaseSite(
      idBaseSite: 2,
      baseSiteName: 'Test Site 2',
      baseSiteCode: 'TS2',
      firstUseDate: DateTime.now(),
    ),
  ];
  
  final testSiteGroups2 = [
    SiteGroup(
      idSitesGroup: 1,
      sitesGroupName: 'Test Group 1',
      sitesGroupDescription: 'Description 1',
    ),
    SiteGroup(
      idSitesGroup: 2,
      sitesGroupName: 'Test Group 2',
      sitesGroupDescription: 'Description 2',
    ),
  ];

  setUp(() {
    mockSitesApi = MockSitesApi();
    mockSitesDatabase = MockSitesDatabase();
    mockModulesDatabase = MockModulesDatabase();
    
    repository = SitesRepositoryImpl(
      mockSitesApi,
      mockSitesDatabase,
      mockModulesDatabase,
    );
    
    // Register fallback values
    registerFallbackValue(testBaseSites[0]);
    registerFallbackValue(testSiteGroups2[0]);
    registerFallbackValue(<BaseSite>[]);
    registerFallbackValue(<SiteGroup>[]);
    registerFallbackValue(<SiteModule>[]);
    registerFallbackValue(<SitesGroupModule>[]);
  });

  group('getSites', () {
    test('should return sites from local database', () async {
      // Arrange
      when(() => mockSitesDatabase.getAllSites())
          .thenAnswer((_) async => testBaseSites.map((s) => s).toList());

      // Act
      final result = await repository.getSites();

      // Assert
      expect(result, equals(testBaseSites));
      verify(() => mockSitesDatabase.getAllSites()).called(1);
    });

    test('should throw exception when database operation fails', () async {
      // Arrange
      when(() => mockSitesDatabase.getAllSites())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => repository.getSites(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockSitesDatabase.getAllSites()).called(1);
    });
  });

  group('getSiteGroups', () {
    test('should return site groups from local database', () async {
      // Arrange
      when(() => mockSitesDatabase.getAllSiteGroups())
          .thenAnswer((_) async => testSiteGroups2.map((s) => s).toList());

      // Act
      final result = await repository.getSiteGroups();

      // Assert
      expect(result, equals(testSiteGroups2));
      verify(() => mockSitesDatabase.getAllSiteGroups()).called(1);
    });

    test('should throw exception when database operation fails', () async {
      // Arrange
      when(() => mockSitesDatabase.getAllSiteGroups())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => repository.getSiteGroups(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockSitesDatabase.getAllSiteGroups()).called(1);
    });
  });

  group('fetchSitesAndSiteModules', () {
    test('should fetch sites from API and update local database', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      for (final module in testModules) {
        // Mock the enriched sites endpoint that's actually used in the implementation
        when(() => mockSitesApi.fetchEnrichedSitesForModule(module.moduleCode!, testToken))
            .thenAnswer((_) async => {
              'enriched_sites': testSites.map((s) => {
                'id_base_site': s.idBaseSite,
                'base_site_name': s.baseSiteName,
                'base_site_code': s.baseSiteCode,
                'first_use_date': s.firstUseDate.toString(),
              }).toList(),
              'site_complements': <SiteComplement>[],
            });
      }
      
      when(() => mockSitesDatabase.clearSites())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSites(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearAllSiteModules())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteModules(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearSiteComplements())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.fetchSitesAndSiteModules(testToken);

      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      
      for (final module in testModules) {
        verify(() => mockSitesApi.fetchEnrichedSitesForModule(module.moduleCode!, testToken)).called(1);
      }
      
      verify(() => mockSitesDatabase.clearSites()).called(1);
      verify(() => mockSitesDatabase.insertSites(any())).called(1);
      verify(() => mockSitesDatabase.clearAllSiteModules()).called(1);
      verify(() => mockSitesDatabase.insertSiteModules(any())).called(1);
      verify(() => mockSitesDatabase.clearSiteComplements()).called(1);
    });

    test('should handle errors when API fails', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      // Make only the first module throw an error - this is more realistic
      when(() => mockSitesApi.fetchEnrichedSitesForModule(testModules[0].moduleCode!, any()))
          .thenThrow(Exception('API error'));
          
      // Let the second module return empty results
      when(() => mockSitesApi.fetchEnrichedSitesForModule(testModules[1].moduleCode!, any()))
          .thenAnswer((_) async => {
            'enriched_sites': <Map<String, dynamic>>[],
            'site_complements': <SiteComplement>[],
          });
          
      // Return empty lists to avoid NPE in database operations
      when(() => mockSitesDatabase.getAllSiteModules())
          .thenAnswer((_) async => []);
          
      when(() => mockSitesDatabase.clearSites())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSites(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearAllSiteModules())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteModules(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearSiteComplements())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.fetchSitesAndSiteModules(testToken);
      
      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      verify(() => mockSitesApi.fetchEnrichedSitesForModule(testModules[0].moduleCode!, any())).called(1);
      verify(() => mockSitesApi.fetchEnrichedSitesForModule(testModules[1].moduleCode!, any())).called(1);
      
      // Verify that database was updated (continuing with second module data)
      verify(() => mockSitesDatabase.clearSites()).called(1);
      verify(() => mockSitesDatabase.insertSites(any())).called(1);
      verify(() => mockSitesDatabase.clearAllSiteModules()).called(1);
      verify(() => mockSitesDatabase.insertSiteModules(any())).called(1);
      verify(() => mockSitesDatabase.clearSiteComplements()).called(1);
    });
  });

  group('fetchSiteGroupsAndSitesGroupModules', () {
    test('should fetch site groups from API and update local database', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      for (final module in testModules) {
        when(() => mockSitesApi.fetchSiteGroupsForModule(module.moduleCode!, testToken))
            .thenAnswer((_) async => testSiteGroups.map((s) => s).toList());
      }
      
      when(() => mockSitesDatabase.clearSiteGroups())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteGroups(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearAllSiteGroupModules())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteGroupModules(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.fetchSiteGroupsAndSitesGroupModules(testToken);

      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      
      for (final module in testModules) {
        verify(() => mockSitesApi.fetchSiteGroupsForModule(module.moduleCode!, testToken)).called(1);
      }
      
      verify(() => mockSitesDatabase.clearSiteGroups()).called(1);
      verify(() => mockSitesDatabase.insertSiteGroups(any())).called(1);
      verify(() => mockSitesDatabase.clearAllSiteGroupModules()).called(1);
      verify(() => mockSitesDatabase.insertSiteGroupModules(any())).called(1);
    });

    test('should handle errors when API fails', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      // Make only the first module throw an error - this is more realistic
      when(() => mockSitesApi.fetchSiteGroupsForModule(testModules[0].moduleCode!, any()))
          .thenThrow(Exception('API error'));
          
      // Let the second module return empty results
      when(() => mockSitesApi.fetchSiteGroupsForModule(testModules[1].moduleCode!, any()))
          .thenAnswer((_) async => <SiteGroupsWithModulesLabel>[]);
          
      // Return empty lists to avoid NPE in database operations
      when(() => mockSitesDatabase.getAllSiteGroupModules())
          .thenAnswer((_) async => []);
          
      when(() => mockSitesDatabase.clearSiteGroups())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteGroups(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearAllSiteGroupModules())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteGroupModules(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.fetchSiteGroupsAndSitesGroupModules(testToken);
      
      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      verify(() => mockSitesApi.fetchSiteGroupsForModule(testModules[0].moduleCode!, any())).called(1);
      verify(() => mockSitesApi.fetchSiteGroupsForModule(testModules[1].moduleCode!, any())).called(1);
      
      // Verify that database was updated (continuing with second module data)
      verify(() => mockSitesDatabase.clearSiteGroups()).called(1);
      verify(() => mockSitesDatabase.insertSiteGroups(any())).called(1);
      verify(() => mockSitesDatabase.clearAllSiteGroupModules()).called(1);
      verify(() => mockSitesDatabase.insertSiteGroupModules(any())).called(1);
    });
  });

  group('incrementalSyncSitesAndSiteModules', () {
    test('should incrementally update sites in database', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      // Mock existing data
      when(() => mockSitesDatabase.getAllSites())
          .thenAnswer((_) async => testBaseSites.sublist(0, 1).map((s) => s).toList()); // Only first site exists
          
      when(() => mockSitesDatabase.getAllSiteModules())
          .thenAnswer((_) async => []); // No existing relationships
      
      // Mock site complements
      when(() => mockSitesDatabase.getAllSiteComplements())
          .thenAnswer((_) async => []);
          
      // Mock API responses for enriched sites endpoint
      for (final module in testModules) {
        when(() => mockSitesApi.fetchEnrichedSitesForModule(module.moduleCode!, testToken))
            .thenAnswer((_) async => {
              'enriched_sites': testSites.map((s) => {
                'id_base_site': s.idBaseSite,
                'base_site_name': s.baseSiteName,
                'base_site_code': s.baseSiteCode,
                'first_use_date': s.firstUseDate.toString(),
              }).toList(),
              'site_complements': <SiteComplement>[],
            });
      }
      
      // Mock database operations
      when(() => mockSitesDatabase.insertSites(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.updateSite(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.deleteSite(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteModules(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.deleteSiteModule(any(), any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.clearSiteComplements())
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.incrementalSyncSitesAndSiteModules(testToken);

      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      verify(() => mockSitesDatabase.getAllSites()).called(1);
      verify(() => mockSitesDatabase.getAllSiteModules()).called(1);
      verify(() => mockSitesDatabase.getAllSiteComplements()).called(1);
      
      for (final module in testModules) {
        verify(() => mockSitesApi.fetchEnrichedSitesForModule(module.moduleCode!, testToken)).called(1);
      }
      
      // Should add new sites, update existing, and add new relationships
      verify(() => mockSitesDatabase.insertSites(any())).called(1);
      verify(() => mockSitesDatabase.updateSite(any())).called(1);
      verify(() => mockSitesDatabase.insertSiteModules(any())).called(1);
    });
  });

  group('incrementalSyncSiteGroupsAndSitesGroupModules', () {
    test('should incrementally update site groups in database', () async {
      // Arrange
      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => testModules);
          
      // Mock existing data
      when(() => mockSitesDatabase.getAllSiteGroups())
          .thenAnswer((_) async => testSiteGroups2.sublist(0, 1).map((s) => s).toList()); // Only first site group exists
          
      when(() => mockSitesDatabase.getAllSiteGroupModules())
          .thenAnswer((_) async => []); // No existing relationships
          
      // Mock API responses
      for (final module in testModules) {
        when(() => mockSitesApi.fetchSiteGroupsForModule(module.moduleCode!, testToken))
            .thenAnswer((_) async => testSiteGroups.map((s) => s).toList()); // All site groups from API
      }
      
      // Mock database operations
      when(() => mockSitesDatabase.insertSiteGroups(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.updateSiteGroup(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.deleteSiteGroup(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.insertSiteGroupModules(any()))
          .thenAnswer((_) async {});
          
      when(() => mockSitesDatabase.deleteSiteGroupModule(any(), any()))
          .thenAnswer((_) async {});

      // Act
      await repository.incrementalSyncSiteGroupsAndSitesGroupModules(testToken);

      // Assert
      verify(() => mockModulesDatabase.getAllModules()).called(1);
      verify(() => mockSitesDatabase.getAllSiteGroups()).called(1);
      verify(() => mockSitesDatabase.getAllSiteGroupModules()).called(1);
      
      for (final module in testModules) {
        verify(() => mockSitesApi.fetchSiteGroupsForModule(module.moduleCode!, testToken)).called(1);
      }
      
      // Should add new site groups, update existing, and add new relationships
      verify(() => mockSitesDatabase.insertSiteGroups(any())).called(1);
      verify(() => mockSitesDatabase.updateSiteGroup(any())).called(1);
      verify(() => mockSitesDatabase.insertSiteGroupModules(any())).called(1);
    });
  });
}
