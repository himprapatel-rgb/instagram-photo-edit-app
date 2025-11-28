import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Professional Curves Adjustment Panel
/// Provides RGB channel curves editing like Lightroom/Photoshop
class CurvesPanel extends StatefulWidget {
  final Function(List<Offset>, List<Offset>, List<Offset>, List<Offset>) onCurvesChanged;
  final VoidCallback? onReset;

  const CurvesPanel({
    Key? key,
    required this.onCurvesChanged,
    this.onReset,
  }) : super(key: key);

  @override
  State<CurvesPanel> createState() => _CurvesPanelState();
}

class _CurvesPanelState extends State<CurvesPanel> {
  // Channel selection: 0=RGB, 1=Red, 2=Green, 3=Blue
  int _selectedChannel = 0;
  
  // Control points for each channel (normalized 0-1)
  List<Offset> _rgbPoints = [const Offset(0, 0), const Offset(1, 1)];
  List<Offset> _redPoints = [const Offset(0, 0), const Offset(1, 1)];
  List<Offset> _greenPoints = [const Offset(0, 0), const Offset(1, 1)];
  List<Offset> _bluePoints = [const Offset(0, 0), const Offset(1, 1)];
  
  int? _draggingPointIndex;

  List<Offset> get _currentPoints {
    switch (_selectedChannel) {
      case 1: return _redPoints;
      case 2: return _greenPoints;
      case 3: return _bluePoints;
      default: return _rgbPoints;
    }
  }

  set _currentPoints(List<Offset> points) {
    switch (_selectedChannel) {
      case 1: _redPoints = points; break;
      case 2: _greenPoints = points; break;
      case 3: _bluePoints = points; break;
      default: _rgbPoints = points;
    }
  }

  Color get _channelColor {
    switch (_selectedChannel) {
      case 1: return Colors.red;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Curves',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.grey, size: 20),
                onPressed: _resetCurves,
                tooltip: 'Reset Curves',
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Channel selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildChannelButton('RGB', 0, Colors.white),
              _buildChannelButton('R', 1, Colors.red),
              _buildChannelButton('G', 2, Colors.green),
              _buildChannelButton('B', 3, Colors.blue),
            ],
          ),
          const SizedBox(height: 16),
          
          // Curves canvas
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTapUp: _onTapUp,
              child: CustomPaint(
                painter: CurvesPainter(
                  points: _currentPoints,
                  curveColor: _channelColor,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton('Linear', _applyLinear),
              _buildPresetButton('S-Curve', _applySCurve),
              _buildPresetButton('Fade', _applyFade),
              _buildPresetButton('High Key', _applyHighKey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelButton(String label, int channel, Color color) {
    final isSelected = _selectedChannel == channel;
    return GestureDetector(
      onTap: () => setState(() => _selectedChannel = channel),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final localPos = box.globalToLocal(details.globalPosition);
    final size = box.size;
    
    // Find nearest point
    double minDist = double.infinity;
    int? nearestIndex;
    
    for (int i = 0; i < _currentPoints.length; i++) {
      final point = _currentPoints[i];
      final px = point.dx * size.width;
      final py = (1 - point.dy) * size.height;
      final dist = (Offset(px, py) - localPos).distance;
      
      if (dist < 30 && dist < minDist) {
        minDist = dist;
        nearestIndex = i;
      }
    }
    
    setState(() => _draggingPointIndex = nearestIndex);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_draggingPointIndex == null) return;
    
    final box = context.findRenderObject() as RenderBox;
    final localPos = box.globalToLocal(details.globalPosition);
    final size = box.size;
    
    final x = (localPos.dx / size.width).clamp(0.0, 1.0);
    final y = 1 - (localPos.dy / size.height).clamp(0.0, 1.0);
    
    setState(() {
      final points = List<Offset>.from(_currentPoints);
      points[_draggingPointIndex!] = Offset(x, y);
      points.sort((a, b) => a.dx.compareTo(b.dx));
      _currentPoints = points;
    });
    
    _notifyChange();
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _draggingPointIndex = null);
  }

  void _onTapUp(TapUpDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final localPos = box.globalToLocal(details.globalPosition);
    final size = box.size;
    
    final x = (localPos.dx / size.width).clamp(0.0, 1.0);
    final y = 1 - (localPos.dy / size.height).clamp(0.0, 1.0);
    
    setState(() {
      final points = List<Offset>.from(_currentPoints);
      points.add(Offset(x, y));
      points.sort((a, b) => a.dx.compareTo(b.dx));
      _currentPoints = points;
    });
    
    _notifyChange();
  }

  void _resetCurves() {
    setState(() {
      _rgbPoints = [const Offset(0, 0), const Offset(1, 1)];
      _redPoints = [const Offset(0, 0), const Offset(1, 1)];
      _greenPoints = [const Offset(0, 0), const Offset(1, 1)];
      _bluePoints = [const Offset(0, 0), const Offset(1, 1)];
    });
    widget.onReset?.call();
    _notifyChange();
  }

  void _applyLinear() {
    setState(() {
      _currentPoints = [const Offset(0, 0), const Offset(1, 1)];
    });
    _notifyChange();
  }

  void _applySCurve() {
    setState(() {
      _currentPoints = [
        const Offset(0, 0),
        const Offset(0.25, 0.15),
        const Offset(0.75, 0.85),
        const Offset(1, 1),
      ];
    });
    _notifyChange();
  }

  void _applyFade() {
    setState(() {
      _currentPoints = [
        const Offset(0, 0.1),
        const Offset(0.25, 0.3),
        const Offset(1, 0.9),
      ];
    });
    _notifyChange();
  }

  void _applyHighKey() {
    setState(() {
      _currentPoints = [
        const Offset(0, 0.2),
        const Offset(0.5, 0.7),
        const Offset(1, 1),
      ];
    });
    _notifyChange();
  }

  void _notifyChange() {
    widget.onCurvesChanged(_rgbPoints, _redPoints, _greenPoints, _bluePoints);
  }
}

/// Custom painter for curves visualization
class CurvesPainter extends CustomPainter {
  final List<Offset> points;
  final Color curveColor;

  CurvesPainter({required this.points, required this.curveColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Grid
    final gridPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 0.5;

    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      final y = size.height * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Diagonal reference line
    final diagPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      diagPaint,
    );

    // Curve
    if (points.length >= 2) {
      final curvePaint = Paint()
        ..color = curveColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();
      final firstPoint = points.first;
      path.moveTo(
        firstPoint.dx * size.width,
        (1 - firstPoint.dy) * size.height,
      );

      for (int i = 1; i < points.length; i++) {
        final point = points[i];
        path.lineTo(
          point.dx * size.width,
          (1 - point.dy) * size.height,
        );
      }

      canvas.drawPath(path, curvePaint);
    }

    // Control points
    final pointPaint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final point in points) {
      final px = point.dx * size.width;
      final py = (1 - point.dy) * size.height;
      canvas.drawCircle(Offset(px, py), 8, pointPaint);
      canvas.drawCircle(Offset(px, py), 8, pointBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CurvesPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.curveColor != curveColor;
  }
}
