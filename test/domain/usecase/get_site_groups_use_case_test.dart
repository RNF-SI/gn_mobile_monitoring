import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase_impl.dart';

// Mock des dépendances
class MockSitesRepository extends Mock implements SitesRepository {}

void main() {
  late GetSiteGroupsUseCase useCase;
  late MockSitesRepository mockRepository;

  setUp(() {
    mockRepository = MockSitesRepository();
    useCase = GetSiteGroupsUseCaseImpl(mockRepository);
  });

  group('GetSiteGroupsUseCase', () {
    test('should return site groups from repository', () async {
      // Arrange
      final testSiteGroups = [
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
      
      when(() => mockRepository.getSiteGroups())
          .thenAnswer((_) async => testSiteGroups);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(testSiteGroups));
      verify(() => mockRepository.getSiteGroups()).called(1);
    });

    test('should return empty list when repository returns empty', () async {
      // Arrange
      when(() => mockRepository.getSiteGroups())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getSiteGroups()).called(1);
    });
    
    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.getSiteGroups())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getSiteGroups()).called(1);
    });
  });
}
