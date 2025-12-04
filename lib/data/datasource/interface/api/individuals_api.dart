import 'package:gn_mobile_monitoring/data/entity/individuals_with_modules.dart';

abstract class IndividualsApi {
  /// Fetches individuals for a specific module with detailed information
  Future<List<IndividualsWithModulesLabel>> fetchEnrichedIndividualsForModule(
    String moduleCode, String token);
    }