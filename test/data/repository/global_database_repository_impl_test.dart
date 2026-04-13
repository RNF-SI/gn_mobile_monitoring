import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/repository/global_database_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GlobalDatabaseRepositoryImpl repository;
  late MockGlobalDatabase mockDatabase;
  late MockGlobalApi mockApi;

  setUp(() {
    mockDatabase = MockGlobalDatabase();
    mockApi = MockGlobalApi();
    repository = GlobalDatabaseRepositoryImpl(mockDatabase, mockApi);
  });

  group('initDatabase', () {
    test('calls database.initDatabase on success', () async {
      when(() => mockDatabase.initDatabase()).thenAnswer((_) async {});

      await repository.initDatabase();

      verify(() => mockDatabase.initDatabase()).called(1);
    });

    test('wraps exception with descriptive message on failure', () async {
      when(() => mockDatabase.initDatabase())
          .thenThrow(Exception('DB error'));

      expect(
        () => repository.initDatabase(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to initialize database'),
        )),
      );
    });
  });

  group('deleteDatabase', () {
    test('calls database.deleteDatabase on success', () async {
      when(() => mockDatabase.deleteDatabase()).thenAnswer((_) async {});

      await repository.deleteDatabase();

      verify(() => mockDatabase.deleteDatabase()).called(1);
    });

    test('wraps exception with descriptive message on failure', () async {
      when(() => mockDatabase.deleteDatabase())
          .thenThrow(Exception('Delete error'));

      expect(
        () => repository.deleteDatabase(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to delete database'),
        )),
      );
    });
  });
}
