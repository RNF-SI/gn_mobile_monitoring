import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/json_parser_helper.dart';

void main() {
  group('JsonParserHelper - Array parsing', () {
    test('should parse JSON with array of integers', () {
      final json = '{"methode_de_prospection": [1034, 1035, 1036]}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['methode_de_prospection'], isA<List>());
      expect(result['methode_de_prospection'], equals([1034, 1035, 1036]));
    });

    test('should parse JSON with array of integers as string', () {
      final json = '{"methode_de_prospection": "[1034, 1035, 1036]"}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['methode_de_prospection'], isA<List>());
      expect(result['methode_de_prospection'], equals([1034, 1035, 1036]));
    });

    test('should parse JSON with array of strings', () {
      final json = '{"values": ["a", "b", "c"]}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['values'], isA<List>());
      expect(result['values'], equals(['a', 'b', 'c']));
    });

    test('should parse JSON with empty array', () {
      final json = '{"values": []}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['values'], isA<List>());
      expect(result['values'], isEmpty);
    });

    test('should parse JSON with mixed types in array', () {
      final json = '{"values": [1, "text", 2.5]}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['values'], isA<List>());
      expect(result['values'].length, equals(3));
      expect(result['values'][0], equals(1));
      expect(result['values'][1], equals('text'));
      expect(result['values'][2], equals(2.5));
    });

    test('should parse complex JSON with multiple arrays', () {
      final json = '''
      {
        "expertise": "Assez expérimenté",
        "num_passage": 1,
        "methode_de_prospection": [1034, 1035, 1036],
        "observers": [1, 2, 3]
      }
      ''';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['expertise'], equals('Assez expérimenté'));
      expect(result['num_passage'], equals(1));
      expect(result['methode_de_prospection'], isA<List>());
      expect(result['methode_de_prospection'], equals([1034, 1035, 1036]));
      expect(result['observers'], isA<List>());
      expect(result['observers'], equals([1, 2, 3]));
    });

    test('should handle array string in Python-style dict', () {
      // Format hybride qui pourrait exister
      final json = '{methode_de_prospection: [1034, 1035, 1036], accessibility: Oui}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      // Le parsing Python-style devrait aussi gérer les arrays
      expect(result!['methode_de_prospection'], isA<List>());
      expect(result['methode_de_prospection'], equals([1034, 1035, 1036]));
      expect(result['accessibility'], equals('Oui'));
    });

    test('should NOT truncate arrays at commas in Python-style dict', () {
      // BUG FIX: Ce test vérifie que les tableaux ne sont pas coupés à la première virgule
      // Format Python-style sans guillemets (comme stocké en DB)
      final json = '{expertise: Assez expérimenté, num_passage: 1, etat_site: Site existant, accessibility: Oui, methode_de_prospection: [1034, 1035, 1036], Heure_debut: 15:22, Heure_fin: 15:22}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['expertise'], equals('Assez expérimenté'));
      expect(result['num_passage'], equals(1));
      expect(result['etat_site'], equals('Site existant'));
      expect(result['accessibility'], equals('Oui'));

      // CRITIQUE: Vérifier que le tableau n'est PAS tronqué à "[1034"
      expect(result['methode_de_prospection'], isA<List>(),
          reason: 'methode_de_prospection devrait être une List, pas une String tronquée');
      expect(result['methode_de_prospection'], equals([1034, 1035, 1036]),
          reason: 'Le tableau ne doit pas être coupé à la première virgule');

      expect(result['Heure_debut'], equals('15:22'));
      expect(result['Heure_fin'], equals('15:22'));
    });

    test('should parse single integer as list when needed', () {
      final json = '{"methode_de_prospection": 657}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['methode_de_prospection'], equals(657));
      // Note: La conversion int -> [int] se fait dans DynamicFormBuilder,
      // pas dans JsonParserHelper
    });

    test('should handle values with commas inside parentheses', () {
      // BUG FIX: Vérifier que les virgules dans les parenthèses ne cassent pas le parsing
      // Cas réel: "Site restauré (travaux, assainissement de l'eau, etc.)"
      final json = '{expertise: Débutant, num_passage: 1, etat_site: Site restauré (travaux, assainissement de l\'eau, etc.), accessibility: Oui, methode_de_prospection: [657], Heure_debut: 16:40, Heure_fin: 16:40}';
      final result = JsonParserHelper.parseRobust(json);

      expect(result, isNotNull);
      expect(result!['expertise'], equals('Débutant'));
      expect(result['num_passage'], equals(1));

      // CRITIQUE: La valeur complète avec parenthèses et virgules doit être préservée
      expect(result['etat_site'], equals('Site restauré (travaux, assainissement de l\'eau, etc.)'),
          reason: 'Les virgules dans les parenthèses ne doivent pas couper la valeur');

      expect(result['accessibility'], equals('Oui'));
      expect(result['methode_de_prospection'], isA<List>());
      expect(result['methode_de_prospection'], equals([657]));
      expect(result['Heure_debut'], equals('16:40'));
      expect(result['Heure_fin'], equals('16:40'));
    });
  });
}
