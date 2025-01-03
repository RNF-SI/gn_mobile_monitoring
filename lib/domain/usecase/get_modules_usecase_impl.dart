import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';

class GetModulesUseCaseImpl implements GetModulesUseCase {
  final ModulesRepository _repository;

  const GetModulesUseCaseImpl(this._repository);

  @override
  Future<List<Module>> execute() async {
    return await _repository.getModulesFromLocal();
  }
}
