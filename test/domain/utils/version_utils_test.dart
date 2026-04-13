import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/utils/version_utils.dart';

void main() {
  group('MonitoringVersion.tryParse', () {
    test('parse version standard "1.2.0"', () {
      final v = MonitoringVersion.tryParse('1.2.0');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 0);
      expect(v.preRelease, isNull);
    });

    test('parse version avec pre-release "1.2.0rc1"', () {
      final v = MonitoringVersion.tryParse('1.2.0rc1');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 0);
      expect(v.preRelease, 'rc1');
    });

    test('parse version avec pre-release "2.0.0-beta.1"', () {
      final v = MonitoringVersion.tryParse('2.0.0-beta.1');
      expect(v, isNotNull);
      expect(v!.major, 2);
      expect(v.minor, 0);
      expect(v.patch, 0);
      expect(v.preRelease, '-beta.1');
    });

    test('parse version courte "1.2"', () {
      final v = MonitoringVersion.tryParse('1.2');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 0);
    });

    test('parse version minimale "1"', () {
      final v = MonitoringVersion.tryParse('1');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 0);
      expect(v.patch, 0);
    });

    test('retourne null pour chaîne vide', () {
      expect(MonitoringVersion.tryParse(''), isNull);
    });

    test('retourne null pour null', () {
      expect(MonitoringVersion.tryParse(null), isNull);
    });

    test('retourne null pour chaîne invalide', () {
      expect(MonitoringVersion.tryParse('abc'), isNull);
    });

    test('gère les espaces', () {
      final v = MonitoringVersion.tryParse('  1.2.0  ');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 0);
    });

    test('parse version "1.2.0dev"', () {
      final v = MonitoringVersion.tryParse('1.2.0dev');
      expect(v, isNotNull);
      expect(v!.preRelease, 'dev');
    });
  });

  group('MonitoringVersion comparaison', () {
    test('1.2.0 > 1.1.0', () {
      final v120 = MonitoringVersion(1, 2, 0);
      final v110 = MonitoringVersion(1, 1, 0);
      expect(v120 > v110, isTrue);
      expect(v110 < v120, isTrue);
    });

    test('2.0.0 > 1.9.9', () {
      final v200 = MonitoringVersion(2, 0, 0);
      final v199 = MonitoringVersion(1, 9, 9);
      expect(v200 > v199, isTrue);
    });

    test('1.2.0 == 1.2.0', () {
      final v1 = MonitoringVersion(1, 2, 0);
      final v2 = MonitoringVersion(1, 2, 0);
      expect(v1 == v2, isTrue);
      expect(v1.compareTo(v2), 0);
    });

    test('1.2.0rc1 < 1.2.0 (pre-release inférieure à release)', () {
      final rc = MonitoringVersion(1, 2, 0, preRelease: 'rc1');
      final release = MonitoringVersion(1, 2, 0);
      expect(rc < release, isTrue);
    });

    test('1.2.0 >= 1.2.0', () {
      final v1 = MonitoringVersion(1, 2, 0);
      final v2 = MonitoringVersion(1, 2, 0);
      expect(v1 >= v2, isTrue);
    });

    test('1.1.0 < 1.2.0', () {
      final v110 = MonitoringVersion(1, 1, 0);
      final v120 = MonitoringVersion(1, 2, 0);
      expect(v110 < v120, isTrue);
      expect(v110 >= v120, isFalse);
    });

    test('1.2.1 > 1.2.0', () {
      final v121 = MonitoringVersion(1, 2, 1);
      final v120 = MonitoringVersion(1, 2, 0);
      expect(v121 > v120, isTrue);
    });
  });

  group('MonitoringVersion.toString', () {
    test('affiche "1.2.0"', () {
      expect(MonitoringVersion(1, 2, 0).toString(), '1.2.0');
    });

    test('affiche "1.2.0rc1" avec pre-release', () {
      expect(MonitoringVersion(1, 2, 0, preRelease: 'rc1').toString(),
          '1.2.0rc1');
    });
  });

  group('MonitoringVersion hashCode et equality', () {
    test('deux versions identiques ont le même hashCode', () {
      final v1 = MonitoringVersion(1, 2, 0);
      final v2 = MonitoringVersion(1, 2, 0);
      expect(v1.hashCode, v2.hashCode);
    });

    test('versions différentes ont des hashCodes différents', () {
      final v1 = MonitoringVersion(1, 2, 0);
      final v2 = MonitoringVersion(1, 3, 0);
      expect(v1.hashCode, isNot(v2.hashCode));
    });
  });

  group('VersionRequirements', () {
    test('minimumMonitoring est 1.2.0', () {
      expect(VersionRequirements.minimumMonitoring.major, 1);
      expect(VersionRequirements.minimumMonitoring.minor, 2);
      expect(VersionRequirements.minimumMonitoring.patch, 0);
    });

    test('1.1.0 est inférieur au minimum', () {
      final v110 = MonitoringVersion(1, 1, 0);
      expect(v110 < VersionRequirements.minimumMonitoring, isTrue);
    });

    test('1.2.0 satisfait le minimum', () {
      final v120 = MonitoringVersion(1, 2, 0);
      expect(v120 >= VersionRequirements.minimumMonitoring, isTrue);
    });

    test('1.3.0 satisfait le minimum', () {
      final v130 = MonitoringVersion(1, 3, 0);
      expect(v130 >= VersionRequirements.minimumMonitoring, isTrue);
    });
  });
}
