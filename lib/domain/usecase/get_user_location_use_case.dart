import 'package:latlong2/latlong.dart';

/// Résultat de la récupération de la position utilisateur.
class UserLocationResult {
  final LatLng position;
  final double accuracy;

  const UserLocationResult({
    required this.position,
    required this.accuracy,
  });
}

/// Use case pour récupérer la position GPS de l'utilisateur.
abstract class GetUserLocationUseCase {
  /// Récupère la position actuelle de l'utilisateur.
  /// Retourne null si le GPS est désactivé ou si les permissions sont refusées.
  Future<UserLocationResult?> execute();

  /// Retourne un stream de positions pour le tracking en temps réel.
  /// Le stream émet des UserLocationResult à chaque mise à jour de position.
  Stream<UserLocationResult> watchPosition();

  /// Vérifie si le service GPS est disponible et si les permissions sont accordées.
  Future<bool> isLocationAvailable();
}
