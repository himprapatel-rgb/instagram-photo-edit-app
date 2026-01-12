import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF1E1E1E);

class VignetteWidget extends StatefulWidget {
  final Widget child;
  const VignetteWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<VignetteWidget> createState() => _VignetteWidgetState();
}

class _VignetteWidgetState extends State<VignetteWidget> {
  double _intensity = 0.0;
  double _radius = 0.3;
  double _feather = 0.8;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.child,
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.5 - _radius,
                        colors: [Colors.transparent, Colors.black.withOpacity(_intensity)],
                        stops: [(1.0 - _feather).clamp(0.0, 0.9), 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: kDarkBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSlider("Intensity", _intensity, (v) => setState(() => _intensity = v)),
                const SizedBox(height: 16),
                _buildSlider("Size", _radius, (v) => setState(() => _radius = v)),
                const SizedBox(height: 16),
                _buildSlider("Feather", _feather, (v) => setState(() => _feather = v)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kAccentColor,
              thumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[800],
            ),
            child: Slider(value: value, min: 0.0, max: 1.0, onChanged: onChanged),
          ),
        ),
      ],
    );
  }
}
