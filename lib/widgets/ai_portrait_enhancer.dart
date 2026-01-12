import 'dart:async';
import 'package:flutter/material.dart';

/// A professional AI Portrait Enhancement interface.
/// Features face detection visualization, depth control, and cosmetic retouching.
class AiPortraitEnhancer extends StatefulWidget {
  final ImageProvider imageProvider;
  final Function(PortraitSettings) onSave;

  const AiPortraitEnhancer({
    Key? key,
    required this.imageProvider,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AiPortraitEnhancer> createState() => _AiPortraitEnhancerState();
}

class _AiPortraitEnhancerState extends State<AiPortraitEnhancer>
    with SingleTickerProviderStateMixin {
  // Enhancement State
  double _skinSmoothing = 0.5;
  double _blurIntensity = 0.4; // Depth effect
  bool _eyeEnhance = true;
  bool _showFaceMesh = true; // Toggle for the tech overlay

  // Animation for the scanning effect
  late AnimationController _scanController;

  // Design System Colors
  static const Color _tealAccent = Color(0xFF1DB9A0);
  static const Color _bgDark = Color(0xFF0F1115);
  static const Color _surfaceGraphite = Color(0xFF1E2129);

  @override
  void initState() {
    super.initState();
    // Simulate the "Scanning" phase of face detection
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Auto-hide the mesh after 3 seconds for a cleaner view
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showFaceMesh = false);
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave(PortraitSettings(
      skinSmoothing: _skinSmoothing,
      blurIntensity: _blurIntensity,
      eyeEnhance: _eyeEnhance,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Portrait Studio', style: TextStyle(fontFamily: 'SpaceGrotesk')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('SAVE', style: TextStyle(color: _tealAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Interactive Preview Area
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // The Base Image
                Image(
                  image: widget.imageProvider,
                  fit: BoxFit.contain,
                ),
                // Face Detection / Tech Overlay
                if (_showFaceMesh)
                  AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _FaceMeshPainter(
                          scanProgress: _scanController.value,
                          accentColor: _tealAccent,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          // 2. Control Panel
          Container(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
            decoration: const BoxDecoration(
              color: _surfaceGraphite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Section 1: Bokeh / Depth
                _buildSliderGroup(
                  label: 'Background Blur',
                  icon: Icons.blur_on,
                  value: _blurIntensity,
                  onChanged: (v) => setState(() => _blurIntensity = v),
                ),
                const SizedBox(height: 24),
                // Section 2: Skin Smoothness
                _buildSliderGroup(
                  label: 'Skin Smoothing',
                  icon: Icons.face,
                  value: _skinSmoothing,
                  onChanged: (v) => setState(() => _skinSmoothing = v),
                ),
                const SizedBox(height: 24),
                // Section 3: Eye Enhancement Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _bgDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.remove_red_eye, color: _tealAccent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Eye Enhancer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            Text('Brighten & Sharpen', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _eyeEnhance,
                      onChanged: (v) => setState(() => _eyeEnhance = v),
                      activeColor: _tealAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderGroup({
    required String label,
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[400], size: 18),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            Text('${(value * 100).toInt()}', style: const TextStyle(color: _tealAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _tealAccent,
            inactiveTrackColor: Colors.grey[800],
            thumbColor: Colors.white,
            overlayColor: _tealAccent.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Draws a futuristic face detection mesh and scanning line overlay.
class _FaceMeshPainter extends CustomPainter {
  final double scanProgress;
  final Color accentColor;

  _FaceMeshPainter({required this.scanProgress, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintDot = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Simulated face rectangle in the center
    final rectW = size.width * 0.4;
    final rectH = size.height * 0.3;
    final left = (size.width - rectW) / 2;
    final top = (size.height - rectH) / 2 - 40;
    final rect = Rect.fromLTWH(left, top, rectW, rectH);

    // Draw Corner Brackets
    const double cornerLen = 20.0;
    final path = Path();

    // Top Left
    path.moveTo(rect.left, rect.top + cornerLen);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + cornerLen, rect.top);

    // Top Right
    path.moveTo(rect.right - cornerLen, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + cornerLen);

    // Bottom Left
    path.moveTo(rect.left, rect.bottom - cornerLen);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left + cornerLen, rect.bottom);

    // Bottom Right
    path.moveTo(rect.right - cornerLen, rect.bottom);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right, rect.bottom - cornerLen);

    canvas.drawPath(
      path,
      Paint()
        ..color = accentColor
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    // Draw Simulated Landmarks
    canvas.drawCircle(Offset(left + rectW * 0.3, top + rectH * 0.35), 3, paintDot);
    canvas.drawCircle(Offset(left + rectW * 0.7, top + rectH * 0.35), 3, paintDot);
    canvas.drawCircle(Offset(left + rectW * 0.5, top + rectH * 0.55), 2, paintDot);

    // Scanning Line
    final scanY = rect.top + (rect.height * scanProgress);
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          accentColor.withOpacity(0.0),
          accentColor.withOpacity(0.8),
          accentColor.withOpacity(0.0)
        ],
      ).createShader(Rect.fromLTWH(left, scanY, rectW, 2));
    canvas.drawRect(Rect.fromLTWH(left - 10, scanY, rectW + 20, 2), scanPaint);
  }

  @override
  bool shouldRepaint(covariant _FaceMeshPainter oldDelegate) =>
      oldDelegate.scanProgress != scanProgress;
}

/// Data class to pass portrait settings back to the caller.
class PortraitSettings {
  final double skinSmoothing;
  final double blurIntensity;
  final bool eyeEnhance;

  PortraitSettings({
    required this.skinSmoothing,
    required this.blurIntensity,
    required this.eyeEnhance,
  });
}
