import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Professional Crop Widget with aspect ratio presets and rotation
const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF121212);

/// Aspect ratio presets
enum AspectRatioPreset {
  free,
  square,    // 1:1
  portrait,  // 4:5
  landscape, // 16:9
  story,     // 9:16
  photo,     // 4:3
}

extension AspectRatioPresetExtension on AspectRatioPreset {
  String get label {
    switch (this) {
      case AspectRatioPreset.free: return 'FREE';
      case AspectRatioPreset.square: return '1:1';
      case AspectRatioPreset.portrait: return '4:5';
      case AspectRatioPreset.landscape: return '16:9';
      case AspectRatioPreset.story: return '9:16';
      case AspectRatioPreset.photo: return '4:3';
    }
  }

  double? get ratio {
    switch (this) {
      case AspectRatioPreset.free: return null;
      case AspectRatioPreset.square: return 1.0;
      case AspectRatioPreset.portrait: return 4 / 5;
      case AspectRatioPreset.landscape: return 16 / 9;
      case AspectRatioPreset.story: return 9 / 16;
      case AspectRatioPreset.photo: return 4 / 3;
    }
  }
}

class CropWidget extends StatefulWidget {
  final Widget child;
  final Function(Rect cropRect, double rotation) onCropChanged;

  const CropWidget({
    Key? key,
    required this.child,
    required this.onCropChanged,
  }) : super(key: key);

  @override
  State<CropWidget> createState() => _CropWidgetState();
}

class _CropWidgetState extends State<CropWidget> {
  AspectRatioPreset _selectedPreset = AspectRatioPreset.free;
  double _rotation = 0.0;
  Rect _cropRect = Rect.zero;
  Size _imageSize = Size.zero;
  
  // Drag state
  int _activeHandle = -1; // -1 = none, 0-3 = corners, 4 = move

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCropRect();
    });
  }

  void _initializeCropRect() {
    final size = context.size ?? const Size(300, 300);
    _imageSize = size;
    setState(() {
      _cropRect = Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.1,
        size.width * 0.8,
        size.height * 0.8,
      );
    });
  }

  void _setAspectRatio(AspectRatioPreset preset) {
    setState(() {
      _selectedPreset = preset;
      if (preset.ratio != null) {
        final centerX = _cropRect.center.dx;
        final centerY = _cropRect.center.dy;
        final newWidth = _cropRect.width;
        final newHeight = newWidth / preset.ratio!;
        _cropRect = Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: newWidth,
          height: newHeight,
        );
      }
    });
    widget.onCropChanged(_cropRect, _rotation);
  }

  void _rotate(double degrees) {
    setState(() {
      _rotation += degrees * (math.pi / 180);
    });
    widget.onCropChanged(_cropRect, _rotation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkBg,
      child: Column(
        children: [
          // Image with crop overlay
          Expanded(
            child: Stack(
              children: [
                // Image
                Center(
                  child: Transform.rotate(
                    angle: _rotation,
                    child: widget.child,
                  ),
                ),
                // Crop overlay
                if (_cropRect != Rect.zero)
                  CustomPaint(
                    size: Size.infinite,
                    painter: _CropOverlayPainter(
                      cropRect: _cropRect,
                      showGrid: true,
                    ),
                  ),
                // Drag handles
                if (_cropRect != Rect.zero) ..._buildHandles(),
              ],
            ),
          ),
          // Controls
          _buildControls(),
        ],
      ),
    );
  }

  List<Widget> _buildHandles() {
    const handleSize = 24.0;
    final corners = [
      _cropRect.topLeft,
      _cropRect.topRight,
      _cropRect.bottomRight,
      _cropRect.bottomLeft,
    ];

    return [
      // Move handle (center)
      Positioned(
        left: _cropRect.center.dx - 20,
        top: _cropRect.center.dy - 20,
        child: GestureDetector(
          onPanStart: (_) => _activeHandle = 4,
          onPanUpdate: (details) {
            if (_activeHandle == 4) {
              setState(() {
                _cropRect = _cropRect.translate(
                  details.delta.dx,
                  details.delta.dy,
                );
              });
            }
          },
          onPanEnd: (_) {
            _activeHandle = -1;
            widget.onCropChanged(_cropRect, _rotation);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.open_with, color: Colors.white, size: 20),
          ),
        ),
      ),
      // Corner handles
      ...List.generate(4, (index) {
        return Positioned(
          left: corners[index].dx - handleSize / 2,
          top: corners[index].dy - handleSize / 2,
          child: GestureDetector(
            onPanStart: (_) => _activeHandle = index,
            onPanUpdate: (details) {
              if (_activeHandle == index) {
                _updateCropRect(index, details.delta);
              }
            },
            onPanEnd: (_) {
              _activeHandle = -1;
              widget.onCropChanged(_cropRect, _rotation);
            },
            child: Container(
              width: handleSize,
              height: handleSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: kAccentColor, width: 2),
              ),
            ),
          ),
        );
      }),
    ];
  }

  void _updateCropRect(int corner, Offset delta) {
    setState(() {
      switch (corner) {
        case 0: // top-left
          _cropRect = Rect.fromLTRB(
            _cropRect.left + delta.dx,
            _cropRect.top + delta.dy,
            _cropRect.right,
            _cropRect.bottom,
          );
          break;
        case 1: // top-right
          _cropRect = Rect.fromLTRB(
            _cropRect.left,
            _cropRect.top + delta.dy,
            _cropRect.right + delta.dx,
            _cropRect.bottom,
          );
          break;
        case 2: // bottom-right
          _cropRect = Rect.fromLTRB(
            _cropRect.left,
            _cropRect.top,
            _cropRect.right + delta.dx,
            _cropRect.bottom + delta.dy,
          );
          break;
        case 3: // bottom-left
          _cropRect = Rect.fromLTRB(
            _cropRect.left + delta.dx,
            _cropRect.top,
            _cropRect.right,
            _cropRect.bottom + delta.dy,
          );
          break;
      }
    });
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Aspect ratio presets
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AspectRatioPreset.values.map((preset) {
                final isSelected = _selectedPreset == preset;
                return GestureDetector(
                  onTap: () => _setAspectRatio(preset),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kAccentColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? kAccentColor : Colors.grey,
                      ),
                    ),
                    child: Text(
                      preset.label,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Rotation controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _rotate(-90),
                icon: const Icon(Icons.rotate_left, color: Colors.white),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () => _rotate(90),
                icon: const Icon(Icons.rotate_right, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final bool showGrid;

  _CropOverlayPainter({required this.cropRect, this.showGrid = true});

  @override
  void paint(Canvas canvas, Size size) {
    // Dim outside area
    final dimPaint = Paint()..color = Colors.black.withOpacity(0.6);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(cropRect),
      ),
      dimPaint,
    );

    // Crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(cropRect, borderPaint);

    // Grid lines (rule of thirds)
    if (showGrid) {
      final gridPaint = Paint()
        ..color = Colors.white30
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final thirdWidth = cropRect.width / 3;
      final thirdHeight = cropRect.height / 3;

      for (int i = 1; i <= 2; i++) {
        // Vertical lines
        canvas.drawLine(
          Offset(cropRect.left + thirdWidth * i, cropRect.top),
          Offset(cropRect.left + thirdWidth * i, cropRect.bottom),
          gridPaint,
        );
        // Horizontal lines
        canvas.drawLine(
          Offset(cropRect.left, cropRect.top + thirdHeight * i),
          Offset(cropRect.right, cropRect.top + thirdHeight * i),
          gridPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect;
  }
}
