import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxon_by_cd_nom_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxons_by_list_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/search_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

/// Provider pour le service de taxons
final taxonServiceProvider = StateNotifierProvider<TaxonService,
    custom_async_state.State<Map<String, List<Taxon>>>>(
  (ref) => TaxonService(
    ref,
    ref.watch(getModuleTaxonsUseCaseProvider),
    ref.watch(getTaxonsByListIdUseCaseProvider),
    ref.watch(getTaxonByCdNomUseCaseProvider),
    ref.watch(searchTaxonsUseCaseProvider),
  ),
);

/// Provider pour récupérer les taxons par liste
final taxonsByListProvider = FutureProvider.family<List<Taxon>, int>(
  (ref, listId) async {
    final taxonService = ref.read(taxonServiceProvider.notifier);
    return await taxonService.getTaxonsByListId(listId);
  },
);

/// Provider pour récupérer les taxons par module
final taxonsByModuleProvider = FutureProvider.family<List<Taxon>, int>(
  (ref, moduleId) async {
    final taxonService = ref.read(taxonServiceProvider.notifier);
    return await taxonService.getTaxonsByModuleId(moduleId);
  },
);

/// Provider pour récupérer un taxon par cd_nom
final taxonByCdNomProvider = FutureProvider.family<Taxon?, int>(
  (ref, cdNom) async {
    final taxonService = ref.read(taxonServiceProvider.notifier);
    return await taxonService.getTaxonByCdNom(cdNom);
  },
);

/// Service pour gérer les taxons
class TaxonService
    extends StateNotifier<custom_async_state.State<Map<String, List<Taxon>>>> {
  final Ref ref;
  final GetModuleTaxonsUseCase _getModuleTaxonsUseCase;
  final GetTaxonsByListIdUseCase _getTaxonsByListIdUseCase;
  final GetTaxonByCdNomUseCase _getTaxonByCdNomUseCase;
  final SearchTaxonsUseCase _searchTaxonsUseCase;

  TaxonService(
    this.ref,
    this._getModuleTaxonsUseCase,
    this._getTaxonsByListIdUseCase,
    this._getTaxonByCdNomUseCase,
    this._searchTaxonsUseCase,
  ) : super(const custom_async_state.State.init());

  /// Récupère les taxons pour un module donné
  /// Note: Cette méthode est maintenue pour la compatibilité, mais il est préférable
  /// d'utiliser getTaxonsByListId avec l'id_list spécifique du champ de formulaire
  Future<List<Taxon>> getTaxonsByModuleId(int moduleId) async {
    try {
      return await _getModuleTaxonsUseCase.execute(moduleId);
    } catch (e) {
      print(
          'Erreur lors de la récupération des taxons pour le module $moduleId: $e');
      return [];
    }
  }

  /// Récupère les taxons pour une liste taxonomique spécifique
  Future<List<Taxon>> getTaxonsByListId(int idListe) async {
    try {
      return await _getTaxonsByListIdUseCase.execute(idListe);
    } catch (e) {
      print(
          'Erreur lors de la récupération des taxons pour la liste $idListe: $e');
      return [];
    }
  }

  /// Récupère un taxon par son code cd_nom
  Future<Taxon?> getTaxonByCdNom(int cdNom) async {
    try {
      return await _getTaxonByCdNomUseCase.execute(cdNom);
    } catch (e) {
      print('Erreur lors de la récupération du taxon $cdNom: $e');
      return null;
    }
  }

  /// Recherche des taxons par terme de recherche
  /// Si idListe est fourni, la recherche se fait uniquement dans cette liste taxonomique
  Future<List<Taxon>> searchTaxons(String searchTerm, {int? idListe}) async {
    try {
      return await _searchTaxonsUseCase.execute(searchTerm, idListe: idListe);
    } catch (e) {
      print('Erreur lors de la recherche de taxons avec "$searchTerm": $e');
      return [];
    }
  }

  /// Formatage de l'affichage d'un taxon selon le format configuré
  String formatTaxonDisplay(Taxon taxon, String displayFormat) {
    switch (displayFormat) {
      case 'nom_vern,lb_nom':
        return taxon.nomVern?.isNotEmpty == true
            ? '${taxon.nomVern} (${taxon.lbNom ?? ""})'
            : taxon.lbNom ?? taxon.nomComplet;
      case 'lb_nom':
        return taxon.lbNom ?? taxon.nomComplet;
      case 'nom_complet':
        return taxon.nomComplet;
      case 'nom_vern':
        return taxon.nomVern ?? taxon.lbNom ?? taxon.nomComplet;
      default:
        return taxon.nomComplet;
    }
  }
}
