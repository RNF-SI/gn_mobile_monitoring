import 'package:freezed_annotation/freezed_annotation.dart';

part 'site_complement.freezed.dart';

@freezed
class SiteComplement with _$SiteComplement {
  const factory SiteComplement({
    required int idBaseSite,
    int? idSitesGroup,
    String? data,
  }) = _SiteComplement;
}
