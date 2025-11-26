# 📱 Complete UI/UX Flow Specification

**Project:** Instagram Photo Editor
**Version:** v0.5.0
**Date:** November 26, 2025
**Document Type:** End-to-End User Interface Specification
**Technology Stack:** Flutter 3.x / Dart 3.x

---

## 🎯 Document Purpose

This document provides a complete end-to-end UI/UX specification for frontend development. It covers:
- All screen flows and user journeys
- Component specifications with Flutter code patterns
- Navigation architecture
- State management patterns
- Responsive design breakpoints
- Accessibility requirements

---

## 🛠️ Technology Stack Reference

### Core Dependencies
```yaml
flutter:
  sdk: flutter
cupertino_icons: ^1.0.6
google_fonts: ^6.1.0
image: ^4.1.0
permission_handler: ^11.1.0
path_provider: ^2.1.0
share_plus: ^7.2.0
shared_preferences: ^2.2.2
```

### Flutter Version
- **Minimum SDK:** 3.0.0
- **Maximum SDK:** <4.0.0
- **Material Design:** Version 3

---

## 🗺️ Complete App Navigation Map

```
┌───────────────────────────────────────────────────┐
│                    APP LAUNCH                     │
└───────────────────────┬───────────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────────┐
│              1. SPLASH SCREEN                      │
│         (2 seconds auto-dismiss)                   │
└───────────────────────┬───────────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────────┐
│               2. HOME SCREEN                       │
│        (Main Landing / Pick Photos)                │
└────────────┬──────────────────────────┬────────────┘
             │                          │
             ▼                          ▼
┌──────────────────────┐  ┌──────────────────────┐
│    3. GALLERY SCREEN   │  │   4. CAMERA SCREEN    │
│   (Image Selection)    │  │   (Take Photo)        │
└──────────┬───────────┘  └──────────┬───────────┘
           │                         │
           └────────────┬────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────────┐
│               5. EDITOR SCREEN                     │
│          (Main Photo Editing Hub)                  │
└────┬────────┬───────┬────────┬───────┬────────┬────┘
     │        │       │        │       │        │
     ▼        ▼       ▼        ▼       ▼        ▼
┌───────┐┌──────┐┌──────┐┌───────┐┌──────┐┌───────┐
│Filters││Adjust││ Crop ││  AI   ││Export││ Share │
│ Modal ││ Modal││ Modal││ Panel ││ Modal││ Sheet │
└───────┘└──────┘└──────┘└───────┘└──────┘└───────┘
```

---

## 📱 Screen-by-Screen Specification

### Screen 1: Splash Screen

**File:** `lib/screens/splash_screen.dart`

**Purpose:** Brand introduction and app initialization

**Duration:** 2 seconds (auto-dismiss)

**Visual Elements:**
```
┌────────────────────────────────────┐
│                                    │
│       GRADIENT BACKGROUND          │
│     (Purple -> Pink -> Orange)     │
│                                    │
│          ┌────────────┐           │
│          │   LOGO   │           │
│          │  (Icon)  │           │
│          └────────────┘           │
│                                    │
│       "Instagram Photo Editor"     │
│                                    │
│         [Loading Indicator]        │
│                                    │
└────────────────────────────────────┘
```

