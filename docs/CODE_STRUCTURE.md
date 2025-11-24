# Code Structure & Architecture

## Professional Flutter Application Structure

This document outlines the complete code architecture for the Instagram Photo Editor app, built with open-source components following industry best practices.

---

## 📁 Complete Project Structure

```
instagram-photo-edit-app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart       # App-wide constants
│   │   └── theme/
│   │       └── app_theme.dart           # Material Design 3 theme
│   ├── models/
│   │   └── instagram_models.dart    # 23 Instagram premium models
│   ├── screens/
│   │   ├── home_screen.dart         # Home screen with navigation
│   │   ├── gallery_screen.dart      # Photo selection gallery
│   │   └── editor_screen.dart       # Main editing interface
│   ├── services/
│   │   ├── filter_service.dart      # 24 professional filters
│   │   ├── export_service.dart      # Image export & sharing
│   │   ├── permission_service.dart  # Camera/storage permissions
│   │   └── image_editor_service.dart # Image adjustments
│   ├── utils/
│   │   └── crop_utility.dart        # Crop & transform tools
│   ├── widgets/
│   │   ├── custom_button.dart       # Reusable button (5 variants)
│   │   ├── loading_widget.dart      # Loading indicator
│   │   └── filter_preview_card.dart # Filter preview UI
│   └── main.dart                   # App entry point
├── docs/
│   ├── CODE_STRUCTURE.md           # This file
│   └── SOW_*.md                    # 11 requirement documents
├── CONTRIBUTING.md                # Contribution guidelines
├── LICENSE                        # MIT License
├── README.md                      # Project documentation
└── pubspec.yaml                   # Dependencies
```

---

## 🏛️ Architecture Layers

### 1. **Core Layer** (`lib/core/`)
Foundational components used throughout the app.

#### Theme (`app_theme.dart`)
- Material Design 3 color schemes
- Light and dark themes
- Custom text styles
- Spacing & radius constants
- Premium gradient definitions

**Key Classes**:
```dart
class AppTheme {
  static ThemeData get lightTheme { ... }
  static ThemeData get darkTheme { ... }
  static List<BoxShadow> get customShadow { ... }
  static const LinearGradient premiumGradient = ...
}
```

#### Constants (`app_constants.dart`)
- App metadata (name, version)
- Instagram aspect ratios
- Animation durations
- Border radius values
- Spacing multipliers

---

### 2. **Models Layer** (`lib/models/`)
Data structures representing Instagram features.

#### Instagram Models (`instagram_models.dart`)
23 premium Instagram filter models including:
- Classic filters: Original, Clarendon, Gingham, etc.
- Vintage filters: Vintage, Lomo, Sepia
- Cool/Warm tone filters
- Special effects filters

**Example Model**:
```dart
class InstagramFilter {
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;
}
```

---

### 3. **Services Layer** (`lib/services/`)
Business logic and data operations.

#### Filter Service (`filter_service.dart`)
**Purpose**: Manages 24 professional filters

**Features**:
- 24 Instagram-style filters organized by category
- Black & White (3): None, Grayscale, Noir
- Vintage (3): Sepia, Vintage, Retro
- Cool Tones (3): Cool, Arctic, Nordic  
- Warm Tones (3): Warm, Sunset, Golden Hour
- Vivid (3): Vivid, Pop, Chrome
- Muted (3): Fade, Pastel, Muted
- Drama (3): Drama, HDR, Silhouette
- Special (3): Nashville, Clarendon, Gingham

**Key Methods**:
```dart
static Future<ui.Image?> applyFilter(
  ui.Image image,
  FilterType filterType,
  {double intensity = 1.0}
)
static List<FilterPreset> getAllFilters()
static FilterPreset? getFilterByType(FilterType type)
```

#### Export Service (`export_service.dart`)
**Purpose**: Image saving and sharing

**Features**:
- Export to device gallery
- Share via system dialog
- PNG and JPEG format support
- Platform-specific optimization (Android/iOS/Web)
- File size calculation
- Dimension formatting

**Key Methods**:
```dart
static Future<File?> exportToGallery(
  ui.Image image,
  {String? fileName, ImageFormat format, int quality}
)
static Future<bool> shareImage(
  ui.Image image,
  {String? text, ImageFormat format, int quality}
)
```

#### Permission Service (`permission_service.dart`)
**Purpose**: Handle app permissions

**Features**:
- Camera permission management
- Photo library access
- Android 13+ granular permissions
- Permission rationale dialogs
- Settings navigation

**Key Methods**:
```dart
static Future<PermissionStatus> requestCameraPermission()
static Future<PermissionStatus> requestStoragePermission()
static Future<Map<Permission, PermissionStatus>> requestAllPermissions()
static Future<void> handlePermissionDenied(BuildContext, Permission)
```

#### Image Editor Service (`image_editor_service.dart`)
**Purpose**: Image adjustments and effects

