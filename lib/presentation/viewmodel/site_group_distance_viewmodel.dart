import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/calculate_distance_usecase.dart';

/// État des distances des groupes de sites
class SiteGroupDistanceState {
  final Map<int, double?> distances;
  final bool isCalculating;
  final Position? userPosition;
  final String? error;

  const SiteGroupDistanceState({
    this.distances = const {},
    this.isCalculating = false,
    this.userPosition,
    this.error,
  });

  SiteGroupDistanceState copyWith({
    Map<int, double?>? distances,
    bool? isCalculating,
    Position? userPosition,
    String? error,
  }) {
    return SiteGroupDistanceState(
      distances: distances ?? this.distances,
      isCalculating: isCalculating ?? this.isCalculating,
      userPosition: userPosition ?? this.userPosition,
      error: error,
    );
  }
}

// Provider pour le ViewModel
final siteGroupDistanceViewModelProvider = StateNotifierProvider<
    SiteGroupDistanceViewModel, SiteGroupDistanceState>(
  (ref) => SiteGroupDistanceViewModel(
    ref.watch(calculateDistanceUseCaseProvider),
  ),
);

/// ViewModel pour gérer les distances des groupes de sites
/// Respecte la Clean Architecture en séparant l'état de la logique métier
class SiteGroupDistanceViewModel extends StateNotifier<SiteGroupDistanceState> {
  final CalculateDistanceUseCase _calculateDistanceUseCase;

  SiteGroupDistanceViewModel(this._calculateDistanceUseCase)
      : super(const SiteGroupDistanceState());

  /// Met à jour la position de l'utilisateur
  void updateUserPosition(Position position) {
    state = state.copyWith(
      userPosition: position,
      error: null,
    );
  }

  /// Calcule les distances pour une liste de groupes
  Future<void> calculateDistances(List<SiteGroup> groups) async {
    if (state.userPosition == null) {
      state = state.copyWith(
        error: 'Position utilisateur non disponible',
      );
      return;
    }

    state = state.copyWith(
      isCalculating: true,
      error: null,
    );

    try {
      final distances = await _calculateDistanceUseCase.calculateGroupDistances(
        groups,
        state.userPosition!,
      );

      state = state.copyWith(
        distances: distances,
        isCalculating: false,
      );
    } catch (e) {
      debugPrint('Erreur lors du calcul des distances: $e');
      state = state.copyWith(
        isCalculating: false,
        error: 'Erreur lors du calcul des distances: $e',
      );
    }
  }

  /// Calcule la distance pour un seul groupe
  Future<double?> calculateSingleDistance(SiteGroup group) async {
    if (state.userPosition == null) {
      return null;
    }

    try {
      final distance = await _calculateDistanceUseCase.calculateGroupDistance(
        group,
        state.userPosition!,
      );

      // Mettre à jour l'état avec la nouvelle distance
      state = state.copyWith(
        distances: {
          ...state.distances,
          group.idSitesGroup: distance,
        },
      );

      return distance;
    } catch (e) {
      debugPrint('Erreur lors du calcul de la distance pour le groupe ${group.idSitesGroup}: $e');
      return null;
    }
  }

  /// Trie les groupes par distance
  List<SiteGroup> sortGroupsByDistance(List<SiteGroup> groups) {
    return _calculateDistanceUseCase.sortGroupsByDistance(groups, state.distances);
  }

  /// Obtient la distance pour un groupe spécifique
  double? getDistanceForGroup(int groupId) {
    return state.distances[groupId];
  }

  /// Vérifie si les distances sont disponibles pour tous les groupes
  bool hasDistancesForGroups(List<SiteGroup> groups) {
    return groups.every((group) => state.distances.containsKey(group.idSitesGroup));
  }

  /// Vide le cache des distances
  void clearDistances() {
    _calculateDistanceUseCase.clearCache();
    state = const SiteGroupDistanceState();
  }

  /// Formate la distance pour l'affichage
  String formatDistance(double? distanceInMeters) {
    if (distanceInMeters == null) {
      return '';
    }

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }
}