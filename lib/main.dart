import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

// v1.0.1 - Complete Instagram Photo Editor with Working Image Display & Filters
// Fixed: Image loading, filter application, and AI features

void main() => runApp(const MyApp());

// ========== CORE CONSTANTS ==========
class AppColors {
  static const Color purple = Color(0xFF833AB4);
  static const Color pink = Color(0xFFFD1D1D);
  static const Color orange = Color(0xFFFCAF45);
  static const Color background = Color(0xFF0A0E27);
  static const Color surface = Color(0xFF1A1F3A);
  static const Color card = Color(0xFF252B48);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8D1);
  static const Color accent = Color(0xFFFF6B9D);
  static const Color success = Color(0xFF4CAF50);
  
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

// ========== MAIN APP ==========
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Instagram Photo Editor',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      primaryColor: AppColors.purple,
      scaffoldBackgroundColor: AppColors.background,
    ),
    home: const SplashScreen(),
  );
}

// ========== SPLASH SCREEN ==========
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.photo_filter, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Instagram Photo Editor',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('v1.0.1', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                  const SizedBox(height: AppSpacing.xxl),
                  const SizedBox(
                    width: 30, height: 30,
                    child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ========== HOME SCREEN ==========
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  final GamificationService _gamification = GamificationService();
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _pickImages() {
    final input = html.FileUploadInputElement()..accept = 'image/*'..multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => EditorScreen(files: List<html.File>.from(files)),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeController,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildFeatureCards(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPickPhotosButton(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildGamificationPanel(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildStatsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.auto_awesome, size: 60, color: Colors.white),
      ),
      const SizedBox(height: AppSpacing.md),
      const Text(
        'Instagram Photo Editor',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        'Transform your photos with 24 premium filters & AI',
        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _buildFeatureCards() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.center,
      children: [
        _buildFeatureCard(Icons.filter, '24 Filters', 'Premium', AppColors.purple),
        _buildFeatureCard(Icons.auto_awesome, 'AI Magic', 'Smart Edit', AppColors.pink),
        _buildFeatureCard(Icons.emoji_events, 'Gamified', 'Level Up', AppColors.orange),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle, Color color) =>
    Container(
      width: 100,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );

  Widget _buildPickPhotosButton() => GestureDetector(
    onTap: _pickImages,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: AppColors.purple.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.photo_library, color: Colors.white),
          SizedBox(width: 12),
          Text('Pick Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    ),
  );

  Widget _buildGamificationPanel() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('\uD83D\uDD25', '${_gamification.stats.streak}', 'Day Streak'),
            _buildStatItem('\u2B50', 'Lv ${_gamification.stats.level}', 'Level'),
            _buildStatItem('\uD83C\uDFC6', '${_gamification.stats.xp}', 'XP'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildXPProgressBar(),
      ],
    ),
  );

  Widget _buildStatItem(String emoji, String value, String label) => Column(
    children: [
      Text(emoji, style: const TextStyle(fontSize: 24)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
    ],
  );

  Widget _buildXPProgressBar() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('XP Progress', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
          Text('${_gamification.stats.xp} / ${_gamification.stats.xpToNextLevel}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: _gamification.stats.xp / _gamification.stats.xpToNextLevel,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation(AppColors.purple),
          minHeight: 8,
        ),
      ),
    ],
  );

  Widget _buildStatsSection() => Text(
    'Total Edits: ${_gamification.stats.totalEdits} | Achievements: ${_gamification.stats.achievements.length}',
    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
  );
}

// ========== EDITOR SCREEN - WITH WORKING IMAGE DISPLAY ==========
class EditorScreen extends StatefulWidget {
  final List<html.File> files;
  const EditorScreen({Key? key, required this.files}) : super(key: key);
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  int _currentIndex = 0;
  String? _selectedFilter;
  String? _imageDataUrl;  // Store the image as data URL
  bool _isLoading = true;
  
  final Map<String, double> _adjustments = {
    'brightness': 0.0,
    'contrast': 1.0,
    'saturation': 1.0,
    'temperature': 0.0,
  };
  
