import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() => runApp(const InstagramPhotoEditorApp());

class InstagramPhotoEditorApp extends StatelessWidget {
  const InstagramPhotoEditorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Instagram Photo Editor',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(primaryColor: const Color(0xFF8B5CF6)),
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

  Future<void> _pickImage() async {
    setState(() => _uploading = true);
    final input = html.FileUploadInputElement()..accept = 'image/*'..multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null) {
        for (var file in files) {
          if (file.size > 10 * 1024 * 1024) continue;
          final reader = html.FileReader();
          reader.onLoadEnd.listen((_) => setState(() => _images.add(reader.result as String)));
          reader.readAsDataUrl(file);
        }
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
          children: [
            if (_images.isNotEmpty)
              Column(children: [
                Image.network(_images.first, height: 400),
                const SizedBox(height: 16),
                if (_images.length > 1) Wrap(spacing: 8, children: _images.asMap().entries.map((e) => Container(width: 80, height: 80, decoration: BoxDecoration(border: Border.all(color: const Color(0xFF8B5CF6), width: 2), borderRadius: BorderRadius.circular(8)), child: Image.network(e.value, fit: BoxFit.cover))).toList()),
              ])
            else Container(width: 300, height: 300, decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey, width: 1)), child: const Icon(Icons.photo_library, size: 80, color: Color(0xFF8B5CF6))),
            const SizedBox(height: 48),
            _uploading ? const CircularProgressIndicator(color: Color(0xFF8B5CF6)) : ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.add_photo_alternate), label: Text(_images.isEmpty ? 'Select Photos' : 'Add More'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6))),
            const SizedBox(height: 16),
            if (_images.isNotEmpty) ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(images: _images))), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)), child: const Text('Start Batch Editing')),
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
  final List<Map<String, dynamic>> filters = [
    {'name': 'None', 'matrix': [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Clarendon', 'matrix': [1.2,0,0,0,0, 0,1.1,0,0,0, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Gingham', 'matrix': [1,0,0.1,0,0, 0,1,0,0,0, 0.1,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Juno', 'matrix': [1.1,0,0,0,0.05, 0,1,0,0,0, 0,0,1.2,0,0, 0,0,0,1,0]},
    {'name': 'Lark', 'matrix': [1,0,0,0,0, 0,1.1,0,0,-0.05, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Ludwig', 'matrix': [0.9,0,0,0,0, 0,1.1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Nashville', 'matrix': [1.2,0.1,0,0,0.1, 0,0.9,0,0,0, 0,0,0.8,0,0, 0,0,0,1,0]},
    {'name': 'Perpetua', 'matrix': [1,0,0,0,0, 0,1.05,0,0,0, 0,0,1.1,0,0, 0,0,0,1,0]},
    {'name': 'Reyes', 'matrix': [1.1,0,0,0,0, 0,1,0,0,0, 0,0,0.9,0,0, 0,0,0,1,0.1]},
    {'name': 'Slumber', 'matrix': [1,0,0,0,0, 0.05,1.05,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Toaster', 'matrix': [1.3,0.1,0,0,0.2, 0,1,0,0,0, 0,0,0.7,0,0, 0,0,0,1,0]},
    {'name': 'Valencia', 'matrix': [1.08,0.08,0,0,0.08, 0,1.08,0,0,0, 0,0,0.92,0,0, 0,0,0,1,0]},
    {'name': 'Walden', 'matrix': [1,0,0,0,0, 0,1.1,0,0,0, 0,0,0.85,0,0, 0,0,0,1,0]},
    {'name': 'Willow', 'matrix': [0.9,0,0.1,0,0, 0,1,0,0,0, 0.1,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'X-Pro II', 'matrix': [1.3,0,0,0,0.15, 0,1,0,0,0, 0,0,0.7,0,0, 0,0,0,1,0]},
    {'name': 'Lo-Fi', 'matrix': [1.1,0.1,0,0,0.1, 0,1,0,0,0, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Hudson', 'matrix': [1.2,0,0,0,0, 0,1.1,0,0,0, 0,0,0.8,0,0, 0,0,0,1,0]},
    {'name': 'Inkwell', 'matrix': [0.3,0.3,0.3,0,0, 0.3,0.3,0.3,0,0, 0.3,0.3,0.3,0,0, 0,0,0,1,0]},
    {'name': 'Amaro', 'matrix': [1.1,0,0,0,0, 0,1.1,0,0,0, 0,0,1,0,0, 0,0,0,1,0.05]},
    {'name': 'Rise', 'matrix': [1,0.05,0,0,0.05, 0,1.05,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Hefe', 'matrix': [1.1,0.1,0,0,0, 0,1,0,0,0, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Sutro', 'matrix': [1,0,0,0,0, 0,0.9,0,0,0, 0,0,1.1,0,0, 0,0,0,1,0]},
    {'name': 'Brannan', 'matrix': [1.3,0.2,0,0,0, 0,1,0,0,0, 0,0,0.7,0,0, 0,0,0,1,0]},
    {'name': 'Earlybird', 'matrix': [1,0.1,0,0,0.1, 0,1.05,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
  ];

  @override
  void initState() {
    super.initState();
    _index = 0;
    _filters = List.filled(widget.images.length, 'None');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit Images'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
    body: Column(children: [
      Expanded(child: Center(child: ColorFiltered(colorFilter: ColorFilter.matrix(_getMatrix()), child: Image.network(widget.images[_index])))),
      Container(
        color: const Color(0xFF1E293B),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('Image ${_index + 1} of ${widget.images.length}', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: filters.map((f) {
                bool sel = _filters[_index] == f['name'];
                return GestureDetector(
                  onTap: () => setState(() => _filters[_index] = f['name']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(border: Border.all(color: sel ? const Color(0xFF8B5CF6) : Colors.grey, width: sel ? 3 : 1), borderRadius: BorderRadius.circular(8)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 35, height: 35, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)), child: ColorFiltered(colorFilter: ColorFilter.matrix((f['matrix'] as List<double>).map((e) => e.toDouble()).toList()), child: Container(color: const Color(0xFF8B5CF6)))),
                      const SizedBox(height: 2),
                      Text(f['name'], style: const TextStyle(fontSize: 9, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (_index > 0) ElevatedButton(onPressed: () => setState(() => _index--), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)), child: const Text('Previous')),
            if (_index < widget.images.length - 1) ElevatedButton(onPressed: () => setState(() => _index++), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)), child: const Text('Next')),
          ]),
        ]),
      ),
    ]),
  );

  List<double> _getMatrix() {
    final filter = filters.firstWhere((f) => f['name'] == _filters[_index]);
    return (filter['matrix'] as List).map((e) => (e as num).toDouble()).toList();
  }
}
