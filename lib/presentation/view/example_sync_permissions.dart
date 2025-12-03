import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

/// Exemple montrant comment les permissions CRUVED sont récupérées lors de la synchronisation
class SyncPermissionsExample extends ConsumerWidget {
  const SyncPermissionsExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions après synchronisation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. Permissions des Modules'),
          _buildModuleExample(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('2. Permissions des Groupes de Sites'),
          _buildSiteGroupExample(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('3. Permissions des Sites'),
          _buildSiteExample(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('4. Permissions des Visites'),
          _buildVisitExample(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildModuleExample() {
    // Exemple de module avec permissions numériques converties en booléen
    final module = Module(
      id: 17,
      moduleCode: 'STOM',
      moduleLabel: 'Suivi temporel des oiseaux de montagne',
      moduleDesc: 'Module pour le suivi des oiseaux de montagne',
      cruved: const CruvedResponse(
        create: false,  // Valeur numérique 0 convertie en false
        read: true,     // Valeur numérique 3 convertie en true
        update: true,   // Valeur numérique 3 convertie en true
        delete: false,  // Valeur numérique 0 convertie en false
        validate: false,
        export: true,   // Valeur numérique 3 convertie en true
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Module: ${module.moduleLabel}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Code: ${module.moduleCode}'),
            const SizedBox(height: 8),
            Text('Permissions: ${module.getPermissionsSummary()}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (module.canRead()) 
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text('Consulter'),
                  ),
                if (module.canUpdate())
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    label: const Text('Configurer'),
                  ),
                if (module.canExport())
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Exporter'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiteGroupExample() {
    final siteGroup = SiteGroup(
      idSitesGroup: 98,
      sitesGroupName: 'Site 1',
      sitesGroupCode: 'S1',
      cruved: const CruvedResponse(
        create: true,   // Valeur numérique 3
        read: true,     // Valeur numérique 3
        update: true,   // Valeur numérique 3
        delete: true,   // Valeur numérique 3
        validate: false, // Valeur numérique 0
        export: false,   // Valeur numérique 0
      ),
    );

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Groupe: ${siteGroup.sitesGroupName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Permissions complètes: ${siteGroup.hasFullCRUD() ? "Oui" : "Non"}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Actions disponibles: '),
                ...['C', 'R', 'U', 'D'].map((action) {
                  bool hasPermission = false;
                  switch (action) {
                    case 'C': hasPermission = siteGroup.canCreate(); break;
                    case 'R': hasPermission = siteGroup.canRead(); break;
                    case 'U': hasPermission = siteGroup.canUpdate(); break;
                    case 'D': hasPermission = siteGroup.canDelete(); break;
                  }
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: hasPermission ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      action,
                      style: TextStyle(
                        color: hasPermission ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiteExample() {
    final site = BaseSite(
      idBaseSite: 1733,
      baseSiteName: 'Site d\'observation #1',
      altitudeMin: 300,
      cruved: const CruvedResponse(
        create: true,   // Format booléen direct
        read: true,
        update: true,
        delete: true,
        validate: false,
        export: false,
      ),
    );

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Site: ${site.baseSiteName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Text('Altitude: ${site.altitudeMin}m'),
            const SizedBox(height: 8),
            const Text('Permissions spécifiques au site:'),
            const SizedBox(height: 4),
            _buildPermissionIndicators(site),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitExample() {
    final visit = BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 17,
      visitDateMin: '2025-11-25',
      observers: [3],
      cruved: const CruvedResponse(
        create: false,
        read: false,
        update: false,
        delete: false,
        validate: false,
        export: false,
      ),
    );

    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Visite du ${visit.visitDateMin}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!visit.hasAnyPermission())
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Aucune permission sur cette visite',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            else
              _buildPermissionIndicators(visit),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionIndicators(dynamic object) {
    final permissions = [
      ('Créer', object.canCreate(), Colors.green),
      ('Lire', object.canRead(), Colors.blue),
      ('Modifier', object.canUpdate(), Colors.orange),
      ('Valider', object.canValidate(), Colors.purple),
      ('Exporter', object.canExport(), Colors.teal),
      ('Supprimer', object.canDelete(), Colors.red),
    ];

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: permissions.map((perm) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: perm.$2 ? perm.$3.withOpacity(0.2) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: perm.$2 ? perm.$3 : Colors.grey[400]!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                perm.$2 ? Icons.check : Icons.close,
                size: 14,
                color: perm.$2 ? perm.$3 : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                perm.$1,
                style: TextStyle(
                  fontSize: 12,
                  color: perm.$2 ? perm.$3 : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}