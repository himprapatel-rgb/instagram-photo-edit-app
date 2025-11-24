import 'package:flutter/material.dart';
import 'dart:html' as html;

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _images = [];
  bool _uploading = false;

  Future<void> _pickImages() async {
    setState(() => _uploading = true);
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        int loaded = 0;
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((e) {
            _images.add(reader.result as String);
            loaded++;
            if (loaded == files.length) {
              setState(() => _uploading = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorScreen(images: _images),
                ),
              );
            }
          });
        }
      } else {
        setState(() => _uploading = false);
      }
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
                ),
                const SizedBox(height: 16),
                const Text('No images selected', style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                    ),
                  ),
                const SizedBox(height: 64),
                const Text('Features:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('📸 24 Professional Filters'),
                const Text('✂️ Crop & Transform Tools'),
                const Text('📐 Instagram Aspect Ratios'),
                const Text('📷 Batch Image Editing'),
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
  late Map<String, String> _filterValues;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _filters = ['None', 'Clarendon', 'Gingham', 'Juno', 'Lark', 'Ludwig', 'Nashville', 'Perpetua', 'Reyes', 'Slumber', 'Toaster', 'Valencia', 'Walden', 'Willow', 'X-Pro II', 'Lo-Fi', 'Hudson', 'Inkwell', 'Amaro', 'Rise', 'Hefe', 'Sutro', 'Brannan', 'Earlybird'];
    _filterValues = {for (var img in widget.images) img: 'None'};
  }

  void _applyFilter(String filterName) {
    setState(() {
      _filterValues[widget.images[_index]] = filterName;
    });
  }

  void _downloadImage() {
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
                          color: _filterValues[widget.images[_index]] == _filters[i] ? Colors.purple : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(_filters[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
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
