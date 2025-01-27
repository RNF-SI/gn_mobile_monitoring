import 'package:freezed_annotation/freezed_annotation.dart';

part 'site_module.freezed.dart';

@freezed
class SiteModule with _$SiteModule {
  const factory SiteModule({
    required int idSite,
    required int idModule,
  }) = _SiteModule;
}