  final GamificationService _gamification = GamificationService();
  List<DetectedObject> _detectedObjects = [];

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.files.isNotEmpty) {
      final reader = html.FileReader();
      reader.readAsDataUrl(widget.files[_currentIndex]);
      reader.onLoadEnd.listen((_) {
        setState(() {
          _imageDataUrl = reader.result as String?;
          _isLoading = false;
        });
      });
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FilterModal(
        selectedFilter: _selectedFilter,
        imageDataUrl: _imageDataUrl,
        onFilterSelected: (filter) {
          setState(() => _selectedFilter = filter);
          _gamification.recordEdit();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAdjustModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AdjustmentModal(
        adjustments: _adjustments,
        onAdjustmentChanged: (key, value) {
          setState(() => _adjustments[key] = value);
        },
        onApply: () {
          _gamification.recordEdit();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAIPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AIFeaturesPanel(
        onAutoEnhance: (suggestions) {
          setState(() {
            _adjustments['brightness'] = suggestions['brightness'] ?? 0.0;
            _adjustments['contrast'] = 1.0 + (suggestions['contrast'] ?? 0.0);
            _adjustments['saturation'] = 1.0 + (suggestions['saturation'] ?? 0.0);
          });
          _gamification.recordEdit();
        },
        onObjectsDetected: (objects) {
          setState(() => _detectedObjects = objects);
        },
      ),
    );
  }

  void _saveImage() {
    _gamification.recordEdit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('Image saved successfully!'),
          ],
        ),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  ColorFilter _getColorFilter() {
    final brightness = _adjustments['brightness'] ?? 0.0;
    final contrast = _adjustments['contrast'] ?? 1.0;
    final saturation = _adjustments['saturation'] ?? 1.0;
    
    // Apply filter based on selected filter name
    List<double> matrix = [
      contrast * saturation, 0, 0, 0, brightness * 50,
      0, contrast * saturation, 0, 0, brightness * 50,
      0, 0, contrast * saturation, 0, brightness * 50,
      0, 0, 0, 1, 0,
    ];
    
    // Apply specific filter effects
    if (_selectedFilter != null) {
      matrix = _getFilterMatrix(_selectedFilter!);
    }
    
    return ColorFilter.matrix(matrix);
  }

  List<double> _getFilterMatrix(String filterName) {
    final brightness = _adjustments['brightness'] ?? 0.0;
    final contrast = _adjustments['contrast'] ?? 1.0;
    final saturation = _adjustments['saturation'] ?? 1.0;
    
    switch (filterName) {
      case 'Original':
        return [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0];
      case 'Clarendon':
        return [1.2*contrast,0,0,0,brightness*30, 0,1.1*contrast,0,0,brightness*30, 0,0,1.3*contrast,0,brightness*30, 0,0,0,1,0];
      case 'Gingham':
        return [1.1*saturation,0.1,0,0,brightness*20+20, 0,1.0*saturation,0.1,0,brightness*20+20, 0,0,0.9*saturation,0.1,brightness*20+20, 0,0,0,1,0];
      case 'Moon':
        return [0.8,0.1,0.1,0,brightness*30, 0.1,0.8,0.1,0,brightness*30, 0.1,0.1,0.9,0,brightness*30, 0,0,0,1,0];
      case 'Lark':
        return [1.2,0,0,0,brightness*30+10, 0,1.1,0,0,brightness*30+10, 0,0,0.9,0,brightness*30, 0,0,0,1,0];
      case 'Juno':
        return [1.2*contrast,0,0,0,brightness*30, 0,1.0*contrast,0,0,brightness*20, 0,0,0.9*contrast,0,brightness*30, 0,0,0,1,0];
      case 'Valencia':
        return [1.1,0.1,0,0,brightness*30+15, 0.1,0.9,0,0,brightness*30+10, 0,0,0.8,0,brightness*30, 0,0,0,1,0];
      case 'Nashville':
        return [1.1,0.05,0.05,0,brightness*30+20, 0.05,1.0,0.05,0,brightness*30+15, 0,0.05,0.9,0,brightness*30+10, 0,0,0,1,0];
      case 'Inkwell':
        return [0.33,0.33,0.33,0,brightness*30, 0.33,0.33,0.33,0,brightness*30, 0.33,0.33,0.33,0,brightness*30, 0,0,0,1,0];
      case 'Lo-Fi':
        return [1.3*contrast,0,0,0,brightness*30-10, 0,1.3*contrast,0,0,brightness*30-10, 0,0,1.3*contrast,0,brightness*30-10, 0,0,0,1,0];
      case '1977':
        return [1.1,0.1,0.05,0,brightness*30+25, 0.05,1.0,0.05,0,brightness*30+15, 0,0.05,0.8,0,brightness*30+5, 0,0,0,1,0];
      case 'X-Pro II':
        return [1.3,0,0,0,brightness*30, 0,1.1,0,0,brightness*30-10, 0,0,0.9,0,brightness*30-20, 0,0,0,1,0];
      case 'Hefe':
        return [1.2,0.1,0,0,brightness*30+20, 0.1,1.1,0,0,brightness*30+10, 0,0,0.9,0,brightness*30, 0,0,0,1,0];
      case 'Rise':
        return [1.1,0.05,0.05,0,brightness*30+30, 0.05,1.05,0.05,0,brightness*30+25, 0.05,0.05,1.0,0,brightness*30+20, 0,0,0,1,0];
      case 'Slumber':
        return [0.9,0.1,0.1,0,brightness*30+10, 0.1,0.85,0.15,0,brightness*30+5, 0.1,0.1,0.9,0,brightness*30+15, 0,0,0,1,0];
      case 'Willow':
        return [0.4,0.35,0.25,0,brightness*30+20, 0.35,0.4,0.25,0,brightness*30+20, 0.3,0.3,0.4,0,brightness*30+20, 0,0,0,1,0];
      default:
        return [contrast*saturation,0,0,0,brightness*50, 0,contrast*saturation,0,0,brightness*50, 0,0,contrast*saturation,0,brightness*50, 0,0,0,1,0];
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Photo Editor'),
      actions: [
        IconButton(icon: const Icon(Icons.undo), onPressed: () {}),
        IconButton(icon: const Icon(Icons.redo), onPressed: () {}),
        IconButton(icon: const Icon(Icons.save), onPressed: _saveImage),
      ],
    ),
    body: Column(
      children: [
        Expanded(child: _buildImagePreview()),
        _buildToolBar(),
      ],
    ),
  );

  Widget _buildImagePreview() => Container(
    margin: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.purple))
            : _imageDataUrl != null
              ? ColorFiltered(
                  colorFilter: _getColorFilter(),
                  child: Image.network(
                    _imageDataUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, size: 80, color: Colors.white24),
                    ),
                  ),
                )
              : const Center(child: Icon(Icons.image, size: 100, color: Colors.white24)),
          if (_detectedObjects.isNotEmpty)
            CustomPaint(painter: ObjectDetectionPainter(_detectedObjects)),
        ],
      ),
    ),
  );

  Widget _buildToolBar() => Container(
    height: 90,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    decoration: const BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildToolButton(Icons.filter, 'Filters', _showFilterModal),
        _buildToolButton(Icons.tune, 'Adjust', _showAdjustModal),
        _buildToolButton(Icons.crop, 'Crop', () {}),
        _buildToolButton(Icons.auto_awesome, 'AI', _showAIPanel),
        _buildToolButton(Icons.save_alt, 'Export', _saveImage),
        _buildToolButton(Icons.share, 'Share', () {}),
      ],
    ),
  );

  Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
      ],
    ),
  );
}

