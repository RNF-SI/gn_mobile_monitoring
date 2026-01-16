import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/service/map_geometry_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:latlong2/latlong.dart';

void main() {
  late MapGeometryService service;

  setUp(() {
    service = const MapGeometryServiceImpl();
  });

  group('MapGeometryService', () {
    group('calculateCentroid', () {
      test('should return (0, 0) for empty list', () {
        final result = service.calculateCentroid([]);
        expect(result.latitude, 0);
        expect(result.longitude, 0);
      });

      test('should return the point itself for single point', () {
        final point = const LatLng(48.85, 2.35);
        final result = service.calculateCentroid([point]);
        expect(result.latitude, 48.85);
        expect(result.longitude, 2.35);
      });

      test('should calculate centroid for multiple points', () {
        final points = [
          const LatLng(0, 0),
          const LatLng(0, 10),
          const LatLng(10, 10),
          const LatLng(10, 0),
        ];
        final result = service.calculateCentroid(points);
        expect(result.latitude, 5.0);
        expect(result.longitude, 5.0);
      });

      test('should calculate centroid for triangle', () {
        final points = [
          const LatLng(0, 0),
          const LatLng(3, 0),
          const LatLng(0, 3),
        ];
        final result = service.calculateCentroid(points);
        expect(result.latitude, 1.0);
        expect(result.longitude, 1.0);
      });
    });

    group('computeBounds', () {
      test('should return null for empty list', () {
        final result = service.computeBounds([]);
        expect(result, isNull);
      });

      test('should return correct bounds for multiple points', () {
        final points = [
          const LatLng(10, 20),
          const LatLng(30, 40),
          const LatLng(15, 25),
        ];
        final result = service.computeBounds(points);
        expect(result, isNotNull);
        expect(result!.southWest.latitude, 10);
        expect(result.southWest.longitude, 20);
        expect(result.northEast.latitude, 30);
        expect(result.northEast.longitude, 40);
      });

      test('should return same point as bounds for single point', () {
        final points = [const LatLng(48.85, 2.35)];
        final result = service.computeBounds(points);
        expect(result, isNotNull);
        expect(result!.southWest.latitude, 48.85);
        expect(result.southWest.longitude, 2.35);
        expect(result.northEast.latitude, 48.85);
        expect(result.northEast.longitude, 2.35);
      });
    });

    group('isPointInPolygon', () {
      final squarePolygon = [
        const LatLng(0, 0),
        const LatLng(0, 10),
        const LatLng(10, 10),
        const LatLng(10, 0),
      ];

      test('should return true for point inside polygon', () {
        final point = const LatLng(5, 5);
        final result = service.isPointInPolygon(point, squarePolygon);
        expect(result, isTrue);
      });

      test('should return false for point outside polygon', () {
        final point = const LatLng(15, 15);
        final result = service.isPointInPolygon(point, squarePolygon);
        expect(result, isFalse);
      });

      test('should return false for point clearly outside', () {
        final point = const LatLng(-5, -5);
        final result = service.isPointInPolygon(point, squarePolygon);
        expect(result, isFalse);
      });

      test('should return false for polygon with less than 3 points', () {
        final point = const LatLng(5, 5);
        final invalidPolygon = [
          const LatLng(0, 0),
          const LatLng(10, 10),
        ];
        final result = service.isPointInPolygon(point, invalidPolygon);
        expect(result, isFalse);
      });

      test('should handle concave polygon', () {
        // L-shaped polygon
        final concavePolygon = [
          const LatLng(0, 0),
          const LatLng(0, 10),
          const LatLng(5, 10),
          const LatLng(5, 5),
          const LatLng(10, 5),
          const LatLng(10, 0),
        ];

        // Point inside the L
        expect(service.isPointInPolygon(const LatLng(2, 2), concavePolygon), isTrue);
        // Point in the "cut-out" area
        expect(service.isPointInPolygon(const LatLng(7, 7), concavePolygon), isFalse);
      });
    });

    group('distanceBetween', () {
      test('should return 0 for same point', () {
        final point = const LatLng(48.85, 2.35);
        final result = service.distanceBetween(point, point);
        expect(result, 0);
      });

      test('should return positive distance for different points', () {
        final point1 = const LatLng(48.85, 2.35);
        final point2 = const LatLng(48.86, 2.36);
        final result = service.distanceBetween(point1, point2);
        expect(result, greaterThan(0));
      });

      test('should be approximately correct for known distance', () {
        // Paris to Lyon is approximately 392 km
        final paris = const LatLng(48.8566, 2.3522);
        final lyon = const LatLng(45.7640, 4.8357);
        final result = service.distanceBetween(paris, lyon);
        // Check it's roughly correct (between 380 and 420 km)
        expect(result, greaterThan(380000));
        expect(result, lessThan(420000));
      });
    });

    group('distanceToLine', () {
      test('should return infinity for empty line', () {
        final point = const LatLng(5, 5);
        final result = service.distanceToLine(point, []);
        expect(result, double.infinity);
      });

      test('should return distance to single point', () {
        final point = const LatLng(5, 5);
        final linePoints = [const LatLng(0, 0)];
        final result = service.distanceToLine(point, linePoints);
        expect(result, greaterThan(0));
      });

      test('should return 0 for point on line', () {
        final point = const LatLng(5, 5);
        final linePoints = [
          const LatLng(0, 0),
          const LatLng(10, 10),
        ];
        final result = service.distanceToLine(point, linePoints);
        // Should be very close to 0 (allowing for floating point errors)
        expect(result, lessThan(1)); // Less than 1 meter
      });

      test('should calculate perpendicular distance', () {
        final point = const LatLng(5, 0);
        final linePoints = [
          const LatLng(0, 5),
          const LatLng(10, 5),
        ];
        final result = service.distanceToLine(point, linePoints);
        // Should be approximately 5 degrees in latitude (~555 km)
        expect(result, greaterThan(500000));
        expect(result, lessThan(600000));
      });
    });

    group('isPointNearTarget', () {
      test('should return true for same point', () {
        final point = const LatLng(48.85, 2.35);
        final result = service.isPointNearTarget(point, point, 0.001);
        expect(result, isTrue);
      });

      test('should return true for point within threshold', () {
        final point = const LatLng(48.85, 2.35);
        final target = const LatLng(48.8501, 2.3501);
        final result = service.isPointNearTarget(point, target, 0.01);
        expect(result, isTrue);
      });

      test('should return false for point outside threshold', () {
        final point = const LatLng(48.85, 2.35);
        final target = const LatLng(48.90, 2.40);
        final result = service.isPointNearTarget(point, target, 0.01);
        expect(result, isFalse);
      });
    });
  });

  group('LatLngBounds', () {
    test('should create bounds from points', () {
      final points = [
        const LatLng(10, 20),
        const LatLng(30, 40),
        const LatLng(15, 25),
      ];
      final bounds = LatLngBounds.fromPoints(points);
      expect(bounds.southWest.latitude, 10);
      expect(bounds.southWest.longitude, 20);
      expect(bounds.northEast.latitude, 30);
      expect(bounds.northEast.longitude, 40);
    });

    test('should calculate center correctly', () {
      final bounds = LatLngBounds(
        southWest: const LatLng(0, 0),
        northEast: const LatLng(10, 20),
      );
      expect(bounds.center.latitude, 5);
      expect(bounds.center.longitude, 10);
    });

    test('should throw for empty points list', () {
      expect(
        () => LatLngBounds.fromPoints([]),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
