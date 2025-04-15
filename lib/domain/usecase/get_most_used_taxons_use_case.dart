import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

/// Cas d'utilisation pour récupérer les taxons les plus fréquemment utilisés
abstract class GetMostUsedTaxonsUseCase {
  /// Récupère les taxons les plus utilisés pour un site et un module spécifiques
  /// 
  /// [idListe] Identifiant de la liste taxonomique à filtrer
  /// [moduleId] Identifiant du module (protocole)
  /// [siteId] Identifiant du site (optionnel)
  /// [visitId] Identifiant de la visite en cours (optionnel)
  /// [limit] Nombre maximum de taxons à retourner
  Future<List<Taxon>> execute({
    required int idListe,
    required int moduleId,
    int? siteId,
    int? visitId,
    int limit = 10,
  });
}

class GetMostUsedTaxonsUseCaseImpl implements GetMostUsedTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  GetMostUsedTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute({
    required int idListe,
    required int moduleId,
    int? siteId,
    int? visitId,
    int limit = 10,
  }) {
    return _taxonRepository.getMostUsedTaxons(
      idListe: idListe,
      moduleId: moduleId,
      siteId: siteId,
      visitId: visitId,
      limit: limit,
    );
  }
}