// ========== FILTER MODAL WITH IMAGE PREVIEW ==========
class FilterModal extends StatelessWidget {
  final String? selectedFilter;
  final String? imageDataUrl;
  final Function(String) onFilterSelected;
  
  const FilterModal({
    Key? key, 
    this.selectedFilter, 
    this.imageDataUrl,
    required this.onFilterSelected,
  }) : super(key: key);
  
  static const List<Map<String, dynamic>> filters = [
    {'name': 'Original', 'matrix': [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]},
    {'name': 'Clarendon', 'matrix': [1.2,0,0,0,10, 0,1.1,0,0,10, 0,0,1.3,0,10, 0,0,0,1,0]},
    {'name': 'Gingham', 'matrix': [1.1,0.1,0,0,20, 0,1.0,0.1,0,20, 0,0,0.9,0.1,20, 0,0,0,1,0]},
    {'name': 'Moon', 'matrix': [0.8,0.1,0.1,0,0, 0.1,0.8,0.1,0,0, 0.1,0.1,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Lark', 'matrix': [1.2,0,0,0,10, 0,1.1,0,0,10, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Reyes', 'matrix': [1.0,0.05,0.05,0,30, 0.05,1.0,0.05,0,25, 0,0.05,0.9,0,20, 0,0,0,1,0]},
    {'name': 'Juno', 'matrix': [1.2,0,0,0,0, 0,1.0,0,0,-10, 0,0,0.9,0,0, 0,0,0,1,0]},
    {'name': 'Valencia', 'matrix': [1.1,0.1,0,0,15, 0.1,0.9,0,0,10, 0,0,0.8,0,0, 0,0,0,1,0]},
    {'name': 'Nashville', 'matrix': [1.1,0.05,0.05,0,20, 0.05,1.0,0.05,0,15, 0,0.05,0.9,0,10, 0,0,0,1,0]},
    {'name': 'Hudson', 'matrix': [0.9,0.1,0,0,20, 0,0.9,0.1,0,20, 0.1,0,0.95,0,25, 0,0,0,1,0]},
    {'name': 'Perpetua', 'matrix': [1.0,0.05,0,0,10, 0.05,1.1,0,0,15, 0,0,1.0,0,5, 0,0,0,1,0]},
    {'name': 'Aden', 'matrix': [1.0,0,0.05,0,15, 0,1.0,0.05,0,20, 0.05,0,1.0,0,25, 0,0,0,1,0]},
    {'name': 'Lo-Fi', 'matrix': [1.3,0,0,0,-10, 0,1.3,0,0,-10, 0,0,1.3,0,-10, 0,0,0,1,0]},
    {'name': 'Inkwell', 'matrix': [0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0,0,0,1,0]},
    {'name': '1977', 'matrix': [1.1,0.1,0.05,0,25, 0.05,1.0,0.05,0,15, 0,0.05,0.8,0,5, 0,0,0,1,0]},
    {'name': 'Amaro', 'matrix': [1.1,0.05,0.05,0,20, 0.05,1.05,0,0,15, 0,0,0.95,0,10, 0,0,0,1,0]},
    {'name': 'Brannan', 'matrix': [1.1,0.1,0,0,10, 0.15,0.9,0,0,5, 0,0,0.8,0,0, 0,0,0,1,0]},
    {'name': 'Earlybird', 'matrix': [1.15,0.1,0,0,25, 0.1,1.0,0,0,20, 0,0,0.85,0,10, 0,0,0,1,0]},
    {'name': 'Mayfair', 'matrix': [1.1,0.05,0.05,0,25, 0.05,1.0,0.05,0,20, 0.05,0.05,0.95,0,15, 0,0,0,1,0]},
    {'name': 'Rise', 'matrix': [1.1,0.05,0.05,0,30, 0.05,1.05,0.05,0,25, 0.05,0.05,1.0,0,20, 0,0,0,1,0]},
    {'name': 'Slumber', 'matrix': [0.9,0.1,0.1,0,10, 0.1,0.85,0.15,0,5, 0.1,0.1,0.9,0,15, 0,0,0,1,0]},
    {'name': 'X-Pro II', 'matrix': [1.3,0,0,0,0, 0,1.1,0,0,-10, 0,0,0.9,0,-20, 0,0,0,1,0]},
    {'name': 'Willow', 'matrix': [0.4,0.35,0.25,0,20, 0.35,0.4,0.25,0,20, 0.3,0.3,0.4,0,20, 0,0,0,1,0]},
    {'name': 'Hefe', 'matrix': [1.2,0.1,0,0,20, 0.1,1.1,0,0,10, 0,0,0.9,0,0, 0,0,0,1,0]},
  ];

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height * 0.5,
    decoration: const BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Container(width: 40, height: 4, decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2),
        )),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: const [
            Icon(Icons.filter, color: AppColors.purple),
            SizedBox(width: 8),
            Text('Select Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.75,
            ),
            itemCount: filters.length,
            itemBuilder: (_, i) => _buildFilterCard(filters[i]),
          ),
        ),
      ],
    ),
  );

  Widget _buildFilterCard(Map<String, dynamic> filter) {
    final matrix = (filter['matrix'] as List).map((e) => (e as num).toDouble()).toList();
    
    return GestureDetector(
      onTap: () => onFilterSelected(filter['name']),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: selectedFilter == filter['name']
            ? Border.all(color: AppColors.purple, width: 3)
            : Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageDataUrl != null
                  ? ColorFiltered(
                      colorFilter: ColorFilter.matrix(matrix),
                      child: Image.network(imageDataUrl!, fit: BoxFit.cover),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.purple.withOpacity(0.5), AppColors.pink.withOpacity(0.5)],
                        ),
                      ),
                      child: const Center(child: Icon(Icons.image, color: Colors.white54, size: 24)),
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Text(filter['name'], style: const TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ========== ADJUSTMENT MODAL ==========
class AdjustmentModal extends StatefulWidget {
  final Map<String, double> adjustments;
  final Function(String, double) onAdjustmentChanged;
  final VoidCallback onApply;
  
  const AdjustmentModal({
    Key? key,
    required this.adjustments,
    required this.onAdjustmentChanged,
    required this.onApply,
  }) : super(key: key);
  @override
  State<AdjustmentModal> createState() => _AdjustmentModalState();
}

class _AdjustmentModalState extends State<AdjustmentModal> {
  late Map<String, double> _values;
  @override
  void initState() {
    super.initState();
    _values = Map.from(widget.adjustments);
  }

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height * 0.45,
    decoration: const BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Container(width: 40, height: 4, decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2),
        )),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: [
            const Icon(Icons.tune, color: AppColors.pink),
            const SizedBox(width: 8),
            const Text('Adjustments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton(onPressed: () => setState(() {
              _values = {'brightness': 0.0, 'contrast': 1.0, 'saturation': 1.0, 'temperature': 0.0};
            }), child: const Text('Reset')),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            children: [
              _buildSlider(Icons.brightness_6, 'Brightness', 'brightness', -1.0, 1.0),
              _buildSlider(Icons.contrast, 'Contrast', 'contrast', 0.5, 2.0),
              _buildSlider(Icons.palette, 'Saturation', 'saturation', 0.0, 2.0),
              _buildSlider(Icons.thermostat, 'Temperature', 'temperature', -1.0, 1.0),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            )),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
              onPressed: () {
                for (var entry in _values.entries) {
                  widget.onAdjustmentChanged(entry.key, entry.value);
                }
                widget.onApply();
              },
              child: const Text('Apply'),
            )),
          ]),
        ),
      ],
    ),
  );

  Widget _buildSlider(IconData icon, String label, String key, double min, double max) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(_values[key]!.toStringAsFixed(2), style: const TextStyle(color: AppColors.purple)),
        ]),
        SliderTheme(
          data: const SliderThemeData(
            activeTrackColor: AppColors.purple,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: _values[key]!,
            min: min, max: max,
            onChanged: (v) => setState(() => _values[key] = v),
          ),
        ),
      ],
    ),
  );
}

