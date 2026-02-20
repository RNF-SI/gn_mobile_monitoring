/// Configuration d'une couche de tuiles de carte.
class TileLayerConfig {
  final String name;
  final String urlTemplate;
  final String attribution;

  const TileLayerConfig({
    required this.name,
    required this.urlTemplate,
    this.attribution = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileLayerConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          urlTemplate == other.urlTemplate &&
          attribution == other.attribution;

  @override
  int get hashCode => name.hashCode ^ urlTemplate.hashCode ^ attribution.hashCode;
}

/// Use case pour charger les couches de tuiles de la carte.
abstract class LoadMapTileLayersUseCase {
  /// Charge les couches de tuiles depuis la configuration.
  /// Retourne une liste de TileLayerConfig.
  Future<List<TileLayerConfig>> execute();
}
