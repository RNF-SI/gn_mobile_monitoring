import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late CreateSiteGroupUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUpAll(() {
    registerFallbackValue(const SiteGroup(idSitesGroup: 0));
  });

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = CreateSiteGroupUseCaseImpl(mockSitesDatabase);
  });

  group('CreateSiteGroupUseCaseImpl', () {
    test('should generate UUID when uuidSitesGroup is null', () async {
      // Arrange
      const siteGroup = SiteGroup(
        idSitesGroup: 0,
        sitesGroupName: 'Test Group',
        sitesGroupCode: 'TG001',
      );
      when(() => mockSitesDatabase.insertSiteGroup(any()))
          .thenAnswer((_) async => 42);

      // Act
      final result = await useCase.execute(siteGroup);

      // Assert
      expect(result, 42);
      final captured =
          verify(() => mockSitesDatabase.insertSiteGroup(captureAny()))
              .captured;
      final insertedGroup = captured.first as SiteGroup;
      expect(insertedGroup.uuidSitesGroup, isNotNull);
      expect(insertedGroup.uuidSitesGroup!.length, greaterThan(0));
      expect(insertedGroup.sitesGroupName, 'Test Group');
    });

    test('should preserve existing UUID when uuidSitesGroup is provided',
        () async {
      // Arrange
      const existingUuid = 'existing-uuid-5678';
      const siteGroup = SiteGroup(
        idSitesGroup: 0,
        sitesGroupName: 'Test Group',
        uuidSitesGroup: existingUuid,
      );
      when(() => mockSitesDatabase.insertSiteGroup(any()))
          .thenAnswer((_) async => 7);

      // Act
      final result = await useCase.execute(siteGroup);

      // Assert
      expect(result, 7);
      final captured =
          verify(() => mockSitesDatabase.insertSiteGroup(captureAny()))
              .captured;
      final insertedGroup = captured.first as SiteGroup;
      expect(insertedGroup.uuidSitesGroup, existingUuid);
    });

    test('should return the ID from database insertion', () async {
      // Arrange
      const siteGroup = SiteGroup(idSitesGroup: 0);
      when(() => mockSitesDatabase.insertSiteGroup(any()))
          .thenAnswer((_) async => 99);

      // Act
      final result = await useCase.execute(siteGroup);

      // Assert
      expect(result, 99);
    });

    test('should propagate exceptions from database', () async {
      // Arrange
      const siteGroup = SiteGroup(idSitesGroup: 0);
      when(() => mockSitesDatabase.insertSiteGroup(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
          () => useCase.execute(siteGroup), throwsA(isA<Exception>()));
    });

    test('should generate different UUIDs for different calls', () async {
      // Arrange
      const group1 =
          SiteGroup(idSitesGroup: 0, sitesGroupName: 'Group 1');
      const group2 =
          SiteGroup(idSitesGroup: 0, sitesGroupName: 'Group 2');
      when(() => mockSitesDatabase.insertSiteGroup(any()))
          .thenAnswer((_) async => 1);

      // Act
      await useCase.execute(group1);
      await useCase.execute(group2);

      // Assert
      final captured =
          verify(() => mockSitesDatabase.insertSiteGroup(captureAny()))
              .captured;
      final uuid1 = (captured[0] as SiteGroup).uuidSitesGroup;
      final uuid2 = (captured[1] as SiteGroup).uuidSitesGroup;
      expect(uuid1, isNot(equals(uuid2)));
    });
  });
}
