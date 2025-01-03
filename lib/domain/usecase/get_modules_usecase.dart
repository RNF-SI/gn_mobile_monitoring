import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class GetModulesUseCase {
  Future<List<Module>> execute();
}
