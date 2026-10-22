import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/network/trusted_roots.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('les racines embarquées sont des PEM valides et déclarés en asset', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- assets/certs/'));
    for (final path in kBundledRootCertificates) {
      final bytes = File(path).readAsBytesSync();
      // Lève une TlsException si le fichier n'est pas un certificat valide.
      SecurityContext(withTrustedRoots: false)
          .setTrustedCertificatesBytes(bytes);
    }
  });

  test("l'installation ne lève pas d'erreur, même appelée deux fois", () async {
    await installBundledRootCertificates();
    await installBundledRootCertificates();
  });
}
