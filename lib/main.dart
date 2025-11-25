import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

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
              const Text('24 Instagram Filters Available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Photos'),
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
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
  Map<int, double> filterIntensity = {};

  final Map<String, ui.ColorFilter> filterMatrix = {
    'None': ui.ColorFilter.linearToSrgbGamma(),
    'Clarendon': ui.ColorFilter.srgbToLinearGamma(),
    'Gingham':
        ui.ColorFilter.mode(Colors.cyan.withOpacity(0.1), BlendMode.lighten),
    'Juno':
        ui.ColorFilter.mode(Colors.yellow.withOpacity(0.1), BlendMode.lighten),
    'Lark':
        ui.ColorFilter.mode(Colors.blue.withOpacity(0.1), BlendMode.lighten),
    'Ludwig': ui.ColorFilter.mode(Colors.white.withOpacity(0.2),
        BlendMode.darken),
    'Nashville': ui.ColorFilter.mode(Colors.orange.withOpacity(0.15),
        BlendMode.lighten),
    'Perpetua': ui.ColorFilter.mode(Colors.pink.withOpacity(0.1),
        BlendMode.lighten),
    'Reyes':
        ui.ColorFilter.mode(Colors.yellow.withOpacity(0.05), BlendMode.lighten),
    'Slumber': ui.ColorFilter.mode(Colors.purple.withOpacity(0.1),
        BlendMode.lighten),
    'Toaster':
        ui.ColorFilter.mode(Colors.red.withOpacity(0.2), BlendMode.lighten),
    'Valencia': ui.ColorFilter.mode(Colors.amber.withOpacity(0.15),
        BlendMode.lighten),
    'Walden': ui.ColorFilter.mode(Colors.green.withOpacity(0.15),
        BlendMode.lighten),
    'Willow':
        ui.ColorFilter.mode(Colors.teal.withOpacity(0.15), BlendMode.lighten),
    'X-Pro II': ui.ColorFilter.mode(Colors.red.withOpacity(0.15),
        BlendMode.lighten),
    'Lo-Fi':
        ui.ColorFilter.mode(Colors.brown.withOpacity(0.15), BlendMode.lighten),
    'Hudson': ui.ColorFilter.mode(Colors.indigo.withOpacity(0.1),
        BlendMode.lighten),
    'Inkwell': ui.ColorFilter.mode(Colors.grey.withOpacity(0.5),
        BlendMode.darken),
    'Amaro': ui.ColorFilter.mode(Colors.amber.withOpacity(0.1),
        BlendMode.lighten),
    'Rise':
        ui.ColorFilter.mode(Colors.yellow.withOpacity(0.08), BlendMode.lighten),
    'Hefe':
        ui.ColorFilter.mode(Colors.orange.withOpacity(0.1), BlendMode.lighten),
    'Sutro': ui.ColorFilter.mode(Colors.orange.withOpacity(0.12),
        BlendMode.lighten),
    'Brannan':
        ui.ColorFilter.mode(Colors.red.withOpacity(0.12), BlendMode.lighten),
    'Earlybird': ui.ColorFilter.mode(Colors.orange.withOpacity(0.15),
        BlendMode.lighten),
  };

  final List<String> filters = [
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
    'Earlybird'
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.imageUrls.length; i++) {
      selectedFilters[i] = 'None';
      filterIntensity[i] = 1.0; // Full intensity by default
    }
  }

  void selectFilter(String filter) =>
      setState(() => selectedFilters[currentIndex] = filter);

  void updateIntensity(double intensity) =>
      setState(() => filterIntensity[currentIndex] = intensity);

  void downloadImage() {
    final filter = selectedFilters[currentIndex] ?? 'None';
    final intensity = filterIntensity[currentIndex] ?? 1.0;
    final link = html.AnchorElement(
        href: widget.imageUrls[currentIndex])
      ..setAttribute(
          'download',
          'photo_${currentIndex + 1}_${filter}_${(intensity * 100).toStringAsFixed(0)}%.jpg')
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = selectedFilters[currentIndex] ?? 'None';
    final currentIntensity = filterIntensity[currentIndex] ?? 1.0;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Photo ${currentIndex + 1}')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Opacity(
                  opacity: currentIntensity,
                  child: ColorFiltered(
                    colorFilter: filterMatrix[currentFilter] ??
                        ui.ColorFilter.linearToSrgbGamma(),
                    child: Image.network(
                      widget.imageUrls[currentIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Intensity: ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Slider(
                        value: currentIntensity,
                        min: 0.0,
                        max: 1.0,
                        divisions: 100,
                        label: '${(currentIntensity * 100).toStringAsFixed(0)}%',
                        onChanged: updateIntensity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
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
                      color:
                          currentFilter == filters[i] ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(filters[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11)),
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
                  onPressed: currentIndex > 0
                      ? () => setState(() => currentIndex--)
                      : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed: downloadImage,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: currentIndex < widget.imageUrls.length - 1
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
}
