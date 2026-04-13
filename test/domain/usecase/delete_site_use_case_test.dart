import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late DeleteSiteUseCaseImpl useCase;
  late MockSitesDatabase mockSitesDatabase;

  setUp(() {
    mockSitesDatabase = MockSitesDatabase();
    useCase = DeleteSiteUseCaseImpl(mockSitesDatabase);
  });

  group('DeleteSiteUseCaseImpl', () {
    test('should return true when deletion succeeds', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSite(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(42);

      // Assert
      expect(result, true);
      verify(() => mockSitesDatabase.deleteSite(42)).called(1);
    });

    test('should return false when deletion throws an exception', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSite(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await useCase.execute(42);

      // Assert
      expect(result, false);
    });

    test('should pass the correct site ID to database', () async {
      // Arrange
      when(() => mockSitesDatabase.deleteSite(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(999);

      // Assert
      verify(() => mockSitesDatabase.deleteSite(999)).called(1);
      verifyNever(() => mockSitesDatabase.deleteSite(any(that: isNot(999))));
    });
  });
}
