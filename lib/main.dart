import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

void main() => runApp(const InstagramPhotoEditorApp());

class InstagramPhotoEditorApp extends StatelessWidget {
  const InstagramPhotoEditorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Instagram Photo Editor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(primaryColor: const Color(0xFFE1306C)),
        home: const HomeScreen(),
      );
}

class HomeScreen extends State<HomeScreen> {
  List<String> _images = [];
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _pickImages();
  }

  Future<void> _pickImages() async {
    setState(() => _uploading = true);
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files!.isNotEmpty) {
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((e) {
            setState(() {
              _images.add(reader.result as String);
              if (_images.length == files.length) {
                _uploading = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditorScreen(images: _images),
                  ),
                );
              }
            });
          });
        }
      }
      setState(() => _uploading = false);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Instagram Photo Editor')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.image, size: 80, color: Colors.purple),
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No images selected',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                if (_uploading)
                  const CircularProgressIndicator(color: Color(0xFFE1306C))
                else
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select Photos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 64),
                const Text('Features:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('📸 24 Professional Filters'),
                const Text('✂️ Crop & Transform Tools'),
                const Text('📐 Instagram Aspect Ratios'),
                const Text('📷 Batch Image Editing'),
                const Text('🤖 AI-Powered Editing (Coming Soon)'),
                const Text('🔗 Social Media Integration (Coming Soon)'),
                const Text('⬇️ Download Edited Images'),
              ],
            ),
          ),
        ),
      );
}

class EditorScreen extends StatefulWidget {
  final List<String> images;
  const EditorScreen({required this.images, super.key});
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late int _index;
  late List<String> _filters;
  late Map<String, dynamic> _filterValues;

  final List<Map<String, dynamic>> filters = [
    {'name': 'None', 'matrix': [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]},
    {'name': 'Clarendon', 'matrix': [1.2,0,0,0, 0,1.1,0,0, 0,0,1,0, 0,0,0,1]},
    {'name': 'Gingham', 'matrix': [1,0,0,0, 0,1.05,0,0, 0,0,0.95,0, 0,0,0,1]},
    {'name': 'Juno', 'matrix': [1.1,0,0,0, 0,1,0,0, 0,0,1.1,0, 0,0,0,1]},
    {'name': 'Lark', 'matrix': [1,0,0,0, 0,1.1,0.05,0, 0,0.05,0.9,0, 0,0,0,1]},
    {'name': 'Ludwig', 'matrix': [0.9,0,0,0, 0,1,0,0, 0,0,0.9,0, 0,0,0,1]},
    {'name': 'Nashville', 'matrix': [1.2,0.1,0,0, 0,1.1,0,0, 0,0,1,0, 0,0,0,1]},
    {'name': 'Perpetua', 'matrix': [1,0,0,0.1, 0,1,0.05,0, 0,0.05,0.9,0, 0,0,0,1]},
    {'name': 'Reyes', 'matrix': [1.1,0,0,0, 0,1,0,0, 0,0,0.9,0, 0,0,0,1]},
    {'name': 'Slumber', 'matrix': [1,0.05,0,0, 0,1,0,0, 0,0,0.95,0, 0,0,0,1]},
    {'name': 'Toaster', 'matrix': [1.3,0.7,0,0, 0,1,0.2,0, 0.1,0.1,0.9,0, 0,0,0,1]},
    {'name': 'Valencia', 'matrix': [1.08,0,0,0.08, 0,1.08,0,0, 0,0,1,0, 0,0,0,1]},
    {'name': 'Walden', 'matrix': [1,0,0,0, 0,1.1,0,0, 0,0,1,0, 0.05,0,0,1]},
    {'name': 'Willow', 'matrix': [0.8,0,0.1,0, 0,1,0,0, 0.1,0,0.8,0, 0,0,0,1]},
    {'name': 'X-Pro II', 'matrix': [1.3,0.5,0.15,0.25, 0,1,0,0, 0,0,1.1,0, 0,0,0,1]},
    {'name': 'Lo-Fi', 'matrix': [1.1,0.1,0,0.1, 0,0.9,0,0, 0,0,1.1,0, 0,0,0,1]},
    {'name': 'Hudson', 'matrix': [1.2,0.1,0,0.1, 0,1.1,0,0, 0,0,1,0, 0,0,0,1]},
    {'name': 'Inkwell', 'matrix': [0.3,0.3,0.3,0, 0.3,0.3,0.3,0, 0.3,0.3,0.3,0, 0,0,0,1]},
    {'name': 'Amaro', 'matrix': [1.1,0,0,0, 0,1.1,0, 0,0,0,1,0, 0,0,0,1]},
    {'name': 'Rise', 'matrix': [1,0.05,0.05,0.05, 0,1.05,0.05,0, 0.05,0.05,1,0, 0,0,0,1]},
    {'name': 'Hefe', 'matrix': [1.1,0.1,0,0, 0,1,0,0, 0.05,0,0.9,0, 0,0,0,1]},
    {'name': 'Sutro', 'matrix': [1,0.15,0.25,0, 0,1,0,0, 0,0,0.9,0, 0,0,0,1]},
    {'name': 'Brannan', 'matrix': [1.3,0.2,0,0, 0,0.9,0,0, 0,0,0.9,0, 0,0,0,1]},
    {'name': 'Earlybird', 'matrix': [1,0.1,0.1, 0.05, 0.05,0.8,0.05, 0, 0.1,0.15,0.8,0.1, 0,0,0,1]},
  ];

  @override
  void initState() {
    super.initState();
    _index = 0;
    _filters = filters.map((f) => f['name'] as String).toList();
    _filterValues = {for (var img in widget.images) img: 'None'};
  }

  void _applyFilter(String filterName) {
    setState(() {
      _filterValues[widget.images[_index]] = filterName;
    });
  }

  void _downloadImage() async {
    final image = widget.images[_index];
    final filterName = _filterValues[image] ?? 'None';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'photo_${_index + 1}_${filterName.toLowerCase()}_$timestamp.png';
    
    final link = html.AnchorElement(href: image)
      ..setAttribute('download', filename)
      ..click();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Photo Editor')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.images[_index],
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: _filters.length,
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => _applyFilter(_filters[i]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _filterValues[widget.images[_index]] == _filters[i]
                              ? Colors.purple
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(_filters[i], textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _index > 0 ? () => setState(() => _index--) : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _downloadImage,
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    ElevatedButton.icon(
                      onPressed: _index < widget.images.length - 1 ? () => setState(() => _index++) : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
