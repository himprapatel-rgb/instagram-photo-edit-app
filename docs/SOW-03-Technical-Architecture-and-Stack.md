# Statement of Work (SOW) #03
## Technical Architecture & Stack

**Document Version:** 1.0  
**Last Updated:** November 24, 2025  
**Project:** Instagram Photo Editing App (Open Source)

---

## 1. Architecture Overview

The app follows a **layered architecture** pattern with clear separation of concerns:

```
┌─────────────────────━
│  Presentation Layer (UI)       │
│  (Flutter, React Native UI)    │
├─────────────────────━
│  Business Logic Layer          │
│  (State management, services)  │
├─────────────────────━
│  Data Layer                    │
│  (APIs, local storage)         │
├─────────────────────━
│  Image Processing Engine      │
│  (Native libraries)            │
└─────────────────────┘
```

---

## 2. Technology Stack

### 2.1 Frontend Framework

**Choice: Flutter**

| Aspect | Reason |
|--------|--------|
| **Why Flutter** | Single codebase for iOS & Android, excellent performance, large open-source ecosystem |
| **Version** | Flutter 3.13+ (stable channel) |
| **Language** | Dart 3.0+ |
| **State Management** | GetX, Riverpod, or Provider (TBD after prototyping) |
| **UI Framework** | Material 3 design |

**Alternative:** React Native (if Flutter unavailable)

### 2.2 Image Processing Libraries

| Library | Purpose | Platform | License |
|---------|---------|----------|----------|
| **OpenCV** | Image manipulation, filters | iOS, Android | Apache 2.0 |
| **Skia** | Graphics rendering | iOS, Android | BSD |
| **ImageSharp** | .NET image processing | Backend | Apache 2.0 |
| **Pillow** | Python image manipulation | Backend utilities | HPND |

### 2.3 AI/ML Stack

| Component | Library | Purpose | License |
|-----------|---------|---------|----------|
| **On-device ML** | TensorFlow Lite | Auto-enhance, background blur | Apache 2.0 |
| **ML Kit** | Google ML Kit | Face detection, object detection | Proprietary (free tier) |
| **Alternative AI** | PyTorch Mobile | If TF Lite unavailable | BSD |

### 2.4 Local Storage

| Data Type | Solution | Platform | License |
|-----------|----------|----------|----------|
| **User settings** | SharedPreferences / Hive | Flutter | Apache 2.0 |
| **Image cache** | File system cache | Device | - |
| **Project save** | SQLite / Hive | Local database | Public domain |

### 2.5 Backend (Future)

- **API Framework:** Django, FastAPI, or Node.js
- **Database:** PostgreSQL
- **Authentication:** OAuth 2.0
- **Cloud Storage:** AWS S3 or MinIO (self-hosted)
- **Image Processing:** FFmpeg, ImageMagick

---

## 3. Module Architecture

### 3.1 Core Modules

```
app/
├─ lib/
│  ├─ models/          # Data models
│  ├─ services/        # Business logic
│  ├─ widgets/         # UI components
│  ├─ screens/         # Full page screens
│  ├─ providers/       # State management (Riverpod)
│  ├─ utils/           # Helper functions
│  ├─ constants/       # App constants
│  ├─ l10n/            # Localization
│  └─ main.dart
├─ android/           # Android-specific code
├─ ios/                # iOS-specific code
└─ test/               # Unit & widget tests
```

### 3.2 Key Services

- **ImageService:** Load, cache, compress images
- **EditingService:** Apply filters, adjustments
- **FilterEngine:** Generate and apply filters
- **ExportService:** Export in multiple formats
- **ProjectService:** Save/load editing sessions
- **CacheManager:** Memory & disk caching

---

## 4. Performance Specifications

### 4.1 Image Processing

- **Image Load:** < 2 seconds for 8MP
- **Filter Application:** < 500ms
- **Preview Render:** < 100ms
- **Export Time:** < 5 seconds

### 4.2 Memory Management

- **Max Image Size:** 12MP (4000x3000)
- **Memory Per Image:** < 300MB
- **Cache Size:** 500MB max
- **Target Devices:** 2GB+ RAM

### 4.3 Battery & Storage

- **Battery Drain (idle):** < 1% per hour
- **App Size:** < 150MB (without filters)
- **Filter Library:** < 200MB (downloadable)

---

## 5. API Design

### 5.1 Image Processing API

```dart
class ImageEditor {
  Future<Uint8List> applyCrop(Image img, Rect rect);
  Future<Uint8List> applyFilter(Image img, Filter filter);
  Future<Uint8List> adjustBrightness(Image img, double value);
  Future<Uint8List> addText(Image img, TextOverlay text);
  Future<Uint8List> export(Image img, ExportFormat format);
}
```

### 5.2 Filter API

```dart
class FilterEngine {
  List<Filter> getAvailableFilters();
  Future<Uint8List> applyFilter(Image img, String filterId, Map params);
  void preloadFilters();
  void cacheFilter(String filterId);
}
```

---

## 6. Security & Privacy

### 6.1 Data Security

- **Encryption:** AES-256 for saved projects
- **No Cloud (MVP):** All data local
- **EXIF Stripping:** Optional removal of metadata
- **Permission Model:** Request only needed permissions

### 6.2 Privacy Commitments

- No tracking/analytics (MVP)
- No data collection
- Open source for transparency
- Device-only processing

---

## 7. Testing Strategy

### 7.1 Testing Framework

- **Unit Tests:** Mockito, test package (Dart)
- **Widget Tests:** Flutter test framework
- **Integration Tests:** Flutter integration_test
- **Performance Tests:** Flutter DevTools, Perfetto

### 7.2 Test Coverage

- **Target:** 80%+ code coverage
- **Critical Paths:** 100% coverage
- **Image Processing:** Performance benchmarks

---

## 8. CI/CD Pipeline

### 8.1 Version Control

- **Repository:** GitHub
- **Branch Strategy:** Git Flow
- **Main branches:** main, develop
- **Feature branches:** feature/*, bugfix/*, hotfix/*

### 8.2 Automation

- **CI Tool:** GitHub Actions
- **Build:** Automated on every PR
- **Testing:** Unit + widget tests on commit
- **Code Quality:** SonarQube, Lint
- **Deployment:** Manual approval for releases

---

## 9. Dependency Management

### 9.1 Critical Dependencies

| Package | Purpose | Version | License |
|---------|---------|---------|----------|
| flutter | Framework | 3.13+ | BSD |
| riverpod | State management | 2.4+ | MIT |
| image | Image processing | 4.0+ | MIT |
| intl | Localization | 0.19+ | BSD |
| hive | Local storage | 2.2+ | Apache 2.0 |

### 9.2 Open Source Compliance

- All dependencies must have compatible licenses
- MIT, Apache 2.0, BSD preferred
- GPL libraries avoided (unless needed)
- License tracking in dependencies.md

---

## 10. Scalability Considerations

### 10.1 Future Growth

- **Plugin Architecture:** Allow custom filters
- **Modular Loading:** Download filters on demand
- **Cloud Backend:** Optional cloud sync (v2.0)
- **API Versioning:** RESTful API versioning

### 10.2 Performance Optimization

- Lazy loading of filters
- Image compression before processing
- Caching preprocessed images
- Parallel processing for batch operations

---

## 11. Document Control

| Version | Date | Author | Changes |
|---------|------|--------|--------|
| 1.0 | 2025-11-24 | himprapatel-rgb | Initial technical architecture |

---

**Next Document:** [SOW #04 - Open Source Licensing & Compliance](./SOW-04-Open-Source-Licensing-and-Compliance.md)
