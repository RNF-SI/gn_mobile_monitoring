import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';

void main() {
  group('ValueFormatter', () {
    group('format', () {
      test('should return "Non renseigné" for null value', () {
        expect(ValueFormatter.format(null), equals('Non renseigné'));
      });

      test('should return string representation for basic types', () {
        expect(ValueFormatter.format(42), equals('42'));
        expect(ValueFormatter.format(3.14), equals('3.14'));
        expect(ValueFormatter.format(true), equals('true'));
        expect(ValueFormatter.format('hello'), equals('hello'));
      });

      test('should format list values', () {
        expect(ValueFormatter.format([1, 2, 3]), equals('3 nomenclatures sélectionnées (IDs: 1, 2, 3)'));
        expect(ValueFormatter.format([]), equals('Non renseigné'));
      });

      test('reformatte une chaîne ISO date en jj/MM/aaaa', () {
        expect(ValueFormatter.format('2026-04-24'), equals('24/04/2026'));
        // Date-heure ISO : on garde uniquement la date côté UI, comme
        // `formatDateString` dans le reste de l'app.
        expect(ValueFormatter.format('2026-04-24T18:30:00.000Z'),
            equals('24/04/2026'));
      });

      test('laisse intactes les chaînes qui ne sont pas une date ISO', () {
        expect(ValueFormatter.format('hello'), equals('hello'));
        expect(ValueFormatter.format('not-a-date'), equals('not-a-date'));
        expect(ValueFormatter.format('24/04/2026'), equals('24/04/2026'));
      });

      test('should call formatNomenclature for Map values', () {
        final map = {'label': 'Test Label'};
        expect(ValueFormatter.format(map), equals('Test Label'));
      });
    });

    group('formatNomenclature', () {
      test('should return label when available', () {
        final nomenclature = {
          'id': 42,
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '7',
          'label': 'Test Nomenclature'
        };
        expect(ValueFormatter.formatNomenclature(nomenclature), equals('Test Nomenclature'));
      });

      test('should return cd_nomenclature when label not available', () {
        final nomenclature = {
          'id': 42,
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '7'
        };
        expect(ValueFormatter.formatNomenclature(nomenclature), equals('7'));
      });

      test('should return id-based fallback when only id available', () {
        final nomenclature = {
          'id': 42,
          'code_nomenclature_type': 'TEST'
        };
        expect(ValueFormatter.formatNomenclature(nomenclature), equals('Nomenclature 42'));
      });

      test('should return "Objet complexe" for non-nomenclature maps', () {
        final complexObject = {
          'foo': 'bar',
          'baz': 42
        };
        expect(ValueFormatter.formatNomenclature(complexObject), equals('Objet complexe'));
      });
    });

    group('formatLabel', () {
      test('applique une casse phrase (1re lettre seule en majuscule)', () {
        expect(ValueFormatter.formatLabel('id_nomenclature_type'),
            equals('Id nomenclature type'));
        expect(ValueFormatter.formatLabel('test_label'), equals('Test label'));
        expect(ValueFormatter.formatLabel('single'), equals('Single'));
      });

      test(
          'préserve les articles français en bas de casse (évite "Nombre D\'observations")',
          () {
        // Cas concret remonté par Gil : un fallback ne doit plus capitaliser
        // "d", "de", "du" comme s\'ils étaient des mots autonomes.
        expect(ValueFormatter.formatLabel('nombre_d_observations'),
            equals('Nombre d observations'));
        expect(ValueFormatter.formatLabel('date_de_releve_du_piege'),
            equals('Date de releve du piege'));
      });

      test('gère chaînes vides et cas limites', () {
        expect(ValueFormatter.formatLabel(''), equals(''));
        expect(ValueFormatter.formatLabel('_'), equals(' '));
        expect(ValueFormatter.formatLabel('__'), equals('  '));
      });
    });
  });
}