/// Instagram Photo Editor - Main Entry Point
/// Professional Flutter application with Material Design 3
///
/// Author: Himanshu Prapatel
/// Version: 1.0.0
/// License: MIT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'screens/home_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/gallery_screen.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Run the application
  runApp(const InstagramPhotoEditorApp());
}

/// Root widget of the Instagram Photo Editor application
class InstagramPhotoEditorApp extends StatelessWidget {
  const InstagramPhotoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App Configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Navigation
      initialRoute: AppRoutes.home,
      routes: _buildRoutes(),
      
      // Performance Optimization
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Prevent text scaling
          ),
          child: child!,
        );
      },
    );
  }
  
  /// Build application routes
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.home: (context) => const HomeScreen(),
      AppRoutes.gallery: (context) => const GalleryScreen(),
      AppRoutes.editor: (context) => const EditorScreen(),
    };
  }
}
