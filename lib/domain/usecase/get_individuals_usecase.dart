import 'package:gn_mobile_monitoring/domain/model/individual.dart';

abstract class GetIndividualsUseCase {
  Future<List<Individual>> execute();
}
