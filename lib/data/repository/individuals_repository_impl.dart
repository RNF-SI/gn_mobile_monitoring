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
            'Aucun module téléchargé trouvé, récupération des groupes de sites ignorée');
        return;
      }

      // Maps to store unique site groups and the relationships to modules
      final Map<int, Individual> uniqueIndividuals = {};
      final List<IndividualModule> individualModules = [];

      // Pour chaque module téléchargé, récupérer ses groupes de sites
      print(
          'Récupération des groupes de sites pour ${modules.length} modules téléchargés');
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

      // Récupérer les groupes de sites pour ce module
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
}
