import 'dart:math';
import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF1E1E1E);

class ColorGrade {
  Color shadows;
  Color midtones;
  Color highlights;
  ColorGrade({this.shadows = Colors.transparent, this.midtones = Colors.transparent, this.highlights = Colors.transparent});
}

class ColorGradingWidget extends StatefulWidget {
  final Function(ColorGrade) onChanged;
  const ColorGradingWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<ColorGradingWidget> createState() => _ColorGradingWidgetState();
}

class _ColorGradingWidgetState extends State<ColorGradingWidget> with TickerProviderStateMixin {
  late TabController _tabController;
  final ColorGrade _grade = ColorGrade();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _updateColor(Color color) {
    setState(() {
      if (_tabController.index == 0) _grade.shadows = color;
      if (_tabController.index == 1) _grade.midtones = color;
      if (_tabController.index == 2) _grade.highlights = color;
    });
    widget.onChanged(_grade);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: kDarkBg,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: kAccentColor,
            labelColor: kAccentColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: "SHADOWS"), Tab(text: "MIDTONES"), Tab(text: "HIGHLIGHTS")],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWheelPage(_grade.shadows),
                _buildWheelPage(_grade.midtones),
                _buildWheelPage(_grade.highlights),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPage(Color currentColor) {
    return Center(
      child: ColorWheelPicker(selectedColor: currentColor, onColorChanged: _updateColor),
    );
  }
}

class ColorWheelPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  const ColorWheelPicker({Key? key, required this.selectedColor, required this.onColorChanged}) : super(key: key);

  @override
  State<ColorWheelPicker> createState() => _ColorWheelPickerState();
}

class _ColorWheelPickerState extends State<ColorWheelPicker> {
  Offset _thumbPos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _handleTouch(details.localPosition),
      onTapDown: (details) => _handleTouch(details.localPosition),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(colors: [Colors.red, Colors.yellow, Colors.green, Colors.cyan, Colors.blue, Colors.magenta, Colors.red]),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.white, Colors.white.withOpacity(0.0)]),
              ),
            ),
            Transform.translate(
              offset: _thumbPos,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.selectedColor == Colors.transparent ? Colors.white : widget.selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTouch(Offset localPosition) {
    final center = const Offset(100, 100);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = sqrt(dx*dx + dy*dy);
    final angle = atan2(dy, dx);
    final maxRadius = 100.0;
    double clampedDist = distance > maxRadius ? maxRadius : distance;
    final thumbX = cos(angle) * clampedDist;
    final thumbY = sin(angle) * clampedDist;
    setState(() => _thumbPos = Offset(thumbX, thumbY));
    double hue = (angle * 180 / pi);
    if (hue < 0) hue += 360;
    double saturation = clampedDist / maxRadius;
    final color = HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();
    widget.onColorChanged(color);
  }
}
