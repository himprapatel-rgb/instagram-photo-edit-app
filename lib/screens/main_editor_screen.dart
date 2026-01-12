import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Theme constants
const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF121212);
const Color kGlassWhite = Colors.white10;
const Color kGlassBorder = Colors.white24;

class MainEditorScreen extends StatefulWidget {
  final String imagePath;
  
  const MainEditorScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  int _selectedToolIndex = -1;
  
  final List<Map<String, dynamic>> _tools = [
    {'name': 'Tune', 'icon': Icons.tune, 'value': 0.5},
    {'name': 'Exposure', 'icon': Icons.exposure, 'value': 0.5},
    {'name': 'Contrast', 'icon': Icons.contrast, 'value': 0.6},
    {'name': 'Saturation', 'icon': Icons.invert_colors, 'value': 0.4},
    {'name': 'Warmth', 'icon': Icons.thermostat, 'value': 0.5},
    {'name': 'Vignette', 'icon': Icons.vignette, 'value': 0.0},
    {'name': 'Sharpen', 'icon': Icons.blur_on, 'value': 0.3},
    {'name': 'Grain', 'icon': Icons.grain, 'value': 0.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image Layer (Zoomable)
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 100),
                  ),
                ),
              ),
            ),
          ),
          // Top Bar (Glass)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
          // Bottom Toolbar Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return GlassBox(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo, color: Colors.white70, size: 24),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo, color: Colors.white70, size: 24),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: kAccentColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
          stops: [0.6, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider Panel
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _selectedToolIndex != -1
                ? _buildSliderControls()
                : const SizedBox(height: 0),
          ),
          // Main Toolbar
          GlassBox(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: SafeArea(
              top: false,
              child: Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _tools.length,
                  itemBuilder: (context, index) {
                    final tool = _tools[index];
                    final isSelected = _selectedToolIndex == index;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedToolIndex = _selectedToolIndex == index ? -1 : index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.white24,
                                ),
                              ),
                              child: Icon(
                                tool['icon'],
                                color: isSelected ? Colors.black : Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tool['name'],
                              style: TextStyle(
                                color: isSelected ? kAccentColor : Colors.grey,
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderControls() {
    final tool = _tools[_selectedToolIndex];
    return Container(
      key: ValueKey(_selectedToolIndex),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tool['name'].toString().toUpperCase(),
            style: const TextStyle(
              color: kAccentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('-100', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: kAccentColor,
                    inactiveTrackColor: Colors.grey[800],
                    thumbColor: Colors.white,
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayColor: kAccentColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: tool['value'],
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _tools[_selectedToolIndex]['value'] = val;
                      });
                    },
                  ),
                ),
              ),
              Text('+100', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable Glass Widget
class GlassBox extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;

  const GlassBox({Key? key, required this.child, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kGlassWhite,
            borderRadius: borderRadius,
            border: Border(
              top: BorderSide(color: kGlassBorder, width: 0.5),
              bottom: BorderSide(color: kGlassBorder, width: 0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
