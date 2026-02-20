import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/service/geojson_parser_service.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case.dart';

/// Implémentation du use case pour charger les features de la carte.
class LoadMapFeaturesUseCaseImpl implements LoadMapFeaturesUseCase {
  final GeoJsonParserService _geoJsonParserService;

  const LoadMapFeaturesUseCaseImpl(this._geoJsonParserService);

  @override
  List<MapFeature> execute(String? geoJsonData) {
    return _geoJsonParserService.parseGeoJson(geoJsonData);
  }
}
