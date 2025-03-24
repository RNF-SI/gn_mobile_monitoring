import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_with_config_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';

// États possibles pour le ViewModel
enum ModuleDetailState {
  loading,
  loaded,
  error,
}

// État du ViewModel
class ModuleDetailViewModelState {
  final ModuleDetailState state;
  final Module? module;
  final String? errorMessage;

  const ModuleDetailViewModelState({
    required this.state,
    this.module,
    this.errorMessage,
  });

  factory ModuleDetailViewModelState.loading() {
    return const ModuleDetailViewModelState(
      state: ModuleDetailState.loading,
    );
  }

  factory ModuleDetailViewModelState.loaded(Module module) {
    return ModuleDetailViewModelState(
      state: ModuleDetailState.loaded,
      module: module,
    );
  }

  factory ModuleDetailViewModelState.error(String message) {
    return ModuleDetailViewModelState(
      state: ModuleDetailState.error,
      errorMessage: message,
    );
  }
}

// ViewModel pour la page de détail du module
class ModuleDetailViewModel extends StateNotifier<ModuleDetailViewModelState> {
  final GetModuleWithConfigUseCase _getModuleWithConfigUseCase;

  ModuleDetailViewModel(this._getModuleWithConfigUseCase)
      : super(ModuleDetailViewModelState.loading());

  Future<void> loadModuleWithConfig(int moduleId) async {
    try {
      state = ModuleDetailViewModelState.loading();
      final module = await _getModuleWithConfigUseCase.execute(moduleId);
      state = ModuleDetailViewModelState.loaded(module);
    } catch (e) {
      state = ModuleDetailViewModelState.error(e.toString());
    }
  }
}

// Provider pour le ViewModel
final moduleDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<ModuleDetailViewModel, ModuleDetailViewModelState, int>(
  (ref, moduleId) {
    final getModuleWithConfigUseCase = ref.watch(getModuleWithConfigUseCaseProvider);
    final viewModel = ModuleDetailViewModel(getModuleWithConfigUseCase);
    viewModel.loadModuleWithConfig(moduleId);
    return viewModel;
  },
);

// Utiliser le provider existant du UseCase défini dans domain_module.dart