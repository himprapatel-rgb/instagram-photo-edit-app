import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../models/filter_model.dart';
import '../services/image_editor_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  File? _selectedImage;
  img.Image? _editedImage;
  String? _selectedFilter;
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

  final ImagePicker _imagePicker = ImagePicker();
  final ImageEditorService _editorService = ImageEditorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Photo Editor'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image preview area
            Container(
              height: 400,
              color: Colors.grey[900],
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              size: 64, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text('No image selected',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
            // Controls section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image selection buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickImageFromCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Filters section
                  const Text('Filters',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var filter in FilterModel.predefinedFilters)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter.name),
                              selected: _selectedFilter == filter.name,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter =
                                      selected ? filter.name : null;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Adjustment sliders
                  const Text('Adjustments',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  _buildSlider('Brightness', _brightness, 0, 2, (value) {
                    setState(() => _brightness = value);
                  }),
                  _buildSlider('Contrast', _contrast, 0, 2, (value) {
                    setState(() => _contrast = value);
                  }),
                  _buildSlider('Saturation', _saturation, 0, 2, (value) {
                    setState(() => _saturation = value);
                  }),
                  const SizedBox(height: 20),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _reset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedImage != null ? _saveImage : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _reset() {
    setState(() {
      _brightness = 1.0;
      _contrast = 1.0;
      _saturation = 1.0;
      _selectedFilter = null;
    });
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved to gallery!')),
    );
  }
}
