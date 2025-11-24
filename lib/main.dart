/// Instagram Photo Editor - Main Entry Point
/// Professional Flutter application with image editing
/// Author: Himanshu Prapatel
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

void main() {
  runApp(const InstagramPhotoEditorApp());
}

class InstagramPhotoEditorApp extends StatelessWidget {
  const InstagramPhotoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Photo Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF8B5CF6),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _selectedImageUrls = [];
  bool _isUploading = false;

  Future<void> _pickImage() async {
    setState(() {
      _isUploading = true;
    });
    try {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true;
      uploadInput.click();
      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            const maxSize = 10 * 1024 * 1024;
            if (file.size > maxSize) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File too large: ${file.name}'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
              continue;
            }
            final reader = html.FileReader();
            reader.onLoadEnd.listen((e) {
              setState(() {
                _selectedImageUrls.add(reader.result as String);
              });
            });
            reader.readAsDataUrl(file);
          }
          setState(() {
            _isUploading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${files.length} image(s) loaded!'),
                backgroundColor: const Color(0xFF8B5CF6),
              ),
            );
          }
        }
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Photo Editor', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImageUrls.isNotEmpty)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selectedImageUrls.length} Image(s) Selected',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          _selectedImageUrls.first,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (_selectedImageUrls.length > 1) ...[  
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedImageUrls.asMap().entries.map((entry) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(entry.value, fit: BoxFit.cover),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                )
              else
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3), width: 2),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 80, color: Color(0xFF8B5CF6)),
                      SizedBox(height: 16),
                      Text('No images selected', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                ),
              const SizedBox(height: 48),
              if (_isUploading)
                const CircularProgressIndicator(color: Color(0xFF8B5CF6))
              else
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate, size: 24),
                  label: Text(
                    _selectedImageUrls.isEmpty ? 'Select Photos' : 'Add More Photos',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              const SizedBox(height: 16),
              if (_selectedImageUrls.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditorScreen(imageUrls: _selectedImageUrls),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
                  label: const Text('Start Batch Editing', style: TextStyle(fontSize: 18, color: Color(0xFF8B5CF6))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              const SizedBox(height: 48),
              const Text('Features:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildFeatureItem('🎨 24 Professional Filters'),
              _buildFeatureItem('✂️ Crop & Transform Tools'),
              _buildFeatureItem('📱 Instagram Aspect Ratios'),
              _buildFeatureItem('📸 Batch Image Editing'),
              _buildFeatureItem('🤖 AI-Powered Editing (Coming Soon)'),
              _buildFeatureItem('🚀 Social Media Integration (Coming Soon)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white70)),
    );
  }
}

class EditorScreen extends StatefulWidget {
  final List<String> imageUrls;
  const EditorScreen({required this.imageUrls, super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late int _currentImageIndex;
  late List<double> _brightness;
  late List<double> _contrast;
  late List<double> _saturation;

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    _brightness = List.filled(widget.imageUrls.length, 1.0);
    _contrast = List.filled(widget.imageUrls.length, 1.0);
    _saturation = List.filled(widget.imageUrls.length, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Images'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(_getColorMatrix()),
                child: Image.network(widget.imageUrls[_currentImageIndex]),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                Text('Image ${_currentImageIndex + 1} of ${widget.imageUrls.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 12),
                Slider(
                  value: _brightness[_currentImageIndex],
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) => setState(() => _brightness[_currentImageIndex] = value),
                  label: 'Brightness: ${_brightness[_currentImageIndex].toStringAsFixed(2)}',
                ),
                Slider(
                  value: _contrast[_currentImageIndex],
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) => setState(() => _contrast[_currentImageIndex] = value),
                  label: 'Contrast: ${_contrast[_currentImageIndex].toStringAsFixed(2)}',
                ),
                Slider(
                  value: _saturation[_currentImageIndex],
                  min: 0.0,
                  max: 2.0,
                  onChanged: (value) => setState(() => _saturation[_currentImageIndex] = value),
                  label: 'Saturation: ${_saturation[_currentImageIndex].toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_currentImageIndex > 0)
                      ElevatedButton(
                        onPressed: () => setState(() => _currentImageIndex--),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                        child: const Text('Previous'),
                      ),
                    if (_currentImageIndex < widget.imageUrls.length - 1)
                      ElevatedButton(
                        onPressed: () => setState(() => _currentImageIndex++),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                        child: const Text('Next'),
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

  List<double> _getColorMatrix() {
    final b = _brightness[_currentImageIndex];
    final c = _contrast[_currentImageIndex];
    final s = _saturation[_currentImageIndex];
    return [
      c * s, 0, 0, 0, b,
      0, c * s, 0, 0, b,
      0, 0, c * s, 0, b,
      0, 0, 0, 1, 0,
    ];
  }
}
