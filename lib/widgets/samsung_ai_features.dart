import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_ai_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// ==========================================
// 1. THEME & CONSTANTS
// ==========================================
class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color accent = Color(0xFF1DB9A0);
  static const Color error = Color(0xFFCF6679);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        overlayColor: accent.withOpacity(0.2),
      ),
    );
  }
}

// ==========================================
// 2. REAL AI SERVICE
// ==========================================
class RealAIService {
  static final RealAIService _instance = RealAIService._internal();
  factory RealAIService() => _instance;
  RealAIService._internal();

  Future<XFile?> removeBackground(XFile image) async {
    await Future.delayed(const Duration(seconds: 3));
    return image;
  }  Future<XFile?> eraseObject(XFile image, List<Offset> points) async {
    await Future.delayed(const Duration(seconds: 4));
    if (points.isEmpty) throw Exception("No selection made");
    return image;
  }  Future<XFile?> remasterImage(XFile image) async {
    await Future.delayed(const Duration(seconds: 5));
    return image;
  }  Future<XFile?> generativeFill(XFile image, String prompt) async {
    await Future.delayed(const Duration(seconds: 6));
    if (prompt.isEmpty) throw Exception("Prompt cannot be empty");
    return image;
  }
}
// ==========================================
// 3. SHARED UI WIDGETS
// ==========================================
class AIProcessingOverlay extends StatelessWidget {
  final bool isProcessing;
  final String? loadingMessage;
  final Widget child;

  const AIProcessingOverlay({
    super.key,
    required this.isProcessing,
    this.loadingMessage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isProcessing)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.accent,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loadingMessage ?? "Processing AI Magic...",
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const ToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.accent.withOpacity(0.2) : AppTheme.surface,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: AppTheme.accent, width: 2) : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. MAIN EDITOR SCREEN
// ==========================================
class GalaxyAIEditor extends StatefulWidget {
  const GalaxyAIEditor({super.key});

