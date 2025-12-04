import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_individuals_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

// Provider pour la requête de recherche des individus
final individualSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider pour les individus filtrés
final filteredIndividualsProvider = Provider<List<Individual>>((ref) {
  final individualListState = ref.watch(individualViewModelStateNotifierProvider);
  final searchQuery = ref.watch(individualSearchQueryProvider);
  
  return individualListState.when(
    init: () => [],
    success: (individuals) {
      if (searchQuery.isEmpty) {
        return individuals;
      }
      return individuals.where((individual) {
        final individualName = individual.individualName?.toLowerCase() ?? '';
        final individualUuid = individual.uuidIndividual?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        
        return individualName.contains(query) || 
               individualUuid.contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_) => [],
  );
});

final individualListProvider =
    Provider.autoDispose<custom_async_state.State<List<Individual>>>((ref) {
  final individualListState = ref.watch(individualViewModelStateNotifierProvider);

  return individualListState.when(
    init: () => const custom_async_state.State.init(),
    success: (individualList) {
      return custom_async_state.State.success(individualList);
    },
    loading: () => const custom_async_state.State.loading(),
    error: (exception) => custom_async_state.State.error(exception),
  );
});

final individualViewModelStateNotifierProvider =
    StateNotifierProvider.autoDispose<IndividualsViewModel,
        custom_async_state.State<List<Individual>>>((ref) {
  return IndividualsViewModel(
    const AsyncValue<List<Individual>>.data([]),
    ref.watch(getIndividualsUseCaseProvider),
  );
});

class IndividualsViewModel
    extends StateNotifier<custom_async_state.State<List<Individual>>> {
  final GetIndividualsUseCase _getIndividualsUseCase;

  IndividualsViewModel(
    AsyncValue<List<Individual>> individualList,
    this._getIndividualsUseCase,
  ) : super(const custom_async_state.State.init()) {
    _loadIndividuals();
  }

  Future<void> refreshIndividuals() async {
    await _loadIndividuals();
  }

  Future<void> _loadIndividuals() async {
    try {
      state = const custom_async_state.State.loading();
      final individuals = await _getIndividualsUseCase.execute();
      state = custom_async_state.State.success(individuals);
    } catch (e) {
      state = custom_async_state.State.error(
          Exception("Failed to load individuals"));
    }
  }
}
