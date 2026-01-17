# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SimplyQibla is a Flutter application for finding the Qibla direction, built with privacy and accuracy in mind. It uses Google Maps to provide accurate prayer direction without requiring location permissions.

## Development Commands

### Dependencies
```bash
# Install dependencies
flutter pub get
```

### Running the Application
```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter run -d [device_id]
```

### Testing
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/map_page_test.dart
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Auto-fix formatting issues
dart format .
```

### Building
```bash
# Build Android APK
flutter build apk

# Build Android App Bundle
flutter build appbundle

# Build iOS IPA
flutter build ipa
```

## Code Architecture

### Directory Structure

- `lib/` - Main application code
  - `main.dart` - App entry point and initialization
  - `pages/` - Main UI screens
    - `map_page.dart` - Primary map interface
    - `map_page_state.dart` - State management for map page
    - `onboarding_page.dart` - Initial user onboarding
  - `widgets/` - Reusable UI components
    - `center_console.dart` - Main control console
    - `coordinates_form_bar.dart` - Coordinate input interface
    - `sq_app_bar.dart` - Custom app bar implementation
  - `helpers/` - Utility functions
    - `shared_preferences_helper.dart` - Local storage management
    - `maps_renderer_helper.dart` - Map rendering utilities
    - `url_launcher_helper.dart` - External URL handling
  - `l10n/` - Localization files (Arabic, English, French, German, Indonesian, Malay, Portuguese)
  - `theme/` - App theming and styling
  - `constants/` - App-wide constants
  - `globals/` - Global state and keys

### Key Technical Details

1. **Google Maps Integration**: Requires API key configuration in:
   - Android: `android/key.properties`
   - iOS: `ios/Runner/APIKey.plist`

2. **State Management**: Uses StatefulWidget with explicit state classes (e.g., MapPageState)

3. **Localization**: Supports 7 languages using Flutter's localization system

4. **Platform-Specific Configuration**:
   - Android uses AndroidViewSurface for better map performance
   - iOS requires specific Info.plist permissions for location services

### Code Style Requirements

The project enforces strict linting rules defined in `analysis_options.yaml`:

- **Required**: Type specifications (`always_specify_types: true`)
- **Required**: Single quotes for strings (`prefer_single_quotes: true`)
- **Required**: Return types for all functions (`always_declare_return_types: true`)
- **Forbidden**: Print statements (`avoid_print: true`)
- **Required**: Ordered imports (`directives_ordering: true`)

### Important Notes

1. Location permissions are optional - the app can work with manual coordinate input
2. The app uses Material 3 (Material You) design with dark theme
3. All new code must pass `flutter analyze` before merging
4. Tests are run automatically on PRs to master and develop branches via GitHub Actions