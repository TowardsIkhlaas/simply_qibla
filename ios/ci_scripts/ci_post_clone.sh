#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# ===== Version Sync from pubspec.yaml =====
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
BUILD_NUMBER=$(echo $VERSION | cut -d'+' -f2)

echo "Setting iOS version to $VERSION_NAME ($BUILD_NUMBER) from pubspec.yaml"

cd ios
agvtool new-marketing-version $VERSION_NAME
agvtool new-version -all $BUILD_NUMBER

# Verify version was set correctly
ACTUAL_VERSION=$(agvtool what-marketing-version -terse1)
ACTUAL_BUILD=$(agvtool what-version -terse)
echo "Verified: iOS version is now $ACTUAL_VERSION ($ACTUAL_BUILD)"

if [ "$ACTUAL_VERSION" != "$VERSION_NAME" ] || [ "$ACTUAL_BUILD" != "$BUILD_NUMBER" ]; then
  echo "ERROR: Version mismatch! Expected $VERSION_NAME ($BUILD_NUMBER) but got $ACTUAL_VERSION ($ACTUAL_BUILD)"
  exit 1
fi

cd ..

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
