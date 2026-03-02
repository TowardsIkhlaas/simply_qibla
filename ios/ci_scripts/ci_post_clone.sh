#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# ===== Version (managed by Flutter) =====
# Flutter reads version from pubspec.yaml and writes FLUTTER_BUILD_NAME and
# FLUTTER_BUILD_NUMBER to ios/Flutter/Generated.xcconfig during `flutter pub get`.
# Info.plist references these via $(FLUTTER_BUILD_NAME) and $(FLUTTER_BUILD_NUMBER).
# IMPORTANT: Disable "Automatically manage version and build numbers" in the
# Xcode Cloud workflow settings, otherwise CI_BUILD_NUMBER overrides CFBundleVersion.
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
echo "pubspec.yaml version: $VERSION (will be applied by flutter pub get)"

# ===== Google Maps API Key =====
if [ -z "$GOOGLE_MAPS_API_KEY_IOS" ]; then
  echo "ERROR: GOOGLE_MAPS_API_KEY_IOS environment variable is not set!"
  echo "Please add it as a secret in Xcode Cloud workflow settings."
  exit 1
fi

cat > "$CI_PRIMARY_REPOSITORY_PATH/ios/Runner/APIKey.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>GoogleMapsApiKeyiOS</key>
	<string>${GOOGLE_MAPS_API_KEY_IOS}</string>
</dict>
</plist>
EOF

echo "Created APIKey.plist with Google Maps API key (${#GOOGLE_MAPS_API_KEY_IOS} chars)"

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0
