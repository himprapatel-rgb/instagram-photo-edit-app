# Development Workflow & Rules 🛠️

## Critical Development Rules ⚠️

**MANDATORY RULE: Documentation-First Development**

> **Whenever you write or update code, you MUST update the documentation at the same time.**

This is not optional. This is a core requirement for maintaining this professional open-source project.

**MANDATORY RULE 2: Dependency-Aware Development**

> **Whenever you write or update code, you MUST also update all dependent code to keep the flow working.**

This is equally critical. Code changes cannot break existing functionality.

### What This Means:

1. **If you change a service method signature**, update all files that call it
2. **If you add a new parameter**, update all usages
3. **If you rename a class or function**, update all references
4. **If you change a model structure**, update all consumers
5. **If you modify an export**, update all imports

### Example Scenarios:

#### Scenario 1: Changing a Service Method
```dart
// OLD: FilterService method
static Future<ui.Image?> applyFilter(ui.Image image, FilterType type)

// NEW: Added intensity parameter
static Future<ui.Image?> applyFilter(ui.Image image, FilterType type, {double intensity = 1.0})
```

**MUST UPDATE:**
- ✅ All files calling `FilterService.applyFilter()` in screens/
- ✅ All files calling it in widgets/
- ✅ Add intensity parameter to all call sites
- ✅ Update documentation showing new signature
- ✅ Update CODE_STRUCTURE.md with new method signature

#### Scenario 2: Adding a New Widget Property
```dart
// OLD: CustomButton
CustomButton({required VoidCallback onPressed, required String text})

// NEW: Added optional icon
CustomButton({required VoidCallback onPressed, required String text, IconData? icon})
```

**MUST UPDATE:**
- ✅ All existing CustomButton usages (they still work, but document the new option)
- ✅ CODE_STRUCTURE.md to show new property
- ✅ README.md if this changes button capabilities
- ✅ Widget documentation inline

#### Scenario 3: Refactoring File Structure
```dart
// OLD location
import '../services/filter_service.dart';

// NEW location (moved to subfolder)
import '../services/filters/filter_service.dart';
```

**MUST UPDATE:**
- ✅ ALL import statements across the entire codebase
- ✅ Project structure in CODE_STRUCTURE.md
- ✅ Any documentation referencing file paths
- ✅ Test files importing this service

### 🚨 Breaking Changes Checklist:

Before committing ANY change that affects other code:

- [ ] Did I search the entire codebase for usages of this code?
- [ ] Did I update all call sites with new signatures?
- [ ] Did I test that all dependent code still works?
- [ ] Did I update imports if I moved/renamed files?
- [ ] Did I update documentation to reflect changes?
- [ ] Did I check widgets that use this service?
- [ ] Did I check screens that use this widget?
- [ ] Did I verify the app still compiles?
- [ ] Did I run the app to ensure it works?

**If ANY checkbox is unchecked, DO NOT COMMIT!**

### ⚠️ Common Dependency Issues:

1. **Changed method signature but forgot to update callers**
   - Result: Compilation errors
   - Fix: Search all files, update all usages

2. **Renamed a file but forgot to update imports**
   - Result: Import errors everywhere
   - Fix: Global find-and-replace for import statements

3. **Modified a model but forgot screens using it**
   - Result: Runtime errors or incorrect data display
   - Fix: Check all consumers of that model

4. **Added required parameter without default value**
   - Result: All existing usages break
   - Fix: Make it optional or update all usages

### 🔍 How to Find Dependencies:

Use your IDE's features:
```
1. Right-click on class/method name
2. Select "Find Usages" or "Find All References"
3. IDE shows all files using this code
4. Update each one systematically
```

Or use command-line tools:
```bash
# Find all files importing a service
grep -r "import.*filter_service" lib/

# Find all usages of a method
grep -r "applyFilter" lib/
```

---

## 📋 Documentation Update Checklist

When you write or modify ANY code, immediately update:

### ✅ Always Update:

1. **CODE_STRUCTURE.md**
   - Add new files to the project structure tree
   - Document new classes, methods, or functions
   - Update architecture diagrams if structure changes
   - Add code examples for new APIs

2. **README.md**
   - Update feature list if adding new features
   - Update roadmap (move items from "Planned" to "Completed")
   - Update tech stack if adding new dependencies
   - Update installation steps if requirements change

3. **pubspec.yaml**
   - Add new dependencies immediately
   - Update version numbers
   - Add comments explaining why each dependency is needed

4. **Inline Code Documentation**
   - Add doc comments (`///`) to all public APIs
   - Explain parameters and return values
   - Provide usage examples
   - Document any gotchas or important notes

---

## 🔄 Development Workflow

### Step-by-Step Process:

```
1. Plan Feature/Fix
   ↓
2. Write Code
   ↓
3. **IMMEDIATELY Update Documentation** ⚠️
   ↓
4. Test Code
   ↓
5. Commit Code + Documentation Together
```

### ❌ WRONG Approach:
```
1. Write lots of code
2. Commit code
3. "I'll update docs later" ← DON'T DO THIS!
```

### ✅ CORRECT Approach:
```
1. Create filter_service.dart
2. IMMEDIATELY update CODE_STRUCTURE.md with service details
3. IMMEDIATELY update README.md feature list
4. Add inline documentation to the code
5. Commit everything together
```

---

## 📝 Documentation Standards

### Code Documentation Template:

