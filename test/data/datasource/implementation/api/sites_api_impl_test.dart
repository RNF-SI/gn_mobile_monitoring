import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late SitesApiImpl sitesApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    sitesApi = SitesApiImpl(dio: mockDio, connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(Options());
  });

  /// Suppress debugPrint output during tests
  Future<T> suppressOutput<T>(Future<T> Function() callback) async {
    return await runZoned(
      callback,
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {},
      ),
    );
  }

  group('sendSite', () {
    test('throws NetworkException when no internet connection', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
      );

      expect(
        () => suppressOutput(
            () => sitesApi.sendSite('token', 'MOD_TEST', site)),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sends POST request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
        firstUseDate: DateTime(2024, 1, 1),
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 100, 'base_site_name': 'Test Site'},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.sendSite('token', 'MOD_TEST', site));

      expect(result['id'], 100);
      verify(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
    });
  });

  group('updateSite', () {
    test('sends PATCH request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Updated Site',
      );

      when(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 1, 'base_site_name': 'Updated Site'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.updateSite('token', 'MOD_TEST', 1, site));

      expect(result['base_site_name'], 'Updated Site');
      verify(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
    });

    test('throws NetworkException on DioException', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test',
      );

      when(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () => suppressOutput(
            () => sitesApi.updateSite('token', 'MOD_TEST', 1, site)),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('sendSiteGroup', () {
    test('throws NetworkException when no internet connection', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final siteGroup = const SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
      );

      expect(
        () => suppressOutput(
            () => sitesApi.sendSiteGroup('token', 'MOD_TEST', siteGroup)),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sends POST request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final siteGroup = const SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 200, 'sites_group_name': 'Test Group'},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.sendSiteGroup('token', 'MOD_TEST', siteGroup));

      expect(result['id'], 200);
    });
  });

  group('fetchEnrichedSitesForModule', () {
    test('handles 204 No Content as valid empty response', () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 204,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      expect(result['enriched_sites'], isEmpty);
      expect(result['site_complements'], isEmpty);
    });

    test('récupère tous les sites en un seul appel /refacto/', () async {
      // Enveloppe {count, items[], limit, page} renvoyée par /refacto/<code>/sites
      // Les items contiennent directement tous les champs (pas de wrapping
      // properties/geometry comme /object/).
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites',
            queryParameters: {'limit': 100000},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 2,
              'limit': 100000,
              'page': 1,
              'items': [
                {
                  'id_base_site': 1,
                  'base_site_name': 'Site 1',
                  'base_site_code': 'S1',
                  'base_site_description': 'Description 1',
                  'altitude_min': 100,
                  'altitude_max': 200,
                  'first_use_date': '2024-01-01',
                  'uuid_base_site': 'uuid-1',
                  'geometry':
                      '{"type": "Point", "coordinates": [1.0, 2.0]}',
                  'id_sites_group': 42,
                },
                {
                  'id_base_site': 2,
                  'base_site_name': 'Site 2',
                  'base_site_code': 'S2',
                  'base_site_description': null,
                  'altitude_min': null,
                  'altitude_max': null,
                  'first_use_date': null,
                  'uuid_base_site': 'uuid-2',
                  'geometry': null,
                  // pas de id_sites_group : site hors groupe
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      final enrichedSites = result['enriched_sites'] as List;
      expect(enrichedSites.length, 2);

      final site1 = enrichedSites
          .cast<Map<String, dynamic>>()
          .firstWhere((s) => s['id_base_site'] == 1);
      expect(site1['base_site_code'], 'S1');
      expect(site1['altitude_min'], 100);
      expect(site1['geometry'], isNotNull);

      final complements = result['site_complements'] as List;
      expect(complements.length, 2);
      final site1Complement = complements.firstWhere(
        (c) => (c as dynamic).idBaseSite == 1,
      ) as dynamic;
      expect(site1Complement.idSitesGroup, 42);
      final site2Complement = complements.firstWhere(
        (c) => (c as dynamic).idBaseSite == 2,
      ) as dynamic;
      expect(site2Complement.idSitesGroup, isNull);
    });

    test(
        'monitoring >= 1.3.2 : lit `geom` (objet) et normalise types_site (ids)',
        () async {
      // Format renvoyé par monitoring develop (GeoNature 2.18) : `geometry`
      // (chaîne) remplacé par `geom` (objet), types_site = liste d'ids.
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites',
            queryParameters: {'limit': 100000},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 2,
              'limit': 100000,
              'page': 1,
              'items': [
                {
                  'id_base_site': 1,
                  'base_site_name': 'Site 1',
                  'uuid_base_site': 'uuid-1',
                  'geom': {
                    'type': 'Point',
                    'coordinates': [-1.15, 46.15],
                  },
                  'types_site': [940],
                  'id_sites_group': 42,
                },
                {
                  // Format monitoring <= 1.3.0 : objets dans types_site
                  'id_base_site': 2,
                  'base_site_name': 'Site 2',
                  'uuid_base_site': 'uuid-2',
                  'geometry': '{"type": "Point", "coordinates": [1.0, 2.0]}',
                  'types_site': [
                    {
                      'config': null,
                      'id_nomenclature_type_site': 941,
                      'label': 'Site POPAmphibien',
                    }
                  ],
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      final sites = (result['enriched_sites'] as List)
          .cast<Map<String, dynamic>>();
      final site1 = sites.firstWhere((s) => s['id_base_site'] == 1);
      expect(site1['geometry'], {
        'type': 'Point',
        'coordinates': [-1.15, 46.15],
      });

      final complements = (result['site_complements'] as List).cast<dynamic>();
      Map<String, dynamic> dataOf(int id) => jsonDecode(
              complements.firstWhere((c) => c.idBaseSite == id).data as String)
          as Map<String, dynamic>;

      final data1 = dataOf(1);
      // La géométrie n'est pas une donnée spécifique du site
      expect(data1.containsKey('geom'), isFalse);
      expect(data1['types_site'], [940]);
      expect(dataOf(2)['types_site'], [941]);
    });
  });

  group('normalizeTypesSite', () {
    test('accepte ids, chaînes et objets', () {
      expect(
        normalizeTypesSite([
          940,
          '941',
          {'id_nomenclature_type_site': 975, 'label': 'Transect'},
          null,
          'abc',
        ]),
        [940, 941, 975],
      );
    });
  });

  group('fetchSiteGroupsForModule', () {
    test('gère 204 No Content comme liste vide', () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites_groups',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 204,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchSiteGroupsForModule('MOD_TEST', 'token'));

      expect(result, isEmpty);
    });

    test('gère 403 comme liste vide (module sans support)', () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites_groups',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        response: Response(
          statusCode: 403,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      ));

      final result = await suppressOutput(
          () => sitesApi.fetchSiteGroupsForModule('MOD_TEST', 'token'));

      expect(result, isEmpty);
    });

    test('un seul call /refacto/ suffit : data reconstitué depuis clés aplaties',
        () async {
      // /refacto/ retourne les attributs spécifiques (habitat_principal,
      // id_inventor) aplatis au top-level. On doit les recoller dans data.
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites_groups',
            queryParameters: {'limit': 100, 'page': 1},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 2,
              'limit': 100,
              'page': 1,
              'items': [
                {
                  'id_sites_group': 29,
                  'sites_group_name': 'frec',
                  'sites_group_code': null,
                  'sites_group_description': null,
                  'uuid_sites_group': '8d3c4dad-c11a-4f0b-8893-3b7447af3dd6',
                  'comments': null,
                  'id_digitiser': null,
                  'altitude_min': null,
                  'altitude_max': null,
                  'geometry': {
                    'type': 'Point',
                    'coordinates': [5.04, 47.33],
                  },
                  // Clés non-standards (spécifiques) → à recoller dans data
                  'habitat_principal': 'Forêt',
                  'id_inventor': null,
                  // Métadonnées backend à ignorer
                  'pk': 'id_sites_group',
                  'cruved': {'R': true},
                  'medias': [],
                  'modules': [12],
                  'nb_sites': 1,
                  'nb_visits': 1,
                  'is_geom_from_child': true,
                  // Refonte : liste des propriétés hors config du module
                  'additional_data_keys': ['habitat_autre_module'],
                },
                {
                  'id_sites_group': 30,
                  'sites_group_name': 'autre',
                  'uuid_sites_group': 'b8e7d5f4-1234-5678-9abc-def012345678',
                  'geometry': null,
                  // Pas d'attributs spécifiques ici
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchSiteGroupsForModule('MOD_TEST', 'token'));

      expect(result.length, 2);

      final group1 = result[0].siteGroup;
      expect(group1.idSitesGroup, 29);
      expect(group1.sitesGroupName, 'frec');
      expect(group1.data, isNotNull);
      expect(group1.data!['habitat_principal'], 'Forêt');
      expect(group1.data!.containsKey('id_inventor'), isTrue);
      // Les clés standards ne doivent PAS fuiter dans data
      expect(group1.data!.containsKey('sites_group_name'), isFalse);
      expect(group1.data!.containsKey('id_sites_group'), isFalse);
      expect(group1.data!.containsKey('additional_data_keys'), isFalse);

      final group2 = result[1].siteGroup;
      expect(group2.idSitesGroup, 30);
      // Pas d'attributs spécifiques → data est un Map vide
      expect(group2.data, isNotNull);
      expect(group2.data, isEmpty);
    });

    test('monitoring >= 1.3.2 : lit `geom` (objet) au lieu de `geometry`',
        () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites_groups',
            queryParameters: {'limit': 100, 'page': 1},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 1,
              'limit': 100,
              'page': 1,
              'items': [
                {
                  'id_sites_group': 29,
                  'sites_group_name': 'frec',
                  'uuid_sites_group': '8d3c4dad-c11a-4f0b-8893-3b7447af3dd6',
                  'geom': {
                    'type': 'Point',
                    'coordinates': [5.04, 47.33],
                  },
                  'habitat_principal': 'Forêt',
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchSiteGroupsForModule('MOD_TEST', 'token'));

      final group = result.single.siteGroup;
      expect(group.geom, isNotNull);
      expect(jsonDecode(group.geom!)['coordinates'], [5.04, 47.33]);
      expect(group.data!.containsKey('geom'), isFalse);
      expect(group.data!['habitat_principal'], 'Forêt');
    });

    test('paginate si count > pageSize', () async {
      // Page 1 : 100 items, Page 2 : 50 items. Total attendu : 150.
      final page1Items = List.generate(
          100,
          (i) => {
                'id_sites_group': i + 1,
                'sites_group_name': 'G${i + 1}',
              });
      final page2Items = List.generate(
          50,
          (i) => {
                'id_sites_group': 101 + i,
                'sites_group_name': 'G${101 + i}',
              });

      when(() => mockDio.get(
            '/monitorings/refacto/BIG_MOD/sites_groups',
            queryParameters: {'limit': 100, 'page': 1},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 150,
              'limit': 100,
              'page': 1,
              'items': page1Items,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));
      when(() => mockDio.get(
            '/monitorings/refacto/BIG_MOD/sites_groups',
            queryParameters: {'limit': 100, 'page': 2},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 150,
              'limit': 100,
              'page': 2,
              'items': page2Items,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchSiteGroupsForModule('BIG_MOD', 'token'));

      expect(result.length, 150);
      expect(result.first.siteGroup.idSitesGroup, 1);
      expect(result.last.siteGroup.idSitesGroup, 150);
    });

    test('throws NetworkException sur erreur réseau non-403', () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites_groups',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () => suppressOutput(
            () => sitesApi.fetchSiteGroupsForModule('MOD_TEST', 'token')),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
