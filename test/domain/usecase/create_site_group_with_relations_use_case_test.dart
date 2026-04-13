import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_site_group_with_relations_use_case_test.mocks.dart';

@GenerateMocks([CreateSiteGroupUseCase, SitesDatabase])
void main() {
  late CreateSiteGroupWithRelationsUseCase useCase;
  late MockCreateSiteGroupUseCase mockCreateSiteGroupUseCase;
  late MockSitesDatabase mockSitesDatabase;

  setUp(() {
    mockCreateSiteGroupUseCase = MockCreateSiteGroupUseCase();
    mockSitesDatabase = MockSitesDatabase();
    useCase = CreateSiteGroupWithRelationsUseCaseImpl(
      mockCreateSiteGroupUseCase,
      mockSitesDatabase,
    );
  });

  group('CreateSiteGroupWithRelationsUseCase', () {
    final testSiteGroup = SiteGroup(
      idSitesGroup: 0,
      sitesGroupName: 'Test Group',
      sitesGroupCode: 'TG001',
      sitesGroupDescription: 'Test Description',
    );

    const testModuleId = 5;
    const createdSiteGroupId = 456;

    test('should create site group and site-group-module relation', () async {
      // Arrange
      when(mockCreateSiteGroupUseCase.execute(testSiteGroup))
          .thenAnswer((_) async => createdSiteGroupId);
      when(mockSitesDatabase.insertSiteGroupModule(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.execute(
        siteGroup: testSiteGroup,
        moduleId: testModuleId,
      );

      // Assert
      expect(result, createdSiteGroupId);
      verify(mockCreateSiteGroupUseCase.execute(testSiteGroup));
      verify(mockSitesDatabase.insertSiteGroupModule(argThat(
        predicate<SitesGroupModule>((sgm) =>
            sgm.idSitesGroup == createdSiteGroupId && sgm.idModule == testModuleId),
      )));
    });

    test('should propagate exception from create site group use case', () async {
      // Arrange
      final testException = Exception('Create site group failed');
      when(mockCreateSiteGroupUseCase.execute(testSiteGroup))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(siteGroup: testSiteGroup, moduleId: testModuleId),
        throwsA(testException),
      );
      verify(mockCreateSiteGroupUseCase.execute(testSiteGroup));
      verifyNever(mockSitesDatabase.insertSiteGroupModule(any));
    });

    test('should propagate exception from insert site group module', () async {
      // Arrange
      final testException = Exception('Insert site group module failed');
      when(mockCreateSiteGroupUseCase.execute(testSiteGroup))
          .thenAnswer((_) async => createdSiteGroupId);
      when(mockSitesDatabase.insertSiteGroupModule(any))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(siteGroup: testSiteGroup, moduleId: testModuleId),
        throwsA(testException),
      );
    });

    test('should handle site group with all fields', () async {
      // Arrange
      final fullSiteGroup = SiteGroup(
        idSitesGroup: 0,
        sitesGroupName: 'Full Site Group',
        sitesGroupCode: 'FSG001',
        sitesGroupDescription: 'Full Description',
        comments: 'Some comments',
        altitudeMin: 100,
        altitudeMax: 500,
        idDigitiser: 42,
        metaCreateDate: DateTime(2024, 1, 1),
        metaUpdateDate: DateTime(2024, 6, 1),
      );

      when(mockCreateSiteGroupUseCase.execute(fullSiteGroup))
          .thenAnswer((_) async => createdSiteGroupId);
      when(mockSitesDatabase.insertSiteGroupModule(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.execute(
        siteGroup: fullSiteGroup,
        moduleId: testModuleId,
      );

      // Assert
      expect(result, createdSiteGroupId);
      verify(mockCreateSiteGroupUseCase.execute(fullSiteGroup));
      verify(mockSitesDatabase.insertSiteGroupModule(any));
    });
  });
}
