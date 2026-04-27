import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckAppUpdateUseCase extends Mock
    implements CheckAppUpdateUseCase {}

class MockDownloadAppUpdateUseCase extends Mock
    implements DownloadAppUpdateUseCase {}

class MockGetTokenUseCase extends Mock
    implements GetTokenFromLocalStorageUseCase {}

class MockGetDismissedAppVersionUseCase extends Mock
    implements GetDismissedAppVersionUseCase {}

class MockSetDismissedAppVersionUseCase extends Mock
    implements SetDismissedAppVersionUseCase {}

/// Persistance en mémoire du versionCode refusé, partagée entre instances.
/// Permet de simuler le SharedPreferences réel pour les tests qui vérifient
/// le comportement à travers une "relance" de l'app (instance fraîche).
class _InMemoryDismissedStore {
  String? value;
}

void main() {
  late MockCheckAppUpdateUseCase mockCheckUseCase;
  late MockDownloadAppUpdateUseCase mockDownloadUseCase;
  late MockGetTokenUseCase mockGetTokenUseCase;
  late MockGetDismissedAppVersionUseCase mockGetDismissedUseCase;
  late MockSetDismissedAppVersionUseCase mockSetDismissedUseCase;
  late _InMemoryDismissedStore dismissedStore;
  late AppUpdateService service;

  const updateV5 = MobileAppVersion(
    idMobileApp: 1,
    appCode: 'MONITORING',
    versionCode: '5',
    urlApk: 'https://example.com/monitoring.apk',
  );

  AppUpdateService buildService() {
    return AppUpdateService(
      mockCheckUseCase,
      mockDownloadUseCase,
      mockGetTokenUseCase,
      mockGetDismissedUseCase,
      mockSetDismissedUseCase,
    );
  }

  setUp(() {
    mockCheckUseCase = MockCheckAppUpdateUseCase();
    mockDownloadUseCase = MockDownloadAppUpdateUseCase();
    mockGetTokenUseCase = MockGetTokenUseCase();
    mockGetDismissedUseCase = MockGetDismissedAppVersionUseCase();
    mockSetDismissedUseCase = MockSetDismissedAppVersionUseCase();
    dismissedStore = _InMemoryDismissedStore();

    when(() => mockGetDismissedUseCase.execute())
        .thenAnswer((_) async => dismissedStore.value);
    when(() => mockSetDismissedUseCase.execute(any()))
        .thenAnswer((invocation) async {
      dismissedStore.value =
          invocation.positionalArguments.first as String?;
    });

    service = buildService();
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

    test(
        'ne re-propose pas la même version dans la même session après un dismiss',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      service.dismiss();
      expect(service.state.state, AppUpdateState.idle);

      // Deuxième check dans la même session : la MAJ est toujours dispo côté
      // serveur, mais le service ne la repropose pas pour ne pas spammer.
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.idle);
    });

    test(
        'fix issue #170 : une MAJ refusée est persistée et n\'est plus '
        'reproposée après relance de l\'app (nouvelle instance du service)',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      // Session 1 : propose → refus
      await service.checkForUpdate();
      service.dismiss();
      // Laisse passer le fire-and-forget de persistance.
      await Future.delayed(Duration.zero);

      // Session 2 : nouvelle instance ; le dismiss est rechargé depuis le store.
      final freshService = buildService();

      await freshService.checkForUpdate();

      expect(freshService.state.state, AppUpdateState.idle,
          reason:
              'Le dismiss est persisté : la même version ne doit plus être reproposée après relance');
    });

    test(
        'reste idle si l\'API renvoie un versionCode vide '
        '(évite le dialog "version " vide)',
        () async {
      const updateEmpty = MobileAppVersion(
        idMobileApp: 1,
        appCode: 'MONITORING',
        versionCode: '',
        urlApk: 'https://example.com/monitoring.apk',
      );

      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateEmpty);

      await service.checkForUpdate();

      expect(service.state.state, AppUpdateState.idle);
    });

    test(
        'ne relance pas un check quand un dialog updateAvailable est déjà '
        'à l\'écran (évite la double popup boot + sync.success)',
        () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      // Un 2e check (déclenché par sync.success après le boot) doit être ignoré
      // pour ne pas rejouer la transition idle → updateAvailable et rouvrir
      // un 2e dialog côté HomePage.
      await service.checkForUpdate();

      verify(() => mockCheckUseCase.execute('token')).called(1);
      expect(service.state.state, AppUpdateState.updateAvailable);
    });

    test('propose une nouvelle version même si une précédente a été refusée',
        () async {
      const updateV6 = MobileAppVersion(
        idMobileApp: 1,
        appCode: 'MONITORING',
        versionCode: '6',
        urlApk: 'https://example.com/monitoring.apk',
      );

      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      service.dismiss();

      // Le serveur expose maintenant v6 (version différente → proposée)
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

      expect(service.state.state, AppUpdateState.idle);
    });
  });

  group('dismiss', () {
    test('remet le service à idle', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.updateAvailable);

      service.dismiss();
      expect(service.state.state, AppUpdateState.idle);
    });
  });

  group('checkForUpdateManually', () {
    test(
        'repropose la MAJ après un dismiss dans la session (issue #170, '
        'bouton "Mise à jour de l\'application")', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => updateV5);

      await service.checkForUpdate();
      service.dismiss();

      // Un checkForUpdate "normal" ne la reproposerait pas dans cette session
      await service.checkForUpdate();
      expect(service.state.state, AppUpdateState.idle);

      // Le check manuel lève le garde-fou et repropose la MAJ
      await service.checkForUpdateManually();
      expect(service.state.state, AppUpdateState.updateAvailable);
    });

    test('reste idle si aucune MAJ disponible', () async {
      when(() => mockGetTokenUseCase.execute())
          .thenAnswer((_) async => 'token');
      when(() => mockCheckUseCase.execute('token'))
          .thenAnswer((_) async => null);

      await service.checkForUpdateManually();
      expect(service.state.state, AppUpdateState.idle);
    });
  });
}
