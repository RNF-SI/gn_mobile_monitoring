import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

final databaseServiceProvider =
    StateNotifierProvider<DatabaseService, custom_async_state.State<void>>(
        (ref) {
  return DatabaseService(
    ref,
    ref.watch(initLocalMonitoringDataBaseUseCaseProvider),
    ref.watch(deleteLocalMonitoringDatabaseUseCaseProvider),
  );
});

class DatabaseService extends StateNotifier<custom_async_state.State<void>> {
  final InitLocalMonitoringDataBaseUseCase _initLocalMonitoringDataBaseUseCase;
  final DeleteLocalMonitoringDatabaseUseCase
      _deleteLocalMonitoringDatabaseUseCase;

  DatabaseService(
    this.ref,
    this._initLocalMonitoringDataBaseUseCase,
    this._deleteLocalMonitoringDatabaseUseCase,
  ) : super(const custom_async_state.State.init()) {
    _init();
  }

  final Ref ref;

  Future<void> _init() async {
    state = const custom_async_state.State.loading();
    try {
      await _initLocalMonitoringDataBaseUseCase.execute();
    } catch (e, stackTrace) {
      print("Error during initialization: $e");
      print(stackTrace);
      state = custom_async_state.State.error(
          Exception("Failed to initialize database"));
    }
  }

  Future<void> deleteAndReinitializeDatabase() async {
    state = const custom_async_state.State.loading();
    try {
      await _deleteLocalMonitoringDatabaseUseCase.execute();
      await _initLocalMonitoringDataBaseUseCase.execute();
      print("Database successfully deleted and reinitialized");
      state = const custom_async_state.State.success(null);
    } catch (e) {
      print("Error during database reinitialization: $e");
      state = custom_async_state.State.error(Exception(e));
    }
  }
}
