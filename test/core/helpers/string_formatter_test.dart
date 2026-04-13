import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';

void main() {
  group('StringFormatterExtension', () {
    group('capitalize()', () {
      test('should capitalize first letter of lowercase string', () {
        const input = 'hello world';
        const expected = 'Hello world';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should keep already capitalized string unchanged', () {
        const input = 'Hello World';
        const expected = 'Hello World';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle single character strings', () {
        const input = 'a';
        const expected = 'A';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle empty string', () {
        const input = '';
        const expected = '';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle strings starting with numbers', () {
        const input = '123abc';
        const expected = '123abc';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle strings starting with special characters', () {
        const input = '@hello';
        const expected = '@hello';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle strings with only whitespace', () {
        const input = '   ';
        const expected = '   ';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle strings starting with whitespace', () {
        const input = ' hello';
        const expected = ' hello';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle mixed case strings', () {
        const input = 'hELLO wORLD';
        const expected = 'HELLO wORLD';
        
        expect(input.capitalize(), equals(expected));
      });

      test('should handle strings with accented characters', () {
        const input = 'été';
        const expected = 'Été';
        
        expect(input.capitalize(), equals(expected));
      });
    });
  });
}