import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/helpers/compass_accuracy.dart';

// Tailwind palette pinned as hex for deterministic rendering across themes.
const Color _emerald500 = Color(0xFF10B981);
const Color _amber500 = Color(0xFFF59E0B);
const Color _rose500 = Color(0xFFF43F5E);
const Color _slate400 = Color(0xFF94A3B8);

// Zero-blur white shadow stamps at 8 offsets — synthesize a uniform 1.5px
// outline around any glyph (classic "text-stroke via shadows" trick).
const List<Shadow> _stickerOutline = <Shadow>[
  Shadow(color: Colors.white, offset: Offset(-1.5, 0)),
  Shadow(color: Colors.white, offset: Offset(1.5, 0)),
  Shadow(color: Colors.white, offset: Offset(0, -1.5)),
  Shadow(color: Colors.white, offset: Offset(0, 1.5)),
  Shadow(color: Colors.white, offset: Offset(-1, -1)),
  Shadow(color: Colors.white, offset: Offset(1, -1)),
  Shadow(color: Colors.white, offset: Offset(-1, 1)),
  Shadow(color: Colors.white, offset: Offset(1, 1)),
];

// TODO: When the reactive map-container border lands, drive its color/animation
// from this same `accuracy` state so the border reinforces the dot.
class CompassAccuracyIndicator extends StatefulWidget {
  const CompassAccuracyIndicator({
    required this.accuracy,
    required this.onTap,
    required this.semanticLabel,
    this.onLongPress,
    super.key,
  });

  final CompassAccuracy accuracy;
  final VoidCallback onTap;
  final String semanticLabel;
  final VoidCallback? onLongPress;

  @override
  State<CompassAccuracyIndicator> createState() =>
      _CompassAccuracyIndicatorState();
}

class _CompassAccuracyIndicatorState extends State<CompassAccuracyIndicator>
    with SingleTickerProviderStateMixin {
  static const double _iconSize = 22.0;
  static const double _hitSize = 44.0;
  static const double _pulseStartSize = 24.0;
  static const double _pulseMaxSize = 42.0;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _syncPulseWithAccuracy();
  }

  @override
  void didUpdateWidget(CompassAccuracyIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accuracy != widget.accuracy) {
      _syncPulseWithAccuracy();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _syncPulseWithAccuracy() {
    if (widget.accuracy == CompassAccuracy.poor) {
      unawaited(_pulseController.repeat());
    } else {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  Color _stateColor() {
    switch (widget.accuracy) {
      case CompassAccuracy.good:
        return _emerald500;
      case CompassAccuracy.moderate:
        return _amber500;
      case CompassAccuracy.poor:
        return _rose500;
      case CompassAccuracy.unknown:
        return _slate400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color stateColor = _stateColor();
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: SizedBox(
          width: _hitSize,
          height: _hitSize,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (widget.accuracy == CompassAccuracy.poor)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (BuildContext context, Widget? child) {
                      final double t = _pulseController.value;
                      final double size = _pulseStartSize +
                          t * (_pulseMaxSize - _pulseStartSize);
                      final double opacity = (1 - t) * 0.7;
                      return IgnorePointer(
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: stateColor.withValues(alpha: opacity),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Icon(
                  TablerIcons.wave_sine,
                  size: _iconSize,
                  color: stateColor,
                  shadows: _stickerOutline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
