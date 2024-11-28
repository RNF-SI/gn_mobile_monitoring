import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_database_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

final databaseServiceProvider =
    StateNotifierProvider<DatabaseService, custom_async_state.State<void>>(
        (ref) {
  return DatabaseService(
    ref,
    ref.watch(deleteDatabaseUseCaseProvider),
  );
});

class DatabaseService extends StateNotifier<custom_async_state.State<void>> {
  final DeleteDatabaseUseCase _deleteDatabaseUseCase;

  DatabaseService(
    this.ref,
    this._deleteDatabaseUseCase,
  ) : super(const custom_async_state.State.init());

  final Ref ref;

  Future<void> deleteDatabase() async {
    state = const custom_async_state.State.loading();
    try {
      await _deleteDatabaseUseCase.execute();
      state = const custom_async_state.State.success(null);
    } on Exception catch (e) {
      state = custom_async_state.State.error(e);
    }
  }
}
