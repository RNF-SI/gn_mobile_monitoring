import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';

void main() {
  group('StringFormatterExtension', () {
    group('capitalize', () {
      test('should capitalize first letter of lowercase string', () {
        const input = 'hello world';
        final result = input.capitalize();
        
        expect(result, 'Hello world');
      });

      test('should capitalize first letter of uppercase string', () {
        const input = 'HELLO WORLD';
        final result = input.capitalize();
        
        expect(result, 'HELLO WORLD');
      });

      test('should handle single character string', () {
        const input = 'a';
        final result = input.capitalize();
        
        expect(result, 'A');
      });

      test('should handle single uppercase character', () {
        const input = 'A';
        final result = input.capitalize();
        
        expect(result, 'A');
      });

      test('should handle empty string', () {
        const input = '';
        final result = input.capitalize();
        
        expect(result, '');
      });

      test('should handle string with numbers', () {
        const input = '123abc';
        final result = input.capitalize();
        
        expect(result, '123abc');
      });

      test('should handle string starting with special character', () {
        const input = '@hello';
        final result = input.capitalize();
        
        expect(result, '@hello');
      });

      test('should handle mixed case string', () {
        const input = 'hELLo WoRLd';
        final result = input.capitalize();
        
        expect(result, 'HELLo WoRLd');
      });

      test('should handle string with leading whitespace', () {
        const input = ' hello world';
        final result = input.capitalize();
        
        expect(result, ' hello world');
      });

      test('should handle French characters', () {
        const input = 'être humain';
        final result = input.capitalize();
        
        expect(result, 'Être humain');
      });

      test('should handle accented characters', () {
        const input = 'école française';
        final result = input.capitalize();
        
        expect(result, 'École française');
      });

      test('should handle Unicode characters', () {
        const input = 'ñoño español';
        final result = input.capitalize();
        
        expect(result, 'Ñoño español');
      });
    });
  });
}