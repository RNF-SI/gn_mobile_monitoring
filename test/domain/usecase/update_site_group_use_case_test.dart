import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late UpdateSiteGroupUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUpAll(() {
    registerFallbackValue(const SiteGroup(idSitesGroup: 0));
  });

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = UpdateSiteGroupUseCaseImpl(mockSitesDatabase);
  });

  group('UpdateSiteGroupUseCaseImpl', () {
    test('should return true when update succeeds', () async {
      // Arrange
      const siteGroup = SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Updated Group',
        sitesGroupCode: 'UG001',
      );
      when(() => mockSitesDatabase.updateSiteGroup(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(siteGroup);

      // Assert
      expect(result, true);
      verify(() => mockSitesDatabase.updateSiteGroup(siteGroup)).called(1);
    });

    test('should return false when update throws an exception', () async {
      // Arrange
      const siteGroup = SiteGroup(idSitesGroup: 1);
      when(() => mockSitesDatabase.updateSiteGroup(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await useCase.execute(siteGroup);

      // Assert
      expect(result, false);
    });

    test('should pass the exact site group object to database', () async {
      // Arrange
      const siteGroup = SiteGroup(
        idSitesGroup: 10,
        sitesGroupName: 'Specific Group',
        sitesGroupDescription: 'A specific group for testing',
        altitudeMin: 200,
        altitudeMax: 500,
        isLocal: true,
        geom: '{"type":"Polygon","coordinates":[[[2.3,48.8],[2.4,48.8],[2.4,48.9],[2.3,48.9],[2.3,48.8]]]}',
      );
      when(() => mockSitesDatabase.updateSiteGroup(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(siteGroup);

      // Assert
      final captured =
          verify(() => mockSitesDatabase.updateSiteGroup(captureAny()))
              .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.idSitesGroup, 10);
      expect(updatedGroup.sitesGroupName, 'Specific Group');
      expect(updatedGroup.altitudeMin, 200);
      expect(updatedGroup.isLocal, true);
    });
  });
}
