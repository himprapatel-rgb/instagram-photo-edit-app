# Instagram Photo Editor App 📸✨

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)

A professional-grade **Flutter** photo editing application for Instagram photos. Built with open-source components and inspired by industry-leading apps like VSCO, Snapseed, Adobe Lightroom, and Canva.

## ✨ Features

### 🎨 24 Professional Filters

Choose from a curated collection of Instagram-style filters:

**Black & White**
- None, Grayscale, Noir

**Vintage**
- Sepia, Vintage, Retro

**Cool Tones**
- Cool, Arctic, Nordic

**Warm Tones**  
- Warm, Sunset, Golden Hour

**Vivid**
- Vivid, Pop, Chrome

**Muted**
- Fade, Pastel, Muted

**Drama**
- Drama, HDR, Silhouette

**Special Effects**
- Nashville, Clarendon, Gingham

### 📐 Instagram Aspect Ratios

Perfectly crop your photos for Instagram:
- **Square** (1:1) - Classic Instagram posts
- **Portrait** (4:5) - Vertical posts
- **Landscape** (1.91:1) - Wide shots
- **Story** (9:16) - Instagram Stories

### 🛠️ Editing Tools

- **Crop & Transform**: Rotate, flip horizontal/vertical
- **Filters**: 24 professional preset filters
- **Export**: Save to gallery or share directly
- **Adjustments**: Brightness, contrast, saturation (coming soon)

### 💾 Export Options

- Save to device gallery
- Share via system share dialog  
- PNG and JPEG format support
- Platform-specific optimization (Android/iOS/Web)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode / VS Code

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/himprapatel-rgb/instagram-photo-edit-app.git
cd instagram-photo-edit-app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

### Platform-Specific Setup

#### Android

Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

#### iOS

Add permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to edit your photos</string>
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/     # App constants and configuration
│   └── theme/         # Material Design 3 theming
├── models/            # Data models
├── screens/           # UI screens (Home, Gallery, Editor)
├── services/          # Business logic
│   ├── filter_service.dart
│   ├── export_service.dart
│   ├── permission_service.dart
│   └── image_editor_service.dart
├── utils/             # Utility functions
│   └── crop_utility.dart
└── widgets/           # Reusable UI components
    ├── custom_button.dart
    ├── loading_widget.dart
    └── filter_preview_card.dart
```

## 🔧 Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **Design**: Material Design 3
- **State Management**: Built-in Flutter state management
- **Architecture**: Service-based architecture
- **Dependencies**: Open-source packages only

### Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  image: ^4.1.0                    # Image processing
  permission_handler: ^11.1.0      # Permission management
  path_provider: ^2.1.0            # File system access
  share_plus: ^7.2.0               # Sharing functionality
  google_fonts: ^6.1.0             # Typography
```

## 🎯 Roadmap

### ✅ Completed

- [x] Material Design 3 theming
- [x] 24 professional filters
- [x] Instagram aspect ratio support
- [x] Image crop and transform utilities
- [x] Export and share functionality
- [x] Permission handling (Camera, Photos)
- [x] Reusable UI components
- [x] Project documentation

### 🚧 In Progress

- [ ] Complete editor screen UI
- [ ] Filter algorithm implementation
- [ ] Adjustment controls (brightness, contrast, etc.)

### 📋 Planned

- [ ] Undo/Redo functionality
- [ ] Text overlay tool
- [ ] Sticker support
- [ ] Blur effects
- [ ] Unit and widget tests
- [ ] CI/CD pipeline
- [ ] Localization (i18n)

## 🤝 Contributing

Contributions are always welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features  
- 🔧 Submit pull requests
- 📖 Improve documentation
- ⭐ Star this repository

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by VSCO, Snapseed, Adobe Lightroom, and Canva
- Built with open-source Flutter and Dart
- Material Design 3 guidelines
- Flutter community packages

## 📱 Screenshots

*Coming soon - Screenshots of the app in action*

## 💬 Support

If you have any questions or need help, please:

- Open an [issue](https://github.com/himprapatel-rgb/instagram-photo-edit-app/issues)
- Start a [discussion](https://github.com/himprapatel-rgb/instagram-photo-edit-app/discussions)
- Check existing documentation

## 🌟 Star History

If you find this project useful, please consider giving it a star! ⭐

---

**Made with ❤️ and Flutter** | [Report Bug](https://github.com/himprapatel-rgb/instagram-photo-edit-app/issues) | [Request Feature](https://github.com/himprapatel-rgb/instagram-photo-edit-app/issues)
