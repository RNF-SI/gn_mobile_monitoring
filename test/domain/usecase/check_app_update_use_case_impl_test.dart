import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/repository/app_update_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAppUpdateRepository extends Mock implements AppUpdateRepository {}

void main() {
  late MockAppUpdateRepository mockRepository;

  setUp(() {
    mockRepository = MockAppUpdateRepository();
  });

  CheckAppUpdateUseCaseImpl createUseCase({String localBuildNumber = '1'}) {
    return CheckAppUpdateUseCaseImpl(
      mockRepository,
      localBuildNumberProvider: () async => localBuildNumber,
    );
  }

  group('execute', () {
    test('retourne la mise à jour quand version serveur > locale', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      final useCase = createUseCase(localBuildNumber: '1');
      final result = await useCase.execute('token');

      expect(result, isNotNull);
      expect(result!.versionCode, '5');
    });

    test('retourne null quand version serveur == locale', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '1',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      final useCase = createUseCase(localBuildNumber: '1');
      final result = await useCase.execute('token');

      expect(result, isNull);
    });

    test('retourne null quand version serveur < locale', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '1',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      final useCase = createUseCase(localBuildNumber: '5');
      final result = await useCase.execute('token');

      expect(result, isNull);
    });

    test('retourne null quand repository retourne null', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => null);

      final useCase = createUseCase();
      final result = await useCase.execute('token');

      expect(result, isNull);
    });

    test('retourne null quand urlApk est null', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: null,
              ));

      final useCase = createUseCase(localBuildNumber: '1');
      final result = await useCase.execute('token');

      expect(result, isNull);
    });

    test('retourne null quand urlApk est vide', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: '',
              ));

      final useCase = createUseCase(localBuildNumber: '1');
      final result = await useCase.execute('token');

      expect(result, isNull);
    });

    test('gère un version_code non numérique gracieusement', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: 'abc',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      final useCase = createUseCase(localBuildNumber: '1');
      final result = await useCase.execute('token');

      // 'abc' → int.tryParse → 0, et 0 < 1 → pas de mise à jour
      expect(result, isNull);
    });

    test('gère un buildNumber local non numérique', () async {
      when(() => mockRepository.fetchRemoteAppVersion('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      final useCase = createUseCase(localBuildNumber: 'invalid');
      final result = await useCase.execute('token');

      // 'invalid' → 0, et 5 > 0 → mise à jour disponible
      expect(result, isNotNull);
    });
  });
}
