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
  String? _selectedImageUrl;
  bool _isUploading = false;

  // Pick image from device
  Future<void> _pickImage() async {
    setState(() {
  List<String> _selectedImageUrls = []; // Store multiple selected images    });

    try {
      // Create file input element
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
            uploadInput.multiple = true; // Enable multiple file selection
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];

                        // Validate file size (max 10MB)
              const maxSize = 10 * 1024 * 1024; // 10MB in bytes
              if (file.size > maxSize) {
                setState(() {
                  _isUploading = false;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image too large! Max size is 10MB. Your file: ${(file.size / (1024 * 1024)).toStringAsFixed(2)}MB'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
                return;
              }
          final reader = html.FileReader();

          reader.onLoadEnd.listen((e) {
            setState(() {
              _selectedImageUrl = reader.result as String;
              _isUploading = false;
            });

            // Show success message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                      content: Text('✅ Image loaded! Size: ${(file.size / (1024 * 1024)).toStringAsFixed(2)}MB'),                  backgroundColor: Color(0xFF8B5CF6),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });

          reader.readAsDataUrl(file);
        } else {
          setState(() {
            _isUploading = false;
          });
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
                    'Professional photo editing app for Instagram.\n\nFeatures:\n\u2022 24 Professional Filters\n\u2022 Crop & Transform Tools\n\u2022 Instagram Aspect Ratios\n\u2022 AI-Powered Editing (Coming Soon)\n\u2022 Social Media Integration (Coming Soon)',
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
              if (_selectedImageUrl != null)
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
                      _selectedImageUrl!,
                      fit: BoxFit.contain,
                    ),
                  ),
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
                        Icons.photo_filter,
                        size: 80,
                        color: Color(0xFF8B5CF6),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No image selected',
                        style: TextStyle(
                          fontSize: 18,
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
                  icon: const Icon(Icons.upload_file, size: 24),
                  label: Text(
                    _selectedImageUrl == null ? 'Upload Photo' : 'Change Photo',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Edit button (only show if image is selected)
              if (_selectedImageUrl != null)
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Editor coming soon! \ud83d\ude80'),
                        backgroundColor: Color(0xFF8B5CF6),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
                  label: const Text(
                    'Start Editing',
                    style: TextStyle(fontSize: 18, color: Color(0xFF8B5CF6)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
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
              _buildFeatureItem('\ud83c\udfa8 24 Professional Filters'),
              _buildFeatureItem('\u2702\ufe0f Crop & Transform Tools'),
              _buildFeatureItem('\ud83d\udcf1 Instagram Aspect Ratios'),
              _buildFeatureItem('\ud83e\udd16 AI-Powered Editing (Coming Soon)'),
              _buildFeatureItem('\ud83d\ude80 Social Media Integration (Coming Soon)'),
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
