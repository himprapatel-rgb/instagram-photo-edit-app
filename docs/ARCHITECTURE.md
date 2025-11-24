# Architecture Documentation 🏗️

## Overview

Instagram Photo Editor App is built using **Flutter** with a clean, modular architecture that emphasizes separation of concerns, testability, and maintainability.

## Architecture Pattern

We use a **layered architecture** combined with **feature-first organization**:

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)         │
│   Screens, Widgets, Animations      │
└───────────┬─────────────────────────┘
            │
┌───────────▼─────────────────────────┐
│     Business Logic Layer            │
│   State Management, Controllers     │
└───────────┬─────────────────────────┘
            │
┌───────────▼─────────────────────────┐
│        Data Layer                   │
│   Services, Repositories, APIs      │
└───────────┬─────────────────────────┘
            │
┌───────────▼─────────────────────────┐
│      Core/Foundation                │
│   Utils, Constants, Themes          │
└─────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── constants/          # App-wide constants
│   │   └── app_constants.dart
│   ├── theme/              # Material Design 3 theming
│   │   └── app_theme.dart
│   └── utils/              # Helper utilities
│       ├── image_utils.dart
│       └── validation_utils.dart
│
├── screens/                # Feature screens
│   ├── home_screen.dart    # Landing page with psychological UI
│   ├── editor_screen.dart  # Photo editing interface
│   └── gallery_screen.dart # Photo selection gallery
│
├── widgets/                # Reusable UI components
│   ├── common/
│   │   ├── app_button.dart
│   │   └── loading_indicator.dart
│   ├── editor/
│   │   ├── filter_preview.dart
│   │   ├── editing_toolbar.dart
│   │   └── slider_control.dart
│   └── gamification/
│       ├── streak_indicator.dart
│       ├── achievement_badge.dart
│       └── progress_bar.dart
│
├── services/               # Business logic
│   ├── image_service.dart  # Image processing
│   ├── filter_service.dart # Filter application
│   ├── gamification_service.dart  # Streaks, XP, achievements
│   └── analytics_service.dart     # User engagement tracking
│
├── models/                 # Data models
│   ├── filter_model.dart
│   ├── user_stats.dart
│   └── achievement.dart
│
├── providers/              # State management (Provider/Riverpod)
│   ├── image_provider.dart
│   ├── gamification_provider.dart
│   └── theme_provider.dart
│
└── main.dart               # App entry point
```

---

## Key Components

### 1. Core Layer

**Purpose:** Foundation services used throughout the app

**Components:**
- `AppConstants` - Configuration values, animation durations, thresholds
- `AppTheme` - Material Design 3 color schemes, typography
- `ImageUtils` - Image processing helpers
- `ValidationUtils` - Input validation

### 2. Screens (Presentation Layer)

#### Home Screen
- **Psychological UI elements**
- Daily streaks, gamification widgets
- Social proof feed
- FOMO timers
- Animated call-to-action buttons

#### Editor Screen
- **Photo editing canvas**
- Filter application
- Advanced editing tools (brightness, contrast, etc.)
- Before/After comparison
- Export functionality

#### Gallery Screen
- **Photo selection interface**
- Multi-select capability
- Camera integration
- Recent photos display

### 3. Widgets (Reusable Components)

**Common Widgets:**
- Buttons, loading indicators, dialogs

**Editor Widgets:**
- Filter preview cards
- Adjustment sliders
- Tool palettes

**Gamification Widgets:**
- Streak indicators (🔥)
- Achievement badges
- XP progress bars
- Reward animations

### 4. Services (Business Logic)

#### ImageService
```dart
class ImageService {
  Future<ui.Image> applyFilter(ui.Image image, FilterType filter);
  Future<ui.Image> adjustBrightness(ui.Image image, double value);
  Future<Uint8List> exportImage(ui.Image image, ImageFormat format);
}
```

#### GamificationService
```dart
class GamificationService {
  int calculateXP(EditAction action);
  void updateStreak();
  List<Achievement> checkAchievements(UserStats stats);
  void awardBadge(Badge badge);
}
```

---

## State Management

### Provider/Riverpod Pattern

We use **Provider** for state management:

```dart
// Image State
class ImageProvider extends ChangeNotifier {
  ui.Image? _currentImage;
  List<FilterType> _appliedFilters = [];
  
