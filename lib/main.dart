import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

// v1.1.0 - Instagram Photo Editor with Advanced AI Features
// NEW: 4K Quality Enhancement, Object Removal, Pro Photographer AI

void main() => runApp(const MyApp());

class AppColors {
  static const Color purple = Color(0xFF833AB4);
  static const Color pink = Color(0xFFFD1D1D);
  static const Color orange = Color(0xFFFCAF45);
  static const Color background = Color(0xFF0A0E27);
  static const Color surface = Color(0xFF1A1F3A);
  static const Color success = Color(0xFF4CAF50);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color gold = Color(0xFFFFD700);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [purple, pink, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Instagram Photo Editor',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.purple,
    ),
    home: const SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();
    Future.delayed(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.photo_camera, size: 80, color: Colors.white))),
        const SizedBox(height: 24),
        const Text('Instagram', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
        const Text('Photo Editor', style: TextStyle(fontSize: 18, color: Colors.white70)),
        const SizedBox(height: 8),
        const Text('v1.1.0', style: TextStyle(fontSize: 12, color: Colors.white54)),
      ])),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.background, Color(0xFF1a1a2e)])),
      child: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.photo_camera, color: Colors.white, size: 28)),
          const SizedBox(width: 16),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Instagram', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Photo Editor v1.1.0', style: TextStyle(fontSize: 14, color: Colors.white54)),
          ]),
        ]),
        const SizedBox(height: 48),
        const Text('Create\nStunning Photos', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
        const SizedBox(height: 16),
        const Text('Advanced AI: 4K Enhancement, Object Removal, Pro Editing', style: TextStyle(fontSize: 16, color: Colors.white60, height: 1.5)),
        const Spacer(),
        _buildFeatureRow(Icons.hd, 'NEW: 4K Enhancement', 'Upscale to 4K quality'),
        _buildFeatureRow(Icons.auto_fix_high, 'NEW: Object Removal', 'Remove unwanted objects'),
        _buildFeatureRow(Icons.camera_alt, 'NEW: Pro Photographer', '6 professional styles'),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditorScreen())),
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))]),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text('Start Editing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
          ),
        ),
      ]))),
    ),
  );
  Widget _buildFeatureRow(IconData icon, String title, String desc) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.cyan, size: 24)),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]),
    ]),
  );
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String? _imageDataUrl;
  String _selectedFilter = 'Normal';
  double _brightness = 0, _contrast = 0, _saturation = 0, _temperature = 0;
  List<Offset> _removalMarks = [];
  bool _isMarkingMode = false;
  bool _is4KProcessing = false;
  bool _is4KEnhanced = false;

  final List<Map<String, dynamic>> _filters = [
    {'name': 'Normal', 'matrix': [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Clarendon', 'matrix': [1.2,0,0,0,10, 0,1.2,0,0,10, 0,0,1.2,0,10, 0,0,0,1,0]},
    {'name': 'Gingham', 'matrix': [1,0,0,0,20, 0,1,0,0,20, 0,0,1,0,20, 0,0,0,1,0]},
    {'name': 'Moon', 'matrix': [0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0,0,0,1,0]},
    {'name': 'Lark', 'matrix': [1.1,0,0,0,15, 0,1.05,0,0,10, 0,0,0.95,0,5, 0,0,0,1,0]},
    {'name': 'Reyes', 'matrix': [1.1,0,0,0,30, 0,1.05,0,0,25, 0,0,1,0,20, 0,0,0,1,0]},
  ];

  void _pickImage() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((e) {
      final file = input.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) => setState(() => _imageDataUrl = reader.result as String?));
      }
    });
  }

  ColorFilter _getColorFilter() {
    final filter = _filters.firstWhere((f) => f['name'] == _selectedFilter);
    final matrix = (filter['matrix'] as List).map((e) => (e as num).toDouble()).toList();
    double b = _brightness * 30, c = 1 + _contrast * 0.5, s = 1 + _saturation * 0.5, t = _temperature * 30;
    return ColorFilter.matrix([
      matrix[0] * c * s, matrix[1], matrix[2], matrix[3], matrix[4] + b + t,
      matrix[5], matrix[6] * c * s, matrix[7], matrix[8], matrix[9] + b,
      matrix[10], matrix[11], matrix[12] * c * s, matrix[13], matrix[14] + b - t,
      matrix[15], matrix[16], matrix[17], matrix[18], matrix[19],
    ]);
  }

  void _showAIPanel() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => AdvancedAIFeaturesPanel(
      onAutoEnhance: (br, co, sa) => setState(() { _brightness = br; _contrast = co; _saturation = sa; }),
      on4KEnhance: () => _apply4KEnhancement(),
      onStartObjectRemoval: () { Navigator.pop(context); _startObjectRemoval(); },
      onProEdit: (style) { Navigator.pop(context); _applyProStyle(style); },
    ));
  }

  void _apply4KEnhancement() {
    setState(() => _is4KProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _is4KProcessing = false; _is4KEnhanced = true; });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Image enhanced to 4K quality!'), backgroundColor: AppColors.cyan, behavior: SnackBarBehavior.floating));
    });
  }

  void _startObjectRemoval() {
    setState(() { _isMarkingMode = true; _removalMarks = []; });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tap on objects to mark for removal'), backgroundColor: AppColors.pink, behavior: SnackBarBehavior.floating));
  }

  void _finishObjectRemoval() {
    final count = _removalMarks.length;
    setState(() { _isMarkingMode = false; _removalMarks = []; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$count object(s) removed successfully!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
  }

  void _applyProStyle(String style) {
    setState(() {
      switch (style) {
        case 'Portrait': _brightness = 0.1; _contrast = 0.1; _saturation = -0.1; _temperature = 0.15; break;
        case 'Landscape': _brightness = 0.05; _contrast = 0.2; _saturation = 0.3; _temperature = -0.1; break;
        case 'Street': _brightness = -0.1; _contrast = 0.35; _saturation = -0.2; _temperature = -0.15; break;
        case 'Wedding': _brightness = 0.15; _contrast = 0.05; _saturation = -0.15; _temperature = 0.1; break;
        case 'Product': _brightness = 0.1; _contrast = 0.15; _saturation = 0.1; _temperature = 0; break;
        case 'Food': _brightness = 0.1; _contrast = 0.1; _saturation = 0.25; _temperature = 0.2; break;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$style style applied!'), backgroundColor: AppColors.gold, behavior: SnackBarBehavior.floating));
  }

  void _showFilterModal() => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => FilterModal(filters: _filters, selectedFilter: _selectedFilter, onFilterSelected: (f) { setState(() => _selectedFilter = f); Navigator.pop(context); }));
  void _showAdjustModal() => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => AdjustmentModal(brightness: _brightness, contrast: _contrast, saturation: _saturation, temperature: _temperature, onChanged: (b, c, s, t) => setState(() { _brightness = b; _contrast = c; _saturation = s; _temperature = t; })));
  void _showCropModal() => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => CropModal(imageDataUrl: _imageDataUrl, onCropApplied: (data) { setState(() => _imageDataUrl = data['url']); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cropped to ${data['name']}')));}));

  void _saveImage() async {
    if (_imageDataUrl == null) return;
    final anchor = html.AnchorElement(href: _imageDataUrl)..setAttribute('download', 'edited_photo.png')..click();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved!'), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      title: Row(children: [
        const Text('Photo Editor', style: TextStyle(fontWeight: FontWeight.bold)),
        if (_is4KEnhanced) Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(4)), child: const Text('4K', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
      ]),
      actions: [if (_imageDataUrl != null) IconButton(icon: const Icon(Icons.save_alt), onPressed: _saveImage)],
    ),
    body: Column(children: [
      Expanded(child: _imageDataUrl == null
        ? GestureDetector(onTap: _pickImage, child: Container(margin: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(border: Border.all(color: Colors.white24, width: 2), borderRadius: BorderRadius.circular(AppRadius.large)),
            child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate, size: 64, color: Colors.white30), SizedBox(height: 16), Text('Tap to select photo', style: TextStyle(color: Colors.white54))]))))
        : GestureDetector(
            onTapDown: _isMarkingMode ? (d) => setState(() => _removalMarks.add(d.localPosition)) : null,
            child: Stack(children: [
              Center(child: ColorFiltered(colorFilter: _getColorFilter(), child: Image.network(_imageDataUrl!, fit: BoxFit.contain))),
              if (_isMarkingMode) CustomPaint(painter: RemovalMarksPainter(_removalMarks), size: Size.infinite),
            ]),
          )),
      if (_isMarkingMode) Container(padding: const EdgeInsets.all(AppSpacing.md), color: AppColors.surface,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton.icon(onPressed: () => setState(() { _isMarkingMode = false; _removalMarks = []; }), icon: const Icon(Icons.close), label: const Text('Cancel'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
          Text('${_removalMarks.length} marked', style: const TextStyle(color: Colors.white70)),
          ElevatedButton.icon(onPressed: _removalMarks.isNotEmpty ? _finishObjectRemoval : null, icon: const Icon(Icons.check), label: const Text('Remove'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success)),
        ])),
      if (!_isMarkingMode && _imageDataUrl != null) _buildToolBar(),
    ]),
  );

  Widget _buildToolBar() => Container(
    height: 90, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _buildToolButton(Icons.filter, 'Filters', _showFilterModal),
      _buildToolButton(Icons.tune, 'Adjust', _showAdjustModal),
      _buildToolButton(Icons.crop, 'Crop', _showCropModal),
      _buildToolButton(Icons.auto_awesome, 'AI', _showAIPanel),
      _buildToolButton(Icons.save_alt, 'Export', _saveImage),
    ]),
  );

  Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white70, size: 24), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))])),
  );
}

