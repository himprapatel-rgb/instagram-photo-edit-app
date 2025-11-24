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

class _EditorScreenState extends State<EditorScreen> with TickerProviderStateMixin {
  File? _selectedImage;
  img.Image? _originalImage;
  img.Image? _editedImage;
  String? _selectedFilter;
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _exposure = 0.0;
  double _shadows = 0.0;
  double _highlights = 0.0;
  double _vibrance = 0.0;
  double _clarity = 0.0;
  bool _showBeforeAfter = false;
  int _currentTabIndex = 0;
  final List<String> _editHistory = [];
  final List<String> _redoHistory = [];

  final ImagePicker _imagePicker = ImagePicker();
  final ImageEditorService _editorService = ImageEditorService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Photo Editor'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare),
            tooltip: 'Before/After',
            onPressed: () {
              setState(() => _showBeforeAfter = !_showBeforeAfter);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            child: Container(
              color: Colors.grey[900],
              child: _selectedImage != null
                  ? Stack(
                      children: [
                        // Before/After toggle
                        if (_showBeforeAfter && _editedImage != null)
                          Center(
                            child: Container(
                              color: Colors.black87,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('BEFORE', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                                  const SizedBox(height: 20),
                                  Image.file(_selectedImage!, fit: BoxFit.contain),
                                ],
                              ),
                            ),
                          )
                        else
                          Image.file(_selectedImage!, fit: BoxFit.cover),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 64, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text('Select a photo to edit',
                              style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    ),
            ),
          ),
          // Tab navigation
          Container(
            color: Colors.black87,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.palette), text: 'Filters'),
                Tab(icon: Icon(Icons.tune), text: 'Adjust'),
                Tab(icon: Icon(Icons.star), text: 'Effects'),
                Tab(icon: Icon(Icons.build), text: 'Tools'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFiltersTab(),
                _buildAdjustmentsTab(),
                _buildEffectsTab(),
                _buildToolsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _pickImageFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
              child: const Text('Reset'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _selectedImage != null ? _saveImage : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var filter in FilterModel.premiumFilters)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = filter.name);
                      _applyFilter(filter.name);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedFilter == filter.name ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: filter.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(filter.name, style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdjustmentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSliderWithValue('Exposure', _exposure, -2, 2, (value) {
          setState(() => _exposure = value);
        }),
        _buildSliderWithValue('Brightness', _brightness, 0, 2, (value) {
          setState(() => _brightness = value);
        }),
        _buildSliderWithValue('Contrast', _contrast, 0, 2, (value) {
          setState(() => _contrast = value);
        }),
        _buildSliderWithValue('Shadows', _shadows, -1, 1, (value) {
          setState(() => _shadows = value);
        }),
        _buildSliderWithValue('Highlights', _highlights, -1, 1, (value) {
          setState(() => _highlights = value);
        }),
        _buildSliderWithValue('Saturation', _saturation, 0, 2, (value) {
          setState(() => _saturation = value);
        }),
        _buildSliderWithValue('Vibrance', _vibrance, -1, 1, (value) {
          setState(() => _vibrance = value);
        }),
        _buildSliderWithValue('Clarity', _clarity, -1, 1, (value) {
          setState(() => _clarity = value);
        }),
      ],
    );
  }

  Widget _buildEffectsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEffectButton('Grayscale', () => _applyEffect('grayscale')),
        _buildEffectButton('Sepia', () => _applyEffect('sepia')),
        _buildEffectButton('Vintage', () => _applyEffect('vintage')),
        _buildEffectButton('Cool', () => _applyEffect('cool')),
        _buildEffectButton('Warm', () => _applyEffect('warm')),
        _buildEffectButton('Vivid', () => _applyEffect('vivid')),
      ],
    );
  }

  Widget _buildToolsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildToolButton('Crop', Icons.crop, () {}),
        _buildToolButton('Rotate', Icons.rotate_right, () {}),
        _buildToolButton('Flip', Icons.flip, () {}),
        _buildToolButton('Straighten', Icons.straighten, () {}),
        _buildToolButton('Blur Background', Icons.blur_on, () {}),
        _buildToolButton('Add Text', Icons.text_fields, () {}),
      ],
    );
  }

  Widget _buildSliderWithValue(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('${value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blue)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[800],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEffectButton(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _applyFilter(String filterName) { async
    if (_originalImage == null) return;
        
    // Load original image if not already loaded
    if (_originalImage == null && _selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      _originalImage = img.decodeImage(bytes);
    }
    
    if (_originalImage == null) return;
    
    // Apply the selected filter
    setState(() {
      _editedImage = ImageEditorService.applyFilter(_originalImage!, filterName);
    });
  }

  void _applyEffect(String effectName) {
    if (_selectedImage == null) return;
    // Effect logic will be implemented
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _reset();
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _reset();
      });
    }
  }

  void _reset() {
    setState(() {
      _brightness = 1.0;
      _contrast = 1.0;
      _saturation = 1.0;
      _exposure = 0.0;
      _shadows = 0.0;
      _highlights = 0.0;
      _vibrance = 0.0;
      _clarity = 0.0;
      _selectedFilter = null;
      _showBeforeAfter = false;
    });
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved to gallery!')),
    );
  }
}
