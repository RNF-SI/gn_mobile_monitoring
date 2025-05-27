import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

/// Use case pour effectuer une synchronisation complète de tous les modules
abstract class SyncCompleteUseCase {
  /// Effectue une synchronisation complète de toutes les visites
  /// en itérant sur tous les modules disponibles
  Future<SyncResult> execute(String token);
}