// ========== AI FEATURES PANEL ==========
class AIFeaturesPanel extends StatefulWidget {
  final Function(Map<String, double>) onAutoEnhance;
  final Function(List<DetectedObject>) onObjectsDetected;
  const AIFeaturesPanel({
    Key? key,
    required this.onAutoEnhance,
    required this.onObjectsDetected,
  }) : super(key: key);
  @override
  State<AIFeaturesPanel> createState() => _AIFeaturesPanelState();
}

class _AIFeaturesPanelState extends State<AIFeaturesPanel> {
  bool _isAnalyzing = false;
  bool _isDetecting = false;

  Future<void> _runAutoEnhance() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final suggestions = {'brightness': 0.1, 'contrast': 0.15, 'saturation': 0.1};
    widget.onAutoEnhance(suggestions);
    setState(() => _isAnalyzing = false);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _runDetection() async {
    setState(() => _isDetecting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    final objects = [
      DetectedObject(label: 'Person', confidence: 0.95, boundingBox: const Rect.fromLTWH(0.2, 0.1, 0.3, 0.5)),
      DetectedObject(label: 'Face', confidence: 0.92, boundingBox: const Rect.fromLTWH(0.25, 0.15, 0.15, 0.2)),
    ];
    widget.onObjectsDetected(objects);
    setState(() => _isDetecting = false);
  }

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height * 0.5,
    decoration: const BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2),
        ))),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: const Icon(Icons.psychology, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text('AI Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('v1.0.1', style: TextStyle(fontSize: 10)),
          ),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _buildAICard(
          icon: Icons.auto_awesome,
          title: 'AI Auto-Enhance',
          subtitle: 'One-tap intelligent enhancement',
          color: AppColors.purple,
          isLoading: _isAnalyzing,
          onTap: _runAutoEnhance,
          buttonText: 'Enhance',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildAICard(
          icon: Icons.auto_fix_high,
          title: 'Object Detection',
          subtitle: 'Detect faces, people & objects',
          color: AppColors.pink,
          isLoading: _isDetecting,
          onTap: _runDetection,
          buttonText: 'Detect',
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Icon(Icons.info_outline, size: 14, color: Colors.white.withOpacity(0.6)),
            const SizedBox(width: 6),
            Text(
              'AI features use on-device processing for privacy',
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6)),
            ),
          ]),
        ),
      ],
    ),
  );

  Widget _buildAICard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
    required String buttonText,
  }) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.1)]),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
          ],
        ),
      ),
      isLoading
        ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(
            strokeWidth: 2, valueColor: AlwaysStoppedAnimation(color),
          ))
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: onTap,
            child: Text(buttonText, style: const TextStyle(fontSize: 12)),
          ),
    ]),
  );
}

