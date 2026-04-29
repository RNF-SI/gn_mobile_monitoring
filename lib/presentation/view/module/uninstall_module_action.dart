import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_uninstall_stats.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_item_card_widget.dart'
    show unsyncedModuleIdsProvider;
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

/// Action de désinstallation à insérer dans `AppBar.actions` de la
/// `ModuleDetailPage`. Charge les stats avant de demander confirmation et
/// affiche un avertissement explicite si des saisies locales non
/// téléversées seraient détruites.
class UninstallModuleAction extends ConsumerWidget {
  final int moduleId;
  final String moduleLabel;

  const UninstallModuleAction({
    super.key,
    required this.moduleId,
    required this.moduleLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'Plus d\'actions',
      onSelected: (value) {
        if (value == 'uninstall') {
          _confirmAndUninstall(context, ref);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'uninstall',
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text('Désinstaller le module'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAndUninstall(BuildContext context, WidgetRef ref) async {
    // Stats récupérées juste avant la modale pour refléter l'état exact
    // (l'utilisateur a pu créer / pousser des visites depuis l'ouverture du
    // module).
    ModuleUninstallStats stats;
    try {
      stats = await ref
          .read(getModuleUninstallStatsUseCaseProvider)
          .execute(moduleId);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de récupérer les stats : $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _UninstallConfirmationDialog(
        moduleLabel: moduleLabel,
        stats: stats,
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(uninstallModuleUseCaseProvider).execute(moduleId);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la désinstallation : $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Refresh : la liste des modules + le badge "non sync" de la home.
    ref.invalidate(unsyncedModuleIdsProvider);
    await ref
        .read(userModuleListeViewModelStateNotifierProvider.notifier)
        .loadModules();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Module « $moduleLabel » désinstallé.'),
        backgroundColor: Colors.green,
      ),
    );
    // Retour à la home : le module détail n'a plus de sens (downloaded=false).
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class _UninstallConfirmationDialog extends StatelessWidget {
  final String moduleLabel;
  final ModuleUninstallStats stats;

  const _UninstallConfirmationDialog({
    required this.moduleLabel,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Expanded(child: Text('Désinstaller ce module ?')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Module : $moduleLabel',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (stats.hasUnsavedData) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.red.withValues(alpha: 0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${stats.unsyncedVisits} visite(s) non téléversée(s) — '
                        'ces saisies seront définitivement perdues si vous '
                        'continuez sans les téléverser d\'abord.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Text('Données qui seront supprimées :',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _BulletLine('${stats.totalVisits} visite(s) saisie(s)'),
            _BulletLine('${stats.totalObservations} observation(s)'),
            _BulletLine(
                '${stats.exclusiveSites} site(s) propre(s) au module'),
            const SizedBox(height: 12),
            const Text(
              'Conservées : sites partagés avec d\'autres modules, '
              'nomenclatures, types de site, taxons.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Désinstaller'),
        ),
      ],
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  const _BulletLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
