import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

/// Widget affichant un bandeau d'information sur un conflit en cours de résolution
class ConflictInfoBanner extends ConsumerWidget {
  final SyncConflict conflict;

  const ConflictInfoBanner({
    super.key,
    required this.conflict,
  });

  Future<String> _getConflictDescription(WidgetRef ref) async {
    // Si un message personnalisé existe, l'utiliser en priorité
    if (conflict.message != null && conflict.message!.isNotEmpty) {
      return conflict.message!;
    }

    if (conflict.conflictType == ConflictType.deletedReference) {
      // Si c'est une nomenclature, essayer de récupérer son nom
      if (conflict.referencedEntityType?.toLowerCase() == 'nomenclature' &&
          conflict.referencedEntityId != null) {
        final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);
        try {
          final id = int.tryParse(conflict.referencedEntityId!);
          if (id != null) {
            final nom = await nomenclatureService.getNomenclatureNameById(id);
            String fieldName = StringFormatter.formatFieldName(conflict.affectedField);
            return 'Référence supprimée: Le champ "$fieldName" '
                'fait référence à une nomenclature qui n\'existe plus sur le serveur '
                '($nom).';
          }
        } catch (e) {
          // Fallback si erreur
        }
      }
      
      // Si c'est un taxon, utiliser les données du contexte local
      if (conflict.referencedEntityType?.toLowerCase() == 'taxon' &&
          conflict.localData['_context'] != null &&
          conflict.localData['_context']['taxon'] != null) {
        try {
          final taxonContext = conflict.localData['_context']['taxon'];
          final nomComplet = taxonContext['nom_complet'] ?? '';
          final nomVern = taxonContext['nom_vern'] ?? '';
          final cdNom = conflict.referencedEntityId ?? taxonContext['cd_nom']?.toString() ?? '';
          
          String taxonName = nomComplet;
          if (nomVern.isNotEmpty && nomVern != nomComplet) {
            taxonName = '$nomComplet ($nomVern)';
          }
          if (taxonName.isEmpty) {
            taxonName = 'Taxon cd_nom: $cdNom';
          }
          
          String fieldName = StringFormatter.formatFieldName(conflict.affectedField);
          return 'Référence supprimée: Le champ "$fieldName" '
              'fait référence à un taxon qui n\'existe plus sur le serveur '
              '($taxonName).';
        } catch (e) {
          // Fallback si erreur d'accès aux données
        }
      }
      return 'Référence supprimée: Le champ "${StringFormatter.formatFieldName(conflict.affectedField)}" '
          'fait référence à un élément qui n\'existe plus sur le serveur '
          '(${StringFormatter.capitalizeFirst(conflict.referencedEntityType ?? "type inconnu")} avec ID ${conflict.referencedEntityId ?? "inconnu"}).';
    } else {
      return 'Conflit de données: Les données locales et distantes diffèrent. '
          'Modifiez les valeurs pour résoudre le conflit.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: conflict.conflictType == ConflictType.deletedReference
            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.8)
            : Theme.of(context).colorScheme.warningContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: conflict.conflictType == ConflictType.deletedReference
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.warning,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: conflict.conflictType == ConflictType.deletedReference
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Conflit à résoudre',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: conflict.conflictType == ConflictType.deletedReference
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.warning,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<String>(
            future: _getConflictDescription(ref),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Chargement de la description...',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
          if (conflict.conflictType == ConflictType.deletedReference &&
              conflict.affectedField != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Action recommandée: Sélectionnez une nouvelle valeur valide ou supprimez cette référence.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

// Extension pour ajouter facilement des couleurs d'avertissement au thème
extension WarningColorScheme on ColorScheme {
  Color get warning => Colors.orange;
  Color get warningContainer => Colors.orange.withOpacity(0.2);
}