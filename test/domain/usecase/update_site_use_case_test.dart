import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late UpdateSiteUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUpAll(() {
    registerFallbackValue(const BaseSite(idBaseSite: 0));
  });

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = UpdateSiteUseCaseImpl(mockSitesDatabase);
  });

  group('UpdateSiteUseCaseImpl', () {
    test('should return true when update succeeds', () async {
      // Arrange
      const site = BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Updated Site',
        baseSiteCode: 'US001',
      );
      when(() => mockSitesDatabase.updateSite(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(site);

      // Assert
      expect(result, true);
      verify(() => mockSitesDatabase.updateSite(site)).called(1);
    });

    test('should return false when update throws an exception', () async {
      // Arrange
      const site = BaseSite(idBaseSite: 1);
      when(() => mockSitesDatabase.updateSite(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await useCase.execute(site);

      // Assert
      expect(result, false);
    });

    test('should pass the exact site object to database', () async {
      // Arrange
      const site = BaseSite(
        idBaseSite: 5,
        baseSiteName: 'Specific Site',
        altitudeMin: 150,
        altitudeMax: 300,
        isLocal: true,
        geom: '{"type":"Point","coordinates":[2.35,48.85]}',
      );
      when(() => mockSitesDatabase.updateSite(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(site);

      // Assert
      final captured =
          verify(() => mockSitesDatabase.updateSite(captureAny())).captured;
      final updatedSite = captured.first as BaseSite;
      expect(updatedSite.idBaseSite, 5);
      expect(updatedSite.baseSiteName, 'Specific Site');
      expect(updatedSite.altitudeMin, 150);
      expect(updatedSite.isLocal, true);
    });
  });
}
