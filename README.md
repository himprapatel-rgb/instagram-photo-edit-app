# Instagram Photo Editor App 📸✨

A professional-grade **Flutter** photo editing application inspired by VSCO, Snapseed, Adobe Lightroom, and Canva. Perfect for editing and enhancing Instagram photos with ease.

## 🎨 **Premium Features**

### **Filters** (23+ Premium Filters)
- **Classic**: Original, Clarendon, Gingham
- **Vintage**: Vintage, Lomo, Sepia  
- **Cool Tones**: Cool, Inkwell, Walden
- **Warm Tones**: Warm, Toaster, Valencia
- **Bold & Vibrant**: Vivid, Juno, Lark
- **Soft & Fade**: Fade, Amaro, Poprocket
- **Dark & Moody**: Noir, Ashby, Hudson
- **Professional**: Aden, Brannan, Brooklyn

### **Advanced Adjustments** (8+ Professional Controls)
- ✅ Exposure Control (Professional-grade)
- ✅ Brightness Adjustment
- ✅ Contrast Enhancement
- ✅ Shadow & Highlight Recovery
- ✅ Saturation Control
- ✅ Vibrance Enhancement (Like Snapseed)
- ✅ Clarity Adjustments (Like Lightroom)
- ✅ Color Temperature

### **Creative Effects**
- Grayscale / Black & White
- Sepia Tone
- Vintage Effect
- Cool Temperature
- Warm Temperature
- Vivid Colors
- Custom Effect Stacking

### **Professional Tools**
- 🔄 **Crop & Rotate** - Free aspect ratio and preset ratios (Instagram, Square, etc.)
- 🔁 **Flip & Mirror** - Horizontal and vertical flip
- ➡️ **Straighten** - Auto-level horizon
- 🌫️ **Blur Background** - Bokeh and background blur effects
- 📝 **Add Text** - Custom fonts, sizes, colors, and positioning
- 🖼️ **Borders & Frames** - Various border styles

### **User Experience Features**
- 👀 **Before/After Preview** - Side-by-side comparison (Like Snapseed)
- ↩️ **Undo/Redo System** - Multiple undo steps
- 💾 **Save Presets** - Quick-apply favorite edits
- 📁 **History** - Track all edits made
- 🎯 **Tabbed Navigation** - Easy access to Filters, Adjustments, Effects, Tools
- 📤 **Direct Share to Instagram** - One-tap Instagram sharing
- 🔄 **Aspect Ratio Presets** - Instagram, Square, Portrait, Landscape

## 🛠️ **Tech Stack**

- **Framework**: Flutter (Cross-platform: iOS & Android)
- **Language**: Dart
- **Image Processing**: `image` (Open-source pixel manipulation)
- **Photography**: `photofilters` (Professional filter library)
- **File Handling**: `image_picker`, `path_provider`
- **Storage**: `shared_preferences` (Local preferences)
- **UI**: Material Design 3 with custom Dark Mode
- **License**: MIT (Fully Open-Source)

## 📂 **Project Structure**

```
lib/
├── main.dart                          # App entry point
├── screens/
│   └── editor_screen.dart            # Main editor with tabbed UI
├── services/
│   └── image_editor_service.dart     # Image processing & filters
├── models/
│   └── filter_model.dart             # 23+ filter definitions
└── widgets/                          # (Coming: Custom UI components)
```

## 🚀 **Getting Started**

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/himprapatel-rgb/instagram-photo-edit-app.git
cd instagram-photo-edit-app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK/IPA

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release
```

## 💡 **Features Inspired By**

| Feature | Inspired By |
|---------|------------|
| Tabbed Navigation | VSCO, Adobe Lightroom |
| Advanced Adjustments | Adobe Lightroom, Snapseed |
| 23+ Filters | VSCO, Instagram |
| Before/After Preview | Snapseed, Afterlight |
| Text Overlay | Canva, Pixlr |
| Aspect Ratios | Instagram, SnapSeed |
| Undo/Redo System | Professional Design Apps |
| Share to Instagram | Native Integration |

## 🎯 **Coming Soon**

- ✨ Advanced Curve Adjustments
- 🎨 Color Grading Tools
- 📐 Perspective & Distortion
- 🌈 HSL (Hue, Saturation, Lightness) Fine-tuning
- 💬 Captions & Watermarks  
- 🖼️ Layout & Collage Maker
- 📤 Cloud Backup & Sync
- 🔒 User Accounts & Profile
- 🎬 Batch Processing
- 📱 Share to Multiple Platforms

## 🤝 **Contributing**

We welcome contributions! Feel free to:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 **Author**

**Himpratel RGB** - [GitHub](https://github.com/himprapatel-rgb)

## 🌟 **Show Your Support**

Give a ⭐ if you like this project! It helps us grow and improve.

---

**Made with ❤️ for Instagram Photo Enthusiasts**
