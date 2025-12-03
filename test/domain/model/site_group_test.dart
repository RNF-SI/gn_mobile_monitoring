import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

void main() {
  group('SiteGroup with CRUVED permissions', () {
    test('should create SiteGroup with CRUVED permissions', () {
      final siteGroup = SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
        sitesGroupCode: 'TG001',
        cruved: const CruvedResponse(
          create: true,
          read: true,
          update: false,
          delete: false,
          validate: true,
          export: true,
        ),
      );

      expect(siteGroup.idSitesGroup, equals(1));
      expect(siteGroup.sitesGroupName, equals('Test Group'));
      expect(siteGroup.cruved, isNotNull);
      expect(siteGroup.cruved!.create, isTrue);
      expect(siteGroup.cruved!.read, isTrue);
      expect(siteGroup.cruved!.update, isFalse);
      expect(siteGroup.cruved!.delete, isFalse);
    });

    test('should use MonitoringObjectMixin methods', () {
      final siteGroup = SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
        cruved: const CruvedResponse(
          create: true,
          read: true,
          update: true,
          delete: false,
          validate: true,
          export: true,
        ),
      );

      expect(siteGroup.canCreate(), isTrue);
      expect(siteGroup.canRead(), isTrue);
      expect(siteGroup.canUpdate(), isTrue);
      expect(siteGroup.canDelete(), isFalse);
      expect(siteGroup.canValidate(), isTrue);
      expect(siteGroup.canExport(), isTrue);
    });

    test('should handle null cruved permissions', () {
      const siteGroup = SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
        cruved: null,
      );

      expect(siteGroup.cruved, isNull);
      expect(siteGroup.canCreate(), isFalse);
      expect(siteGroup.canRead(), isFalse);
      expect(siteGroup.canUpdate(), isFalse);
      expect(siteGroup.canDelete(), isFalse);
    });

    test('should return correct permissions summary', () {
      final siteGroup = SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
        cruved: const CruvedResponse(
          create: true,
          read: true,
          update: true,
          delete: false,
          validate: false,
          export: true,
        ),
      );

      expect(siteGroup.getPermissionsSummary(), equals('CRUE'));
    });
  });
}