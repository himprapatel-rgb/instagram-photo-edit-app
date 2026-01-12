import 'package:flutter/material.dart';

/// HSL Color Adjustment Panel - Professional color grading tool
/// Allows adjusting Hue, Saturation, Luminance for specific color ranges
const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF1E1E1E);

/// Data model for HSL adjustments per color channel
class HSLAdjustment {
  double hue;
  double saturation;
  double luminance;

  HSLAdjustment({this.hue = 0, this.saturation = 0, this.luminance = 0});
}

/// All color channels
enum ColorChannel { reds, oranges, yellows, greens, cyans, blues, purples, magentas }

class HSLPanel extends StatefulWidget {
  final Function(Map<ColorChannel, HSLAdjustment>) onChanged;

  const HSLPanel({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<HSLPanel> createState() => _HSLPanelState();
}

class _HSLPanelState extends State<HSLPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ColorChannel _selectedChannel = ColorChannel.reds;
  
  final Map<ColorChannel, HSLAdjustment> _adjustments = {
    ColorChannel.reds: HSLAdjustment(),
    ColorChannel.oranges: HSLAdjustment(),
    ColorChannel.yellows: HSLAdjustment(),
    ColorChannel.greens: HSLAdjustment(),
    ColorChannel.cyans: HSLAdjustment(),
    ColorChannel.blues: HSLAdjustment(),
    ColorChannel.purples: HSLAdjustment(),
    ColorChannel.magentas: HSLAdjustment(),
  };

  final Map<ColorChannel, Color> _channelColors = {
    ColorChannel.reds: Colors.red,
    ColorChannel.oranges: Colors.orange,
    ColorChannel.yellows: Colors.yellow,
    ColorChannel.greens: Colors.green,
    ColorChannel.cyans: Colors.cyan,
    ColorChannel.blues: Colors.blue,
    ColorChannel.purples: Colors.purple,
    ColorChannel.magentas: Colors.pinkAccent,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateAdjustment(String property, double value) {
    setState(() {
      final adj = _adjustments[_selectedChannel]!;
      switch (property) {
        case 'hue':
          adj.hue = value;
          break;
        case 'saturation':
          adj.saturation = value;
          break;
        case 'luminance':
          adj.luminance = value;
          break;
      }
    });
    widget.onChanged(_adjustments);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkBg,
      child: Column(
        children: [
          // Color Channel Selector
          _buildChannelSelector(),
          const SizedBox(height: 20),
          // HSL Tabs
          TabBar(
            controller: _tabController,
            indicatorColor: kAccentColor,
            labelColor: kAccentColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'HUE'),
              Tab(text: 'SAT'),
              Tab(text: 'LUM'),
            ],
          ),
          // Slider Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSlider('hue', _adjustments[_selectedChannel]!.hue, -180, 180),
                _buildSlider('saturation', _adjustments[_selectedChannel]!.saturation, -100, 100),
                _buildSlider('luminance', _adjustments[_selectedChannel]!.luminance, -100, 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ColorChannel.values.length,
        itemBuilder: (context, index) {
          final channel = ColorChannel.values[index];
          final isSelected = _selectedChannel == channel;
          final color = _channelColors[channel]!;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedChannel = channel),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : Colors.grey.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    channel.name.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? color : Colors.grey,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlider(String property, double value, double min, double max) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(
              color: kAccentColor,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _channelColors[_selectedChannel],
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: _channelColors[_selectedChannel]!.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: (v) => _updateAdjustment(property, v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toInt()}', style: const TextStyle(color: Colors.grey)),
              Text('${max.toInt()}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
