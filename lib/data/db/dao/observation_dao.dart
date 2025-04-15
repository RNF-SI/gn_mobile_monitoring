import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_taxrefs.dart';

part 'observation_dao.g.dart';

@DriftAccessor(tables: [TObservations, TObservationComplements, TBaseVisits, TTaxrefs])
class ObservationDao extends DatabaseAccessor<AppDatabase>
    with _$ObservationDaoMixin {
  ObservationDao(super.db);

  /// Récupère toutes les observations liées à une visite
  Future<List<TObservation>> getObservationsByVisitId(int visitId) async {
    return await (select(tObservations)
          ..where((tbl) => tbl.idBaseVisit.equals(visitId)))
        .get();
  }

  /// Récupère une observation par son ID
  Future<TObservation?> getObservationById(int observationId) async {
    return await (select(tObservations)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .getSingleOrNull();
  }

  /// Récupère les données complémentaires d'une observation
  Future<TObservationComplement?> getObservationComplementById(
      int observationId) async {
    return await (select(tObservationComplements)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .getSingleOrNull();
  }

  /// Insère ou met à jour une observation
  Future<int> insertOrUpdateObservation(
      TObservationsCompanion observation) async {
    return await into(tObservations).insertOnConflictUpdate(observation);
  }

  /// Insère ou met à jour les données complémentaires d'une observation
  Future<int> insertOrUpdateObservationComplement(
      TObservationComplementsCompanion complement) async {
    return await into(tObservationComplements)
        .insertOnConflictUpdate(complement);
  }

  /// Supprime une observation
  Future<int> deleteObservation(int observationId) async {
    return await (delete(tObservations)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .go();
  }

  /// Supprime les données complémentaires d'une observation
  Future<int> deleteObservationComplement(int observationId) async {
    return await (delete(tObservationComplements)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .go();
  }

  /// Récupère une observation avec ses données complémentaires
  Future<Map<String, dynamic>> getObservationWithComplement(
      int observationId) async {
    final observation = await getObservationById(observationId);
    if (observation == null) {
      throw Exception('Observation not found');
    }

    final complement = await getObservationComplementById(observationId);

    return {
      'observation': observation,
      'complement': complement,
    };
  }

  /// Récupère les taxons les plus fréquemment utilisés pour un module et site donnés
  /// Priorise les taxons utilisés dans la visite actuelle, puis dans les visites sur le site,
  /// et enfin dans toutes les visites du module.
  Future<List<int>> getMostUsedTaxonIds({
    required List<int> validCdNoms,
    required int moduleId,
    int? siteId,
    int? visitId,
    int limit = 10,
  }) async {
    try {
      if (validCdNoms.isEmpty) {
        return [];
      }

      // Préparer les listes de résultats pour chaque niveau de priorité
      List<int> cdNomsFromVisit = [];
      List<int> cdNomsFromSite = [];
      List<int> cdNomsFromModule = [];

      // 1. Taxons déjà utilisés dans la visite actuelle (priorité la plus haute)
      if (visitId != null) {
        final countExpression = countAll();
        final visitQuery = selectOnly(tObservations)
          ..addColumns([tObservations.cdNom])
          ..addColumns([countExpression])
          ..where(tObservations.idBaseVisit.equals(visitId) &
              tObservations.cdNom.isNotNull())
          ..groupBy([tObservations.cdNom])
          ..orderBy([OrderingTerm.desc(countExpression)]);

        final visitResults = await visitQuery.get();
        cdNomsFromVisit = visitResults
            .where((row) =>
                row.read(tObservations.cdNom) != null &&
                validCdNoms.contains(row.read(tObservations.cdNom)))
            .map((row) => row.read(tObservations.cdNom)!)
            .toList();
      }

      // 2. Taxons déjà utilisés sur ce site pour ce module (priorité intermédiaire)
      if (siteId != null) {
        // Requête pour obtenir toutes les visites associées à ce site et module
        final visitesQuery = selectOnly(tBaseVisits)
          ..addColumns([tBaseVisits.idBaseVisit])
          ..where(tBaseVisits.idBaseSite.equals(siteId) &
              tBaseVisits.idModule.equals(moduleId));

        final sitesVisitesIds = (await visitesQuery.get())
            .map((row) => row.read(tBaseVisits.idBaseVisit)!)
            .toList();

        if (sitesVisitesIds.isNotEmpty) {
          final countExpression = countAll();
          final siteQuery = selectOnly(tObservations)
            ..addColumns([tObservations.cdNom])
            ..addColumns([countExpression])
            ..where(tObservations.idBaseVisit.isIn(sitesVisitesIds) &
                tObservations.cdNom.isNotNull())
            ..groupBy([tObservations.cdNom])
            ..orderBy([OrderingTerm.desc(countExpression)]);

          final siteResults = await siteQuery.get();
          cdNomsFromSite = siteResults
              .where((row) =>
                  row.read(tObservations.cdNom) != null &&
                  validCdNoms.contains(row.read(tObservations.cdNom)) &&
                  !cdNomsFromVisit.contains(row.read(tObservations.cdNom)))
              .map((row) => row.read(tObservations.cdNom)!)
              .toList();
        }
      }

      // 3. Taxons les plus utilisés pour ce module en général (priorité la plus basse)
      final allVisitsQuery = selectOnly(tBaseVisits)
        ..addColumns([tBaseVisits.idBaseVisit])
        ..where(tBaseVisits.idModule.equals(moduleId));

      final moduleVisitIds = (await allVisitsQuery.get())
          .map((row) => row.read(tBaseVisits.idBaseVisit)!)
          .toList();

      if (moduleVisitIds.isNotEmpty) {
        final countExpression = countAll();
        final moduleQuery = selectOnly(tObservations)
          ..addColumns([tObservations.cdNom])
          ..addColumns([countExpression])
          ..where(tObservations.idBaseVisit.isIn(moduleVisitIds) &
              tObservations.cdNom.isNotNull())
          ..groupBy([tObservations.cdNom])
          ..orderBy([OrderingTerm.desc(countExpression)]);

        final moduleResults = await moduleQuery.get();
        cdNomsFromModule = moduleResults
            .where((row) =>
                row.read(tObservations.cdNom) != null &&
                validCdNoms.contains(row.read(tObservations.cdNom)) &&
                !cdNomsFromVisit.contains(row.read(tObservations.cdNom)) &&
                !cdNomsFromSite.contains(row.read(tObservations.cdNom)))
            .map((row) => row.read(tObservations.cdNom)!)
            .toList();
      }

      // Combiner les résultats selon la priorité (visite, site, module)
      final prioritizedCdNoms = [
        ...cdNomsFromVisit,
        ...cdNomsFromSite,
        ...cdNomsFromModule,
      ].take(limit).toList();

      // Si nous n'avons pas assez de taxons fréquemment utilisés, compléter avec des taxons aléatoires de la liste
      if (prioritizedCdNoms.length < limit) {
        final remainingTaxons = validCdNoms
            .where((cdNom) => !prioritizedCdNoms.contains(cdNom))
            .take(limit - prioritizedCdNoms.length)
            .toList();

        prioritizedCdNoms.addAll(remainingTaxons);
      }

      return prioritizedCdNoms;
    } catch (e) {
      print('Erreur dans getMostUsedTaxonIds: $e');
      return [];
    }
  }
}
