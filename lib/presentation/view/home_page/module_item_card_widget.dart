import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_download_button.dart';

class ModuleItemCardWidget extends ConsumerStatefulWidget {
  const ModuleItemCardWidget({super.key, required this.moduleInfo});

  final ModuleInfo moduleInfo;

  @override
  ConsumerState<ModuleItemCardWidget> createState() =>
      _ModuleItemCardWidgetState();
}

class _ModuleItemCardWidgetState extends ConsumerState<ModuleItemCardWidget> {
  late Color _cardColor;
  Timer? _longPressTimer;
  double _pressProgress = 0;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _cardColor = Colors.white;
  }

  void _startLongPress() {
    _pressProgress = 0;
    _isLongPressed = true;
    
    _longPressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _pressProgress += 0.1 / 4; // 4 secondes = 40 étapes
        });

        if (_pressProgress >= 1.0) {
          setState(() {
            _cardColor = Colors.pinkAccent; // 🎨 Rose après 4 secondes
          });
          timer.cancel();
        }
      }
    });
  }

  void _cancelLongPress() {
    _longPressTimer?.cancel();
    if (mounted) {
      setState(() {
        _pressProgress = 0;
        _isLongPressed = false;
        // Si pas encore rose, revenir au blanc
        if (_cardColor != Colors.pinkAccent) {
          _cardColor = Colors.white;
        }
      });
    }
  }

  void _resetColor() {
    if (mounted) {
      setState(() {
        _cardColor = Colors.white;
        _pressProgress = 0;
        _isLongPressed = false;
      });
    }
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startLongPress(),
      onLongPressEnd: (_) => _cancelLongPress(),
      onLongPressCancel: _cancelLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 4,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.moduleInfo.module.moduleLabel ?? 'Module sans nom',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  // ✅ MODIFICATION : Changer la couleur du titre en Unicorn Mode
                                color: _cardColor == Colors.pinkAccent
                                  ? const Color.fromARGB(255, 255, 246, 250)
                                  : const Color(0xFF598979), // Brand color
                            ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.moduleInfo.module.moduleDesc ??
                              'Pas de description disponible',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            // ✅ Changer la couleur de la description en Unicorn Mode
                            color: _cardColor == Colors.pinkAccent
                              ? const Color.fromARGB(255, 255, 246, 250)  // 🦄 Couleur Unicorn Mode
                              : null, // Couleur par défaut
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 96,
                    child: ModuleDownloadButton(
                        moduleInfo: widget.moduleInfo),
                  )
                ],
              ),
              // ✅ Barre de progression visuelle pendant le long-press
              if (_isLongPressed && _pressProgress < 1.0)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _pressProgress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.pinkAccent,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          // '${(_pressProgress * 100).toStringAsFixed(0)}%',
                          '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.pinkAccent.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              // ✅ Message de confirmation quand rose
              if (_cardColor == Colors.pinkAccent)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Icon(Icons.check_circle, color: Colors.pinkAccent.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '🦄 Unicorn Mode',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 246, 250),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: _resetColor,
                          child: Text(
                            'Réinitialiser',
                            style: TextStyle(color: const Color.fromARGB(255, 255, 246, 250)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}