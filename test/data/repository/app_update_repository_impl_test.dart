import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/mobile_app_api.dart';
import 'package:gn_mobile_monitoring/data/repository/app_update_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockMobileAppApi extends Mock implements MobileAppApi {}

void main() {
  late MockMobileAppApi mockApi;
  late AppUpdateRepositoryImpl repository;

  setUp(() {
    mockApi = MockMobileAppApi();
    repository = AppUpdateRepositoryImpl(mockApi);
  });

  group('fetchRemoteAppVersion', () {
    test('retourne MobileAppVersion quand MONITORING est trouvé', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => [
                {
                  'id_mobile_app': 1,
                  'app_code': 'MONITORING',
                  'version_code': '2',
                  'url_apk': 'https://example.com/monitoring.apk',
                  'package': 'fr.geonature.monitoring',
                }
              ]);

      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNotNull);
      expect(result!.idMobileApp, 1);
      expect(result.appCode, 'MONITORING');
      expect(result.versionCode, '2');
      expect(result.urlApk, 'https://example.com/monitoring.apk');
      expect(result.package, 'fr.geonature.monitoring');
    });

    test('retourne null quand la liste est vide', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => []);

      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNull);
    });

    test('retourne null quand l\'API retourne null', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => null);

      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNull);
    });

    test('retourne null quand MONITORING n\'est pas dans la liste', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => [
                {
                  'id_mobile_app': 1,
                  'app_code': 'OCCTAX',
                  'version_code': '3',
                }
              ]);

      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNull);
    });

    test('recherche case-insensitive de MONITORING', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => [
                {
                  'id_mobile_app': 1,
                  'app_code': 'monitoring',
                  'version_code': '5',
                }
              ]);

      // app_code en minuscules ne match pas "MONITORING" en uppercase
      // car on compare avec toUpperCase()
      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNotNull);
      expect(result!.versionCode, '5');
    });

    test('ignore les entrées sans id_mobile_app ou version_code', () async {
      when(() => mockApi.fetchMobileApps('token', 'MONITORING'))
          .thenAnswer((_) async => [
                {
                  'app_code': 'MONITORING',
                  // pas de id_mobile_app ni version_code
                }
              ]);

      final result = await repository.fetchRemoteAppVersion('token');
      expect(result, isNull);
    });
  });
}
