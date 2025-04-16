import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxon_download_status.freezed.dart';

@freezed
class TaxonDownloadStatus with _$TaxonDownloadStatus {
  const factory TaxonDownloadStatus.initial() = _Initial;
  const factory TaxonDownloadStatus.loading() = _Loading;
  const factory TaxonDownloadStatus.success() = _Success;
  const factory TaxonDownloadStatus.error(String message) = _Error;
}