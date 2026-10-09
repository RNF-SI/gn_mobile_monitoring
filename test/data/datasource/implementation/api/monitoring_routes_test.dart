import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/monitoring_routes.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/visits_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockConnectivity extends Mock implements Connectivity {}

class _FixedModeResolver extends MonitoringApiModeResolver {
  const _FixedModeResolver(this.mode);
  final MonitoringApiMode mode;

  @override
  Future<MonitoringApiMode> resolve(
          Dio dio, String token, String moduleCode) async =>
      mode;
}

Response<dynamic> _response(String path, int status, [dynamic data]) =>
    Response(
      requestOptions: RequestOptions(path: path),
      statusCode: status,
      data: data,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  group('MonitoringWriteRequest', () {
    final legacyVisit = {
      'properties': {
        'id_base_site': 4,
        'visit_date_min': '2026-10-08',
        'observers': [3],
        'id_dataset': 1,
        'id_module': 15,
        'expertise': 'Débutant',
      },
      'module_code': 'POPAmphibien',
    };

    test('legacy : route générique, corps inchangé', () {
      final request = MonitoringWriteRequest.build(
        mode: MonitoringApiMode.legacy,
        moduleCode: 'POPAmphibien',
        type: MonitoringObjectType.visit,
        legacyBody: legacyVisit,
        id: 7,
      );

      expect(request.path, '/monitorings/object/POPAmphibien/visit/7');
      expect(request.body, same(legacyVisit));
    });

    test('current : POST sur la route du module avec un corps à plat', () {
      final request = MonitoringWriteRequest.build(
        mode: MonitoringApiMode.current,
        moduleCode: 'POPAmphibien',
        type: MonitoringObjectType.visit,
        legacyBody: legacyVisit,
      );

      expect(request.path, '/monitorings/POPAmphibien/visits');
      expect(request.body, {
        'id_base_site': 4,
        'visit_date_min': '2026-10-08',
        'observers': [3],
        'id_dataset': 1,
        'id_module': 15,
        'expertise': 'Débutant',
      });
    });

    test('current : PATCH avec la clé primaire dans le corps', () {
      final request = MonitoringWriteRequest.build(
        mode: MonitoringApiMode.current,
        moduleCode: 'POPAmphibien',
        type: MonitoringObjectType.observation,
        legacyBody: {
          'properties': {'id_base_visit': 7, 'cd_nom': 212},
          'uuid_observation': 'ignoré comme en legacy',
          'module_code': 'POPAmphibien',
        },
        id: 6,
      );

      expect(request.path, '/monitorings/POPAmphibien/observations/6');
      expect(request.body,
          {'id_base_visit': 7, 'cd_nom': 212, 'id_observation': 6});
    });

    test('current : geometry devient geom, first_use_date une date seule', () {
      final point = {
        'type': 'Point',
        'coordinates': [5.75, 45.15]
      };
      final request = MonitoringWriteRequest.build(
        mode: MonitoringApiMode.current,
        moduleCode: 'POPAmphibien',
        type: MonitoringObjectType.site,
        legacyBody: {
          'type': 'Feature',
          'module_code': 'POPAmphibien',
          'geometry': point,
          'properties': {
            'base_site_name': 'Site',
            'first_use_date': '2026-10-08T00:00:00.000',
            'types_site': [941],
          },
        },
      );

      expect(request.path, '/monitorings/POPAmphibien/sites');
      expect(request.body, {
        'base_site_name': 'Site',
        'first_use_date': '2026-10-08',
        'types_site': [941],
        'geom': point,
      });
    });

    test('chemins de chaque type en mode current', () {
      String path(MonitoringObjectType type) => MonitoringWriteRequest.build(
            mode: MonitoringApiMode.current,
            moduleCode: 'M',
            type: type,
            legacyBody: const {'properties': {}},
          ).path;

      expect(
          path(MonitoringObjectType.sitesGroup), '/monitorings/M/sites_groups');
      expect(path(MonitoringObjectType.observationDetail),
          '/monitorings/M/observation_details');
    });
  });

  group('normalizeWriteResponse', () {
    test('ajoute id depuis la clé primaire', () {
      expect(
        normalizeWriteResponse(
            MonitoringObjectType.visit, {'id_base_visit': 7, 'comments': 'c'}),
        {'id_base_visit': 7, 'comments': 'c', 'id': 7},
      );
    });

    test('ne touche pas une réponse legacy', () {
      final legacy = {'id': 7, 'properties': {}};
      expect(normalizeWriteResponse(MonitoringObjectType.visit, legacy),
          same(legacy));
    });
  });

  group('MonitoringApiModeResolver', () {
    late MockDio dio;
    const probe = '/monitorings/module/POPAmphibien';

    setUp(() {
      dio = MockDio();
      MonitoringApiModeResolver.clearCache();
      Config.setStoredApiUrl('https://geonature.example.org');
    });

    tearDown(() {
      MonitoringApiModeResolver.clearCache();
      Config.clearStoredApiUrl();
    });

    void stubProbe(Future<Response<dynamic>> Function() answer) {
      when(() => dio.get(
            probe,
            queryParameters: {'field_name': 'module_code', 'depth': 0},
            options: any(named: 'options'),
          )).thenAnswer((_) => answer());
    }

    test('200 → routes de la refonte, mémorisé par serveur', () async {
      stubProbe(() async => _response(probe, 200, {'module_code': 'x'}));
      const resolver = MonitoringApiModeResolver();

      expect(await resolver.resolve(dio, 't', 'POPAmphibien'),
          MonitoringApiMode.current);
      expect(await resolver.resolve(dio, 't', 'POPAmphibien'),
          MonitoringApiMode.current);
      verify(() => dio.get(probe,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'))).called(1);
    });

    test('404 (monitoring ≤ 1.3.x) → routes legacy', () async {
      stubProbe(() async => throw DioException(
            requestOptions: RequestOptions(path: probe),
            response: _response(probe, 404),
            type: DioExceptionType.badResponse,
          ));

      expect(
          await const MonitoringApiModeResolver()
              .resolve(dio, 't', 'POPAmphibien'),
          MonitoringApiMode.legacy);
    });

    test('erreur réseau → legacy sans mémoriser', () async {
      stubProbe(() async => throw DioException(
            requestOptions: RequestOptions(path: probe),
            type: DioExceptionType.connectionError,
          ));
      const resolver = MonitoringApiModeResolver();
      expect(await resolver.resolve(dio, 't', 'POPAmphibien'),
          MonitoringApiMode.legacy);

      stubProbe(() async => _response(probe, 200, {}));
      expect(await resolver.resolve(dio, 't', 'POPAmphibien'),
          MonitoringApiMode.current);
    });
  });

  group('API d\'écriture en mode current', () {
    late MockDio dio;
    late MockConnectivity connectivity;
    const current = _FixedModeResolver(MonitoringApiMode.current);

    setUp(() {
      dio = MockDio();
      connectivity = MockConnectivity();
      when(() => connectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
    });

    test('sendVisit poste à plat et renvoie id', () async {
      when(() => dio.post(
                any(),
                data: any(named: 'data'),
                options: any(named: 'options'),
              ))
          .thenAnswer((_) async => _response(
              '/monitorings/POPAmphibien/visits', 200, {'id_base_visit': 42}));

      final result = await VisitsApiImpl(
              dio: dio, connectivity: connectivity, modeResolver: current)
          .sendVisit(
        'token',
        'POPAmphibien',
        const BaseVisit(
          idBaseVisit: 0,
          idBaseSite: 4,
          idDataset: 1,
          idModule: 15,
          visitDateMin: '2026-10-08',
          data: {'expertise': 'Débutant'},
        ),
      );

      expect(result['id'], 42);
      final captured = verify(() => dio.post(
            '/monitorings/POPAmphibien/visits',
            data: captureAny(named: 'data'),
            options: any(named: 'options'),
          )).captured.single as Map<String, dynamic>;
      expect(captured.containsKey('properties'), isFalse);
      expect(captured['id_base_site'], 4);
      expect(captured['expertise'], 'Débutant');
    });

    test('updateSite patche à plat avec id_base_site et geom', () async {
      when(() => dio.patch(
                any(),
                data: any(named: 'data'),
                options: any(named: 'options'),
              ))
          .thenAnswer((_) async => _response(
              '/monitorings/POPAmphibien/sites/21', 201, {'id_base_site': 21}));

      final result = await SitesApiImpl(
              dio: dio, connectivity: connectivity, modeResolver: current)
          .updateSite(
        'token',
        'POPAmphibien',
        21,
        BaseSite(
          idBaseSite: 21,
          baseSiteName: 'Site',
          geom: '{"type":"Point","coordinates":[5.75,45.15]}',
          firstUseDate: DateTime(2026, 10, 8),
        ),
      );

      expect(result['id'], 21);
      final captured = verify(() => dio.patch(
            '/monitorings/POPAmphibien/sites/21',
            data: captureAny(named: 'data'),
            options: any(named: 'options'),
          )).captured.single as Map<String, dynamic>;
      expect(captured['id_base_site'], 21);
      expect(captured['first_use_date'], '2026-10-08');
      expect(captured['geom'], {
        'type': 'Point',
        'coordinates': [5.75, 45.15]
      });
    });
  });
}
