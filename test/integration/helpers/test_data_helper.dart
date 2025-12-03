import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:uuid/uuid.dart';

/// Helper pour créer des données de test dans la base de données locale
class TestDataHelper {
  static const _uuid = Uuid();

  /// Crée une visite de test dans la base de données locale
  static Future<int> createLocalVisit({
    required AppDatabase db,
    required int siteId,
    required int datasetId,
    required int moduleId,
    DateTime? visitDate,
    String? comments,
    int? serverVisitId,
  }) async {
    final date = visitDate ?? DateTime.now();
    final dateStr = date.toIso8601String();

    final visitCompanion = TBaseVisitsCompanion.insert(
      idBaseSite: Value(siteId),
      idDataset: datasetId,
      idModule: moduleId,
      uuidBaseVisit: Value(_uuid.v4()),
      visitDateMin: dateStr,
      visitDateMax: Value(dateStr),
      comments: Value(comments),
      serverVisitId: Value(serverVisitId),
    );

    final visitId = await db.into(db.tBaseVisits).insert(visitCompanion);
    print('✅ Visite créée localement: ID=$visitId, Site=$siteId, Module=$moduleId');
    return visitId;
  }

  /// Crée une observation de test dans la base de données locale
  static Future<int> createLocalObservation({
    required AppDatabase db,
    required int visitId,
    required int taxonCdNom,
    int? count,
    String? comments,
    int? serverObservationId,
  }) async {
    final observationCompanion = TObservationsCompanion.insert(
      idBaseVisit: Value(visitId),
      uuidObservation: Value(_uuid.v4()),
      cdNom: Value(taxonCdNom),
      comments: Value(comments),
      serverObservationId: Value(serverObservationId),
    );

    final observationId = await db.into(db.tObservations).insert(observationCompanion);

    // Si un count est spécifié, on peut l'ajouter dans les compléments
    // (selon la structure de votre schéma)

    print('✅ Observation créée localement: ID=$observationId, Visit=$visitId, Taxon=$taxonCdNom');
    return observationId;
  }

  /// Vérifie qu'une visite existe dans la base de données locale
  static Future<bool> visitExists({
    required AppDatabase db,
    required int visitId,
  }) async {
    final visit = await (db.select(db.tBaseVisits)
          ..where((t) => t.idBaseVisit.equals(visitId)))
        .getSingleOrNull();
    return visit != null;
  }

  /// Vérifie qu'une observation existe dans la base de données locale
  static Future<bool> observationExists({
    required AppDatabase db,
    required int observationId,
  }) async {
    final observation = await (db.select(db.tObservations)
          ..where((t) => t.idObservation.equals(observationId)))
        .getSingleOrNull();
    return observation != null;
  }

  /// Récupère une visite par son ID
  static Future<TBaseVisit?> getVisitById({
    required AppDatabase db,
    required int visitId,
  }) async {
    return await (db.select(db.tBaseVisits)
          ..where((t) => t.idBaseVisit.equals(visitId)))
        .getSingleOrNull();
  }

  /// Récupère une observation par son ID
  static Future<TObservation?> getObservationById({
    required AppDatabase db,
    required int observationId,
  }) async {
    return await (db.select(db.tObservations)
          ..where((t) => t.idObservation.equals(observationId)))
        .getSingleOrNull();
  }

  /// Compte le nombre de visites dans la base de données
  static Future<int> countVisits({required AppDatabase db}) async {
    final count = await db.select(db.tBaseVisits).get();
    return count.length;
  }

  /// Compte le nombre d'observations dans la base de données
  static Future<int> countObservations({required AppDatabase db}) async {
    final count = await db.select(db.tObservations).get();
    return count.length;
  }

  /// Supprime toutes les visites de test
  static Future<void> deleteAllVisits({required AppDatabase db}) async {
    await db.delete(db.tBaseVisits).go();
    print('🗑️  Toutes les visites supprimées');
  }

  /// Supprime toutes les observations de test
  static Future<void> deleteAllObservations({required AppDatabase db}) async {
    await db.delete(db.tObservations).go();
    print('🗑️  Toutes les observations supprimées');
  }
}
