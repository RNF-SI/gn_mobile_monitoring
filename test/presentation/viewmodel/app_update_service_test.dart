import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckAppUpdateUseCase extends Mock
    implements CheckAppUpdateUseCase {}

class MockDownloadAppUpdateUseCase extends Mock
    implements DownloadAppUpdateUseCase {}

class MockGetTokenUseCase extends Mock
    implements GetTokenFromLocalStorageUseCase {}

void main() {
  late MockCheckAppUpdateUseCase mockCheckUseCase;
  late MockDownloadAppUpdateUseCase mockDownloadUseCase;
  late MockGetTokenUseCase mockGetTokenUseCase;
  late AppUpdateService service;

  setUp(() {
    mockCheckUseCase = MockCheckAppUpdateUseCase();
    mockDownloadUseCase = MockDownloadAppUpdateUseCase();
    mockGetTokenUseCase = MockGetTokenUseCase();
    service = AppUpdateService(
      mockCheckUseCase,
      mockDownloadUseCase,
      mockGetTokenUseCase,
    );
  });

  group('checkForUpdate', () {
    test('passe de idle à updateAvailable quand une MAJ est disponible',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.updateAvailable);
      expect(service.state.availableUpdate, isNotNull);
      expect(service.state.availableUpdate!.versionCode, '5');
    });

    test('reste idle quand aucune MAJ disponible', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => null);

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.idle);
      expect(service.state.availableUpdate, isNull);
    });

    test('reste idle quand le token est null', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => null);

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.idle);
    });

    test('reste idle quand le token est vide', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => '');

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.idle);
    });

    test('reste idle en cas d\'erreur (pas de blocage)', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenThrow(Exception('network error'));

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.idle);
    });

    test('ne propose pas la même version deux fois', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      // Premier check → updateAvailable
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      // Dismiss
      service.dismiss();
      expect(service.state.state, AppUpdateState.idle);

      // Deuxième check même version → idle (pas de re-proposition)
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.idle);
    });
  });

  group('downloadAndInstall', () {
    test('passe en état error quand le téléchargement échoue', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      await service.checkForUpdate();

      // Mock download qui échoue
      when(() => mockDownloadUseCase.execute(
            any(),
            token: any(named: 'token'),
            onProgress: any(named: 'onProgress'),
          )).thenThrow(Exception('download failed'));

      await service.downloadAndInstall();

      expect(service.state.state, AppUpdateState.error);
      expect(service.state.errorMessage, isNotNull);
    });

    test('ne fait rien quand pas de mise à jour disponible', () async {
      await service.downloadAndInstall();

      // Reste idle, pas de changement d'état
      expect(service.state.state, AppUpdateState.idle);
    });
  });

  group('dismiss', () {
    test('remet le service à idle', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => const MobileAppVersion(
                idMobileApp: 1,
                appCode: 'MONITORING',
                versionCode: '5',
                urlApk: 'https://example.com/monitoring.apk',
              ));

      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      service.dismiss();
      expect(service.state.state, AppUpdateState.idle);
    });
  });
}