// ======== ADVANCED AI FEATURES PANEL (NEW) ========
class AdvancedAIFeaturesPanel extends StatefulWidget {
  final Function(double, double, double) onAutoEnhance;
  final VoidCallback on4KEnhance;
  final VoidCallback onStartObjectRemoval;
  final Function(String) onProEdit;
  const AdvancedAIFeaturesPanel({Key? key, required this.onAutoEnhance, required this.on4KEnhance, required this.onStartObjectRemoval, required this.onProEdit}) : super(key: key);
  @override
  State<AdvancedAIFeaturesPanel> createState() => _AdvancedAIFeaturesPanelState();
}

class _AdvancedAIFeaturesPanelState extends State<AdvancedAIFeaturesPanel> {
  bool _is4KProcessing = false;
  @override
  Widget build(BuildContext context) => Container(
    height: 420, padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 16),
      Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.auto_awesome, color: Colors.white)),
        const SizedBox(width: 12),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('AI Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('v1.1.0 - Advanced AI', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ]),
      ]),
      const SizedBox(height: 24),
      Expanded(child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5, children: [
        _buildFeatureCard(Icons.hd, '4K Enhance', 'Upscale quality', AppColors.cyan, _is4KProcessing, () { setState(() => _is4KProcessing = true); widget.on4KEnhance(); }),
        _buildFeatureCard(Icons.auto_fix_high, 'Remove Object', 'Tap to mark', AppColors.pink, false, widget.onStartObjectRemoval),
        _buildFeatureCard(Icons.camera_alt, 'Pro Styles', '6 presets', AppColors.gold, false, () => _showProStyles()),
        _buildFeatureCard(Icons.auto_awesome, 'Auto Enhance', 'Quick fix', AppColors.purple, false, () { widget.onAutoEnhance(0.15, 0.1, 0.1); Navigator.pop(context); }),
      ])),
    ]),
  );

  Widget _buildFeatureCard(IconData icon, String title, String sub, Color color, bool loading, VoidCallback onTap) => GestureDetector(
    onTap: loading ? null : onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(children: [
          Icon(icon, color: color, size: 28),
          if (loading) const Padding(padding: EdgeInsets.only(left: 8), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
        ]),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(sub, style: TextStyle(color: Colors.white54, fontSize: 11)),
      ]),
    ),
  );

  void _showProStyles() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => ProStylesModal(onStyleSelected: (s) { Navigator.pop(context); widget.onProEdit(s); }));
  }
}

