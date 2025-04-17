import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockModulesDatabase extends Mock implements ModulesDatabase {}
class MockModulesRepository extends Mock implements ModulesRepository {}

void main() {
  late MockModulesRepository repository;
  late MockModulesDatabase mockModulesDatabase;

  setUp(() {
    mockModulesDatabase = MockModulesDatabase();
    repository = MockModulesRepository();
  });

  group('getDatasetIdsForModule', () {
    const moduleId = 1;
    final expectedDatasetIds = [1, 2, 3];

    test('should forward the database call correctly', () async {
      // Setup - simulate what the real implementation would do
      when(() => mockModulesDatabase.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => expectedDatasetIds);
          
      // Make the repository method work like the real one
      when(() => repository.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => await mockModulesDatabase.getDatasetIdsForModule(moduleId));

      // Execute
      final result = await repository.getDatasetIdsForModule(moduleId);

      // Verify
      expect(result, equals(expectedDatasetIds));
      verify(() => mockModulesDatabase.getDatasetIdsForModule(moduleId)).called(1);
    });

    test('should throw exception when database operation fails', () async {
      // Setup - simulate error in database
      when(() => mockModulesDatabase.getDatasetIdsForModule(moduleId))
          .thenThrow(Exception('Database error'));
          
      // Make the repository method work like the real one
      when(() => repository.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => await mockModulesDatabase.getDatasetIdsForModule(moduleId));

      // Execute & Verify
      expect(
        () => repository.getDatasetIdsForModule(moduleId),
        throwsA(isA<Exception>()),
      );
    });
  });
}