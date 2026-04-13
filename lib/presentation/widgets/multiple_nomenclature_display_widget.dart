import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/multiple_nomenclature_selector_widget.dart';

/// Widget pour afficher une liste de nomenclatures sélectionnées
///
/// Charge les nomenclatures depuis la base de données par leurs IDs
/// et affiche leurs labels séparés par des virgules
class MultipleNomenclatureDisplayWidget extends ConsumerWidget {
  final List<int> nomenclatureIds;
  final String typeCode;

  const MultipleNomenclatureDisplayWidget({
    super.key,
    required this.nomenclatureIds,
    required this.typeCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nomenclaturesAsync = ref.watch(nomenclaturesByTypeProvider(typeCode));

    return nomenclaturesAsync.when(
      data: (allNomenclatures) {
        // Filtrer pour ne garder que les nomenclatures sélectionnées
        final selectedNomenclatures = allNomenclatures
            .where((n) => nomenclatureIds.contains(n.id))
            .toList();

        if (selectedNomenclatures.isEmpty) {
          return Text(
            'Nomenclatures introuvables (IDs: ${nomenclatureIds.join(', ')})',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          );
        }

        // Créer une liste de labels
        final labels = selectedNomenclatures
            .map((n) => n.labelFr ?? n.labelDefault ?? n.cdNomenclature)
            .toList();

        return Text(labels.join(', '));
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stackTrace) => Text(
        'Erreur de chargement (IDs: ${nomenclatureIds.join(', ')})',
        style: const TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
