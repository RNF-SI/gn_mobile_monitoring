import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:latlong2/latlong.dart';

/// Implémentation du use case pour la localisation utilisateur.
class GetUserLocationUseCaseImpl implements GetUserLocationUseCase {
  const GetUserLocationUseCaseImpl();

  @override
  Future<UserLocationResult?> execute() async {
    try {
      // Vérifier si le service GPS est activé
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('GetUserLocationUseCase: GPS désactivé');
        return null;
      }

      // Vérifier les permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('GetUserLocationUseCase: Permission refusée');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('GetUserLocationUseCase: Permission bloquée définitivement');
        return null;
      }

      // Récupérer la position
      final position = await Geolocator.getCurrentPosition();
      return UserLocationResult(
        position: LatLng(position.latitude, position.longitude),
        accuracy: position.accuracy,
      );
    } catch (e) {
      debugPrint('GetUserLocationUseCase: Erreur localisation: $e');
      return null;
    }
  }

  @override
  Stream<UserLocationResult> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2, // mise à jour tous les 2 m
      ),
    ).map((position) => UserLocationResult(
          position: LatLng(position.latitude, position.longitude),
          accuracy: position.accuracy,
        ));
  }

  @override
  Future<bool> isLocationAvailable() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }
}
