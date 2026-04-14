import 'dart:async';

import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:latlong2/latlong.dart';

/// Implémentation stub du use case de localisation, utilisée par les tests
/// E2E pour éviter l'appel réel à `Geolocator` (qui échoue silencieusement
/// sur un device de test et désactive tous les boutons dépendant du GPS).
///
/// Par défaut, retourne la position de Paris (48.8566, 2.3522) avec une
/// précision de 5 m. Les tests peuvent passer une [position] spécifique
/// pour contrôler la géographie (p. ex. simuler un utilisateur à côté
/// d'un site donné).
class FakeGetUserLocation implements GetUserLocationUseCase {
  final LatLng position;
  final double accuracy;

  const FakeGetUserLocation({
    this.position = const LatLng(48.8566, 2.3522),
    this.accuracy = 5,
  });

  @override
  Future<UserLocationResult?> execute() async {
    return UserLocationResult(position: position, accuracy: accuracy);
  }

  @override
  Future<bool> isLocationAvailable() async => true;

  @override
  Stream<UserLocationResult> watchPosition() =>
      Stream.value(UserLocationResult(position: position, accuracy: accuracy));
}