**Flutter Implementation:**
```dart
class SplashScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF833AB4), // Purple
              Color(0xFFFD1D1D), // Pink
              Color(0xFFFCAF45), // Orange
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 800),
                child: Icon(Icons.photo_filter, size: 100),
              ),
              SizedBox(height: 24),
              // App Name
              Text(
                'Instagram Photo Editor',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Animations:**
- Logo: Fade in + Scale (800ms)
- Text: Fade in (600ms, 200ms delay)
- Loading: Rotate infinite

**Navigation:**
- Auto-navigate to HomeScreen after 2 seconds
- Use `Navigator.pushReplacement`

---

### Screen 2: Home Screen (Main Landing)

**File:** `lib/screens/home_screen.dart`

**Purpose:** Main entry point for users to start editing

**Visual Layout:**
```
┌────────────────────────────────────┐
│         STATUS BAR                  │
├────────────────────────────────────┤
│       GRADIENT BACKGROUND           │
│                                     │
│   ┌─────────────────────────────┐   │
│   │     HERO SECTION            │   │
│   │  🎨 Instagram Photo Editor  │   │
│   │  "Transform your photos"   │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────┐ ┌─────────┐ ┌───────┐ │
│   │ 🖼️      │ │ ✨       │ │ 🎨    │ │
│   │24 Filter│ │ AI Edit │ │Gamify│ │
│   │  Cards  │ │  Card   │ │ Card │ │
│   └─────────┘ └─────────┘ └───────┘ │
│                                     │
│   ┌─────────────────────────────┐   │
│   │    📷 PICK PHOTOS (CTA)      │   │
│   │    [Gradient Button]        │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │    🔥 STREAK INDICATOR       │   │
│   │    Day 5 | Level 12 | XP   │   │
│   └─────────────────────────────┘   │
│                                     │
└────────────────────────────────────┘
```

**Components:**

#### 2.1 Hero Section
```dart
Widget buildHeroSection() {
  return Container(
    padding: EdgeInsets.all(24),
    child: Column(
      children: [
        // Animated Icon
        AnimatedContainer(
          duration: Duration(seconds: 2),
          child: Icon(
            Icons.photo_filter,
            size: 80,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        // Title
        Text(
          'Instagram Photo Editor',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        // Subtitle
        Text(
          'Transform your photos with 24 premium filters',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}
```

#### 2.2 Feature Cards (Glassmorphism)
```dart
Widget buildFeatureCard({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Container(
    width: 110,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, size: 32, color: Colors.white),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(description, style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
```

#### 2.3 Primary CTA Button
```dart
Widget buildPickPhotosButton() {
  return GestureDetector(
    onTap: () => _pickImages(),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF833AB4),
            Color(0xFFFD1D1D),
            Color(0xFFFCAF45),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF833AB4).withOpacity(0.5),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_library, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Pick Photos',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
```

**User Actions:**
| Action | Result |
|--------|--------|
| Tap "Pick Photos" | Opens Gallery Screen |
| Tap Feature Card | Shows feature info tooltip |
| Pull down | Refresh streak data |

---

### Screen 3: Gallery Screen

**File:** `lib/screens/gallery_screen.dart`

**Purpose:** Image selection from device gallery

**Visual Layout:**
```
┌────────────────────────────────────┐
│ [←]  Select Photos      [Done]  │
├────────────────────────────────────┤
│                                    │
│  ┌────────┐┌────────┐┌────────┐   │
│  │  IMG   ││  IMG   ││  IMG   │   │
│  │  [✓]   ││        ││        │   │
│  └────────┘└────────┘└────────┘   │
│  ┌────────┐┌────────┐┌────────┐   │
│  │  IMG   ││  IMG   ││  IMG   │   │
│  │  [✓]   ││        ││  [✓]   │   │
│  └────────┘└────────┘└────────┘   │
│         ... (Grid continues)       │
│                                    │
├────────────────────────────────────┤
│  Selected: 3 photos                │
└────────────────────────────────────┘
```

**Grid Specifications:**
- Columns: 3 (mobile), 4 (tablet), 6 (desktop)
- Spacing: 4px between items
- Aspect Ratio: 1:1 (square)
- Selection Indicator: Blue checkmark overlay

---

### Screen 4: Editor Screen (Main Hub)

**File:** `lib/screens/editor_screen.dart`

**Purpose:** Primary photo editing workspace

**Visual Layout:**
```
┌────────────────────────────────────┐
│ [←]  Photo Editor   [⭐] [Save] │
├────────────────────────────────────┤
│                                    │
│   ┌────────────────────────────┐   │
│   │                            │   │
│   │      IMAGE PREVIEW         │   │
│   │      (Interactive)         │   │
│   │    [Pinch to Zoom]         │   │
│   │                            │   │
│   └────────────────────────────┘   │
│                                    │
│   [Undo] [Redo] [Compare]          │
│                                    │
├────────────────────────────────────┤
│        TOOL BAR (Bottom)           │
│ [🎨] [⚙️] [✂️] [✨] [💾] [📤]  │
│ Filter Adjust Crop  AI  Save Share│
└────────────────────────────────────┘
```

**Tool Bar Implementation:**
```dart
Widget buildToolBar() {
  return Container(
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Color(0xFF1A1F3A),
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildToolButton(
          icon: Icons.filter,
          label: 'Filters',
          onTap: () => _showFilterModal(),
        ),
        _buildToolButton(
          icon: Icons.tune,
          label: 'Adjust',
          onTap: () => _showAdjustModal(),
        ),
        _buildToolButton(
          icon: Icons.crop,
          label: 'Crop',
          onTap: () => _showCropModal(),
        ),
        _buildToolButton(
          icon: Icons.auto_awesome,
          label: 'AI',
          onTap: () => _showAIPanel(),
        ),
        _buildToolButton(
          icon: Icons.save,
          label: 'Save',
          onTap: () => _saveImage(),
        ),
        _buildToolButton(
          icon: Icons.share,
          label: 'Share',
          onTap: () => _showShareSheet(),
        ),
      ],
    ),
  );
}

Widget _buildToolButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
```

---

## 🎨 Modal Specifications

### Modal 1: Filter Selection

**Trigger:** Tap "Filters" button in Editor
**Type:** `showModalBottomSheet`

**Visual Layout:**
```
┌────────────────────────────────────┐
│          BLUR BACKDROP             │
│                                    │
│  ┌──────────────────────────────┐  │
│  │  🎨 Select Filter              │  │
│  ├──────────────────────────────┤  │
│  │  ┌────┐┌────┐┌────┐┌────┐   │  │
│  │  │Orig││Clar││Juno││Lark│<--│  │
│  │  │    ││    ││    ││    │   │  │
│  │  └────┘└────┘└────┘└────┘   │  │
│  │  ┌────┐┌────┐┌────┐┌────┐   │  │
│  │  │Reye││Gngm││Rise││Vlen│   │  │
│  │  └────┘└────┘└────┘└────┘   │  │
│  │        (24 filters total)     │  │
│  ├──────────────────────────────┤  │
│  │  [Cancel]    [Apply Filter]   │  │
│  └──────────────────────────────┘  │
└────────────────────────────────────┘
```

**24 Available Filters:**
| Category | Filters |
|----------|----------|
| Classic | Original, Clarendon, Gingham, Moon |
| Warm | Juno, Lark, Reyes, Valencia |
| Cool | Aden, Crema, Ludwig, Perpetua |
| Dramatic | Lo-Fi, Nashville, Stinson, Vesper |
| Vintage | 1977, Amaro, Brannan, Earlybird |
| Modern | Hudson, Inkwell, Kelvin, Mayfair |

**Filter Preview Card:**
```dart
Widget buildFilterCard(String filterName, ImageFilter filter) {
  return GestureDetector(
    onTap: () => _selectFilter(filter),
    child: Container(
      width: 80,
      height: 100,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: _selectedFilter == filter
            ? Border.all(color: Color(0xFF833AB4), width: 3)
            : null,
      ),
      child: Column(
        children: [
          // Filter preview thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: _currentImage,
              colorBlendMode: filter.blendMode,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4),
          Text(
            filterName,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    ),
  );
}
```

---

### Modal 2: Adjustment Panel

**Trigger:** Tap "Adjust" button
**Type:** `showModalBottomSheet`

**Visual Layout:**
```
┌────────────────────────────────────┐
│  ⚙️ Adjustments          [Reset]  │
├────────────────────────────────────┤
│                                    │
│  ☀️ Brightness      [-100|+100]   │
│  ───────●────────────       +25    │
│                                    │
│  🌟 Contrast         [0.5|2.0x]   │
│  ──────────●────────       1.2x   │
│                                    │
│  🎨 Saturation       [0|2.0x]     │
│  ─────────●─────────       1.0x   │
│                                    │
│  🌡️ Temperature     [-100|+100]   │
│  ────────●──────────       +10    │
│                                    │
├────────────────────────────────────┤
│  [Cancel]         [Apply]          │
└────────────────────────────────────┘
```

**Adjustment Slider Implementation:**
```dart
Widget buildAdjustmentSlider({
  required String label,
  required IconData icon,
  required double value,
  required double min,
  required double max,
  required ValueChanged<double> onChanged,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.white70),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white)),
            Spacer(),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(color: Color(0xFF833AB4)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Color(0xFF833AB4),
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}
```

---

### Modal 3: AI Enhancement Panel

**File:** `lib/widgets/ai_filter_panel.dart`
**Service:** `lib/services/ai_filter_service.dart`

**Visual Layout:**
```
┌────────────────────────────────────┐
│  ✨ AI Enhancement                  │
├────────────────────────────────────┤
│                                    │
│  ┌──────────────────────────────┐  │
│  │  ⚡ Auto-Enhance               │  │
│  │  One-click photo improvement  │  │
│  │  [       ENHANCE NOW       ]  │  │
│  └──────────────────────────────┘  │
│                                    │
│  AI Strength: [Low|Medium|High]    │
│  ──────────●────────  Medium      │
│                                    │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │Portrait│ │Landscp│ │ Food   │  │
│  │ Mode   │ │  Mode │ │ Mode   │  │
│  └────────┘ └────────┘ └────────┘  │
│                                    │
├────────────────────────────────────┤
│  [Cancel]         [Apply AI]       │
└────────────────────────────────────┘
```

---

## 📊 State Management

### App State Architecture

```dart
// lib/models/app_state.dart

class AppState {
  final List<File> selectedImages;
  final int currentImageIndex;
  final String? selectedFilter;
  final Map<String, double> adjustments;
  final UserProfile userProfile;
  final GamificationState gamification;
  
  AppState({
    this.selectedImages = const [],
    this.currentImageIndex = 0,
    this.selectedFilter,
    this.adjustments = const {},
    required this.userProfile,
    required this.gamification,
  });
}

class GamificationState {
  final int level;
  final int xp;
  final int streak;
  final List<String> achievements;
  final DateTime lastEditDate;
}
```

### State Flow Diagram

```
User Action --> Provider/Riverpod --> State Update --> UI Rebuild
     |                                    |
     v                                    v
SharedPreferences <----------------> Persistence
```

---

## 📱 Responsive Design Breakpoints

```dart
// lib/core/app_breakpoints.dart

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double widescreen = 1800;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}
```

### Layout Adaptations

| Screen | Mobile (<600px) | Tablet (600-900px) | Desktop (>900px) |
|--------|-----------------|-------------------|------------------|
| Home | Single column | 2 columns | 3 columns |
| Gallery Grid | 3 columns | 4 columns | 6 columns |
| Editor Tools | Bottom bar | Bottom bar | Side panel |
| Filter Grid | 4 per row | 6 per row | 8 per row |

---

## ⚙️ Navigation Implementation

```dart
// lib/core/app_router.dart

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/gallery':
        return MaterialPageRoute(builder: (_) => GalleryScreen());
      case '/editor':
        final args = settings.arguments as EditorArguments;
        return MaterialPageRoute(
          builder: (_) => EditorScreen(images: args.images),
        );
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}

// Navigation helpers
class AppNavigation {
  static void goToEditor(BuildContext context, List<File> images) {
    Navigator.pushNamed(
      context,
      '/editor',
      arguments: EditorArguments(images: images),
    );
  }
  
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
```

---

## 🎨 Color Constants

```dart
// lib/core/app_colors.dart

class AppColors {
  // Primary Gradient
  static const purple = Color(0xFF833AB4);
  static const pink = Color(0xFFFD1D1D);
  static const orange = Color(0xFFFCAF45);
  
  // Background
  static const background = Color(0xFF0A0E27);
  static const surface = Color(0xFF1A1F3A);
  static const card = Color(0xFF252B48);
  
  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB8B8D1);
  
  // Accent
  static const accent = Color(0xFFFF6B9D);
  
  // Status
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  
  // Gradient
  static const instagramGradient = LinearGradient(
    colors: [purple, pink, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

---

## 📝 Typography Constants

```dart
// lib/core/app_typography.dart

class AppTypography {
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );
  
  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
  );
  
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  
  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
  );
  
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );
}
```

---

## ✅ Implementation Checklist

### Phase 1: Core Screens
- [ ] Splash Screen with animations
- [ ] Home Screen with gradient background
- [ ] Gallery Screen with multi-select
- [ ] Editor Screen with tool bar

### Phase 2: Modals
- [ ] Filter Selection Modal (24 filters)
- [ ] Adjustment Panel Modal
- [ ] AI Enhancement Panel
- [ ] Export Options Modal
- [ ] Share Sheet

### Phase 3: Components
- [ ] Gradient buttons
- [ ] Glassmorphism cards
- [ ] Custom sliders
- [ ] Filter preview cards
- [ ] Streak indicator widget

### Phase 4: Features
- [ ] Image processing service
- [ ] AI filter service
- [ ] Gamification service
- [ ] Export service
- [ ] Permission handling

---

## 📚 References

- Flutter Documentation: https://flutter.dev/docs
- Material Design 3: https://m3.material.io
- Google Fonts: https://fonts.google.com
- Existing UI_UX_DESIGN.md in /docs
- ARCHITECTURE.md in /docs

---

**Document Version:** 1.0
**Last Updated:** November 26, 2025
**Author:** Development Team
**Next Review:** December 1, 2025
