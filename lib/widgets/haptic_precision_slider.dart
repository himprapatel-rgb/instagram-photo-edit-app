import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// A production-ready, high-performance precision slider widget
/// Uses a custom [RenderBox] to draw the ruler ticks efficiently
/// Provides haptic feedback for professional tactile experience
const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF121212);

class HapticPrecisionSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color accentColor;
  final double height;

  const HapticPrecisionSlider({
    Key? key,
    required this.value,
    this.min = -100,
    this.max = 100,
    required this.onChanged,
    this.accentColor = kAccentColor,
    this.height = 60,
  }) : super(key: key);

  @override
  State<HapticPrecisionSlider> createState() => _HapticPrecisionSliderState();
}

class _HapticPrecisionSliderState extends State<HapticPrecisionSlider> {
  double _currentValue = 0;
  int _lastTickTriggered = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _lastTickTriggered = widget.value.round();
  }

  @override
  void didUpdateWidget(HapticPrecisionSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;
    }
  }

  void _triggerHaptic(int newTick) {
    if (newTick != _lastTickTriggered) {
      // Major tick every 10 units
      if (newTick % 10 == 0) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
      _lastTickTriggered = newTick;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.transparent,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          final sensitivity = 0.5; // pixels per unit
          final delta = -details.delta.dx * sensitivity;
          final newValue = (_currentValue + delta).clamp(widget.min, widget.max);
          
          setState(() {
            _currentValue = newValue;
          });
          
          _triggerHaptic(newValue.round());
          widget.onChanged(newValue);
        },
        child: _PrecisionRuler(
          value: _currentValue,
          min: widget.min,
          max: widget.max,
          accentColor: widget.accentColor,
        ),
      ),
    );
  }
}

/// Custom RenderBox for high-performance ruler drawing
class _PrecisionRuler extends LeafRenderObjectWidget {
  final double value;
  final double min;
  final double max;
  final Color accentColor;

  const _PrecisionRuler({
    required this.value,
    required this.min,
    required this.max,
    required this.accentColor,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPrecisionRuler(
      value: value,
      min: min,
      max: max,
      accentColor: accentColor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderPrecisionRuler renderObject) {
    renderObject
      ..value = value
      ..min = min
      ..max = max
      ..accentColor = accentColor;
  }
}

class _RenderPrecisionRuler extends RenderBox {
  double _value;
  double _min;
  double _max;
  Color _accentColor;

  _RenderPrecisionRuler({
    required double value,
    required double min,
    required double max,
    required Color accentColor,
  })  : _value = value,
        _min = min,
        _max = max,
        _accentColor = accentColor;

  set value(double v) {
    if (_value != v) {
      _value = v;
      markNeedsPaint();
    }
  }

  set min(double v) {
    if (_min != v) {
      _min = v;
      markNeedsPaint();
    }
  }

  set max(double v) {
    if (_max != v) {
      _max = v;
      markNeedsPaint();
    }
  }

  set accentColor(Color v) {
    if (_accentColor != v) {
      _accentColor = v;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(const Size(double.infinity, 60));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final rect = offset & size;
    
    // Background
    canvas.drawRect(rect, Paint()..color = kDarkBg);
    
    final centerX = rect.center.dx;
    final pixelsPerUnit = 8.0;
    
    // Draw tick marks
    for (double tick = _min; tick <= _max; tick += 1) {
      final tickOffset = (tick - _value) * pixelsPerUnit;
      final x = centerX + tickOffset;
      
      if (x < rect.left - 20 || x > rect.right + 20) continue;
      
      // Calculate fade based on distance from center
      final distanceFromCenter = (x - centerX).abs();
      final maxDistance = rect.width / 2;
      double opacity = 1.0 - (distanceFromCenter / maxDistance);
      opacity = math.pow(opacity.clamp(0.0, 1.0), 1.5); // Non-linear fade
      
      final isMajorTick = tick % 10 == 0;
      final isMinorTick = tick % 5 == 0;
      
      final tickHeight = isMajorTick ? 24.0 : (isMinorTick ? 16.0 : 10.0);
      final tickWidth = isMajorTick ? 2.0 : 1.0;
      
      final tickPaint = Paint()
        ..color = Colors.white.withOpacity(opacity * (isMajorTick ? 1.0 : 0.5))
        ..strokeWidth = tickWidth;
      
      final y1 = rect.center.dy - tickHeight / 2;
      final y2 = rect.center.dy + tickHeight / 2;
      
      canvas.drawLine(Offset(x, y1), Offset(x, y2), tickPaint);
      
      // Draw number labels for major ticks
      if (isMajorTick && opacity > 0.3) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: tick.toInt().toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(opacity * 0.7),
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, rect.bottom - 14),
        );
      }
    }
    
    // Draw center cursor (accent color)
    final cursorPaint = Paint()
      ..color = _accentColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(centerX, rect.top + 8),
      Offset(centerX, rect.bottom - 18),
      cursorPaint,
    );
    
    // Draw glow effect
    final glowPaint = Paint()
      ..color = _accentColor.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawLine(
      Offset(centerX, rect.top + 8),
      Offset(centerX, rect.bottom - 18),
      glowPaint,
    );
    
    // Draw current value label
    final valuePainter = TextPainter(
      text: TextSpan(
        text: _value.toStringAsFixed(0),
        style: TextStyle(
          color: _accentColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    valuePainter.layout();
    valuePainter.paint(
      canvas,
      Offset(centerX - valuePainter.width / 2, rect.top - 2),
    );
  }
}
