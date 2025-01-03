import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class ModulesDatabase {
  Future<List<Module>> getModules();
}
