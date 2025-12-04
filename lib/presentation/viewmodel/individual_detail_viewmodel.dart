import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_individuals_usecase.dart';

// Provider pour le ViewModel qui gère les sites d'un groupe de sites
final individualDetailViewModelProvider = StateNotifierProvider.family<
    IndividualDetailViewModel, AsyncValue<List<Individual>>, Individual>(
  (ref, individual) => IndividualDetailViewModel(
    ref.watch(getIndividualsUseCaseProvider),
    individual,
  )..loadSites(),
);

/// ViewModel responsible for managing sites associated with a site group
class IndividualDetailViewModel extends StateNotifier<AsyncValue<List<Individual>>> {
  final GetIndividualsUseCase _getIndividualsUseCase;
  final Individual _individual;

  IndividualDetailViewModel(this._getIndividualsUseCase, this._individual)
      : super(const AsyncValue.loading());

  /// Loads sites associated with the site group
  Future<void> loadSites() async {
    try {
      // On ne réinitialise pas l'état ici car le constructeur initialize déjà à loading
      // Récupérer les sites directement
      final individuals = await _getIndividualsUseCase.execute();
      state = AsyncValue.data(individuals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refreshes the sites list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadSites();
  }
}