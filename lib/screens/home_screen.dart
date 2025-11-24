/// Home Screen - Instagram Photo Editor
/// Professional landing page with Material Design 3

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import 'editor_screen.dart';
import 'gallery_screen.dart';

/// Home Screen with quick actions and recent edits
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationSlow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildAppBar(),
              
              // Hero Section
              _buildHeroSection(),
              
              // Quick Actions
              _buildQuickActions(),
              
              // Features
              _buildFeatures(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build custom app bar
  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.premiumGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.photo_camera, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  /// Build hero section
  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transform Your Photos',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMedium),
            Text(
              'Professional photo editing with Instagram-optimized filters',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick action buttons
  Widget _buildQuickActions() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLarge,
        vertical: AppTheme.spaceMedium,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppTheme.spaceMedium,
          crossAxisSpacing: AppTheme.spaceMedium,
          childAspectRatio: 1.2,
        ),
        delegate: SliverChildListDelegate([
          _buildActionCard(
            icon: Icons.photo_library,
            title: 'Gallery',
            subtitle: 'Choose from photos',
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor.withOpacity(0.8), AppTheme.primaryColor],
            ),
            onTap: () => _pickFromGallery(),
          ),
          _buildActionCard(
            icon: Icons.camera_alt,
            title: 'Camera',
            subtitle: 'Take a photo',
            gradient: LinearGradient(
              colors: [AppTheme.secondaryColor.withOpacity(0.8), AppTheme.secondaryColor],
            ),
            onTap: () => _pickFromCamera(),
          ),
        ]),
      ),
    );
  }

  /// Build feature cards
  Widget _buildFeatures() {
    final features = [
      {'icon': Icons.palette, 'title': '23+ Premium Filters', 'desc': 'Instagram-style filters'},
      {'icon': Icons.tune, 'title': 'Advanced Adjustments', 'desc': 'Brightness, contrast, and more'},
      {'icon': Icons.crop, 'title': 'Smart Cropping', 'desc': 'Instagram aspect ratios'},
      {'icon': Icons.layers, 'title': 'Multiple Effects', 'desc': 'Vintage, cool, warm, vivid'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildFeatureItem(features[index]),
          childCount: features.length,
        ),
      ),
    );
  }

  /// Build action card widget
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          padding: const EdgeInsets.all(AppTheme.spaceLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: AppTheme.spaceSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build feature item
  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMedium),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppTheme.premiumGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(feature['icon'], color: Colors.white),
        ),
        title: Text(
          feature['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(feature['desc']),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  /// Pick image from gallery
  Future<void> _pickFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(imageFile: pickedFile),
        ),
      );
    }
  }

  /// Pick image from camera
  Future<void> _pickFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(imageFile: pickedFile),
        ),
      );
    }
  }

  /// Show about dialog
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2025 Open Source Project',
      children: [
        const SizedBox(height: 16),
        const Text('Professional Instagram photo editing app'),
      ],
    );
  }
}
