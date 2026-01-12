import 'dart:ui';
import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF121212);

class BlurBokehWidget extends StatefulWidget {
  final String imageUrl;

  const BlurBokehWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<BlurBokehWidget> createState() => _BlurBokehWidgetState();
}

class _BlurBokehWidgetState extends State<BlurBokehWidget> {
  double _blurAmount = 0.0;
  bool _isRadial = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkBg,
      child: Column(
        children: [
          // IMAGE PREVIEW AREA
          Expanded(
            child: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Base Image (Sharp)
                  Image.network(widget.imageUrl, fit: BoxFit.cover),
                  // Blurred Layer
                  if (_blurAmount > 0)
                    _isRadial ? _buildRadialBokeh() : _buildFullBlur(),
                ],
              ),
            ),
          ),
          // CONTROLS AREA
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Blur Intensity",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => setState(() => _isRadial = !_isRadial),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isRadial ? kAccentColor : Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _isRadial ? "Radial (Bokeh)" : "Full Blur",
                          style: TextStyle(
                            color: _isRadial ? Colors.black : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.blur_off, color: Colors.grey, size: 20),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: kAccentColor,
                          thumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[800],
                          overlayColor: kAccentColor.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _blurAmount,
                          min: 0.0,
                          max: 15.0,
                          onChanged: (val) => setState(() => _blurAmount = val),
                        ),
                      ),
                    ),
                    const Icon(Icons.blur_on, color: kAccentColor, size: 20),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFullBlur() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: _blurAmount, sigmaY: _blurAmount),
      child: Image.network(widget.imageUrl, fit: BoxFit.cover),
    );
  }

  Widget _buildRadialBokeh() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.center,
          radius: 0.6,
          colors: const [Colors.transparent, Colors.black],
          stops: const [0.3, 1.0],
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcOver,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: _blurAmount, sigmaY: _blurAmount),
        child: Image.network(widget.imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
