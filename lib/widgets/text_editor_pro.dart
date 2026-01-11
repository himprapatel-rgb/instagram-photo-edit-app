import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// --- CONSTANTS & THEME ---
const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF121212);
const Color kPanelBg = Color(0xFF1E1E1E);

// --- DATA MODELS ---
class TextLayer {
  String id;
  String text;
  TextStyle style;
  Offset position;
  double rotation;
  double scale;
  Color color;
  String fontFamily;
  bool hasShadow;
  TextAlign align;

  TextLayer({
    required this.id,
    required this.text,
    this.position = const Offset(100, 100),
    this.rotation = 0.0,
    this.scale = 1.0,
    this.color = Colors.white,
    this.fontFamily = 'Lato',
    this.hasShadow = false,
    this.align = TextAlign.center,
  }) : style = GoogleFonts.getFont(fontFamily, color: color, fontSize: 24);

  TextLayer copyWith({
    String? text,
    Offset? position,
    double? rotation,
    double? scale,
    Color? color,
    String? fontFamily,
    bool? hasShadow,
    TextAlign? align,
  }) {
    return TextLayer(
      id: this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      hasShadow: hasShadow ?? this.hasShadow,
      align: align ?? this.align,
    );
  }
}

// --- MAIN TEXT EDITOR WIDGET ---
class TextEditorPro extends StatefulWidget {
  final Widget background;
  final Function(List<TextLayer>) onLayersChanged;

  const TextEditorPro({
    super.key,
    required this.background,
    required this.onLayersChanged,
  });

  @override
  State<TextEditorPro> createState() => _TextEditorProState();
}

class _TextEditorProState extends State<TextEditorPro> {
  List<TextLayer> _layers = [];
  TextLayer? _activeLayer;

  final List<Color> _colors = [
    Colors.white, Colors.black, kAccentColor, Colors.red,
    Colors.yellow, Colors.blue, Colors.purple, Colors.orange, Colors.pink
  ];

  final List<String> _fonts = [
    'Lato', 'Roboto', 'Lobster', 'Oswald', 'Pacifico', 'Anton', 'Dancing Script'
  ];

  void _addNewText() {
    final newLayer = TextLayer(
      id: DateTime.now().toIso8601String(),
      text: "Tap to Edit",
      position: Offset(MediaQuery.of(context).size.width / 2 - 50,
          MediaQuery.of(context).size.height / 2 - 20),
    );
    setState(() {
      _layers.add(newLayer);
    });
    widget.onLayersChanged(_layers);
    _openEditor(newLayer);
  }

  void _openEditor(TextLayer layer) async {
    final updatedLayer = await showModalBottomSheet<TextLayer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TextEditorModal(
        layer: layer,
        colors: _colors,
        fonts: _fonts,
      ),
    );

    if (updatedLayer != null) {
      setState(() {
        final index = _layers.indexWhere((l) => l.id == updatedLayer.id);
        if (index != -1) {
          _layers[index] = updatedLayer;
        }
      });
      widget.onLayersChanged(_layers);
    }
  }

  void _deleteLayer(TextLayer layer) {
    setState(() {
      _layers.removeWhere((l) => l.id == layer.id);
    });
    widget.onLayersChanged(_layers);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.background,
        ..._layers.map((layer) => _buildTextOverlay(layer)),
        Positioned(
          top: 50,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: kPanelBg.withOpacity(0.8),
            onPressed: _addNewText,
            child: const Icon(Icons.text_fields, color: kAccentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTextOverlay(TextLayer layer) {
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onScaleStart: (details) => _activeLayer = layer,
        onScaleUpdate: (details) {
          if (_activeLayer == null) return;
          setState(() {
            final index = _layers.indexWhere((l) => l.id == _activeLayer!.id);
            if (index == -1) return;
            final newPos = _layers[index].position + details.focalPointDelta;
            final newScale = (_layers[index].scale * details.scale).clamp(0.5, 5.0);
            final newRotation = _layers[index].rotation + details.rotation;
            _layers[index] = _layers[index].copyWith(
              position: newPos,
              scale: details.scale == 1.0 ? _layers[index].scale : newScale,
              rotation: details.rotation == 0.0 ? _layers[index].rotation : newRotation,
            );
          });
        },
        onTap: () => _openEditor(layer),
        onLongPress: () => _deleteLayer(layer),
        child: Transform.rotate(
          angle: layer.rotation,
          child: Transform.scale(
            scale: layer.scale,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                layer.text,
                textAlign: layer.align,
                style: GoogleFonts.getFont(
                  layer.fontFamily,
                  color: layer.color,
                  fontSize: 32,
                  shadows: layer.hasShadow
                      ? [Shadow(blurRadius: 10, color: Colors.black87, offset: const Offset(2, 2))]
                      : [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- EDITOR MODAL ---
class _TextEditorModal extends StatefulWidget {
  final TextLayer layer;
  final List<Color> colors;
  final List<String> fonts;

  const _TextEditorModal({
    required this.layer,
    required this.colors,
    required this.fonts,
  });

  @override
  State<_TextEditorModal> createState() => _TextEditorModalState();
}

class _TextEditorModalState extends State<_TextEditorModal> {
  late TextEditingController _controller;
  late TextLayer _tempLayer;

  @override
  void initState() {
    super.initState();
    _tempLayer = widget.layer;
    _controller = TextEditingController(text: widget.layer.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: kDarkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  _tempLayer = _tempLayer.copyWith(text: _controller.text);
                  Navigator.pop(context, _tempLayer);
                },
                child: const Text("Done", style: TextStyle(color: kAccentColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textAlign: _tempLayer.align,
              maxLines: null,
              style: GoogleFonts.getFont(
                _tempLayer.fontFamily,
                color: _tempLayer.color,
                fontSize: 32,
                shadows: _tempLayer.hasShadow
                    ? [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))]
                    : [],
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              cursorColor: kAccentColor,
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.format_align_left,
                  color: _tempLayer.align == TextAlign.left ? kAccentColor : Colors.white),
              onPressed: () => setState(() => _tempLayer = _tempLayer.copyWith(align: TextAlign.left)),
            ),
            IconButton(
              icon: Icon(Icons.format_align_center,
                  color: _tempLayer.align == TextAlign.center ? kAccentColor : Colors.white),
              onPressed: () => setState(() => _tempLayer = _tempLayer.copyWith(align: TextAlign.center)),
            ),
            IconButton(
              icon: Icon(Icons.format_align_right,
                  color: _tempLayer.align == TextAlign.right ? kAccentColor : Colors.white),
              onPressed: () => setState(() => _tempLayer = _tempLayer.copyWith(align: TextAlign.right)),
            ),
            const SizedBox(width: 20),
            ChoiceChip(
              label: const Text("Shadow"),
              selected: _tempLayer.hasShadow,
              onSelected: (v) => setState(() => _tempLayer = _tempLayer.copyWith(hasShadow: v)),
              selectedColor: kAccentColor,
              backgroundColor: Colors.grey[800],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.fonts.length,
            itemBuilder: (context, index) {
              final font = widget.fonts[index];
              final isSelected = _tempLayer.fontFamily == font;
              return GestureDetector(
                onTap: () => setState(() => _tempLayer = _tempLayer.copyWith(fontFamily: font)),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(font, style: GoogleFonts.getFont(font, color: isSelected ? Colors.black : Colors.white)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.colors.length,
            itemBuilder: (context, index) {
              final color = widget.colors[index];
              return GestureDetector(
                onTap: () => setState(() => _tempLayer = _tempLayer.copyWith(color: color)),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _tempLayer.color == color ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
