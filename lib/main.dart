import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Photo Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Uint8List> selectedImages = [];

  void pickImages() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        List<Uint8List> images = [];
        int loaded = 0;
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoad.listen((_) {
            images.add(Uint8List.fromList(reader.result as List<int>));
            loaded++;
            if (loaded == files.length) {
              setState(() => selectedImages = images);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorPage(images: images),
                ),
              );
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instagram Photo Editor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            const Text('Select photos to edit', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Photos'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditorPage extends StatefulWidget {
  final List<Uint8List> images;
  const EditorPage({Key? key, required this.images}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  int currentIndex = 0;
  Map<int, String> selectedFilters = {};
  List<String> filters = [
    'None',
    'Clarendon',
    'Gingham',
    'Juno',
    'Lark',
    'Ludwig',
    'Nashville',
    'Perpetua',
    'Reyes',
    'Slumber',
    'Toaster',
    'Valencia',
    'Walden',
    'Willow',
    'X-Pro II',
    'Lo-Fi',
    'Hudson',
    'Inkwell',
    'Amaro',
    'Rise',
    'Hefe',
    'Sutro',
    'Brannan',
    'Earlybird',
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.images.length; i++) {
      selectedFilters[i] = 'None';
    }
  }

  void selectFilter(String filter) {
    setState(() {
      selectedFilters[currentIndex] = filter;
    });
  }

  void downloadImage() {
    final image = widget.images[currentIndex];
    final filter = selectedFilters[currentIndex] ?? 'None';
    final blob = html.Blob([image], 'image/jpeg');
    final url = html.Url.createObjectUrl(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'photo_${currentIndex + 1}_$filter.jpg')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Photo')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Image.memory(
                widget.images[currentIndex],
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => selectFilter(filters[i]),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedFilters[currentIndex] == filters[i]
                          ? Colors.blue
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      filters[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () => setState(() => currentIndex--)
                      : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed: downloadImage,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
                ElevatedButton(
                  onPressed: currentIndex < widget.images.length - 1
                      ? () => setState(() => currentIndex++)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
mport 'dart:typed_data';
