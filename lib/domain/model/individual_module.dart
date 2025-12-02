import 'package:freezed_annotation/freezed_annotation.dart';

part 'individual_module.freezed.dart';

@freezed
class IndividualModule with _$IndividualModule {
  const factory IndividualModule({
    required int idIndividual,
    required int idModule,
  }) = _IndividualModule;
}