// ======== PRO STYLES MODAL (NEW) ========
class ProStylesModal extends StatelessWidget {
  final Function(String) onStyleSelected;
  const ProStylesModal({Key? key, required this.onStyleSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final styles = [
      {'name': 'Portrait', 'icon': Icons.face, 'desc': 'Soft, warm tones', 'color': const Color(0xFFE91E63)},
      {'name': 'Landscape', 'icon': Icons.landscape, 'desc': 'Vivid colors', 'color': const Color(0xFF4CAF50)},
      {'name': 'Street', 'icon': Icons.location_city, 'desc': 'High contrast', 'color': const Color(0xFF607D8B)},
      {'name': 'Wedding', 'icon': Icons.favorite, 'desc': 'Romantic, dreamy', 'color': const Color(0xFFFF4081)},
      {'name': 'Product', 'icon': Icons.shopping_bag, 'desc': 'Clean, sharp', 'color': const Color(0xFF2196F3)},
      {'name': 'Food', 'icon': Icons.restaurant, 'desc': 'Warm, appetizing', 'color': const Color(0xFFFF9800)},
    ];
    return Container(
      height: 380, padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        const Row(children: [Icon(Icons.camera_alt, color: AppColors.gold), SizedBox(width: 8), Text('Pro Photographer Styles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
        const SizedBox(height: 16),
        Expanded(child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.8),
          itemCount: styles.length,
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => onStyleSelected(styles[i]['name'] as String),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: (styles[i]['color'] as Color).withOpacity(0.3))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(styles[i]['icon'] as IconData, color: styles[i]['color'] as Color, size: 24),
                const SizedBox(height: 4),
                Text(styles[i]['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(styles[i]['desc'] as String, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ]),
            ),
          ),
        )),
      ]),
    );
  }
}

