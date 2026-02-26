import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/taxon_api_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late TaxonApiImpl taxonApi;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    taxonApi = TaxonApiImpl(dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(Options());
  });

  group('fetchTaxonPage', () {
    test('parses response correctly on success', () async {
      final responseData = [
        {
          'cd_nom': 12345,
          'cd_ref': 12345,
          'lb_nom': 'Parus major',
          'search_name': 'Mésange charbonnière',
          'nom_vern': 'Mésange charbonnière',
          'nom_valide': 'Parus major',
          'regne': 'Animalia',
          'group2_inpn': 'Oiseaux',
          'group3_inpn': null,
        },
        {
          'cd_nom': 67890,
          'cd_ref': 67890,
          'lb_nom': 'Parus caeruleus',
          'search_name': 'Mésange bleue',
          'nom_vern': 'Mésange bleue',
          'nom_valide': 'Cyanistes caeruleus',
          'regne': 'Animalia',
          'group2_inpn': 'Oiseaux',
          'group3_inpn': null,
        },
      ];

      when(() => mockDio.get(
            '/taxhub/api/taxref/allnamebylist/1',
            queryParameters: {'limit': 5000, 'page': 1},
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/taxhub/api/taxref/allnamebylist/1'),
          ));

      final result = await taxonApi.fetchTaxonPage(1, page: 1);

      expect(result, hasLength(2));
      expect(result[0].cdNom, 12345);
      expect(result[0].nomComplet, 'Mésange charbonnière');
      expect(result[0].lbNom, 'Parus major');
      expect(result[1].cdNom, 67890);
    });

    test('throws NetworkException on DioException', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/test'),
          ));

      expect(
        () => taxonApi.fetchTaxonPage(1, page: 1),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws ApiException on non-200 status', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: '/test'),
          ));

      expect(
        () => taxonApi.fetchTaxonPage(1, page: 1),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('getTaxonsByList', () {
    test('fetches single page when results < limit', () async {
      final taxonData = List.generate(
        10,
        (i) => {
          'cd_nom': i + 1,
          'cd_ref': i + 1,
          'lb_nom': 'Taxon $i',
          'search_name': 'Taxon $i',
          'nom_vern': null,
          'nom_valide': 'Taxon $i',
          'regne': 'Animalia',
          'group2_inpn': null,
          'group3_inpn': null,
        },
      );

      when(() => mockDio.get(
            '/taxhub/api/taxref/allnamebylist/1',
            queryParameters: {'limit': 5000, 'page': 1},
          )).thenAnswer((_) async => Response(
            data: taxonData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await taxonApi.getTaxonsByList(1);

      expect(result, hasLength(10));
      // Only 1 page since 10 < 5000
      verify(() => mockDio.get(
            '/taxhub/api/taxref/allnamebylist/1',
            queryParameters: {'limit': 5000, 'page': 1},
          )).called(1);
    });
  });

  group('getTaxonList', () {
    test('parses response correctly', () async {
      when(() => mockDio.get('/monitorings/util/taxonomy_list/42'))
          .thenAnswer((_) async => Response(
                data: {
                  'id_liste': 42,
                  'code_liste': 'OISEAUX',
                  'nom_liste': 'Liste des oiseaux',
                  'desc_liste': 'Description',
                  'regne': 'Animalia',
                  'group2_inpn': 'Oiseaux',
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/test'),
              ));

      final result = await taxonApi.getTaxonList(42);

      expect(result.idListe, 42);
      expect(result.codeListe, 'OISEAUX');
      expect(result.nomListe, 'Liste des oiseaux');
      expect(result.regne, 'Animalia');
    });

    test('throws NetworkException on DioException', () async {
      when(() => mockDio.get(any())).thenThrow(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () => taxonApi.getTaxonList(42),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getTaxonByCdNom', () {
    test('parses full taxon response', () async {
      when(() => mockDio.get('/taxonomie/taxref/12345'))
          .thenAnswer((_) async => Response(
                data: {
                  'cd_nom': 12345,
                  'cd_ref': 12345,
                  'id_statut': 'P',
                  'id_habitat': 1,
                  'id_rang': 'ES',
                  'regne': 'Animalia',
                  'phylum': 'Chordata',
                  'classe': 'Aves',
                  'ordre': 'Passeriformes',
                  'famille': 'Paridae',
                  'sous_famille': null,
                  'tribu': null,
                  'cd_taxsup': 100,
                  'cd_sup': 99,
                  'lb_nom': 'Parus major',
                  'lb_auteur': 'Linnaeus, 1758',
                  'nom_complet': 'Parus major Linnaeus, 1758',
                  'nom_complet_html': '<i>Parus major</i>',
                  'nom_vern': 'Mésange charbonnière',
                  'nom_valide': 'Parus major',
                  'nom_vern_eng': 'Great Tit',
                  'group1_inpn': 'Vertébrés',
                  'group2_inpn': 'Oiseaux',
                  'group3_inpn': null,
                  'url': 'https://inpn.mnhn.fr/espece/cd_nom/12345',
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/test'),
              ));

      final result = await taxonApi.getTaxonByCdNom(12345);

      expect(result.cdNom, 12345);
      expect(result.lbNom, 'Parus major');
      expect(result.famille, 'Paridae');
      expect(result.nomVern, 'Mésange charbonnière');
      expect(result.lbAuteur, 'Linnaeus, 1758');
    });
  });

  group('searchTaxons', () {
    test('sends correct parameters and parses response', () async {
      when(() => mockDio.get(
            '/taxonomie/taxref/search',
            queryParameters: {'search': 'mésange', 'limit': 50},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: [
              {
                'cd_nom': 12345,
                'cd_ref': 12345,
                'lb_nom': 'Parus major',
                'nom_complet': 'Parus major',
                'nom_vern': 'Mésange charbonnière',
                'nom_valide': 'Parus major',
                'regne': 'Animalia',
                'group2_inpn': 'Oiseaux',
              },
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await taxonApi.searchTaxons('token', 'mésange');

      expect(result, hasLength(1));
      expect(result[0].cdNom, 12345);
    });

    test('includes id_liste when provided', () async {
      when(() => mockDio.get(
            '/taxonomie/taxref/search',
            queryParameters: {
              'search': 'parus',
              'limit': 50,
              'id_liste': '42',
            },
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result =
          await taxonApi.searchTaxons('token', 'parus', idListe: 42);

      expect(result, isEmpty);
    });

    test('throws ApiException on non-200 status', () async {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 403,
            requestOptions: RequestOptions(path: '/test'),
          ));

      expect(
        () => taxonApi.searchTaxons('token', 'test'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
