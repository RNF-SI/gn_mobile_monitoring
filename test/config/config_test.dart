import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';

void main() {
  group('normalizeUserInputUrl', () {
    test('ajoute https:// par défaut', () {
      expect(
        Config.normalizeUserInputUrl('geonature.reserves-naturelles.org'),
        'https://geonature.reserves-naturelles.org',
      );
    });

    test('respecte un schéma http:// déjà présent', () {
      expect(
        Config.normalizeUserInputUrl('http://127.0.0.1:8001'),
        'http://127.0.0.1:8001',
      );
    });

    test('retire le slash final', () {
      expect(
        Config.normalizeUserInputUrl('https://geonature.lpo-aura.org/'),
        'https://geonature.lpo-aura.org',
      );
    });

    test('retire le suffixe /api', () {
      expect(
        Config.normalizeUserInputUrl('https://demo.geonature.fr/geonature/api'),
        'https://demo.geonature.fr/geonature',
      );
    });

    test('retire le fragment SPA `#/` collé en fin (URL copiée du navigateur)',
        () {
      expect(
        Config.normalizeUserInputUrl(
            'https://geonature.reserves-naturelles.org/#/'),
        'https://geonature.reserves-naturelles.org',
      );
    });

    test('retire un fragment SPA plus complexe (#/login, #/home, …)', () {
      expect(
        Config.normalizeUserInputUrl(
            'https://geonature-test.reservenaturelle.fr/#/login'),
        'https://geonature-test.reservenaturelle.fr',
      );
      expect(
        Config.normalizeUserInputUrl(
            'https://demo.geonature.fr/geonature/#/home'),
        'https://demo.geonature.fr/geonature',
      );
    });

    test('retire la query string', () {
      expect(
        Config.normalizeUserInputUrl(
            'https://geonature.lpo-aura.org/?next=foo'),
        'https://geonature.lpo-aura.org',
      );
    });

    test('garde un sous-chemin GeoNature (ex. demo)', () {
      expect(
        Config.normalizeUserInputUrl('https://demo.geonature.fr/geonature'),
        'https://demo.geonature.fr/geonature',
      );
    });

    test("renvoie la chaîne vide pour une saisie vide", () {
      expect(Config.normalizeUserInputUrl(''), '');
      expect(Config.normalizeUserInputUrl('   '), '');
    });
  });

  group('apiBase', () {
    tearDown(Config.clearStoredApiUrl);

    test('ajoute /api en mode production', () {
      Config.setStoredApiUrl('https://geonature.reserves-naturelles.org/');
      expect(Config.apiBase, 'https://geonature.reserves-naturelles.org/api');
    });

    test('ajoute /api après un sous-chemin GeoNature', () {
      Config.setStoredApiUrl('https://demo.geonature.fr/geonature');
      expect(Config.apiBase, 'https://demo.geonature.fr/geonature/api');
    });

    test("ne rajoute pas /api en mode dev local (127.0.0.1:8001)", () {
      Config.setStoredApiUrl('http://127.0.0.1:8001');
      expect(Config.apiBase, 'http://127.0.0.1:8001');
    });

    test("ne rajoute pas /api en mode dev local (localhost)", () {
      Config.setStoredApiUrl('http://localhost:8000');
      expect(Config.apiBase, 'http://localhost:8000');
    });

    test('produit la bonne URL d\'API même quand l\'utilisateur copie '
        "l'URL avec /#/ depuis le navigateur", () {
      Config.setStoredApiUrl('https://geonature-test.reservenaturelle.fr/#/');
      expect(Config.apiBase, 'https://geonature-test.reservenaturelle.fr/api');
    });
  });
}
