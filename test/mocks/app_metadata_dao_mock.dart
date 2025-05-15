import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/dao/app_metadata_dao.dart';
import 'package:mocktail/mocktail.dart';

// A mock implementation of AppMetadataDao that can be used in tests
class MockAppMetadataDao extends Mock implements AppMetadataDao {
  MockAppMetadataDao() {
    registerFallbackValue('any_key');
    registerFallbackValue('any_value');
    
    // Setup default behaviors
    when(() => getValue(any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0] as String;
      if (key.startsWith('last_sync_')) {
        return '2024-05-15T10:00:00Z';
      }
      return null;
    });
    
    when(() => setValue(any(), any())).thenAnswer((_) async {});
    when(() => deleteValue(any())).thenAnswer((_) async {});
    when(() => getAllWithPrefix(any())).thenAnswer((invocation) async {
      final prefix = invocation.positionalArguments[0] as String;
      return {'${prefix}_test': 'test_value'};
    });
  }
}