import 'package:gn_mobile_monitoring/data/datasource/interface/api/individuals_api.dart';
import 'package:gn_mobile_monitoring/core/utils/error_message_helper.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/individuals_database.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/individual_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/individuals_repository.dart';

class IndividualsRepositoryImpl implements IndividualsRepository {
  final IndividualsApi api;
  final ModulesDatabase modulesDatabase;
  final IndividualsDatabase database;

  IndividualsRepositoryImpl(
      this.api, this.modulesDatabase, this.database);


  @override
  Future<void> fetchIndividualsAndIndividualModules(String token) async {
    try {
      // Récupérer uniquement les modules téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      if (modules.isEmpty) {
        print(
            'Aucun module téléchargé trouvé, récupération des individus ignorée');
        return;
      }

      // Maps to store unique site groups and the relationships to modules
      final Map<int, Individual> uniqueIndividuals = {};
      final List<IndividualModule> individualModules = [];

      // Pour chaque module téléchargé, récupérer ses individus
      print(
          'Récupération des individus pour ${modules.length} modules téléchargés');
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch site groups for this module using the new method
          final individuals =
              await api.fetchEnrichedIndividualsForModule(module.moduleCode!, token);

          // Add site groups to our map and create site-group-module relationships
          for (final individual in individuals) {
            final domainIndividual = individual.individual.toDomain();
            uniqueIndividuals[domainIndividual.idIndividual] = domainIndividual;

            // Create site-group-module relationship
            individualModules.add(IndividualModule(
              idIndividual: domainIndividual.idIndividual,
              idModule: module.id,
            ));
          }
        } catch (e) {
          print(
              'Error fetching site groups for module ${module.moduleCode}: $e');
          // Continue with next module instead of failing completely
          continue;
        }
      }

      // Save unique site groups to database
      await database.clearIndividuals();
      await database.insertIndividuals(uniqueIndividuals.values.toList());

      // Save site-group-module relationships
      await database.clearAllIndividualModules();
      await database.insertIndividualModules(individualModules);
    } catch (error) {
      print('Error fetching site groups: $error');
      throw Exception('Failed to fetch site groups');
    }
  }

  @override
  Future<List<Individual>> getIndividuals() async {
    try {
      final groups = await database.getAllIndividuals();
      return groups;
    } catch (error) {
      print('Error getting site groups: $error');
      throw Exception('Failed to get site groups');
    }
  }

  @override
  Future<void> fetchIndividualsForModule(String moduleCode, String token) async {
    try {
      // Récupérer le module par son code
      final module = await modulesDatabase.getModuleByCode(moduleCode);
      if (module == null) {
        throw Exception('Module $moduleCode not found');
      }

      // Récupérer les individus pour ce module
      final individuals = await api.fetchEnrichedIndividualsForModule(moduleCode, token);

      for (final individual in individuals) {
        final domainIndividual = individual.individual.toDomain();

        // Vérifier si le groupe existe déjà
        final existingGroups = await database.getAllIndividuals();
        final existingGroup = existingGroups.firstWhere(
          (g) => g.idIndividual == domainIndividual.idIndividual,
          orElse: () => const Individual(
            idIndividual: -1,
          ),
        );

        if (existingGroup.idIndividual == -1) {
          // Le groupe n'existe pas, l'ajouter
          await database.insertIndividuals([domainIndividual]);
        } else {
          // Le groupe existe, le mettre à jour
          await database.updateIndividual(domainIndividual);
        }

        // Créer la relation groupe-module
        await database.insertIndividualModules([
          IndividualModule(
            idIndividual: domainIndividual.idIndividual,
            idModule: module.id,
          )
        ]);
      }

      print('Fetched ${individuals.length} site groups for module $moduleCode');
    } catch (error) {
      print('Error fetching site groups for module $moduleCode: $error');
      throw Exception('Failed to fetch site groups for module $moduleCode');
    }
  }

  
  @override
  Future<SyncResult> incrementalSyncIndividualsWithConflictHandling(
      String token) async {
    // Variables pour les métriques et conflits
    final List<SyncConflict> allConflicts = [];
    int itemsProcessed = 0;
    int itemsAdded = 0;
    int itemsUpdated = 0;
    int itemsDeleted = 0;
    int itemsSkipped = 0;

    try {
      // Récupérer uniquement les modules téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      if (modules.isEmpty) {
        print(
            'Aucun module téléchargé trouvé, synchronisation des individus ignorée');
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      // Traiter chaque module individuellement
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        print('=== Synchronisation individus module ${module.moduleCode} ===');

        // NOTE: Les compléments de sites sont mis à jour lors de la synchronisation des sites
        // qui précède cette synchronisation des individus dans le processus complet

        // 1. Récupérer les individus LOCAUX pour CE MODULE spécifiquement
        final localIndividualsForModule = await database.getIndividualsByModuleId(module.id);
        final localIndividualIdsForModule =
            localIndividualsForModule.map((ind) => ind.idIndividual).toSet();

        print(
            'Individus locaux pour le module ${module.moduleCode}: ${localIndividualsForModule.length}');

        // 2. Récupérer les individus DISTANTS pour CE MODULE
        List<Individual> remoteIndividuals;

        try {
          final individuals =
              await api.fetchEnrichedIndividualsForModule(module.moduleCode!, token);

          remoteIndividuals = individuals
              .map((ind) => ind.individual.toDomain())
              .toList();

          print(
              'Individus distants pour le module ${module.moduleCode}: ${remoteIndividuals.length}');
        } catch (e) {
          final errorMessage = ErrorMessageHelper.formatError(
            'la synchronisation des individus', 
            e, 
            moduleCode: module.moduleCode
          );
          print(errorMessage);
          // Si le module n'a pas de individus, traiter comme une liste vide
          remoteIndividuals = [];
          // Ne pas faire continue, traiter comme un cas normal avec 0 groupe
        }

        // 3. Créer les ensembles d'IDs pour la comparaison
        final remoteIndividualIds = remoteIndividuals.map((ind) => ind.idIndividual).toSet();

        // 4. Identifier les changements pour CE MODULE

        // Individus à ajouter : existent sur le serveur mais pas localement pour ce module
        final individualsToAdd = remoteIndividuals
            .where((ind) => !localIndividualIdsForModule.contains(ind.idIndividual))
            .toList();

        // Individus à supprimer : existent localement pour ce module mais plus sur le serveur
        final individualsToDelete = localIndividualsForModule
            .where((ind) => !remoteIndividualIds.contains(ind.idIndividual))
            .toList();

        // Individus à mettre à jour : existent des deux côtés
        final individualsToUpdate = remoteIndividuals
            .where((ind) => localIndividualIdsForModule.contains(ind.idIndividual))
            .toList();

        print(
            'Module ${module.moduleCode} - À ajouter: ${individualsToAdd.length}, À supprimer: ${individualsToDelete.length}, À mettre à jour: ${individualsToUpdate.length}');
        // 5. Gérer les suppressions des individus - pas de conflit car la suppression
        // d'un groupe n'entraine pas de perte de données (les sites restent, seul id_sites_group devient NULL)
        for (final individual in individualsToDelete) {
          print('Suppression de l\'individu ${individual.idIndividual} du module ${module.moduleCode}');
          
          // Supprimer la relation individu-module
          await database.deleteIndividualModule(individual.idIndividual, module.id);

          // Vérifier si le groupe appartient à d'autres modules avant suppression complète
          final hasOtherReferences = await database.individualHasOtherModuleReferences(individual.idIndividual, module.id);

          if (!hasOtherReferences) {
            // Le groupe n'est lié à aucun autre module, on peut le supprimer complètement
            // Note: Les compléments de sites ont déjà été mis à jour lors de la synchronisation des sites (qui précède celle des groupes)
            await database.deleteIndividual(individual.idIndividual);
            print('Individu ${individual.idIndividual} supprimé complètement (pas d\'autres références de modules)');
            itemsDeleted++;
          } else {
            // Le groupe est encore lié à d'autres modules, on ne supprime que la relation
            print('Individu ${individual.idIndividual} conservé (lié à d\'autres modules), relation supprimée uniquement');
          }
        }

        // 6. Ajouter les nouveaux individus
        for (final individual in individualsToAdd) {
          // Vérifier si le groupe existe déjà dans la base (pour un autre module)
          final existingIndividuals = await database.getAllIndividuals();
          final existingIndividual = existingIndividuals.firstWhere(
            (g) => g.idIndividual == individual.idIndividual,
            orElse: () => const Individual(idIndividual: -1),
          );

          if (existingIndividual.idIndividual == -1) {
            // Le groupe n'existe pas du tout, l'ajouter
            await database.insertIndividuals([individual]);
          }

          // Créer la relation individu-module
          await database.insertIndividualModules([
            IndividualModule(
              idIndividual: individual.idIndividual,
              idModule: module.id,
            )
          ]);
          itemsAdded++;
        }

        // 7. Mettre à jour les individus existants
        for (final individual in individualsToUpdate) {
          await database.updateIndividual(individual);
          itemsUpdated++;
        }

        itemsProcessed += remoteIndividuals.length;
      }

      print('=== Résumé de la synchronisation des individus ===');
      print(
          'Traités: $itemsProcessed, Ajoutés: $itemsAdded, Mis à jour: $itemsUpdated, Supprimés: $itemsDeleted, Conflits: ${allConflicts.length}');

      if (allConflicts.isNotEmpty) {
        return SyncResult.withConflicts(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
          itemsFailed: 0,
          conflicts: allConflicts,
          errorMessage:
              'Certains individus ont des références locales dans différents modules',
        );
      } else {
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
        );
      }
    } catch (error) {
      print('Erreur lors de la synchronisation des individus par module: $error');
      return SyncResult.failure(
        errorMessage: 'Erreur: $error',
      );
    }
  }
}