  void loadImage(File file) { ... }
  void applyFilter(FilterType filter) { ... }
  void undo() { ... }
}

// Gamification State
class GamificationProvider extends ChangeNotifier {
  int _currentStreak = 0;
  int _totalXP = 0;
  int _level = 1;
  
  void incrementEditCount() { ... }
  void checkDailyStreak() { ... }
  void awardXP(int amount) { ... }
}
```

---

## Data Flow

### Image Editing Flow
```
User Action (UI)
     ↓
Widget (Presentation)
     ↓
Provider (State)
     ↓
ImageService (Logic)
     ↓
Image Package (Processing)
     ↓
Updated Image
     ↓
UI Update (setState/notifyListeners)
```

### Gamification Flow
```
User Completes Edit
     ↓
GamificationService.recordAction()
     ↓
Calculate XP + Check Achievements
     ↓
Update GamificationProvider
     ↓
Trigger Reward Animations
     ↓
Update UI (badges, streaks, level)
```

---

## Image Processing Pipeline

### Filter Application

1. **Load Image** → Convert to `ui.Image`
2. **Convert to Pixels** → Extract RGBA pixel data
3. **Apply Filter Matrix** → Mathematical transformations
4. **Recompose Image** → Create new `ui.Image`
5. **Display** → Render to canvas

### Supported Filters

```dart
enum FilterType {
  none, grayscale, sepia, vintage,
  cool, warm, vivid, noir,
  valencia, nashville, kelvin, lofi
}
```

---

## Performance Optimizations

### 1. Image Caching
- Cache processed images to avoid reprocessing
- Use LRU cache for filter previews

### 2. Async Processing
- Process images on separate isolates
- Non-blocking UI during heavy operations

### 3. Lazy Loading
- Load filters on-demand
- Progressive image loading

### 4. Widget Optimization
- `const` constructors where possible
- `RepaintBoundary` for expensive widgets
- Optimized `shouldRebuild` logic

---

## Security Considerations

- **No sensitive data storage** - All processing client-side
- **Secure file handling** - Validate image formats
- **Privacy-first** - No analytics without consent
- **HTTPS only** - Secure external connections

---

## Testing Strategy

### Unit Tests
```dart
test('ImageService applies filter correctly', () {
  final service = ImageService();
  final result = service.applyFilter(testImage, FilterType.sepia);
  expect(result, isNotNull);
});
```

### Widget Tests
```dart
testWidgets('HomeScreen displays streak counter', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.byType(StreakIndicator), findsOneWidget);
});
```

### Integration Tests
- End-to-end user flows
- Photo upload → Edit → Export

---

## Future Architecture Plans

### Phase 1: Current (✅)
- Clean architecture
- Basic state management
- Core editing features

### Phase 2: Enhanced State (🚧)
- Migrate to Riverpod
- Add Redux for complex state
- Implement command pattern for undo/redo

### Phase 3: Backend Integration (📅)
- Firebase authentication
- Cloud storage for user data
- Analytics and crash reporting

### Phase 4: AI Integration (🔮)
- TensorFlow Lite models
- ML Kit for smart features
- Background removal AI

---

## Dependencies

### Core Dependencies
```yaml
flutter:
  sdk: flutter

image: ^4.0.0              # Image processing
image_picker: ^1.0.0       # Photo selection
provider: ^6.0.0           # State management
shared_preferences: ^2.0.0 # Local storage
```

### Development Dependencies
```yaml
flutter_test:
  sdk: flutter
flutter_lints: ^2.0.0
mockito: ^5.0.0
```

---

## Build & Deployment

### Web Build
```bash
flutter build web --release
```

### Android Build
```bash
flutter build apk --release
```

### iOS Build
```bash
flutter build ios --release
```

---

## Performance Metrics

### Target Benchmarks
- **App Start Time:** < 2s
- **Filter Application:** < 200ms
- **Export (1080p):** < 3s
- **Memory Usage:** < 150MB
- **Frame Rate:** Consistent 60fps

---

## Contributing to Architecture

When adding new features:

1. **Follow the layered architecture**
2. **Keep components decoupled**
3. **Write tests for business logic**
4. **Document public APIs**
5. **Optimize for performance**

---

## Resources

- [Flutter Architecture Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Material Design 3](https://m3.material.io/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

**Last Updated:** November 24, 2025  
**Maintained by:** Instagram Photo Editor Team
