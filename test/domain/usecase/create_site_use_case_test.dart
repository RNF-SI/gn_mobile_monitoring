import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late CreateSiteUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUpAll(() {
    registerFallbackValue(const BaseSite(idBaseSite: 0));
  });

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = CreateSiteUseCaseImpl(mockSitesDatabase);
  });

  group('CreateSiteUseCaseImpl', () {
    test('should generate UUID when uuidBaseSite is null', () async {
      // Arrange
      const site = BaseSite(
        idBaseSite: 0,
        baseSiteName: 'Test Site',
        baseSiteCode: 'TS001',
      );
      when(() => mockSitesDatabase.insertSite(any()))
          .thenAnswer((_) async => 42);

      // Act
      final result = await useCase.execute(site);

      // Assert
      expect(result, 42);
      final captured =
          verify(() => mockSitesDatabase.insertSite(captureAny())).captured;
      final insertedSite = captured.first as BaseSite;
      expect(insertedSite.uuidBaseSite, isNotNull);
      expect(insertedSite.uuidBaseSite!.length, greaterThan(0));
      expect(insertedSite.baseSiteName, 'Test Site');
    });

    test('should preserve existing UUID when uuidBaseSite is provided',
        () async {
      // Arrange
      const existingUuid = 'existing-uuid-1234';
      const site = BaseSite(
        idBaseSite: 0,
        baseSiteName: 'Test Site',
        uuidBaseSite: existingUuid,
      );
      when(() => mockSitesDatabase.insertSite(any()))
          .thenAnswer((_) async => 7);

      // Act
      final result = await useCase.execute(site);

      // Assert
      expect(result, 7);
      final captured =
          verify(() => mockSitesDatabase.insertSite(captureAny())).captured;
      final insertedSite = captured.first as BaseSite;
      expect(insertedSite.uuidBaseSite, existingUuid);
    });

    test('should return the ID from database insertion', () async {
      // Arrange
      const site = BaseSite(idBaseSite: 0);
      when(() => mockSitesDatabase.insertSite(any()))
          .thenAnswer((_) async => 123);

      // Act
      final result = await useCase.execute(site);

      // Assert
      expect(result, 123);
    });

    test('should propagate exceptions from database', () async {
      // Arrange
      const site = BaseSite(idBaseSite: 0);
      when(() => mockSitesDatabase.insertSite(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
          () => useCase.execute(site), throwsA(isA<Exception>()));
    });

    test('should generate different UUIDs for different calls', () async {
      // Arrange
      const site1 = BaseSite(idBaseSite: 0, baseSiteName: 'Site 1');
      const site2 = BaseSite(idBaseSite: 0, baseSiteName: 'Site 2');
      when(() => mockSitesDatabase.insertSite(any()))
          .thenAnswer((_) async => 1);

      // Act
      await useCase.execute(site1);
      await useCase.execute(site2);

      // Assert
      final captured =
          verify(() => mockSitesDatabase.insertSite(captureAny())).captured;
      final uuid1 = (captured[0] as BaseSite).uuidBaseSite;
      final uuid2 = (captured[1] as BaseSite).uuidBaseSite;
      expect(uuid1, isNot(equals(uuid2)));
    });
  });
}
