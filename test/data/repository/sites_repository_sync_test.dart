import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/repository/sites_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

// Define mocks specifically for this test
class MockSitesApi extends Mock implements SitesApi {}
class MockSitesDatabase extends Mock implements SitesDatabase {}
class MockModulesDatabase extends Mock implements ModulesDatabase {}
class MockVisitesDatabase extends Mock implements VisitesDatabase {}

void main() {
  late SitesRepository repository;
  late MockSitesApi mockSitesApi;
  late MockSitesDatabase mockSitesDatabase;
  late MockModulesDatabase mockModulesDatabase;
  late MockVisitesDatabase mockVisitesDatabase;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(SiteModule(idSite: 0, idModule: 0));
    registerFallbackValue(BaseSite(
      idBaseSite: 0,
      baseSiteName: '',
      baseSiteCode: '',
      firstUseDate: DateTime.now(),
    ));
    registerFallbackValue(<SiteComplement>[]);
    registerFallbackValue(<BaseSite>[]);
  });

  setUp(() {
    mockSitesApi = MockSitesApi();
    mockSitesDatabase = MockSitesDatabase();
    mockModulesDatabase = MockModulesDatabase();
    mockVisitesDatabase = MockVisitesDatabase();
    
    repository = SitesRepositoryImpl(
      mockSitesApi,
      mockSitesDatabase,
      mockModulesDatabase,
      mockVisitesDatabase,
    );
  });

  group('SitesRepository - Site Complements Sync', () {
    test('should save site complements with correct id_sites_group during incremental sync', () async {
      // Arrange
      const testToken = 'test-token';
      const testModuleCode = 'TEST_MODULE';
      const testModuleId = 1;
      const testSiteId = 100;
      const testSiteGroupId = 10;
      
      final testModule = Module(
        id: testModuleId,
        moduleCode: testModuleCode,
        moduleLabel: 'Test Module',
        activeFrontend: true,
      );

      // Mock module database to return our test module
      when(() => mockModulesDatabase.getDownloadedModules())
          .thenAnswer((_) async => [testModule]);

      // Mock local sites for module (empty initially)
      when(() => mockSitesDatabase.getSiteModulesByModuleId(testModuleId))
          .thenAnswer((_) async => []);

      // Mock API response with site in a group
      final apiResponse = {
        'enriched_sites': [
          {
            'id_base_site': testSiteId,
            'base_site_name': 'Test Site',
            'base_site_code': 'TS001',
            'base_site_description': 'Test description',
            'altitude_min': 100,
            'altitude_max': 200,
            'first_use_date': '2024-01-01',
            'uuid_base_site': 'uuid-test',
          }
        ],
        'site_complements': [
          SiteComplement(
            idBaseSite: testSiteId,
            idSitesGroup: testSiteGroupId,  // This should be preserved
            data: '{"id_nomenclature_type_site": 123}',
          )
        ]
      };

      when(() => mockSitesApi.fetchEnrichedSitesForModule(testModuleCode, testToken))
          .thenAnswer((_) async => apiResponse);

      // Mock database operations
      when(() => mockSitesDatabase.getSiteById(testSiteId))
          .thenAnswer((_) async => null); // Site doesn't exist yet
      
      when(() => mockSitesDatabase.insertSites(any()))
          .thenAnswer((_) async => {});
      
      when(() => mockSitesDatabase.insertSiteModule(any()))
          .thenAnswer((_) async => {});
      
      when(() => mockSitesDatabase.getSiteComplementsByModuleId(testModuleId))
          .thenAnswer((_) async => []); // No existing complements
      
      // Capture the site complements being inserted
      List<SiteComplement>? capturedComplements;
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((invocation) async {
            capturedComplements = invocation.positionalArguments[0] as List<SiteComplement>;
          });

      // Act
      final result = await repository.incrementalSyncSitesWithConflictHandling(testToken);

      // Assert
      expect(result.itemsAdded, equals(1));
      expect(capturedComplements, isNotNull);
      expect(capturedComplements!.length, equals(1));
      
      final savedComplement = capturedComplements!.first;
      expect(savedComplement.idBaseSite, equals(testSiteId));
      expect(savedComplement.idSitesGroup, equals(testSiteGroupId), 
        reason: 'id_sites_group should be preserved from API response');
      expect(savedComplement.data, contains('id_nomenclature_type_site'));
      
      // Verify the site module relationship was created
      verify(() => mockSitesDatabase.insertSiteModule(
        SiteModule(idSite: testSiteId, idModule: testModuleId)
      )).called(1);
    });

    test('should update existing site complement with new id_sites_group', () async {
      // Arrange
      const testToken = 'test-token';
      const testModuleCode = 'TEST_MODULE';
      const testModuleId = 1;
      const testSiteId = 100;
      const oldSiteGroupId = 5;
      const newSiteGroupId = 10;
      
      final testModule = Module(
        id: testModuleId,
        moduleCode: testModuleCode,
        moduleLabel: 'Test Module',
        activeFrontend: true,
      );

      // Mock module database
      when(() => mockModulesDatabase.getDownloadedModules())
          .thenAnswer((_) async => [testModule]);

      // Mock existing site module relationship
      when(() => mockSitesDatabase.getSiteModulesByModuleId(testModuleId))
          .thenAnswer((_) async => [
            SiteModule(idSite: testSiteId, idModule: testModuleId)
          ]);

      // Mock existing site
      when(() => mockSitesDatabase.getSiteById(testSiteId))
          .thenAnswer((_) async => BaseSite(
            idBaseSite: testSiteId,
            baseSiteName: 'Test Site',
            baseSiteCode: 'TS001',
            firstUseDate: DateTime.now(),
          ));

      // Mock API response with updated site group
      final apiResponse = {
        'enriched_sites': [
          {
            'id_base_site': testSiteId,
            'base_site_name': 'Test Site',
            'base_site_code': 'TS001',
            'base_site_description': 'Test description',
            'altitude_min': 100,
            'altitude_max': 200,
            'first_use_date': '2024-01-01',
            'uuid_base_site': 'uuid-test',
          }
        ],
        'site_complements': [
          SiteComplement(
            idBaseSite: testSiteId,
            idSitesGroup: newSiteGroupId,  // Changed group ID
            data: '{"id_nomenclature_type_site": 123}',
          )
        ]
      };

      when(() => mockSitesApi.fetchEnrichedSitesForModule(testModuleCode, testToken))
          .thenAnswer((_) async => apiResponse);

      // Mock existing complement with old group ID
      when(() => mockSitesDatabase.getSiteComplementsByModuleId(testModuleId))
          .thenAnswer((_) async => [
            SiteComplement(
              idBaseSite: testSiteId,
              idSitesGroup: oldSiteGroupId,
              data: '{"id_nomenclature_type_site": 123}',
            )
          ]);

      // Mock update operations
      when(() => mockSitesDatabase.updateSite(any()))
          .thenAnswer((_) async => {});
      
      // Capture the site complements being inserted/updated
      List<SiteComplement>? capturedComplements;
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((invocation) async {
            capturedComplements = invocation.positionalArguments[0] as List<SiteComplement>;
          });

      // Act
      final result = await repository.incrementalSyncSitesWithConflictHandling(testToken);

      // Assert
      expect(result.itemsUpdated, equals(1));
      expect(capturedComplements, isNotNull);
      expect(capturedComplements!.length, equals(1));
      
      final updatedComplement = capturedComplements!.first;
      expect(updatedComplement.idBaseSite, equals(testSiteId));
      expect(updatedComplement.idSitesGroup, equals(newSiteGroupId), 
        reason: 'id_sites_group should be updated to new value from API');
    });
  });
}