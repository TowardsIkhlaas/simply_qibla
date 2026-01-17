fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android upload_metadata

```sh
[bundle exec] fastlane android upload_metadata
```

Upload store listing metadata only (descriptions, screenshots, images)

### android deploy_internal

```sh
[bundle exec] fastlane android deploy_internal
```

Deploy AAB to internal testing track (draft)

### android deploy_production

```sh
[bundle exec] fastlane android deploy_production
```

Deploy AAB to production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