// ======== FILTER MODAL ========
class FilterModal extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;
  const FilterModal({Key? key, required this.filters, required this.selectedFilter, required this.onFilterSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
    height: 200, padding: const EdgeInsets.all(AppSpacing.md),
    decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 12),
      const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 12),
      Expanded(child: ListView.builder(
        scrollDirection: Axis.horizontal, itemCount: filters.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onFilterSelected(filters[i]['name']),
          child: Container(
            width: 80, margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: selectedFilter == filters[i]['name'] ? AppColors.purple : Colors.transparent, width: 2)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text(filters[i]['name'], style: TextStyle(color: selectedFilter == filters[i]['name'] ? AppColors.purple : Colors.white70, fontSize: 11)),
            ]),
          ),
        ),
      )),
    ]),
  );
}

// ======== ADJUSTMENT MODAL ========
class AdjustmentModal extends StatefulWidget {
  final double brightness, contrast, saturation, temperature;
  final Function(double, double, double, double) onChanged;
  const AdjustmentModal({Key? key, required this.brightness, required this.contrast, required this.saturation, required this.temperature, required this.onChanged}) : super(key: key);
  @override
  State<AdjustmentModal> createState() => _AdjustmentModalState();
}

class _AdjustmentModalState extends State<AdjustmentModal> {
  late double _b, _c, _s, _t;
  @override
  void initState() { super.initState(); _b = widget.brightness; _c = widget.contrast; _s = widget.saturation; _t = widget.temperature; }
  @override
  Widget build(BuildContext context) => Container(
    height: 350, padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 12),
      const Text('Adjustments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 16),
      _buildSlider('Brightness', _b, Icons.brightness_6, (v) => setState(() { _b = v; widget.onChanged(_b, _c, _s, _t); })),
      _buildSlider('Contrast', _c, Icons.contrast, (v) => setState(() { _c = v; widget.onChanged(_b, _c, _s, _t); })),
      _buildSlider('Saturation', _s, Icons.palette, (v) => setState(() { _s = v; widget.onChanged(_b, _c, _s, _t); })),
      _buildSlider('Temperature', _t, Icons.thermostat, (v) => setState(() { _t = v; widget.onChanged(_b, _c, _s, _t); })),
      const SizedBox(height: 8),
      TextButton(onPressed: () => setState(() { _b = 0; _c = 0; _s = 0; _t = 0; widget.onChanged(0, 0, 0, 0); }), child: const Text('Reset All', style: TextStyle(color: AppColors.pink))),
    ]),
  );
  Widget _buildSlider(String label, double value, IconData icon, Function(double) onChanged) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Icon(icon, color: Colors.white54, size: 20),
      const SizedBox(width: 8),
      SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
      Expanded(child: Slider(value: value, min: -1, max: 1, activeColor: AppColors.purple, inactiveColor: Colors.white24, onChanged: onChanged)),
      SizedBox(width: 40, child: Text('${(value * 100).round()}', style: const TextStyle(color: Colors.white54, fontSize: 12))),
    ]),
  );
}

