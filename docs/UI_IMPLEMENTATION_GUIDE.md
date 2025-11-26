# 🛠️ UI Implementation Guide

**Version:** v0.5.1
**Date:** November 26, 2025
**Source of Truth:** [UI_UX_FLOW_SPECIFICATION.md](./UI_UX_FLOW_SPECIFICATION.md)
**Based on:** Latest Flutter best practices + AI research insights

---

## 🎯 Implementation Summary

This guide delivers step-by-step implementation instructions, patterns, and reusable code for the Instagram Photo Editor app. It is tightly coupled with:
- **[UI_UX_FLOW_SPECIFICATION.md](./UI_UX_FLOW_SPECIFICATION.md):** All screen, modal, navigation, and UI tool flows.
- **[UI_UX_DESIGN.md](./UI_UX_DESIGN.md):** Component specs, style system, and accessibility references.

---

## 📋 Reference Architecture

See [ARCHITECTURE.md](./ARCHITECTURE.md) for technical and AI architecture details. All UI modules, services, and ViewModels should conform to the structure shown in the flow spec.

---

## 🏗️ Step-by-Step Implementation Guide

### 1. Screen Builders

| Screen | Flow Spec Ref | Implementation Pattern |
|--------|--------------|----------------------|
| Splash | §3.1 | Animated gradient and logo (AnimatedSwitcher) |
| Home | §3.2 | Feature cards & glassmorphism (Stack, SafeArea, Hero) |
| Gallery | §3.3 | GridView.asset, permission_handler for access |
| Editor | §3.4 | TabBar & bottom navigation for tools |
| Filter Modal | §4.1 | Popup modal, ListView for 24 filters |
| AI Modal | §4.3 | Slide-up modal, FutureBuilder for AI feedback |

Example Splash Screen snippet:
```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 1000),
  child: appLogoWidget,
)
```

---

### 2. Navigation Structure

```dart
// lib/navigation/app_routes.dart
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/home': (context) => HomeScreen(),
  '/gallery': (context) => GalleryScreen(),
  '/editor': (context) => EditorScreen(),
};
```

- Use named Navigator routes
- Cross-reference navigation map in UI_UX_FLOW_SPECIFICATION.md §2

---

### 3. Component & Widget Implementations

- **Gradient backgrounds** (LinearGradient, Alignment.topLeft → Alignment.bottomRight) – See Design Spec
- **Glassmorphism cards/modal** (ClipRRect, BackdropFilter, Container with opacity)
- **Animated buttons** using InkWell & scale/fade transitions
- **Responsive layouts**: Use MediaQuery, LayoutBuilder, and Flow Spec breakpoints

**Glass card implementation:**
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      color: Colors.white.withOpacity(0.15),
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      // Card contents...
    ),
  ),
)
```

---

### 4. Filters and Editor Tools

**Implementing 24 Instagram-style Filters:**
Use the [image](https://pub.dev/packages/image) package, optimized filter presets.
- Organize filters in a Map<String, FilterPreset>
- Cross-reference filter categories/tables in UI_UX_FLOW_SPECIFICATION.md §4.1

```dart
final Map<String, FilterPreset> filters = {
  'Clarendon': clarendonPreset,
  'Gingham': ginghamPreset,
  // ... All 24 presets
};
```

**Editor Tool Panel Implementation:**
Refer to UI_UX_FLOW_SPECIFICATION.md §5 for details
- TabBar or segmented control for tool selection (Filters, Adjust, Crop, AI, Export, Share)
- ToolWidget pattern for modularity

---

### 5. State Management

Recommended: Riverpod (preferred for scalability), Provider OK for simple screens.
- **Global AppState** for user/session info
- **ImageEditorState** for temp edits/undo

Riverpod State Example:
```dart
final appStateProvider = StateProvider<AppState>((ref) => AppState());
final editorStateProvider = StateNotifierProvider<ImageEditorState, EditState>(...);
```

---

### 6. Responsive Implementation Patterns

Cross-reference responsive design in UI_UX_FLOW_SPECIFICATION.md §7.
- Use LayoutBuilder for adaptive grid layouts
- MediaQuery for breakpoints (<600 mobile, 600-900 tablet, >900 desktop)

Example:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      // Mobile layout
    } else if (constraints.maxWidth < 900) {
      // Tablet layout
    } else {
      // Desktop layout
    }
  },
)
```

---

### 7. Accessibility Implementation

- Minimum contrast and text sizing – refer to UI_UX_DESIGN.md & flow spec
- All touch targets >=44px for WCAG compliance
- Semantics widget for screen reader support

```dart
Semantics(
  label: 'Edit photo button',
  button: true,
  child: editButtonWidget,
)
```

---

### 8. AI Features Implementation

Cross-reference UI_UX_FLOW_SPECIFICATION.md §6 (AI Filter Panel UI, Real-time Preview, Loading State design):
- Use FutureBuilder for async AI tasks
- Display loading shimmer during CNN/ML processing

AI enhancement example:
```dart
FutureBuilder<AIResult>(
  future: getAIEnhancement(photo),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return LoadingShimmer();
    return AIResultWidget(snapshot.data);
  },
)
```

---

### 9. Implementation Checklist

- [x] SplashScreen: Animated gradient, logo
- [x] HomeScreen: Feature cards, hero section
- [x] Gallery: Photo picker, permissions
- [x] Editor: TabBar for tools, dynamic filter grid
- [x] Filter Modal: ListView, tap to apply filter
- [x] AI Modal: FutureBuilder pattern
- [x] Responsive support: LayoutBuilder, breakpoints
- [x] Accessibility: Semantics, WCAG contrast

---

### 10. Related Documentation

| Document | Description |
|----------|-------------|
| [UI_UX_FLOW_SPECIFICATION.md](./UI_UX_FLOW_SPECIFICATION.md) | Complete flows and navigation |
| [UI_UX_DESIGN.md](./UI_UX_DESIGN.md) | Visual styles, component & accessibility specs |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Technical/AI architecture |
| [PROGRESS_TRACKER.md](./PROGRESS_TRACKER.md) | Development tracking |

---

**Document Version:** 1.1
**Implementation Status:** ✅ Ready to Deploy
**Last Updated:** November 26, 2025
**Next Review:** December 1, 2025
