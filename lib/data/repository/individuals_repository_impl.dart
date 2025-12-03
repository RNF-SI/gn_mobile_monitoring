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
  final IndividualsDatabase _individualsDatabase;

  IndividualsRepositoryImpl(
      this.api, this.modulesDatabase, this._individualsDatabase);

  @override
  Future<void> fetchAllIndividuals(String token) async {
    try {
      final individualsEntities = await api.fetchAllIndividuals(token);
      final List<Map<String, dynamic>> enrichedIndividuals =
              (individualsEntities as List).cast<Map<String, dynamic>>();

          for (final individualJson in enrichedIndividuals) {
            final individual = IndividualEntity.fromJson(individualJson);
            final domainIndividual = individual.toDomain();

            final existingIndividual =
            await _individualsDatabase.getIndividualById(domainIndividual.idIndividual);

            if (existingIndividual == null) {
              await _individualsDatabase.insertIndividuals([domainIndividual]);
            } else {
              await _individualsDatabase.updateIndividual(domainIndividual);
            }
          }
          print('Fetched ${enrichedIndividuals.length} individuals');
            } catch (error) {
          print('Error fetching individuals: $error');
          throw Exception('Failed to fetch individuals');
            }
  }

  // @override
  // Future<void> fetchIndividualsForModule(String moduleCode, String token) async {
  //   try {
  //     // Récupérer le module par son code
  //     final module = await modulesDatabase.getModuleByCode(moduleCode);
  //     if (module == null) {
  //       throw Exception('Module $moduleCode not found');
  //     }

  //     // Récupérer les individuals enrichis pour ce module
  //     final enrichedData =
  //         await api.fetchEnrichedIndividualsForModule(moduleCode, token);

  //     final List<Map<String, dynamic>> enrichedIndividuals =
  //         (enrichedData['enriched_individuals'] as List).cast<Map<String, dynamic>>();

  //     // Traiter les individuals
  //     for (final individualJson in enrichedIndividuals) {
  //       final individual = IndividualEntity.fromJson(individualJson);
  //       final domainIndividual = individual.toDomain();

  //       // Vérifier si le individual existe déjà
  //       final existingIndividual = await _individualsDatabase.getIndividualById(domainIndividual.idIndividual);

  //       if (existingIndividual == null) {
  //         // Le individual n'existe pas, l'ajouter
  //         await _individualsDatabase.insertIndividuals([domainIndividual]);
  //       } else {
  //         // Le individual existe, le mettre à jour
  //         await _individualsDatabase.updateIndividual(domainIndividual);
  //       }

  //       // Créer la relation individual-module (même si elle existe déjà, ça ne fait pas de doublon)
  //       await _individualsDatabase.insertIndividualModule(IndividualModule(
  //         idIndividual: domainIndividual.idIndividual,
  //         idModule: module.id,
  //       ));
  //     }
  //     print('Fetched ${enrichedIndividuals.length} individuals for module $moduleCode');
  //   } catch (error) {
  //     print('Error fetching individuals for module $moduleCode: $error');
  //     throw Exception('Failed to fetch individuals for module $moduleCode');
  //   }
  // }

  @override
  Future<Individual?> getIndividualById(int individualId) async {
    final entity =
        await _individualsDatabase.getIndividualById(individualId);
    return entity;
  }

  @override
  Future<bool> updateIndividualServerId(int localIndividualId, int serverIndividualId) async {
    return await _individualsDatabase.updateIndividualServerId(localIndividualId, serverIndividualId);
  }
}
