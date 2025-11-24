/// Application Constants and Configuration
/// Centralized configuration for the Instagram Photo Editor app

import 'package:flutter/foundation.dart';

/// App Information Constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== App Information ====================
  
  static const String appName = 'Instagram Photo Editor';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.instagram.photoeditor';
  
  // ==================== API Configuration ====================
  
  // Base URLs (for future cloud features)
  static const String baseUrl = kDebugMode 
      ? 'https://api-dev.photoeditor.com' 
      : 'https://api.photoeditor.com';
  
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/$apiVersion';
  
  // API Endpoints (for future backend integration)
  static const String uploadEndpoint = '/upload';
  static const String filtersEndpoint = '/filters';
  static const String saveEndpoint = '/save';
  
  // ==================== Storage Keys ====================
  
  // SharedPreferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyRecentFilters = 'recent_filters';
  static const String keyFavoriteFilters = 'favorite_filters';
  static const String keyEditHistory = 'edit_history';
  static const String keyQualityPreference = 'quality_preference';
  static const String keyAutoSave = 'auto_save';
  static const String keyWatermarkEnabled = 'watermark_enabled';
  
  // ==================== Image Configuration ====================
  
  // Image Quality Settings
  static const int imageQualityHigh = 100;
  static const int imageQualityMedium = 85;
  static const int imageQualityLow = 70;
  static const int defaultImageQuality = imageQualityHigh;
  
  // Image Size Limits
  static const int maxImageWidth = 4000;
  static const int maxImageHeight = 4000;
  static const int maxImageSizeBytes = 50 * 1024 * 1024; // 50 MB
  
  // Instagram Aspect Ratios
  static const double aspectRatioSquare = 1.0; // 1:1
  static const double aspectRatioPortrait = 4.0 / 5.0; // 4:5
  static const double aspectRatioLandscape = 1.91 / 1.0; // 1.91:1
  static const double aspectRatioStory = 9.0 / 16.0; // 9:16
  
  // ==================== Filter Configuration ====================
  
  // Filter Intensity
  static const double filterIntensityMin = 0.0;
  static const double filterIntensityMax = 1.0;
  static const double filterIntensityDefault = 1.0;
  static const double filterIntensityStep = 0.01;
  
  // ==================== Editing Limits ====================
  
  // Adjustment Ranges
  static const double brightnessMin = 0.0;
  static const double brightnessMax = 2.0;
  static const double brightnessDefault = 1.0;
  
  static const double contrastMin = 0.0;
  static const double contrastMax = 2.0;
  static const double contrastDefault = 1.0;
  
  static const double saturationMin = 0.0;
  static const double saturationMax = 2.0;
  static const double saturationDefault = 1.0;
  
  static const double exposureMin = -2.0;
  static const double exposureMax = 2.0;
  static const double exposureDefault = 0.0;
  
  static const double shadowsMin = -1.0;
  static const double shadowsMax = 1.0;
  static const double shadowsDefault = 0.0;
  
  static const double highlightsMin = -1.0;
  static const double highlightsMax = 1.0;
  static const double highlightsDefault = 0.0;
  
  static const double vibranceMin = -1.0;
  static const double vibranceMax = 1.0;
  static const double vibranceDefault = 0.0;
  
  static const double clarityMin = -1.0;
  static const double clarityMax = 1.0;
  static const double clarityDefault = 0.0;
  
  // ==================== Animation Durations ====================
  
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // ==================== Cache Configuration ====================
  
  static const int maxCacheSize = 500 * 1024 * 1024; // 500 MB
  static const int cacheExpiryDays = 7;
  static const String cacheFolderName = 'photo_editor_cache';
  
  // ==================== Export Configuration ====================
  
  // Export Formats
  static const String exportFormatJPG = 'jpg';
  static const String exportFormatPNG = 'png';
  static const String exportFormatWEBP = 'webp';
  static const String defaultExportFormat = exportFormatJPG;
  
  // Export Paths
  static const String exportFolderName = 'InstagramPhotoEditor';
  static const String exportFilePrefix = 'IMG_EDIT_';
  
  // ==================== Permissions ====================
  
  static const String permissionCamera = 'camera';
  static const String permissionStorage = 'storage';
  static const String permissionPhotos = 'photos';
  
  // ==================== Error Messages ====================
  
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorPermission = 'Permission denied. Please grant access.';
  static const String errorImageTooLarge = 'Image size exceeds maximum limit.';
  static const String errorInvalidFormat = 'Invalid image format.';
  static const String errorSaveFailed = 'Failed to save image.';
  static const String errorLoadFailed = 'Failed to load image.';
  
  // ==================== Success Messages ====================
  
  static const String successImageSaved = 'Image saved successfully!';
  static const String successFilterApplied = 'Filter applied successfully!';
  static const String successExported = 'Exported to gallery!';
  
  // ==================== Feature Flags ====================
  
  static const bool enableCloudSync = false; // Not implemented in v1.0
  static const bool enableSocialSharing = true;
  static const bool enableBatchEditing = false; // Future feature
  static const bool enableAIFilters = false; // Future feature
  static const bool enablePremiumFilters = true;
  static const bool enableAnalytics = false; // Privacy-first approach
  
  // ==================== Social Media ====================
  
  static const String githubUrl = 'https://github.com/himprapatel-rgb/instagram-photo-edit-app';
  static const String issuesUrl = '$githubUrl/issues';
  static const String contributingUrl = '$githubUrl/blob/main/CONTRIBUTING.md';
  static const String licenseUrl = '$githubUrl/blob/main/LICENSE';
  
  // ==================== UI Constants ====================
  
  // Grid Configuration
  static const int galleryGridCrossAxisCount = 3;
  static const double galleryGridSpacing = 4.0;
  static const double galleryGridAspectRatio = 1.0;
  
  // Filter Preview
  static const int filterPreviewSize = 80;
  static const int filterPreviewCacheSize = 20;
  
  // Bottom Sheet
  static const double bottomSheetMaxHeight = 0.6; // 60% of screen
  static const double bottomSheetMinHeight = 0.3; // 30% of screen
  
  // ==================== Timeouts ====================
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration imageLoadTimeout = Duration(seconds: 10);
  static const Duration processingTimeout = Duration(seconds: 60);
  
  // ==================== Debug Configuration ====================
  
  static bool get isDebugMode => kDebugMode;
  static bool get isReleaseMode => kReleaseMode;
  static bool get isProfileMode => kProfileMode;
  
  // Logging
  static const bool enableDebugLogs = kDebugMode;
  static const bool enableErrorLogs = true;
  static const bool enablePerformanceLogs = kProfileMode;
}

/// Asset Paths
class AppAssets {
  AppAssets._();
  
  // Icons
  static const String iconsPath = 'assets/icons';
  static const String appIcon = '$iconsPath/app_icon.png';
  
  // Images
  static const String imagesPath = 'assets/images';
  static const String splashLogo = '$imagesPath/splash_logo.png';
  static const String placeholderImage = '$imagesPath/placeholder.png';
  static const String emptyState = '$imagesPath/empty_state.png';
  
  // Lottie Animations (for future use)
  static const String animationsPath = 'assets/animations';
  static const String loadingAnimation = '$animationsPath/loading.json';
  static const String successAnimation = '$animationsPath/success.json';
  
  // Fonts (if custom fonts are added)
  static const String fontsPath = 'assets/fonts';
}

/// Route Names
class AppRoutes {
  AppRoutes._();
  
  static const String splash = '/';
  static const String home = '/home';
  static const String gallery = '/gallery';
  static const String editor = '/editor';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String help = '/help';
  static const String filters = '/filters';
  static const String export = '/export';
}
