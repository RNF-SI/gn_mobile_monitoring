import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_cache_manager.dart';

void main() {
  group('SyncCacheManager', () {
    tearDown(() {
      // Clear failure stats after each test
      SyncCacheManager.clearFailureStats();
    });

    group('Failure count tracking', () {
      test('should track visit failure counts', () {
        const visitId = 123;
        
        expect(SyncCacheManager.getVisitFailureCount(visitId), 0);
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 2);
      });

      test('should track observation failure counts', () {
        const observationId = 456;
        
        expect(SyncCacheManager.getObservationFailureCount(observationId), 0);
        
        SyncCacheManager.incrementObservationFailureCount(observationId);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 1);
        
        SyncCacheManager.incrementObservationFailureCount(observationId);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 2);
      });

      test('should provide failure statistics', () {
        const visitId = 789;
        const observationId = 999;
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        SyncCacheManager.incrementVisitFailureCount(visitId);
        SyncCacheManager.incrementObservationFailureCount(observationId);
        
        final stats = SyncCacheManager.getFailureStats();
        
        expect(stats['visitFailureCounts'][visitId], 2);
        expect(stats['observationFailureCounts'][observationId], 1);
      });

      test('should clear failure statistics', () {
        const visitId = 111;
        const observationId = 222;
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        SyncCacheManager.incrementObservationFailureCount(observationId);
        
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 1);
        
        SyncCacheManager.clearFailureStats();
        
        expect(SyncCacheManager.getVisitFailureCount(visitId), 0);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 0);
      });
    });

    group('Deprecated methods behavior', () {
      test('isVisitFailed should always return false', () {
        const visitId = 123;
        
        // Même après avoir "marqué" comme échoué, retourne false
        SyncCacheManager.markVisitAsFailed(visitId);
        expect(SyncCacheManager.isVisitFailed(visitId), isFalse);
      });

      test('isObservationFailed should always return false', () {
        const observationId = 456;
        
        // Même après avoir "marqué" comme échoué, retourne false
        SyncCacheManager.markObservationAsFailed(observationId);
        expect(SyncCacheManager.isObservationFailed(observationId), isFalse);
      });

      test('resetForNewSyncSession should not affect failure counts', () {
        const visitId = 789;
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
        
        // L'ancienne méthode de reset ne fait plus rien
        SyncCacheManager.resetForNewSyncSession();
        
        // Les compteurs restent intacts
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
      });

      test('getCacheStats should delegate to getFailureStats', () {
        const visitId = 111;
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        
        final deprecatedStats = SyncCacheManager.getCacheStats();
        final newStats = SyncCacheManager.getFailureStats();
        
        expect(deprecatedStats['visitFailureCounts'], newStats['visitFailureCounts']);
        expect(deprecatedStats['observationFailureCounts'], newStats['observationFailureCounts']);
      });
    });

    group('Edge cases', () {
      test('should handle negative IDs', () {
        const visitId = -1;
        
        expect(() => SyncCacheManager.incrementVisitFailureCount(visitId), returnsNormally);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
      });

      test('should handle zero IDs', () {
        const observationId = 0;
        
        expect(() => SyncCacheManager.incrementObservationFailureCount(observationId), returnsNormally);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 1);
      });

      test('should handle large IDs', () {
        const largeId = 999999999;
        
        SyncCacheManager.incrementVisitFailureCount(largeId);
        expect(SyncCacheManager.getVisitFailureCount(largeId), 1);
      });
    });
  });
}