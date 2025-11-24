import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';

/// Service for handling app permissions
class PermissionService {
  /// Request camera permission
  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  /// Request storage/photo library permission
  static Future<PermissionStatus> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ uses granular media permissions
      if (await _isAndroid13OrHigher()) {
        return await Permission.photos.request();
      } else {
        return await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.request();
    }
    return PermissionStatus.granted; // Web doesn't need explicit permission
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        return await Permission.photos.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.isGranted;
    }
    return true; // Web doesn't need explicit permission
  }

  /// Request all required permissions
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        return await [
          Permission.camera,
          Permission.photos,
        ].request();
      } else {
        return await [
          Permission.camera,
          Permission.storage,
        ].request();
      }
    } else if (Platform.isIOS) {
      return await [
        Permission.camera,
        Permission.photos,
      ].request();
    }
    return {};
  }

  /// Check permission status
  static Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Show permission rationale dialog
  static Future<bool?> showPermissionRationale(
    BuildContext context, {
    required String title,
    required String message,
    required Permission permission,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              final status = await permission.request();
              if (status.isPermanentlyDenied) {
                await openAppSettings();
              }
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  /// Check if Android version is 13 or higher
  static Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    // This is a simplified check - in production, use device_info_plus
    return false; // Default to false for safety
  }

  /// Handle permission denial
  static Future<void> handlePermissionDenied(
    BuildContext context,
    Permission permission,
  ) async {
    final status = await permission.status;
    
    if (status.isPermanentlyDenied) {
      // Show dialog to open settings
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: Text(
            'This permission is required for the app to function properly. '
            'Please grant it in the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  /// Get permission status message
  static String getPermissionStatusMessage(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Permission granted';
      case PermissionStatus.denied:
        return 'Permission denied';
      case PermissionStatus.restricted:
        return 'Permission restricted';
      case PermissionStatus.limited:
        return 'Permission limited';
      case PermissionStatus.permanentlyDenied:
        return 'Permission permanently denied. Please enable in settings.';
      default:
        return 'Unknown permission status';
    }
  }
}
