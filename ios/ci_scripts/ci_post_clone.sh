#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

echo "=== Creating APIKey.plist ==="
echo "CI_PRIMARY_REPOSITORY_PATH: $CI_PRIMARY_REPOSITORY_PATH"
echo "Target path: $CI_PRIMARY_REPOSITORY_PATH/ios/Runner/APIKey.plist"

# Create APIKey.plist with Google Maps API key from Xcode Cloud environment variable
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

# Verify file was created
echo "=== Verifying APIKey.plist ==="
ls -la "$CI_PRIMARY_REPOSITORY_PATH/ios/Runner/APIKey.plist"
cat "$CI_PRIMARY_REPOSITORY_PATH/ios/Runner/APIKey.plist"

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

# Final verification
echo "=== Final verification of APIKey.plist ==="
ls -la "$CI_PRIMARY_REPOSITORY_PATH/ios/Runner/APIKey.plist"

exit 0