```dart
/// Brief one-line description of what this does
///
/// More detailed explanation if needed. Explain the purpose,
/// when to use it, and any important considerations.
///
/// **Parameters:**
/// - `param1`: Description of first parameter
/// - `param2`: Description of second parameter
///
/// **Returns:** Description of what is returned
///
/// **Example:**
/// ```dart
/// final result = await myFunction(value1, value2);
/// print(result);
/// ```
///
/// **Throws:**
/// - `Exception`: When something goes wrong
static Future<ReturnType> myFunction(
  ParamType param1,
  ParamType param2,
) async {
  // Implementation
}
```

### README Update Template:

When adding a feature, add to README.md:

```markdown
### 🆕 New Feature Name

- Brief description
- Key capabilities
- Usage example (if applicable)

Update roadmap:
- [x] Feature Name  ← Move from Planned to Completed
```

### CODE_STRUCTURE Update Template:

When adding a new file:

```markdown
#### New Service/Widget/Utility
**Purpose**: What this component does

**Features:**
- Feature 1
- Feature 2
- Feature 3

**Key Methods:**
```dart
method signature
```
```

---

## 🎯 Why This Rule Exists

### For Users:
- They need to understand how to use the app
- They need setup instructions
- They need to know what features exist

### For Contributors:
- They need to understand the architecture
- They need to know where to add code
- They need to understand existing code

### For Future You:
- You'll forget what you wrote 3 months from now
- Documentation helps you remember why you made decisions
- Makes debugging and maintenance easier

### For Open Source:
- Professional projects have professional documentation
- Good documentation attracts contributors
- Documentation is as important as code

---

## 📊 Documentation Priority Matrix

| Code Change Type | Must Update | Should Update | Optional |
|-----------------|-------------|---------------|----------|
| New Service/Class | CODE_STRUCTURE.md, Inline docs | README.md | - |
| New Feature | README.md, CODE_STRUCTURE.md, Inline docs | - | - |
| New Widget | CODE_STRUCTURE.md, Inline docs | README.md | - |
| Bug Fix | Inline docs | - | README.md |
| Refactoring | CODE_STRUCTURE.md if structure changes | - | README.md |
| New Dependency | pubspec.yaml, README.md | CODE_STRUCTURE.md | - |
| Breaking Change | README.md, CODE_STRUCTURE.md, Inline docs | CHANGELOG | - |

---

## 🚫 Common Mistakes to Avoid

1. **"I'll document it later"**
   - ❌ Wrong! Later never comes
   - ✅ Right! Document immediately while it's fresh

2. **"The code is self-documenting"**
   - ❌ Wrong! Code shows HOW, not WHY
   - ✅ Right! Documentation explains purpose and usage

3. **"I'll update the README when I'm done"**
   - ❌ Wrong! You'll forget what you added
   - ✅ Right! Update as you go

4. **"Documentation is for others"**
   - ❌ Wrong! It's for future you too
   - ✅ Right! You'll thank yourself later

---

## ✅ Commit Message Format

When committing code + documentation together:

```
<type>(<scope>): <subject>

<body explaining what was done>

Documentation updated:
- Updated CODE_STRUCTURE.md with new service details
- Updated README.md feature list
- Added inline documentation to all public methods
```

**Example:**
```
feat(filters): Add 24 professional filter presets

Implemented comprehensive filter service with Instagram-style
filters organized into 8 categories.

Documentation updated:
- Added FilterService to CODE_STRUCTURE.md with full API docs
- Updated README.md with filter list and categories
- Added inline documentation to all filter methods
- Updated feature roadmap in README.md
```

---

## 🔍 Pre-Commit Checklist

Before committing, ask yourself:

- [ ] Did I add inline documentation to new public methods?
- [ ] Did I update CODE_STRUCTURE.md if I added new files?
- [ ] Did I update README.md if I added new features?
- [ ] Did I update pubspec.yaml if I added dependencies?
- [ ] Did I update the roadmap in README.md?
- [ ] Are my commit messages clear and descriptive?
- [ ] Did I include "Documentation updated:" in commit message?

**If ANY checkbox is unchecked, DO NOT COMMIT YET!**

---

## 🎓 Documentation Examples

### Example 1: Adding a New Service

**Code added:** `lib/services/export_service.dart`

**Documentation updated:**
1. ✅ CODE_STRUCTURE.md - Added export service section
2. ✅ README.md - Added to feature list
3. ✅ Inline docs - All methods documented
4. ✅ pubspec.yaml - Added share_plus dependency

### Example 2: Adding a New Widget

**Code added:** `lib/widgets/filter_preview_card.dart`

**Documentation updated:**
1. ✅ CODE_STRUCTURE.md - Added widget documentation
2. ✅ Inline docs - Widget and parameters documented
3. ✅ README.md - Mentioned in widgets section

---

## 📚 Documentation Resources

### Internal Documents:
- [CODE_STRUCTURE.md](CODE_STRUCTURE.md) - Complete architecture
- [README.md](../README.md) - User-facing documentation
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines

### External Resources:
- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)
- [Flutter Documentation Best Practices](https://flutter.dev/docs/development/documentation)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## 🎯 The Golden Rule

> **"If it's not documented, it doesn't exist."**

No matter how good your code is, if nobody knows about it or understands how to use it, it's useless.

**Documentation is not optional. It's mandatory.**

---

## 📞 Questions?

If you're unsure about documentation:
1. Look at existing documentation for examples
2. Ask in GitHub Discussions
3. Check this guide
4. When in doubt, over-document rather than under-document

---

**Last Updated:** November 24, 2025  
**Version:** 1.0.0  
**Status:** Mandatory for all contributors
