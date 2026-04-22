import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_last_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckAppUpdateUseCase extends Mock
    implements CheckAppUpdateUseCase {}

class MockDownloadAppUpdateUseCase extends Mock
    implements DownloadAppUpdateUseCase {}

class MockGetTokenUseCase extends Mock
    implements GetTokenFromLocalStorageUseCase {}

class MockGetLastDismissedUseCase extends Mock
    implements GetLastDismissedAppVersionUseCase {}

class MockSetLastDismissedUseCase extends Mock
    implements SetLastDismissedAppVersionUseCase {}

void main() {
  late MockCheckAppUpdateUseCase mockCheckUseCase;
  late MockDownloadAppUpdateUseCase mockDownloadUseCase;
  late MockGetTokenUseCase mockGetTokenUseCase;
  late MockGetLastDismissedUseCase mockGetLastDismissedUseCase;
  late MockSetLastDismissedUseCase mockSetLastDismissedUseCase;
  late AppUpdateService service;

  const updateV5 = MobileAppVersion(
    idMobileApp: 1,
    appCode: 'MONITORING',
    versionCode: '5',
    urlApk: 'https://example.com/monitoring.apk',
  );

  setUp(() {
    mockCheckUseCase = MockCheckAppUpdateUseCase();
    mockDownloadUseCase = MockDownloadAppUpdateUseCase();
    mockGetTokenUseCase = MockGetTokenUseCase();
    mockGetLastDismissedUseCase = MockGetLastDismissedUseCase();
    mockSetLastDismissedUseCase = MockSetLastDismissedUseCase();

    // Par défaut : rien n'a été refusé précédemment
    when(() => mockGetLastDismissedUseCase.execute())
        .thenAnswer((_) async => null);
    when(() => mockSetLastDismissedUseCase.execute(any()))
        .thenAnswer((_) async {});

    service = AppUpdateService(
      mockCheckUseCase,
      mockDownloadUseCase,
      mockGetTokenUseCase,
      mockGetLastDismissedUseCase,
      mockSetLastDismissedUseCase,
    );
  });

  group('checkForUpdate', () {
    test('passe de idle à updateAvailable quand une MAJ est disponible',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

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

    test('ne propose pas la même version deux fois dans la même session',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      // Premier check : aucune version persistée → updateAvailable
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      // Dismiss : persiste '5'
      await service.dismiss();
      expect(service.state.state, AppUpdateState.idle);
      verify(() => mockSetLastDismissedUseCase.execute('5')).called(1);

      // Simuler une relance : la version persistée est maintenant '5'
      when(() => mockGetLastDismissedUseCase.execute())
          .thenAnswer((_) async => '5');

      // Deuxième check même version → idle (issue #170)
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.idle);
    });

    test(
        'issue #170 : une nouvelle instance du service ne re-propose pas une '
        'version déjà refusée lors d\'une session précédente', () async {
      // Simule une persistance laissée par une session antérieure
      when(() => mockGetLastDismissedUseCase.execute())
          .thenAnswer((_) async => '5');
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      // Nouvelle instance (aucun state en mémoire)
      final freshService = AppUpdateService(
        mockCheckUseCase,
        mockDownloadUseCase,
        mockGetTokenUseCase,
        mockGetLastDismissedUseCase,
        mockSetLastDismissedUseCase,
      );

      await freshService.checkForUpdate();

      expect(freshService.state.state, AppUpdateState.idle,
          reason:
              'Une version déjà refusée ne doit plus être proposée au relancement');
    });

    test(
        'issue #170 : propose à nouveau si le serveur publie une version '
        'strictement plus récente que la dernière refusée', () async {
      const updateV6 = MobileAppVersion(
        idMobileApp: 1,
        appCode: 'MONITORING',
        versionCode: '6',
        urlApk: 'https://example.com/monitoring.apk',
      );
      // Dernière version refusée : '5'. Le serveur expose maintenant '6'.
      when(() => mockGetLastDismissedUseCase.execute())
          .thenAnswer((_) async => '5');
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV6);

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.updateAvailable);
      expect(service.state.availableUpdate!.versionCode, '6');
    });
  });

  group('downloadAndInstall', () {
    test('passe en état error quand le téléchargement échoue', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

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
    test('remet le service à idle et persiste la version refusée', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      await service.dismiss();
      expect(service.state.state, AppUpdateState.idle);
      verify(() => mockSetLastDismissedUseCase.execute('5')).called(1);
    });

    test('ne persiste rien si aucun update disponible', () async {
      await service.dismiss();

      verifyNever(() => mockSetLastDismissedUseCase.execute(any()));
    });
  });
}
