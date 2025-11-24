/// Instagram Photo Editor - Main Entry Point
/// Professional Flutter application with image upload and editing
/// Author: Himanshu Prapatel

import 'package:flutter/material.dart';
import 'dart:html' as html;

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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
  List<String> _selectedImageUrls = []; // Store multiple selected images
  bool _isUploading = false;

  // Pick images from device
  Future<void> _pickImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create file input element
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true; // Enable multiple file selection
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          // Process ALL selected files
          for (var file in files) {
            // Validate file size (max 10MB)
            const maxSize = 10 * 1024 * 1024; // 10MB in bytes
            if (file.size > maxSize) {
              // Skip files that are too large
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Skipped ${file.name}: File too large! Max 10MB. Size: ${(file.size / (1024 * 1024)).toStringAsFixed(2)}MB'),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              continue; // Skip this file and move to next
            }

            // Read each file
            final reader = html.FileReader();
            reader.onLoadEnd.listen((e) {
              setState(() {
                _selectedImageUrls.add(reader.result as String);
              });
            });
            reader.readAsDataUrl(file);
          }

          // All files loaded
          setState(() {
            _isUploading = false;
          });

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${files.length} image(s) loaded successfully!'),
                backgroundColor: const Color(0xFF8B5CF6),
                duration: const Duration(seconds: 2),
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
          SnackBar(
            content: Text('Error loading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram Photo Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'Professional photo editing app for Instagram.\n\nFeatures:\n• 24 Professional Filters\n• Crop & Transform Tools\n• Instagram Aspect Ratios\n• Multi-Image Batch Editing\n• AI-Powered Editing (Coming Soon)\n• Social Media Integration (Coming Soon)',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image preview or placeholder
              if (_selectedImageUrls.isNotEmpty)
                Column(
                  children: [
                    // Show image count
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
                    // Display first image as preview
                    Container(
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
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
                    // Show grid of thumbnails if multiple images
                    if (_selectedImageUrls.length > 1) ..[
                      const SizedBox(height: 16),
                      Text(
                        'All Selected Images:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedImageUrls.asMap().entries.map((entry) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF8B5CF6),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                entry.value,
                                fit: BoxFit.cover,
                              ),
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
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 80,
                        color: Color(0xFF8B5CF6),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No images selected',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Select multiple images',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 48),

              // Upload button
              if (_isUploading)
                const CircularProgressIndicator(
                  color: Color(0xFF8B5CF6),
                )
              else
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate, size: 24),
                  label: Text(
                    _selectedImageUrls.isEmpty
                        ? 'Select Photos'
                        : 'Add More Photos',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),

              const SizedBox(height: 16),

              // Edit button (only show if image is selected)
              if (_selectedImageUrls.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Batch editor coming soon! Ready to edit ${_selectedImageUrls.length} image(s) 🚀'),
                        backgroundColor: const Color(0xFF8B5CF6),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
                  label: const Text(
                    'Start Batch Editing',
                    style:
                        TextStyle(fontSize: 18, color: Color(0xFF8B5CF6)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 48),

              // Features list
              const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem('🎨 24 Professional Filters'),
              _buildFeatureItem('✂️ Crop & Transform Tools'),
              _buildFeatureItem('📱 Instagram Aspect Ratios'),
              _buildFeatureItem('📸 Multi-Image Batch Editing'),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
