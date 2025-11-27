# PRO Editor - Design System v2.1.0

## ⚠️ LOCKED DESIGN - DO NOT CHANGE ⚠️

This document defines the official design system for PRO Editor.
**All future updates MUST use these exact values.**

---

## 🎨 Color Palette

### Primary Colors (LOCKED)
```dart
// AppColors class - DO NOT MODIFY
static const Color purple = Color(0xFF833AB4);   // Logo gradient start
static const Color pink = Color(0xFFFD1D1D);     // Logo gradient middle  
static const Color orange = Color(0xFFFCAF45);   // Logo gradient end
static const Color teal = Color(0xFF1DB9A0);     // Primary action color
static const Color dark = Color(0xFF121212);     // Background
static const Color surface = Color(0xFF1E1E1E);  // Card/Panel background
```

### Secondary Colors
```dart
static const Color white = Colors.white;          // Primary text
static const Color grey400 = Colors.grey[400];    // Secondary text
static const Color grey600 = Colors.grey[600];    // Disabled text
static const Color grey800 = Colors.grey[800];    // Borders
```

---

## 🔘 Button Styles

### Primary Button (Open Photo)
```dart
Container(
  height: 56,
  decoration: BoxDecoration(
    color: AppColors.teal,  // #1DB9A0
    borderRadius: BorderRadius.circular(16),
  ),
)
```

### Toolbar Button (Selected)
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.teal.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## 📝 Typography

### Font Family
- **Primary**: System default (San Francisco on iOS, Roboto on Android)

### Text Styles
```dart
// App Title
TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)

// Section Header  
TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)

// Body Text
TextStyle(fontSize: 14, color: Colors.grey[400])

// Small Label
TextStyle(fontSize: 10, color: Colors.white)
```

---

## 📐 Spacing & Layout

### Standard Spacing
```dart
const double spacingXS = 4;
const double spacingS = 8;
const double spacingM = 16;
const double spacingL = 24;
const double spacingXL = 32;
```

### Border Radius
```dart
const double radiusS = 8;
const double radiusM = 12;
const double radiusL = 16;
const double radiusXL = 20;
const double radiusCircle = 100;
```

---

## 🖼️ Component Specifications

### Home Screen
| Element | Value |
|---------|-------|
| Background | #121212 |
| Logo Size | 48x48 |
| Title Font | 24px Bold White |
| Subtitle | 14px Grey[400] |
| Feature Icon BG | Teal 20% opacity |
| CTA Button | Teal solid, 56px height |

### Editor Screen
| Element | Value |
|---------|-------|
| AppBar Height | 56px |
| Bottom Toolbar | 80px height |
| Panel Height | 200px |
| Slider Track | Grey[800] |
| Slider Active | Teal |

### Filter Thumbnails
| Element | Value |
|---------|-------|
| Size | 64x64 |
| Border Radius | 8px |
| Selected Border | 2px Teal |
| Label | 10px White |

---

## 🚫 What NOT to Change

1. **AppColors values** - These are brand colors
2. **Teal (#1DB9A0)** - Primary action color
3. **Dark background (#121212)** - App background
4. **Button heights** - 56px for primary CTA
5. **Border radius values** - Consistent rounded corners
6. **Font sizes** - Established hierarchy

---

## ✅ What CAN Change

1. **Feature functionality** - Add new features
2. **Panel content** - New sliders, options
3. **Filter presets** - Add more filters
4. **AI modes** - Add new AI features
5. **Bug fixes** - Fix issues without changing design

---

## 📋 Version History

| Version | Date | Design Changes |
|---------|------|----------------|
| v2.1.0 | Nov 27, 2025 | **DESIGN LOCKED** - Teal buttons, dark theme |
| v2.0.2 | Nov 27, 2025 | Orange gradient button (deprecated) |
| v2.0.0 | Nov 27, 2025 | Initial professional design |

---

**Maintained by**: PRO Editor Team  
**Last Updated**: November 27, 2025  
**Status**: 🔒 LOCKED
