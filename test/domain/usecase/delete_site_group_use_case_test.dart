import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late DeleteSiteGroupUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = DeleteSiteGroupUseCaseImpl(mockSitesDatabase);
  });

  group('DeleteSiteGroupUseCaseImpl', () {
    test('should return true when deletion succeeds', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSiteGroup(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(42);

      // Assert
      expect(result, true);
      verify(() => mockSitesDatabase.deleteSiteGroup(42)).called(1);
    });

    test('should return false when deletion throws an exception', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSiteGroup(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await useCase.execute(42);

      // Assert
      expect(result, false);
    });

    test('should pass the correct site group ID to database', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSiteGroup(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(777);

      // Assert
      verify(() => mockSitesDatabase.deleteSiteGroup(777)).called(1);
      verifyNever(
          () => mockSitesDatabase.deleteSiteGroup(any(that: isNot(777))));
    });
  });
}
