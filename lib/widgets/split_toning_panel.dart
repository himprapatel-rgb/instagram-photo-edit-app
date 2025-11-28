import 'package:flutter/material.dart';

/// Professional Split Toning Panel
/// Adds color tints to highlights and shadows separately
class SplitToningPanel extends StatefulWidget {
  final Function(Color, Color, double) onSplitToningChanged;
  final VoidCallback? onReset;

  const SplitToningPanel({
    Key? key,
    required this.onSplitToningChanged,
    this.onReset,
  }) : super(key: key);

  @override
  State<SplitToningPanel> createState() => _SplitToningPanelState();
}

class _SplitToningPanelState extends State<SplitToningPanel> {
  // Highlight tint (warm colors like orange/yellow)
  double _highlightHue = 45.0; // Default warm orange
  double _highlightSaturation = 0.0;
  
  // Shadow tint (cool colors like blue/teal)
  double _shadowHue = 220.0; // Default cool blue
  double _shadowSaturation = 0.0;
  
  // Balance between highlights and shadows (-100 to +100)
  double _balance = 0.0;

  Color get _highlightColor => HSLColor.fromAHSL(
    1.0,
    _highlightHue,
    _highlightSaturation,
    0.5,
  ).toColor();

  Color get _shadowColor => HSLColor.fromAHSL(
    1.0,
    _shadowHue,
    _shadowSaturation,
    0.5,
  ).toColor();

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
                'Split Toning',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.grey, size: 20),
                onPressed: _reset,
                tooltip: 'Reset Split Toning',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Highlights Section
          _buildSectionHeader('Highlights', _highlightColor),
          const SizedBox(height: 8),
          _buildHueSelector(
            'Hue',
            _highlightHue,
            (v) => setState(() {
              _highlightHue = v;
              _notifyChange();
            }),
          ),
          _buildSlider(
            'Saturation',
            _highlightSaturation,
            0,
            1,
            (v) => setState(() {
              _highlightSaturation = v;
              _notifyChange();
            }),
          ),
          
          const SizedBox(height: 16),
          
          // Shadows Section
          _buildSectionHeader('Shadows', _shadowColor),
          const SizedBox(height: 8),
          _buildHueSelector(
            'Hue',
            _shadowHue,
            (v) => setState(() {
              _shadowHue = v;
              _notifyChange();
            }),
          ),
          _buildSlider(
            'Saturation',
            _shadowSaturation,
            0,
            1,
            (v) => setState(() {
              _shadowSaturation = v;
              _notifyChange();
            }),
          ),
          
          const SizedBox(height: 16),
          
          // Balance
          _buildSectionHeader('Balance', Colors.grey),
          const SizedBox(height: 8),
          _buildBalanceSlider(),
          
          const SizedBox(height: 16),
          
          // Presets
          const Text(
            'Presets',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetButton('Cinematic', 35, 0.3, 210, 0.25, 0),
              _buildPresetButton('Vintage', 45, 0.4, 180, 0.3, 20),
              _buildPresetButton('Teal & Orange', 30, 0.5, 180, 0.5, 0),
              _buildPresetButton('Cool Fade', 200, 0.2, 240, 0.3, -30),
              _buildPresetButton('Warm Sunset', 25, 0.4, 280, 0.2, 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHueSelector(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text('${value.toInt()}', style: const TextStyle(color: Colors.blue, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF0000), // Red
                Color(0xFFFFFF00), // Yellow
                Color(0xFF00FF00), // Green
                Color(0xFF00FFFF), // Cyan
                Color(0xFF0000FF), // Blue
                Color(0xFFFF00FF), // Magenta
                Color(0xFFFF0000), // Red
              ],
            ),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 24,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: SliderComponentShape.noOverlay,
              trackShape: const RoundedRectSliderTrackShape(),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 360,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(color: Colors.blue, fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shadows', style: TextStyle(color: Colors.grey, fontSize: 10)),
            Text(
              _balance == 0 ? 'Balanced' : (_balance > 0 ? '+${_balance.toInt()}' : '${_balance.toInt()}'),
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
            const Text('Highlights', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _balance,
            min: -100,
            max: 100,
            onChanged: (v) => setState(() {
              _balance = v;
              _notifyChange();
            }),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(
    String name,
    double highlightHue,
    double highlightSat,
    double shadowHue,
    double shadowSat,
    double balance,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _highlightHue = highlightHue;
          _highlightSaturation = highlightSat;
          _shadowHue = shadowHue;
          _shadowSaturation = shadowSat;
          _balance = balance;
        });
        _notifyChange();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Text(
          name,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }

  void _reset() {
    setState(() {
      _highlightHue = 45.0;
      _highlightSaturation = 0.0;
      _shadowHue = 220.0;
      _shadowSaturation = 0.0;
      _balance = 0.0;
    });
    widget.onReset?.call();
    _notifyChange();
  }

  void _notifyChange() {
    widget.onSplitToningChanged(_highlightColor, _shadowColor, _balance);
  }
}