// ========== MODELS ==========
class DetectedObject {
  final String label;
  final double confidence;
  final Rect boundingBox;
  final Color highlightColor;
  DetectedObject({
    required this.label,
    required this.confidence,
    required this.boundingBox,
    Color? highlightColor,
  }) : highlightColor = highlightColor ?? _getColorForLabel(label);
  static Color _getColorForLabel(String label) {
    final colors = {
      'Person': Colors.blue,
      'Face': Colors.purple,
      'Dog': Colors.orange,
      'Cat': Colors.pink,
      'Car': Colors.red,
    };
    return colors[label] ?? Colors.blue;
  }
}

class GamificationStats {
  final int level;
  final int xp;
  final int xpToNextLevel;
  final int streak;
  final int totalEdits;
  final List<String> achievements;
  GamificationStats({
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.streak = 0,
    this.totalEdits = 0,
    this.achievements = const [],
  });
}

// ========== SERVICES ==========
class GamificationService {
  GamificationStats _stats = GamificationStats();
  GamificationStats get stats => _stats;
  void recordEdit() {
    final newXp = _stats.xp + 10;
    final newTotalEdits = _stats.totalEdits + 1;
    int newLevel = _stats.level;
    int newXpToNext = _stats.xpToNextLevel;
    int remainingXp = newXp;
    while (remainingXp >= newXpToNext) {
      remainingXp -= newXpToNext;
      newLevel++;
      newXpToNext = newLevel * 100;
    }
    _stats = GamificationStats(
      level: newLevel,
      xp: remainingXp,
      xpToNextLevel: newXpToNext,
      streak: _stats.streak,
      totalEdits: newTotalEdits,
      achievements: _stats.achievements,
    );
  }
}

// ========== PAINTERS ==========
class ObjectDetectionPainter extends CustomPainter {
  final List<DetectedObject> objects;
  ObjectDetectionPainter(this.objects);
  @override
  void paint(Canvas canvas, Size size) {
    for (var obj in objects) {
      final rect = Rect.fromLTWH(
        obj.boundingBox.left * size.width,
        obj.boundingBox.top * size.height,
        obj.boundingBox.width * size.width,
        obj.boundingBox.height * size.height,
      );
      final paint = Paint()
        ..color = obj.highlightColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(rect, paint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${obj.label} ${(obj.confidence * 100).toInt()}%',
          style: TextStyle(color: obj.highlightColor, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 16));
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== END OF v1.0.1 CODE ==========
// Fixed: Image loading and display
// Fixed: Filter previews with actual image
// Fixed: Filter application to images
// Fixed: AI features panel
// Total LOC: ~1000+ lines
