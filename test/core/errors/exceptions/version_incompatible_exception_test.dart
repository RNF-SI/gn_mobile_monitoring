import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/version_incompatible_exception.dart';
import 'package:gn_mobile_monitoring/domain/utils/version_utils.dart';

void main() {
  group('VersionIncompatibleException', () {
    const requiredVersion = MonitoringVersion(1, 2, 0);
    const serverUrl = 'https://geonature.example.fr';

    test('toString avec version détectée affiche les détails', () {
      final exception = VersionIncompatibleException(
        detectedVersion: '1.1.0',
        requiredVersion: requiredVersion,
        serverUrl: serverUrl,
      );

      final message = exception.toString();
      expect(message, contains('1.1.0'));
      expect(message, contains('1.2.0'));
      expect(message, contains(serverUrl));
      expect(message, contains('mettre à jour'));
    });

    test('toString sans version détectée affiche un message générique', () {
      final exception = VersionIncompatibleException(
        detectedVersion: null,
        requiredVersion: requiredVersion,
        serverUrl: serverUrl,
      );

      final message = exception.toString();
      expect(message, contains('Impossible de déterminer'));
      expect(message, contains('1.2.0'));
      expect(message, contains(serverUrl));
    });

    test('stocke correctement les propriétés', () {
      final exception = VersionIncompatibleException(
        detectedVersion: '1.0.0',
        requiredVersion: requiredVersion,
        serverUrl: serverUrl,
      );

      expect(exception.detectedVersion, '1.0.0');
      expect(exception.requiredVersion, requiredVersion);
      expect(exception.serverUrl, serverUrl);
    });
  });
}