**Features**:
- Brightness, contrast, saturation controls
- Exposure, shadows, highlights
- Vibrance and clarity adjustments
- Grayscale, sepia, vintage effects

---

### 4. **Utilities Layer** (`lib/utils/`)
Helper functions and tools.

#### Crop Utility (`crop_utility.dart`)
**Purpose**: Image cropping and transformation

**Features**:
- Crop to custom rectangle
- Instagram aspect ratios:
  * Square (1:1)
  * Portrait (4:5)
  * Landscape (1.91:1)
  * Story (9:16)
- Rotate (90°, 180°, 270°)
- Flip horizontal/vertical
- Centered crop calculation

**Key Methods**:
```dart
static Future<ui.Image?> cropImage(
  ui.Image image,
  {required Rect cropRect}
)
static Future<ui.Image?> cropToAspectRatio(
  ui.Image image,
  AspectRatioPreset preset
)
static Future<ui.Image?> rotateImage(ui.Image image, int degrees)
```

---

### 5. **Widgets Layer** (`lib/widgets/`)
Reusable UI components.

#### Custom Button (`custom_button.dart`)
**Purpose**: Styled button component

**Variants**:
1. Primary - Filled button with primary color
2. Secondary - Filled button with secondary color
3. Outlined - Border with transparent background
4. Text - Text-only button
5. Icon - Icon button variant

**Props**: `onPressed`, `text`, `icon`, `variant`, `isLoading`

#### Loading Widget (`loading_widget.dart`)
**Purpose**: Loading indicator

**Features**:
- Material Design circular progress
- Customizable size and color
- Centered layout

#### Filter Preview Card (`filter_preview_card.dart`)
**Purpose**: Display filter thumbnails

**Features**:
- 80x80px compact card design
- Filter preview thumbnail
- Filter name and icon
- Selection state visualization
- Tap gesture handling

---

### 6. **Screens Layer** (`lib/screens/`)
Full-screen UI views.

#### Home Screen (`home_screen.dart`)
**Features**:
- Welcome interface
- Navigation to gallery
- Premium gradient background
- Animated transitions
- Feature highlights

#### Gallery Screen (`gallery_screen.dart`)
**Features**:
- Photo grid display
- Camera/gallery picker
- Multi-select support
- Permission handling

#### Editor Screen (`editor_screen.dart`)
**Features**:
- Tabbed interface (Filters, Adjust, Effects)
- Real-time preview
- Filter selection carousel
- Adjustment sliders
- Export/share actions

---

## 🔧 Tech Stack

### Framework
- **Flutter**: 3.0+
- **Dart**: 3.0+

### Architecture Pattern
- **Service-based architecture**
- **Separation of concerns**
- **Clean code principles**

### Key Dependencies
```yaml
image: ^4.1.0              # Image processing
permission_handler: ^11.1.0 # Permission management
path_provider: ^2.1.0       # File system access
share_plus: ^7.2.0          # Sharing functionality
google_fonts: ^6.1.0        # Typography
```

---

## 📊 Data Flow

```
User Action
    ↓
Screen (UI)
    ↓
Service (Business Logic)
    ↓
Utility/Model (Data Processing)
    ↓
Result
    ↓
UI Update
```

### Example: Applying a Filter
```
1. User taps filter card in FilterPreviewCard
2. EditorScreen receives tap event
3. Calls FilterService.applyFilter()
4. Service processes image with filter
5. Returns filtered image
6. Screen updates preview
```

---

## 🎉 Development Principles

### Code Quality
✅ Const constructors where possible
✅ Null safety enabled
✅ Comprehensive documentation
✅ Descriptive naming
✅ DRY principle (Don't Repeat Yourself)

### Performance
✅ Async/await for heavy operations
✅ Lazy loading
✅ Image caching
✅ Efficient widget rebuilds

### Accessibility
✅ Semantic labels
✅ Screen reader support
✅ Sufficient contrast ratios
✅ Touch target sizes (48x48dp)

---

## 📚 Documentation

All public APIs are documented with:
- Function purpose
- Parameter descriptions
- Return value specifications
- Usage examples

**Example**:
```dart
/// Crop an image to specified rectangle
///
/// Parameters:
///   - image: Source image to crop
///   - cropRect: Rectangle defining crop area
///
/// Returns: Cropped image or null if operation fails
static Future<ui.Image?> cropImage(
  ui.Image image, {
  required Rect cropRect,
}) async { ... }
```

---

## ✅ Completed Features

- [x] Material Design 3 theming
- [x] 24 professional filters
- [x] Instagram aspect ratios
- [x] Crop and transform tools
- [x] Export and share functionality
- [x] Permission handling
- [x] Reusable UI components
- [x] Comprehensive documentation

## 🚧 In Development

- [ ] Complete editor screen UI
- [ ] Filter algorithm implementation
- [ ] Adjustment controls UI
- [ ] Undo/Redo functionality
- [ ] Unit and widget tests

---

**Last Updated**: November 24, 2025  
**Version**: 1.0.0
