import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';

class IndividualsWithModulesLabel {
  final IndividualEntity individual;
  final List<String> moduleLabelList;

  IndividualsWithModulesLabel({
    required this.individual,
    required this.moduleLabelList,
  });

  factory IndividualsWithModulesLabel.fromJson(Map<String, dynamic> json) {
    return IndividualsWithModulesLabel(
      individual: IndividualEntity.fromJson(json),
      moduleLabelList: (json['modules'] as List<dynamic>).cast<String>(),
    );
  }
}