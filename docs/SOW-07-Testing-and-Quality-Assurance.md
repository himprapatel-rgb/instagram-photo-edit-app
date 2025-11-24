# Statement of Work (SOW) #07
## Testing & Quality Assurance

**Document Version:** 1.0  
**Last Updated:** November 24, 2025  
**Project:** Instagram Photo Editing App (Open Source)

---

## 1. Testing Strategy

### 1.1 Testing Pyramid

```
        /\
       /E2E\
      /-----\
     /Widget \
    /---------\
   /Unit Tests \
  /-----------\
```

**Distribution:**
- Unit Tests: 60%
- Widget Tests: 30%
- E2E/Integration: 10%

### 1.2 Testing Framework

- **Unit:** Mockito, test package
- **Widget:** Flutter test
- **Integration:** integration_test
- **Performance:** Flutter DevTools, Perfetto

---

## 2. Test Coverage Goals

| Component | Target | Notes |
|-----------|--------|-------|
| Core business logic | 90%+ | Critical paths |
| Image processing | 85%+ | Edge cases important |
| UI components | 60%+ | Visual testing manual |
| Utilities | 80%+ | Helper functions |
| **Overall** | **80%+** | MVP target |

---

## 3. Manual Testing

### 3.1 Device Matrix

**iOS:**
- iPhone 12 mini (iOS 15)
- iPhone 14 (iOS 16+)
- iPhone 14 Pro (iOS 16+)

**Android:**
- Pixel 4 (API 30)
- Pixel 6 (API 31+)
- OnePlus 9 (OxygenOS)
- Samsung A12 (API 31)

### 3.2 Test Scenarios

- Image import (camera, gallery)
- All filters (visual inspection)
- Text overlay (rendering, export)
- Crop/rotate (accuracy)
- Export (format validation)
- Edge cases (extreme values, corrupted images)

---

## 4. Performance Testing

### 4.1 Benchmarks

- Image load: < 2 sec (8MP)
- Filter: < 500ms
- Slider response: < 100ms
- Export: < 5 sec
- Memory: < 300MB per image

### 4.2 Tools

- Flutter DevTools (CPU, memory)
- Android Profiler
- Xcode Instruments
- Custom performance tests

---

## 5. QA Checklist

### Pre-Release

- [ ] 80%+ unit test coverage
- [ ] All critical paths tested
- [ ] Device testing complete (iOS & Android)
- [ ] Accessibility audit (WCAG AA)
- [ ] Performance within spec
- [ ] No critical bugs
- [ ] All P0 features functional
- [ ] App store guidelines compliance

---

## 6. Bug Classification

| Severity | Impact | Examples |
|----------|--------|----------|
| **Critical** | App crash/unusable | Blank screen, data loss |
| **High** | Major feature broken | Filter not applying |
| **Medium** | Minor feature broken | UI misalignment |
| **Low** | Cosmetic | Typos, minor UX |

---

## 7. Regression Testing

- Automated test suite on every PR
- Manual regression before releases
- Beta testing with community
- Crash reporting post-launch

---

## 8. Document Control

| Version | Date | Author | Changes |
|---------|------|--------|--------|
| 1.0 | 2025-11-24 | himprapatel-rgb | Initial QA plan |

---

**Next Document:** [SOW #08 - Release & Deployment Plan](./SOW-08-Release-and-Deployment-Plan.md)
