import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';

/// Implémentation du use case pour charger les couches de tuiles.
class LoadMapTileLayersUseCaseImpl implements LoadMapTileLayersUseCase {
  const LoadMapTileLayersUseCaseImpl();

  @override
  Future<List<TileLayerConfig>> execute() async {
    try {
      final jsonString = await rootBundle.loadString('assets/settings.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final layers = jsonData['layers'] as List<dynamic>? ?? [];

      return layers
          .map<TileLayerConfig>((e) => TileLayerConfig(
                name: e['name'] as String? ?? 'Layer',
                urlTemplate: e['urlTemplate'] as String? ?? '',
                attribution: e['attribution'] as String? ?? '',
              ))
          .where((layer) => layer.urlTemplate.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('LoadMapTileLayersUseCase: Erreur chargement settings.json: $e');
      return [];
    }
  }
}
