import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/bad_credentials_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _redirect({
  required String requestUrl,
  required String location,
  int statusCode = 302,
}) {
  return Response<dynamic>(
    statusCode: statusCode,
    headers: Headers.fromMap({
      'location': [location],
    }),
    requestOptions: RequestOptions(path: requestUrl),
  );
}

Response<dynamic> _ok({required String requestUrl}) {
  return Response<dynamic>(
    statusCode: 200,
    data: {
      'token': 'tok-123',
      'user': {
        'active': true,
        'date_insert': '2024-01-01',
        'date_update': '2024-01-01',
        'groupe': false,
        'id_organisme': 1,
        'id_role': 42,
        'identifiant': 'admin',
        'max_level_profil': 1,
        'nom_complet': 'Admin Admin',
        'nom_role': 'Admin',
        'prenom_role': 'Admin',
      },
    },
    requestOptions: RequestOptions(path: requestUrl),
  );
}

void main() {
  late AuthenticationApiImpl api;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    api = AuthenticationApiImpl(dio: mockDio);
  });

  group('login', () {
    test('renvoie un UserEntity quand le serveur répond 200', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => _ok(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
          ));

      final user = await api.login('admin', 'admin');

      expect(user.token, 'tok-123');
      expect(user.idRole, 42);
    });

    test('décode un body JSON renvoyé en String par certains serveurs',
        () async {
      // Reproduit le cas où Dio reçoit le body en String brute (Content-Type
      // pas tout à fait "application/json") au lieu d'une Map déjà parsée.
      // Avant le fix : `data['user']` plantait avec « 'String' is not a
      // subtype of 'int' of 'index' ».
      const rawJson = '{"token":"tok-456","user":{"active":true,'
          '"date_insert":"2024-01-01","date_update":"2024-01-01",'
          '"groupe":false,"id_organisme":1,"id_role":7,'
          '"identifiant":"admin","max_level_profil":1,'
          '"nom_complet":"Admin","nom_role":"Admin","prenom_role":"Admin"}}';
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            statusCode: 200,
            data: rawJson,
            requestOptions: RequestOptions(
                path: 'https://demo.geonature.fr/geonature/api/auth/login'),
          ));

      final user = await api.login('admin', 'admin');

      expect(user.token, 'tok-456');
      expect(user.idRole, 7);
    });

    test('renvoie un message lisible quand le serveur sert la SPA HTML '
        '(URL mal saisie)', () async {
      // Reproduit le scénario où l'URL ne pointe pas sur l'API : le serveur
      // sert la single-page app GeoNature, qui répond 200 avec du HTML.
      const html = '<!DOCTYPE html><html lang="en"><head>'
          '<title>GeoNature</title></head><body></body></html>';
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            statusCode: 200,
            data: html,
            requestOptions: RequestOptions(
                path: 'https://demo.geonature.fr/api/auth/login'),
          ));

      await expectLater(
        api.login('admin', 'admin'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('ne pointe pas vers une API GeoNature') &&
            !e.toString().contains('<!DOCTYPE'))),
      );
    });

    test('jette BadCredentialsException sur un 401', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            statusCode: 401,
            requestOptions: RequestOptions(
                path: 'https://demo.geonature.fr/geonature/api/auth/login'),
          ));

      expect(api.login('admin', 'bad'), throwsA(isA<BadCredentialsException>()));
    });

    test('traite un 302 vers la SPA #/login comme un échec d\'auth '
        '(comportement GeoNature)', () async {
      // GeoNature renvoie un 302 vers /#/login quand les identifiants sont
      // invalides au lieu d'un 401 propre. Suivre ce redirect tomberait sur
      // la SPA HTML — on doit le traiter comme BadCredentialsException.
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => _redirect(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
            location:
                'https://demo.geonature.fr/geonature/#/login?next=https%3A%2F%2Fdemo.geonature.fr%2Fgeonature%2Fapi%2Fauth%2Flogin',
          ));

      expect(api.login('admin', 'bad'),
          throwsA(isA<BadCredentialsException>()));
    });

    test('en mode dev local (path sans /api/), suit un redirect interne '
        'vers une autre route locale', () async {
      // Localhost : Config n'ajoute pas /api/. Si le serveur dev fait un
      // redirect interne (ex. trailing slash), on doit le suivre — la règle
      // « sortir de /api/ » ne s'applique pas car on n'y était jamais.
      var callIndex = 0;
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async {
        callIndex += 1;
        if (callIndex == 1) {
          return _redirect(
            requestUrl: 'http://localhost:8000/auth/login',
            location: 'http://localhost:8000/auth/login/',
          );
        }
        return _ok(requestUrl: 'http://localhost:8000/auth/login/');
      });

      final user = await api.login('admin', 'admin');
      expect(user.token, 'tok-123');
      expect(callIndex, 2);
    });

    test('traite un 302 hors de /api/ comme un échec d\'auth', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => _redirect(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
            location: 'https://demo.geonature.fr/geonature/login',
          ));

      expect(api.login('admin', 'bad'),
          throwsA(isA<BadCredentialsException>()));
    });

    test('demande à passer en https quand on part en HTTP et que le serveur '
        'redirige vers HTTPS', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => _redirect(
            requestUrl: 'http://demo.geonature.fr/geonature/api/auth/login',
            location: 'https://demo.geonature.fr/geonature/api/auth/login',
          ));

      await expectLater(
        api.login('admin', 'admin'),
        throwsA(predicate(
          (e) => e is Exception && e.toString().contains('https://'),
        )),
      );
    });

    test('suit silencieusement un redirect HTTPS→HTTPS et finit par retourner '
        "l'utilisateur", () async {
      // 1er appel : 302 vers une autre URL HTTPS (ex. trailing slash, route renommée)
      // 2e appel  : 200 OK
      var callIndex = 0;
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async {
        callIndex += 1;
        if (callIndex == 1) {
          return _redirect(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
            location: 'https://demo.geonature.fr/geonature/api/auth/login/',
          );
        }
        return _ok(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login/');
      });

      final user = await api.login('admin', 'admin');

      expect(user.token, 'tok-123');
      expect(callIndex, 2,
          reason: 'le redirect doit être suivi par un second POST');
    });

    test('résout une URL relative dans le Location', () async {
      var callIndex = 0;
      String? secondCallUrl;
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((invocation) async {
        callIndex += 1;
        if (callIndex == 1) {
          return _redirect(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
            location: '/geonature/api/v2/auth/login',
          );
        }
        secondCallUrl = invocation.positionalArguments.first as String;
        return _ok(requestUrl: secondCallUrl!);
      });

      await api.login('admin', 'admin');

      expect(secondCallUrl, 'https://demo.geonature.fr/geonature/api/v2/auth/login');
    });

    test('jette une exception explicite après trop de redirections', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => _redirect(
            requestUrl: 'https://demo.geonature.fr/geonature/api/auth/login',
            location: 'https://demo.geonature.fr/geonature/api/auth/login/',
          ));

      await expectLater(
        api.login('admin', 'admin'),
        throwsA(predicate((e) =>
            e is Exception && e.toString().contains('Trop de redirections'))),
      );
    });

    test('jette une exception explicite si le 3xx ne porte pas de Location',
        () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            statusCode: 302,
            headers: Headers(),
            requestOptions: RequestOptions(
                path: 'https://demo.geonature.fr/geonature/api/auth/login'),
          ));

      await expectLater(
        api.login('admin', 'admin'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('sans en-tête Location'))),
      );
    });
  });
}
