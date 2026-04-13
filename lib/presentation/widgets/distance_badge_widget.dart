import 'package:flutter/material.dart';

/// Widget pour afficher un badge de distance
class DistanceBadgeWidget extends StatelessWidget {
  final double? distanceInMeters;

  const DistanceBadgeWidget({
    super.key,
    required this.distanceInMeters,
  });

  @override
  Widget build(BuildContext context) {
    if (distanceInMeters == null) {
      return const SizedBox.shrink();
    }

    String distanceText;
    if (distanceInMeters! < 1000) {
      distanceText = '${distanceInMeters!.toStringAsFixed(0)} m';
    } else {
      distanceText = '${(distanceInMeters! / 1000).toStringAsFixed(1)} km';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 14,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            distanceText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
