import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

/// Provider pour le service de nomenclatures
final nomenclatureServiceProvider = StateNotifierProvider<NomenclatureService,
    custom_async_state.State<Map<String, List<Nomenclature>>>>(
  (ref) => NomenclatureService(
    ref,
    ref.watch(getNomenclaturesByTypeCodeUseCaseProvider),
    ref.watch(getNomenclatureByIdUseCaseProvider),
  ),
);

/// Service pour gérer et mettre en cache les nomenclatures
class NomenclatureService extends StateNotifier<
    custom_async_state.State<Map<String, List<Nomenclature>>>> {
  final Ref ref;
  final GetNomenclaturesByTypeCodeUseCase _getNomenclaturesByTypeCodeUseCase;
  final GetNomenclatureByIdUseCase _getNomenclatureByIdUseCase;

  NomenclatureService(
    this.ref,
    this._getNomenclaturesByTypeCodeUseCase,
    this._getNomenclatureByIdUseCase,
  ) : super(const custom_async_state.State.init());

  /// Récupère les nomenclatures pour un type donné
  /// Utilise le cache si disponible, sinon fait l'appel à l'API
  Future<List<Nomenclature>> getNomenclaturesByTypeCode(String typeCode) async {
    // Si l'état est en chargement ou en erreur, on ne peut pas utiliser le cache
    if (state.isLoading || state.isError) {
      return _fetchNomenclaturesForType(typeCode);
    }

    // Si l'état est initialisé avec succès, on peut utiliser le cache
    if (state.isSuccess) {
      final cachedData = state.data as Map<String, List<Nomenclature>>;

      // Si le type est déjà dans le cache, on le retourne
      if (cachedData.containsKey(typeCode)) {
        return cachedData[typeCode]!;
      }

      // Sinon, on fait l'appel pour ce type et on met à jour le cache
      return _fetchAndCacheNomenclatures(typeCode);
    }

    // Par défaut, faire l'appel frais
    return _fetchNomenclaturesForType(typeCode);
  }

  /// Récupère les nomenclatures pour un type spécifique sans utiliser le cache
  Future<List<Nomenclature>> _fetchNomenclaturesForType(String typeCode) async {
    try {
      return await _getNomenclaturesByTypeCodeUseCase.execute(typeCode);
    } catch (e) {
      print(
          'Erreur lors de la récupération des nomenclatures pour le type $typeCode: $e');
      return [];
    }
  }

  /// Récupère et met en cache les nomenclatures pour un type donné
  Future<List<Nomenclature>> _fetchAndCacheNomenclatures(
      String typeCode) async {
    try {
      // Récupérer les nouvelles nomenclatures
      final nomenclatures =
          await _getNomenclaturesByTypeCodeUseCase.execute(typeCode);

      // Mettre à jour le cache
      if (state.isSuccess) {
        final currentCache = state.data as Map<String, List<Nomenclature>>;
        final updatedCache = Map<String, List<Nomenclature>>.from(currentCache);
        updatedCache[typeCode] = nomenclatures;

        // Mettre à jour l'état
        state = custom_async_state.State.success(updatedCache);
      } else {
        // Si l'état n'est pas encore Success, initialiser le cache
        state = custom_async_state.State.success({typeCode: nomenclatures});
      }

      return nomenclatures;
    } catch (e) {
      print(
          'Erreur lors de la mise en cache des nomenclatures pour le type $typeCode: $e');
      state = custom_async_state.State.error(Exception(e));
      return [];
    }
  }

  /// Effacer le cache pour forcer un rechargement
  void clearCache() {
    state = const custom_async_state.State.init();
  }

  /// Précharger les nomenclatures pour plusieurs types à la fois
  Future<void> preloadNomenclatures(List<String> typeCodes) async {
    state = const custom_async_state.State.loading();

    try {
      final Map<String, List<Nomenclature>> cache = {};

      // Récupérer les nomenclatures pour chaque type
      for (final typeCode in typeCodes) {
        final nomenclatures =
            await _getNomenclaturesByTypeCodeUseCase.execute(typeCode);
        cache[typeCode] = nomenclatures;
      }

      state = custom_async_state.State.success(cache);
    } catch (e) {
      print('Erreur lors du préchargement des nomenclatures: $e');
      state = custom_async_state.State.error(Exception(e));
    }
  }

  /// Récupère le nom d'une nomenclature par son ID
  /// Recherche dans toutes les nomenclatures en cache
  Future<String> getNomenclatureNameById(int id) async {
    // Si on a un cache valide
    if (state.isSuccess) {
      final cachedData = state.data as Map<String, List<Nomenclature>>;
      
      // Parcourir toutes les listes de nomenclatures en cache
      for (final nomenclatures in cachedData.values) {
        final found = nomenclatures.firstWhere(
          (n) => n.id == id,
          orElse: () => const Nomenclature(id: -1, idType: -1, cdNomenclature: ''),
        );
        
        if (found.id != -1) {
          return found.labelFr ?? found.labelDefault ?? found.cdNomenclature ?? 'Nomenclature $id';
        }
      }
    }
    
    // Si on ne trouve pas dans le cache, rechercher dans la base
    try {
      final nomenclature = await _getNomenclatureByIdUseCase.execute(id);
      if (nomenclature != null) {
        return nomenclature.labelFr ?? nomenclature.labelDefault ?? nomenclature.cdNomenclature ?? 'Nomenclature $id';
      }
    } catch (e) {
      // Ignorer l'erreur et retourner le fallback
    }
    
    return 'Nomenclature $id (non trouvée)';
  }
}
