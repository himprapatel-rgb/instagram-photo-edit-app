import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
// v0.5.0 - Instagram UI Enhancement

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF833AB4),  // Instagram Purple
              Color(0xFFFD1D1D),  // Instagram Pink
              Color(0xFFFCAF45),  // Instagram Orange
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instagram Photo Editor',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '24 Professional Filters',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 48),

                  // Feature Cards with Glassmorphism
                  _buildGlassCard(
                    icon: Icons.filter_vintage,
                    title: 'Pro Filters',
                    description: '24 Instagram-style filters',
                  ),
                  SizedBox(height: 16),
                  _buildGlassCard(
                    icon: Icons.tune,
                    title: 'Adjustments',
                    description: 'Brightness, Contrast, Saturation',
                  ),
                  SizedBox(height: 16),
                  _buildGlassCard(
                    icon: Icons.auto_awesome,
                    title: 'Real-time Preview',
                    description: 'See changes instantly',
                  ),
                  SizedBox(height: 48),

                  // CTA Button with Gradient
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: pickImages,
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Pick Photos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Stats
                  Text(
                    '✨ Free • No Watermark • Unlimited Edits',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    // Glassmorphism Card Widget
  Widget _buildGlassCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
    Map<int, double> brightness = {};
  Map<int, double> contrast = {};
  Map<int, double> saturation = {};
  Map<int, double> filterIntensity = {};

  final Map<String, ui.ColorFilter> filterMatrix = {
    'None': ui.ColorFilter.linearToSrgbGamma(),
    'Clarendon': ui.ColorFilter.srgbToLinearGamma(),
    'Gingham':
        ui.ColorFilter.mode(Colors.cyan.withOpacity(0.1), BlendMode.lighten),
     'Juno':          ui.ColorFilter.mode(Colors.yellow.withOpacity(0.1), BlendMode.lighten),
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
      filterIntensity[i] = 1.0;
            brightness[i] = 0.0;
      contrast[i] = 1.0;
      saturation[i] = 1.0;
    }
  }

  void selectFilter(String filter) {
    setState(() => selectedFilters[currentIndex] = filter);
  }

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

    // Helper method to apply brightness adjustment
  ui.ColorFilter _getAdjustmentFilter() {
    final b = brightness[currentIndex] ?? 0.0;
    final c = contrast[currentIndex] ?? 1.0;
    final s = saturation[currentIndex] ?? 1.0;
    
    // Simplified approach: Use matrix for combined adjustments
    // Note: Full ColorMatrix implementation requires more complex calculations
    // For now, returning a simple filter that will be enhanced
    return ui.ColorFilter.linearToSrgbGamma();
  }

  void showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Filter',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filters.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    selectFilter(filters[i]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedFilters[currentIndex] == filters[i]
                            ? Colors.blue
                            : Colors.grey,
                        width:
                            selectedFilters[currentIndex] == filters[i] ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ColorFiltered(
                              colorFilter: filterMatrix[filters[i]] ?? ui.ColorFilter.linearToSrgbGamma(),
                              child: Image.network(
                                widget.imageUrls[currentIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.image, color: Colors.white54, size: 24),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          filters[i],
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    void showAdjustModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Adjust Image',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Brightness Slider
                    Text('Brightness: ${brightness[currentIndex]?.toStringAsFixed(0) ?? "0"}'),
                    Slider(
                      value: brightness[currentIndex] ?? 0.0,
                      min: -100,
                      max: 100,
                      divisions: 200,
                      label: brightness[currentIndex]?.toStringAsFixed(0),
                      onChanged: (value) => setState(() => brightness[currentIndex] = value),
                    ),
                    const SizedBox(height: 24),
                    // Contrast Slider
                    Text('Contrast: ${contrast[currentIndex]?.toStringAsFixed(2) ?? "1.00"}x'),
                    Slider(
                      value: contrast[currentIndex] ?? 1.0,
                      min: 0.5,
                      max: 2.0,
                      divisions: 150,
                      label: '${contrast[currentIndex]?.toStringAsFixed(2)}x',
                      onChanged: (value) => setState(() => contrast[currentIndex] = value),
                    ),
                    const SizedBox(height: 24),
                    // Saturation Slider
                    Text('Saturation: ${saturation[currentIndex]?.toStringAsFixed(2) ?? "1.00"}x'),
                    Slider(
                      value: saturation[currentIndex] ?? 1.0,
                      min: 0.0,
                      max: 2.0,
                      divisions: 200,
                      label: '${saturation[currentIndex]?.toStringAsFixed(2)}x',
                      onChanged: (value) => setState(() => saturation[currentIndex] = value),
                    ),
                    const SizedBox(height: 24),
                    // Reset Button
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          brightness[currentIndex] = 0.0;
                          contrast[currentIndex] = 1.0;
                          saturation[currentIndex] = 1.0;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                        label:
                            '${(currentIntensity * 100).toStringAsFixed(0)}%',
                        onChanged: updateIntensity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  onPressed: showFilterModal,
                  icon: const Icon(Icons.filter_vintage),
                  label: const Text('Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                            ElevatedButton.icon(
              onPressed: showAdjustModal,
              icon: const Icon(Icons.tune),
              label: const Text('Adjust'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
            ),
                ElevatedButton.icon(
                  onPressed: downloadImage,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
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
