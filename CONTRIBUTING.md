# Contributing to Instagram Photo Editor App 🎨

First off, thank you for considering contributing to Instagram Photo Editor App! It's people like you that make this app a great tool for everyone. We welcome contributions from everyone, whether you're fixing typos, adding new features, or reporting bugs.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)

## Code of Conduct

This project and everyone participating in it is governed by our commitment to create a welcoming and inclusive environment. By participating, you are expected to:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if possible**
- **Include your environment details** (OS, Flutter version, device)

### Suggesting Enhancements 💡

We love to receive enhancement suggestions! When submitting an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List some examples of how it would be used**
- **Include mockups or examples if applicable**

### Pull Requests ✅

1. **Fork the repository** and create your branch from `main`
2. **Follow the development setup** instructions below
3. **Make your changes** following our style guidelines
4. **Test your changes** thoroughly
5. **Update documentation** if needed
6. **Write clear commit messages**
7. **Submit a pull request** with a clear description

## Development Setup 🛠️

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Git

### Setup Steps

1. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/instagram-photo-edit-app.git
   cd instagram-photo-edit-app
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/himprapatel-rgb/instagram-photo-edit-app.git
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Run tests**
   ```bash
   flutter test
   ```

### Creating a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

## Style Guidelines 📝

### Dart Code Style

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check for issues
- Format code with `dart format .`
- Use meaningful variable and function names
- Add doc comments for public APIs
- Keep functions small and focused

### Code Organization

```
lib/
├── core/          # Core functionality (theme, constants)
├── models/        # Data models
├── screens/       # UI screens
├── services/      # Business logic and services
├── utils/         # Utility functions
└── widgets/       # Reusable widgets
```

### Widget Guidelines

- Prefer `const` constructors when possible
- Extract reusable widgets into separate files
- Use meaningful widget names
- Keep build methods focused
- Follow Material Design 3 guidelines

### Testing

- Write unit tests for services and utilities
- Write widget tests for custom widgets
- Aim for good test coverage
- Test edge cases and error handling

## Commit Messages 📋

Follow the conventional commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```bash
feat(filters): Add vintage filter effect

Implements the vintage filter with sepia tones and vignette effect.
Includes preview thumbnail and intensity control.

Closes #123
```

```bash
fix(export): Resolve image quality issue on Android

Fixed compression quality when exporting PNG images on Android devices.
Now maintains original quality settings.
```

## Areas for Contribution 🎯

We especially welcome contributions in these areas:

### High Priority

- Additional filter effects
- Performance optimizations
- Cross-platform testing
- Accessibility improvements
- Localization (i18n)

### Medium Priority

- UI/UX enhancements
- Documentation improvements
- Code examples and tutorials
- Unit and widget tests

### Nice to Have

- Dark mode improvements
- Animation enhancements
- Advanced editing features
- Social media integration

## Questions? 💬

Feel free to:

- Open an issue with the `question` label
- Start a discussion in GitHub Discussions
- Check existing documentation and issues

## Recognition 🌟

All contributors will be:

- Listed in our CONTRIBUTORS.md file
- Mentioned in release notes for significant contributions
- Given credit in relevant documentation

---

Thank you for contributing to Instagram Photo Editor App! Your efforts help make photo editing accessible and enjoyable for everyone. 📸✨
