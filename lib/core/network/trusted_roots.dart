import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';

/// Racines Let's Encrypt embarquées dans l'app (issue #200).
///
/// Les anciens Android (< 7.1.1) n'ont pas ISRG Root X1 dans leur magasin de
/// certificats système. Depuis que Let's Encrypt délivre des chaînes sans
/// cross-signature DST Root CA X3 (ex. chaîne « Generation Y » YE1 → Root YE →
/// ISRG Root X2 → ISRG Root X1), la poignée de main TLS échoue sur ces
/// appareils avec `CERTIFICATE_VERIFY_FAILED: unable to get local issuer
/// certificate`.
const List<String> kBundledRootCertificates = [
  'assets/certs/isrgrootx1.pem',
  'assets/certs/isrg-root-x2.pem',
];

/// Ajoute les racines embarquées au [SecurityContext.defaultContext], utilisé
/// par tous les `HttpClient` (donc Dio) créés sans contexte explicite.
///
/// Les racines système restent actives : on complète le magasin, on ne le
/// remplace pas. À appeler une fois au démarrage, avant toute requête réseau.
Future<void> installBundledRootCertificates({AssetBundle? bundle}) async {
  final assets = bundle ?? rootBundle;
  for (final path in kBundledRootCertificates) {
    try {
      final data = await assets.load(path);
      SecurityContext.defaultContext
          .setTrustedCertificatesBytes(data.buffer.asUint8List());
    } on TlsException catch (e) {
      // Certificat déjà présent dans le magasin système : rien à faire.
      if (!e.toString().contains('CERT_ALREADY_IN_HASH_TABLE')) {
        AppLogger().w('Racine $path non chargée : $e', tag: 'TLS');
      }
    } catch (e) {
      AppLogger().w('Racine $path non chargée : $e', tag: 'TLS');
    }
  }
}
