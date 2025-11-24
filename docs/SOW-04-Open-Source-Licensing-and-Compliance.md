# Statement of Work (SOW) #04
## Open Source Licensing & Compliance

**Document Version:** 1.0  
**Last Updated:** November 24, 2025  
**Project:** Instagram Photo Editing App (Open Source)

---

## 1. Project License

### 1.1 Primary License: MIT

**Choice:** MIT License (Expat variant)

**Why MIT?**
- Permissive open-source license
- Minimal restrictions
- Widely recognized and used
- Compatible with proprietary derivatives
- Used by Flutter, Dart, and major libraries

### 1.2 License Header

Every source file includes:

```
Copyright (c) 2025 Instagram Photo Edit App Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 2. Dependency Compliance

### 2.1 Acceptable Licenses

✅ **Compatible:**
- MIT
- Apache 2.0
- BSD (2-clause, 3-clause)
- ISC
- MPL 2.0
- LGPL 2.1+ (with care)
- Unlicense
- Public Domain

❌ **Incompatible:**
- GPL v2/v3 (viral copyleft)
- AGPL (too restrictive)
- Commercial/Proprietary

### 2.2 Dependency Audit

All dependencies audited for:
- License compatibility
- Security vulnerabilities
- Active maintenance
- No GPL dependencies (unless isolated)

---

## 3. Third-Party Attributions

### 3.1 ATTRIBUTION.md

Project includes ATTRIBUTION.md with:
- All third-party libraries
- License names
- Links to repositories
- Copyright notices

### 3.2 Sample Format

```markdown
## Third-Party Libraries

- **Flutter**: BSD License
  https://github.com/flutter/flutter
  
- **OpenCV**: Apache 2.0
  https://github.com/opencv/opencv

- **TensorFlow Lite**: Apache 2.0
  https://www.tensorflow.org/lite
```

---

## 4. Contribution Guidelines

### 4.1 Contributor License Agreement (CLA)

- **Policy:** No formal CLA required (MIT-friendly)
- **Assumption:** Contributions released under MIT
- **Documentation:** CONTRIBUTING.md clarifies this

### 4.2 Pull Request Requirements

All PRs must:
- ✅ Use MIT-compatible licenses
- ✅ Include license headers in new files
- ✅ Document external dependencies
- ✅ Pass license compliance check

---

## 5. Open Source Repository Management

### 5.1 GitHub Repository

- **Visibility:** Public
- **Branch Protection:** Enabled
- **Issue Templates:** Included
- **PR Templates:** Included
- **Code of Conduct:** Included

### 5.2 Key Documents

| Document | Purpose |
|----------|----------|
| LICENSE | Full MIT license text |
| CONTRIBUTING.md | Contribution guidelines |
| ATTRIBUTION.md | Third-party credits |
| CODE_OF_CONDUCT.md | Community standards |
| README.md | Project overview |
| SECURITY.md | Vulnerability reporting |

---

## 6. Distribution & Deployment

### 6.1 App Store Compliance

**iOS App Store:**
- License visible in app
- Attribution prominently displayed
- No copyright claims in app name

**Google Play Store:**
- License link in description
- Source code availability link
- Proper open-source classification

### 6.2 Open Source Distribution

- GitHub releases with source code
- No license circumvention
- Transparent about modifications

---

## 7. Trademark & Branding

### 7.1 Instagram Trademark

**Important:** Instagram is a trademark of Meta Platforms, Inc.

- **Usage:** Descriptive only ("for Instagram photos")
- **Not Claimed:** App name doesn't include "Instagram"
- **Compliant:** Described as "Instagram photo editing app"

### 7.2 Project Name

- **Official Name:** Instagram Photo Edit App
- **Repository:** instagram-photo-edit-app
- **No Logo Copying:** Original logo required

---

## 8. Compliance Checklist

### 8.1 Before Release

- [ ] LICENSE file includes full MIT text
- [ ] All source files have license headers
- [ ] ATTRIBUTION.md includes all dependencies
- [ ] CODE_OF_CONDUCT.md present
- [ ] CONTRIBUTING.md present
- [ ] No GPL dependencies
- [ ] All dependency licenses compatible
- [ ] SECURITY.md present
- [ ] README explains open-source nature

### 8.2 Ongoing

- [ ] Monthly dependency audits
- [ ] Security vulnerability monitoring
- [ ] License compliance in PRs
- [ ] Attribution updates
- [ ] Community policy enforcement

---

## 9. Legal Disclaimers

### 9.1 Warranty Disclaimer

MIT License includes:
"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND..."

### 9.2 Liability Limitation

Not liable for:
- Data loss
- Indirect damages
- Business interruption
- Installation on unauthorized devices

---

## 10. Document Control

| Version | Date | Author | Changes |
|---------|------|--------|--------|
| 1.0 | 2025-11-24 | himprapatel-rgb | Initial licensing & compliance |

---

**Next Document:** [SOW #05 - UI/UX Requirements](./SOW-05-UI-UX-Requirements.md)
