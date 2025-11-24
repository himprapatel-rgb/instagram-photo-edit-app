import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Instagram Photo Editor',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void pickImages() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        List<String> dataUrls = [];
        int loaded = 0;
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((_) {
            dataUrls.add(reader.result as String);
            loaded++;
            if (loaded == files.length) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorPage(imageUrls: dataUrls),
                ),
              );
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Instagram Photo Editor')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text('24 Instagram Filters Available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: pickImages,
            icon: const Icon(Icons.photo_library),
            label: const Text('Pick Photos'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
          ),
        ],
      ),
    ),
  );
}

class EditorPage extends StatefulWidget {
  final List<String> imageUrls;
  const EditorPage({Key? key, required this.imageUrls}) : super(key: key);
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  int currentIndex = 0;
  Map<int, String> selectedFilters = {};
  List<String> filters = ['None','Clarendon','Gingham','Juno','Lark','Ludwig','Nashville','Perpetua','Reyes','Slumber','Toaster','Valencia','Walden','Willow','X-Pro II','Lo-Fi','Hudson','Inkwell','Amaro','Rise','Hefe','Sutro','Brannan','Earlybird'];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.imageUrls.length; i++) {
      selectedFilters[i] = 'None';
    }
  }

  void selectFilter(String filter) => setState(() => selectedFilters[currentIndex] = filter);

  void downloadImage() {
    final filter = selectedFilters[currentIndex] ?? 'None';
    final link = html.AnchorElement(href: widget.imageUrls[currentIndex])
      ..setAttribute('download', 'photo_${currentIndex + 1}_$filter.jpg')
      ..click();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit Photo ${currentIndex + 1}')),
    body: Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Image.network(widget.imageUrls[currentIndex], fit: BoxFit.contain),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () => selectFilter(filters[i]),
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedFilters[currentIndex] == filters[i] ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(filters[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0 ? () => setState(() => currentIndex--) : null,
                child: const Text('Previous'),
              ),
              ElevatedButton.icon(
                onPressed: downloadImage,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton(
                onPressed: currentIndex < widget.imageUrls.length - 1 ? () => setState(() => currentIndex++) : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
