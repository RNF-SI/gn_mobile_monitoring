import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_cache_manager.dart';

void main() {
  group('SyncCacheManager', () {
    tearDown(() {
      // Reset cache after each test
      SyncCacheManager.resetForNewSyncSession();
    });

    group('Visit failure tracking', () {
      test('should track visit failures', () {
        const visitId = 123;
        
        expect(SyncCacheManager.isVisitFailed(visitId), isFalse);
        
        SyncCacheManager.markVisitAsFailed(visitId);
        
        expect(SyncCacheManager.isVisitFailed(visitId), isTrue);
      });

      test('should increment failure count', () {
        const visitId = 456;
        
        expect(SyncCacheManager.getVisitFailureCount(visitId), 0);
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 1);
        
        SyncCacheManager.incrementVisitFailureCount(visitId);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 2);
      });

      test('should remove visit from failed cache', () {
        const visitId = 789;
        
        SyncCacheManager.markVisitAsFailed(visitId);
        expect(SyncCacheManager.isVisitFailed(visitId), isTrue);
        
        SyncCacheManager.removeFromFailedCache(visitId);
        expect(SyncCacheManager.isVisitFailed(visitId), isFalse);
      });
    });

    group('Observation failure tracking', () {
      test('should track observation failures', () {
        const observationId = 222;
        
        expect(SyncCacheManager.isObservationFailed(observationId), isFalse);
        
        SyncCacheManager.markObservationAsFailed(observationId);
        
        expect(SyncCacheManager.isObservationFailed(observationId), isTrue);
      });

      test('should increment observation failure count', () {
        const observationId = 333;
        
        expect(SyncCacheManager.getObservationFailureCount(observationId), 0);
        
        SyncCacheManager.incrementObservationFailureCount(observationId);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 1);
        
        SyncCacheManager.incrementObservationFailureCount(observationId);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 2);
      });

      test('should remove observation from failed cache', () {
        const observationId = 444;
        
        SyncCacheManager.markObservationAsFailed(observationId);
        expect(SyncCacheManager.isObservationFailed(observationId), isTrue);
        
        SyncCacheManager.removeObservationFromFailedCache(observationId);
        expect(SyncCacheManager.isObservationFailed(observationId), isFalse);
      });
    });

    group('Session management', () {
      test('should reset all caches for new sync session', () {
        const visitId = 555;
        const observationId = 666;
        
        // Mark items as failed
        SyncCacheManager.markVisitAsFailed(visitId);
        SyncCacheManager.markObservationAsFailed(observationId);
        
        expect(SyncCacheManager.isVisitFailed(visitId), isTrue);
        expect(SyncCacheManager.isObservationFailed(observationId), isTrue);
        
        // Reset session
        SyncCacheManager.resetForNewSyncSession();
        
        expect(SyncCacheManager.isVisitFailed(visitId), isFalse);
        expect(SyncCacheManager.isObservationFailed(observationId), isFalse);
        expect(SyncCacheManager.getVisitFailureCount(visitId), 0);
        expect(SyncCacheManager.getObservationFailureCount(observationId), 0);
      });

      test('should get cache statistics', () {
        SyncCacheManager.markVisitAsFailed(1);
        SyncCacheManager.markVisitAsFailed(2);
        SyncCacheManager.markObservationAsFailed(10);
        
        final stats = SyncCacheManager.getCacheStats();
        
        expect(stats['failedVisits'], 2);
        expect(stats['failedObservations'], 1);
        expect(stats.containsKey('visitFailureCounts'), isTrue);
        expect(stats.containsKey('observationFailureCounts'), isTrue);
      });
    });

    group('Edge cases', () {
      test('should handle negative IDs', () {
        const visitId = -1;
        
        expect(() => SyncCacheManager.markVisitAsFailed(visitId), returnsNormally);
        expect(SyncCacheManager.isVisitFailed(visitId), isTrue);
      });

      test('should handle zero IDs', () {
        const observationId = 0;
        
        expect(() => SyncCacheManager.markObservationAsFailed(observationId), returnsNormally);
        expect(SyncCacheManager.isObservationFailed(observationId), isTrue);
      });

      test('should handle large IDs', () {
        const largeId = 999999999;
        
        SyncCacheManager.markVisitAsFailed(largeId);
        expect(SyncCacheManager.isVisitFailed(largeId), isTrue);
      });
    });
  });
}