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
        expect(ValueFormatter.format([1, 2, 3]), equals('Liste (3 éléments)'));
        expect(ValueFormatter.format([]), equals('Liste (0 éléments)'));
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
      test('should capitalize words and replace underscores with spaces', () {
        expect(ValueFormatter.formatLabel('id_nomenclature_type'), equals('Id Nomenclature Type'));
        expect(ValueFormatter.formatLabel('test_label'), equals('Test Label'));
        expect(ValueFormatter.formatLabel('single'), equals('Single'));
      });

      test('should handle empty strings and edge cases', () {
        expect(ValueFormatter.formatLabel(''), equals(''));
        expect(ValueFormatter.formatLabel('_'), equals(' '));
        expect(ValueFormatter.formatLabel('__'), equals('  '));
      });
    });
  });
}