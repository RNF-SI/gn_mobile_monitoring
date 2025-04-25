import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_card_widget.dart';

/// Widget pour afficher la boîte de dialogue des conflits
class ConflictDialogWidget extends ConsumerWidget {
  /// Liste des conflits à afficher
  final List<SyncConflict> conflicts;

  /// Titre spécifique pour le type de conflit (optionnel)
  final String? typeTitle;

  const ConflictDialogWidget({
    super.key,
    required this.conflicts,
    this.typeTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dans notre application, tous les conflits sont des références supprimées
    final referenceConflicts = conflicts
        .where((c) => c.conflictType == ConflictType.deletedReference)
        .toList();

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            typeTitle != null
                ? 'Références supprimées - $typeTitle'
                : 'Références supprimées',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // Message explicatif compact
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Données locales faisant référence à des éléments supprimés sur le serveur.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Séparateur avec compteur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Theme.of(context).colorScheme.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${referenceConflicts.length} élément(s) à résoudre',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Cliquez pour modifier',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Liste des conflits
            if (referenceConflicts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aucune référence supprimée',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: referenceConflicts.length,
                  itemBuilder: (context, index) {
                    final conflict = referenceConflicts[index];
                    return ConflictCardWidget(
                      conflict: conflict,
                      conflictType: ConflictType.deletedReference,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}