// créer le modele pour sites_group_module
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sites_group_module.freezed.dart';

@freezed
class SitesGroupModule with _$SitesGroupModule {
  const factory SitesGroupModule({
    required int idSitesGroup,
    required int idModule,
  }) = _SitesGroupModule;
}