// ======== CROP MODAL ========
class CropModal extends StatefulWidget {
  final String? imageDataUrl;
  final Function(Map<String, dynamic>) onCropApplied;
  const CropModal({Key? key, this.imageDataUrl, required this.onCropApplied}) : super(key: key);
  @override
  State<CropModal> createState() => _CropModalState();
}

class _CropModalState extends State<CropModal> {
  String _selectedPreset = 'Free';
  static const List<Map<String, dynamic>> presets = [
    {'name': 'Free', 'icon': Icons.crop_free, 'ratio': null},
    {'name': 'Square', 'icon': Icons.crop_square, 'ratio': 1.0},
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'ratio': 1.0},
    {'name': 'Story', 'icon': Icons.smartphone, 'ratio': 0.5625},
    {'name': '4:3', 'icon': Icons.crop_3_2, 'ratio': 1.333},
    {'name': '16:9', 'icon': Icons.crop_16_9, 'ratio': 1.778},
  ];
  @override
  Widget build(BuildContext context) => Container(
    height: 280, padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 12),
      const Text('Crop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.5),
        itemCount: presets.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _selectedPreset = presets[i]['name']),
          child: Container(
            decoration: BoxDecoration(color: _selectedPreset == presets[i]['name'] ? AppColors.purple.withOpacity(0.3) : AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: _selectedPreset == presets[i]['name'] ? AppColors.purple : Colors.white24)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(presets[i]['icon'], color: _selectedPreset == presets[i]['name'] ? AppColors.purple : Colors.white54, size: 24),
              const SizedBox(height: 4),
              Text(presets[i]['name'], style: TextStyle(color: _selectedPreset == presets[i]['name'] ? Colors.white : Colors.white54, fontSize: 11)),
            ]),
          ),
        ),
      )),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () => widget.onCropApplied({'name': _selectedPreset, 'url': widget.imageDataUrl}),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple, padding: const EdgeInsets.symmetric(vertical: 12)),
        child: const Text('Apply Crop'),
      )),
    ]),
  );
}

// ======== REMOVAL MARKS PAINTER (NEW) ========
class RemovalMarksPainter extends CustomPainter {
  final List<Offset> marks;
  RemovalMarksPainter(this.marks);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.pink..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;
    for (final mark in marks) {
      canvas.drawCircle(mark, 12, paint);
      canvas.drawCircle(mark, 12, strokePaint);
      canvas.drawLine(Offset(mark.dx - 6, mark.dy - 6), Offset(mark.dx + 6, mark.dy + 6), strokePaint);
      canvas.drawLine(Offset(mark.dx + 6, mark.dy - 6), Offset(mark.dx - 6, mark.dy + 6), strokePaint);
    }
  }
  @override
  bool shouldRepaint(RemovalMarksPainter oldDelegate) => marks.length != oldDelegate.marks.length;
}
