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

## CI/CD Pipeline

### Overview
- **Android:** GitHub Actions → Play Store (Production)
- **iOS:** Xcode Cloud → App Store

### Release Workflow
1. Work on `develop` branch
2. Bump version in `pubspec.yaml` (e.g., `3.0.4+35`)
3. Update release notes:
   - Android: `android/fastlane/metadata/android/{locale}/changelogs/default.txt`
   - iOS: `ios/fastlane/metadata/{locale}/release_notes.txt`
4. Merge `develop` → `master`
5. CI automatically: builds → deploys → creates GitHub release

### Fastlane Lanes

| Platform | Lane | Purpose | Trigger |
|----------|------|---------|---------|
| Android | `upload_metadata` | Store listing only | Manual |
| Android | `deploy_internal` | Internal track (draft) | Manual |
| Android | `deploy_production` | Production track | CI |
| iOS | `upload_metadata` | Store listing only | Manual |
| iOS | `deploy_production` | App Store | Xcode Cloud |

### Store Metadata Locations

| Platform | Content | Path |
|----------|---------|------|
| Android | Description | `android/fastlane/metadata/android/{locale}/full_description.txt` |
| Android | Release Notes | `android/fastlane/metadata/android/{locale}/changelogs/default.txt` |
| Android | Screenshots | `android/fastlane/metadata/android/{locale}/images/` |
| iOS | Description | `ios/fastlane/metadata/{locale}/description.txt` |
| iOS | Release Notes | `ios/fastlane/metadata/{locale}/release_notes.txt` |

### GitHub Secrets Required
- `PLAY_STORE_JSON_KEY` - Base64-encoded Play Store service account JSON
- `ANDROID_KEYSTORE_BASE64` - Base64-encoded upload keystore
- `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`
- `GOOGLE_MAPS_API_KEY_ANDROID`

### Xcode Cloud Environment Variables
- `GOOGLE_MAPS_API_KEY_IOS` - Set as secret in Xcode Cloud workflow

### Caveats
1. **Version must be bumped** before merging to master (Play Store rejects duplicate version codes)
2. **Metadata updates** (descriptions, screenshots) can be deployed separately via `fastlane upload_metadata` without version bump
3. **iOS release notes** use a single `release_notes.txt` per locale (overwrites each release)
4. **Android changelogs** use `default.txt` for "What's New" text
5. **APIKey.plist** (iOS) and **key.properties** (Android) are in `.gitignore` - CI creates them from secrets
6. **iOS version sync** - `ci_post_clone.sh` uses `agvtool` to set iOS CFBundleShortVersionString and CFBundleVersion from `pubspec.yaml`