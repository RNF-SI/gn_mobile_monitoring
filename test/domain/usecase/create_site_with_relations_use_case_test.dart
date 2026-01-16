import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_site_with_relations_use_case_test.mocks.dart';

@GenerateMocks([CreateSiteUseCase, SitesDatabase])
void main() {
  late CreateSiteWithRelationsUseCase useCase;
  late MockCreateSiteUseCase mockCreateSiteUseCase;
  late MockSitesDatabase mockSitesDatabase;

  setUp(() {
    mockCreateSiteUseCase = MockCreateSiteUseCase();
    mockSitesDatabase = MockSitesDatabase();
    useCase = CreateSiteWithRelationsUseCaseImpl(
      mockCreateSiteUseCase,
      mockSitesDatabase,
    );
  });

  group('CreateSiteWithRelationsUseCase', () {
    final testSite = BaseSite(
      idBaseSite: 0,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TS001',
      baseSiteDescription: 'Test Description',
      isLocal: true,
    );

    const testModuleId = 5;
    const createdSiteId = 123;

    test('should create site and site-module relation without complement', () async {
      // Arrange
      when(mockCreateSiteUseCase.execute(testSite))
          .thenAnswer((_) async => createdSiteId);
      when(mockSitesDatabase.insertSiteModule(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.execute(
        site: testSite,
        moduleId: testModuleId,
      );

      // Assert
      expect(result, createdSiteId);
      verify(mockCreateSiteUseCase.execute(testSite));
      verify(mockSitesDatabase.insertSiteModule(argThat(
        predicate<SiteModule>((sm) =>
            sm.idSite == createdSiteId && sm.idModule == testModuleId),
      )));
      verifyNever(mockSitesDatabase.insertSiteComplements(any));
    });

    test('should create site with complement when provided', () async {
      // Arrange
      final testComplement = SiteComplement(
        idBaseSite: 0,
        idSitesGroup: 10,
        data: '{"field": "value"}',
      );

      when(mockCreateSiteUseCase.execute(testSite))
          .thenAnswer((_) async => createdSiteId);
      when(mockSitesDatabase.insertSiteModule(any))
          .thenAnswer((_) async => {});
      when(mockSitesDatabase.insertSiteComplements(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.execute(
        site: testSite,
        moduleId: testModuleId,
        complement: testComplement,
      );

      // Assert
      expect(result, createdSiteId);
      verify(mockCreateSiteUseCase.execute(testSite));
      verify(mockSitesDatabase.insertSiteModule(any));
      verify(mockSitesDatabase.insertSiteComplements(argThat(
        predicate<List<SiteComplement>>((list) =>
            list.length == 1 &&
            list.first.idBaseSite == createdSiteId &&
            list.first.idSitesGroup == 10),
      )));
    });

    test('should propagate exception from create site use case', () async {
      // Arrange
      final testException = Exception('Create site failed');
      when(mockCreateSiteUseCase.execute(testSite))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(site: testSite, moduleId: testModuleId),
        throwsA(testException),
      );
      verify(mockCreateSiteUseCase.execute(testSite));
      verifyNever(mockSitesDatabase.insertSiteModule(any));
    });

    test('should propagate exception from insert site module', () async {
      // Arrange
      final testException = Exception('Insert site module failed');
      when(mockCreateSiteUseCase.execute(testSite))
          .thenAnswer((_) async => createdSiteId);
      when(mockSitesDatabase.insertSiteModule(any))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(site: testSite, moduleId: testModuleId),
        throwsA(testException),
      );
    });

    test('should propagate exception from insert site complements', () async {
      // Arrange
      final testComplement = SiteComplement(
        idBaseSite: 0,
        idSitesGroup: 10,
        data: '{"field": "value"}',
      );
      final testException = Exception('Insert complement failed');

      when(mockCreateSiteUseCase.execute(testSite))
          .thenAnswer((_) async => createdSiteId);
      when(mockSitesDatabase.insertSiteModule(any))
          .thenAnswer((_) async => {});
      when(mockSitesDatabase.insertSiteComplements(any))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(
          site: testSite,
          moduleId: testModuleId,
          complement: testComplement,
        ),
        throwsA(testException),
      );
    });
  });
}