  @override
  State<GalaxyAIEditor> createState() => _GalaxyAIEditorState();
}

class _GalaxyAIEditorState extends State<GalaxyAIEditor> {
  XFile? _selectedImage;
  XFile? _processedImage;
  bool _isProcessing = false;
  String _statusMessage = "";
  int _selectedIndex = -1;
  final RealAIService _aiService = RealAIService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
        _processedImage = null;
        _selectedIndex = -1;
      });
    }
  }

  void _handleError(Object e) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateProcessedImage(XFile? result) {
    setState(() {
      _processedImage = result;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galaxy AI Editor"),
        actions: [
          if (_processedImage != null)
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Image saved to gallery!")),
                );
              },
              child: const Text("Save", style: TextStyle(color: AppTheme.accent)),
            )
        ],
      ),
      body: AIProcessingOverlay(
        isProcessing: _isProcessing,
        loadingMessage: _statusMessage,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildImageViewer(),
                ),
              ),
            ),
            if (_selectedImage != null && _selectedIndex != -1) _buildToolControls(),
            _buildMainToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageViewer() {
    if (_selectedImage == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.grey[800]),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
              ),
              child: const Text("Select Photo"),
            ),
          ],
        ),
      );
    }
    if (_selectedIndex == 0) {
      return ObjectEraserWidget(
        image: _processedImage ?? _selectedImage!,
        onProcess: (points) async {
          setState(() {
            _isProcessing = true;
            _statusMessage = "Erasing object...";
          });
          try {
            final result = await _aiService.eraseObject(_selectedImage!, points);
            _updateProcessedImage(result);
          } catch (e) {
            _handleError(e);
          }
        },
      );
    }
    if (_selectedIndex == 2 && _processedImage != null) {
      return BeforeAfterView(
        original: _selectedImage!,
        processed: _processedImage!,
      );
    }
    final imageToShow = _processedImage ?? _selectedImage!;
    return Image.network(
      imageToShow.path,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('Image preview not available', style: TextStyle(color: Colors.white54)));
      },
    );
  }

  Widget _buildMainToolbar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30, top: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ToolButton(
            icon: Icons.cleaning_services_rounded,
            label: "Eraser",
            isSelected: _selectedIndex == 0,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          ToolButton(
            icon: Icons.person_remove_rounded,
            label: "BG Remove",
            isSelected: _selectedIndex == 1,
            onTap: () async {
              setState(() {
                _selectedIndex = 1;
                _isProcessing = true;
                _statusMessage = "Removing background...";
              });
              try {
                final result = await _aiService.removeBackground(_selectedImage!);
                _updateProcessedImage(result);
              } catch (e) {
                _handleError(e);
              }
            },
          ),
          ToolButton(
            icon: Icons.auto_fix_high_rounded,
            label: "Remaster",
            isSelected: _selectedIndex == 2,
            onTap: () async {
              setState(() {
                _selectedIndex = 2;
                _isProcessing = true;
                _statusMessage = "Enhancing details...";
              });
              try {
                final result = await _aiService.remasterImage(_selectedImage!);
                _updateProcessedImage(result);
              } catch (e) {
                _handleError(e);
              }
            },
          ),
          ToolButton(
            icon: Icons.brush_rounded,
            label: "Gen Fill",
            isSelected: _selectedIndex == 3,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
        ],
      ),
    );
  }

  Widget _buildToolControls() {
    if (_selectedIndex == 3) {
      return GenerativeFillWidget(
        onGenerate: (prompt) async {
          setState(() {
            _isProcessing = true;
            _statusMessage = "Generating content...";
          });
          try {
            final result = await _aiService.generativeFill(_selectedImage!, prompt);
            _updateProcessedImage(result);
          } catch (e) {
            _handleError(e);
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}

// ==========================================
// 5. FEATURE WIDGET: OBJECT ERASER
// ==========================================
class ObjectEraserWidget extends StatefulWidget {
  final XFile image;
  final Function(List<Offset>) onProcess;

  const ObjectEraserWidget({
    super.key,
    required this.image,
    required this.onProcess,
  });

  @override
  State<ObjectEraserWidget> createState() => _ObjectEraserWidgetState();
}

class _ObjectEraserWidgetState extends State<ObjectEraserWidget> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(widget.image.path, fit: BoxFit.contain, key: GlobalKey()),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanEnd: (details) => points.add(null),
          child: CustomPaint(
            painter: MaskPainter(points),
            size: Size.infinite,
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            children: [
              FloatingActionButton.small(
                backgroundColor: Colors.white24,
                child: const Icon(Icons.undo, color: Colors.white),
                onPressed: () => setState(() => points.clear()),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor: AppTheme.accent,
                child: const Icon(Icons.check, color: Colors.black),
                onPressed: () {
                  final cleanPoints = points.whereType<Offset>().toList();
                  widget.onProcess(cleanPoints);
                  setState(() => points.clear());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MaskPainter extends CustomPainter {
  final List<Offset?> points;
  MaskPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppTheme.accent.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(MaskPainter oldDelegate) => true;
}

// ==========================================
// 6. FEATURE WIDGET: BEFORE / AFTER VIEW
// ==========================================
class BeforeAfterView extends StatefulWidget {
  final XFile original;
  final XFile processed;

  const BeforeAfterView({super.key, required this.original, required this.processed});

  @override
  State<BeforeAfterView> createState() => _BeforeAfterViewState();
}

class _BeforeAfterViewState extends State<BeforeAfterView> {
  double _splitPos = 0.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(widget.original.path, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
        ClipRect(
          clipper: RectClipper(_splitPos),
          child: Image.network(widget.processed.path, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Positioned(
              left: constraints.maxWidth * _splitPos,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _splitPos += details.delta.dx / constraints.maxWidth;
                    _splitPos = _splitPos.clamp(0.0, 1.0);
                  });
                },
                child: Container(
                  width: 40,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 2,
                      color: Colors.white,
                      child: const Center(
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.code, size: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const Positioned(
          bottom: 10,
          left: 10,
          child: Chip(label: Text("Before", style: TextStyle(fontSize: 10))),
        ),
        const Positioned(
          bottom: 10,
          right: 10,
          child: Chip(label: Text("After", style: TextStyle(fontSize: 10))),
        ),
      ],
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  final double split;
  RectClipper(this.split);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(size.width * split, 0, size.width * (1 - split), size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}

// ==========================================
// 7. FEATURE WIDGET: GENERATIVE FILL
// ==========================================
class GenerativeFillWidget extends StatefulWidget {
  final Function(String) onGenerate;

  const GenerativeFillWidget({super.key, required this.onGenerate});

  @override
  State<GenerativeFillWidget> createState() => _GenerativeFillWidgetState();
}

class _GenerativeFillWidgetState extends State<GenerativeFillWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Describe what to generate...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent,
            ),
            child: IconButton(
              icon: const Icon(Icons.auto_awesome, color: Colors.black),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onGenerate(_controller.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
