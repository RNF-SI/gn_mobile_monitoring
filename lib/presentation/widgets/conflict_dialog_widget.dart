import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_card_widget.dart';

/// Widget pour afficher la boîte de dialogue des conflits
class ConflictDialogWidget extends ConsumerWidget {
  /// Liste des conflits à afficher
  final List<domain.SyncConflict> conflicts;

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
        .where((c) => c.conflictType == domain.ConflictType.deletedReference)
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
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyAllConflictsToClipboard(context, referenceConflicts),
              tooltip: 'Copier le rapport de conflits',
            ),
          ],
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
                      conflictType: domain.ConflictType.deletedReference,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Copie tous les conflits dans le presse-papiers pour envoi à l'administrateur
  void _copyAllConflictsToClipboard(BuildContext context, List<domain.SyncConflict> conflicts) async {
    if (conflicts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun conflit à copier'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Créer un rapport structuré des conflits
    final StringBuffer report = StringBuffer();
    report.writeln('RAPPORT DE CONFLITS DE SYNCHRONISATION');
    report.writeln('${'=' * 50}');
    report.writeln('Date: ${DateTime.now().toIso8601String()}');
    report.writeln('Type: Mise à jour des données (synchronisation descendante)');
    report.writeln('');
    report.writeln('RÉSUMÉ:');
    report.writeln('${'-' * 40}');
    report.writeln('Nombre total de conflits: ${conflicts.length}');
    
    // Grouper les conflits par type d'entité
    final Map<String, List<domain.SyncConflict>> conflictsByType = {};
    for (final conflict in conflicts) {
      final type = conflict.entityType ?? 'Inconnu';
      conflictsByType.putIfAbsent(type, () => []).add(conflict);
    }
    
    report.writeln('');
    report.writeln('Conflits par type d\'entité:');
    for (final entry in conflictsByType.entries) {
      report.writeln('  - ${entry.key}: ${entry.value.length} conflit(s)');
    }
    
    report.writeln('');
    report.writeln('DÉTAILS DES CONFLITS:');
    report.writeln('${'-' * 40}');
    
    int index = 1;
    for (final conflict in conflicts) {
      report.writeln('');
      report.writeln('$index. ${conflict.entityType ?? "Type inconnu"} (ID: ${conflict.entityId ?? "inconnu"})');
      report.writeln('   Type de conflit: ${_getConflictTypeDescription(conflict.conflictType)}');
      
      if (conflict.affectedField != null) {
        report.writeln('   Champ affecté: ${conflict.affectedField}');
      }
      
      if (conflict.referencedEntityType != null && conflict.referencedEntityId != null) {
        // Essayer d'obtenir le nom enrichi de l'entité
        String entityInfo = '${conflict.referencedEntityType} ID ${conflict.referencedEntityId}';
        
        try {
          // Pour les nomenclatures
          if (conflict.referencedEntityType?.toLowerCase() == 'nomenclature') {
            // Extraire depuis le contexte si disponible
            if (conflict.localData['_context'] != null &&
                conflict.localData['_context']['nomenclature'] != null) {
              final nomenclatureContext = conflict.localData['_context']['nomenclature'];
              final nomLabel = nomenclatureContext['label_default'] ?? nomenclatureContext['label_fr'] ?? '';
              if (nomLabel.isNotEmpty) {
                entityInfo = '$nomLabel (ID: ${conflict.referencedEntityId})';
              }
            }
          }
          // Pour les taxons
          else if (conflict.referencedEntityType?.toLowerCase() == 'taxon') {
            if (conflict.localData['_context'] != null &&
                conflict.localData['_context']['taxon'] != null) {
              final taxonContext = conflict.localData['_context']['taxon'];
              final nomComplet = taxonContext['nom_complet'] ?? '';
              final nomVern = taxonContext['nom_vern'] ?? '';
              
              String taxonName = nomComplet;
              if (nomVern.isNotEmpty && nomVern != nomComplet) {
                taxonName = '$nomComplet ($nomVern)';
              }
              if (taxonName.isNotEmpty) {
                entityInfo = '$taxonName (cd_nom: ${conflict.referencedEntityId})';
              }
            }
          }
          // Pour les sites
          else if (conflict.referencedEntityType?.toLowerCase() == 'site' || 
                   conflict.referencedEntityType?.toLowerCase() == 'basesite') {
            if (conflict.localData['_context'] != null &&
                conflict.localData['_context']['site'] != null) {
              final siteContext = conflict.localData['_context']['site'];
              final siteName = siteContext['base_site_name'] ?? siteContext['site_name'] ?? '';
              final siteCode = siteContext['base_site_code'] ?? siteContext['site_code'] ?? '';
              
              if (siteName.isNotEmpty) {
                if (siteCode.isNotEmpty) {
                  entityInfo = '$siteName ($siteCode)';
                } else {
                  entityInfo = siteName;
                }
              }
            }
          }
        } catch (e) {
          // En cas d'erreur, utiliser l'info par défaut
        }
        
        report.writeln('   Référence supprimée: $entityInfo');
      }
      
      if (conflict.message != null && conflict.message!.isNotEmpty) {
        report.writeln('   Message: ${conflict.message}');
      }
      
      // Ajouter les données locales si disponibles (en omettant les données sensibles)
      if (conflict.localData.isNotEmpty) {
        final relevantData = Map.from(conflict.localData)
          ..remove('_context')  // Retirer les données de contexte volumineuses
          ..remove('data_origin');
        
        if (relevantData.isNotEmpty) {
          report.writeln('   Données locales:');
          relevantData.forEach((key, value) {
            if (value != null && value.toString().isNotEmpty) {
              report.writeln('     - $key: $value');
            }
          });
        }
      }
      
      index++;
    }
    
    report.writeln('');
    report.writeln('${'=' * 50}');
    report.writeln('INFORMATIONS SYSTÈME:');
    report.writeln('Application: GeoNature Mobile');
    report.writeln('');
    report.writeln('Note: Ce rapport peut être envoyé à votre administrateur système');
    report.writeln('pour obtenir de l\'aide dans la résolution de ces conflits.');

    Clipboard.setData(ClipboardData(text: report.toString()));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapport de conflits copié dans le presse-papiers'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  String _getConflictTypeDescription(domain.ConflictType type) {
    switch (type) {
      case domain.ConflictType.deletedReference:
        return 'Référence supprimée';
      case domain.ConflictType.dataConflict:
        return 'Conflit de données';
      default:
        return 'Type inconnu';
    }
  }
}