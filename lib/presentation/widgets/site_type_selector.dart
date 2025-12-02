import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';

/// Widget pour sélectionner le type de site si plusieurs types sont disponibles
class SiteTypeSelector extends StatelessWidget {
  final ModuleInfo moduleInfo;
  final Function(int siteTypeId) onSiteTypeSelected;

  const SiteTypeSelector({
    super.key,
    required this.moduleInfo,
    required this.onSiteTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final typesSite = moduleInfo.module.complement?.configuration?.module?.typesSite;

    if (typesSite == null || typesSite.isEmpty) {
      return const SizedBox.shrink();
    }

    // Si un seul type est disponible, le sélectionner automatiquement
    if (typesSite.length == 1) {
      final singleTypeId = int.parse(typesSite.keys.first);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSiteTypeSelected(singleTypeId);
      });
      return const SizedBox.shrink();
    }

    // Si plusieurs types sont disponibles, afficher un sélecteur
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sélectionnez le type de site',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...typesSite.entries.map((entry) {
              final typeId = int.parse(entry.key);
              final typeConfig = entry.value;
              final typeName = typeConfig.name ?? 'Type de site $typeId';

              return ListTile(
                title: Text(typeName),
                leading: const Icon(Icons.location_on),
                onTap: () => onSiteTypeSelected(typeId),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

