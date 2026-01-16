import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Widget Boussole pour la carte
/// Affiche une boussole qui indique le nord et permet de réorienter la carte
class CompassWidget extends StatefulWidget {
  final MapController mapController;

  const CompassWidget({super.key, required this.mapController});

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  double currentRotation = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Écoute les mouvements et rotations de la carte
    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMove || event is MapEventRotate) {
        setState(() {
          currentRotation = widget.mapController.camera.rotationRad;
        });
      }
    });
  }

  void resetNorth() {
    final startRotation = widget.mapController.camera.rotation;
    final endRotation = 0.0;

    _rotationAnimation = Tween<double>(
      begin: startRotation,
      end: endRotation,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
        widget.mapController.rotate(_rotationAnimation.value);
      });

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: GestureDetector(
        onTap: resetNorth,
        child: Transform.rotate(
          angle: currentRotation,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.navigation, color: Colors.red, size: 28),
          ),
        ),
      ),
    );
  }
}
