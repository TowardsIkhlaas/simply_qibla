# /release - Automated Release Command

Prepares a new release by extracting commits, generating release notes, translating to all supported languages, updating all necessary files, and creating a PR.

## Trigger

User runs `/release` or asks to "prepare a release"

## Prerequisites

- Must be on `develop` branch (or warn if not)
- Working directory should be clean (no uncommitted changes)

## Steps

### Step 1: Verify Environment

```bash
# Check current branch
git branch --show-current

# Check for uncommitted changes
git status --porcelain
```

If not on `develop`, warn the user and ask if they want to proceed.
If there are uncommitted changes, ask the user to commit or stash them first.

### Step 2: Get Last Release Tag

```bash
git describe --tags --abbrev=0 --match "v*"
```

This returns the last version tag (e.g., `v3.0.3`). If no tags exist, use the initial commit.

### Step 3: Extract Commits Since Last Release

```bash
git log {last_tag}..HEAD --oneline --no-merges
```

Parse commits using conventional commit prefixes:
- `feat:` → Features
- `fix:` → Bug Fixes
- `perf:`, `refactor:`, `chore:`, `style:`, `docs:` → Improvements

Skip commits that:
- Don't match any conventional commit pattern
- Are trivial (e.g., merge commits, version bumps)
- Start with `chore(release):`

### Step 4: Handle Edge Cases

If no commits since last tag:
- Warn the user: "No new commits since {last_tag}."
- Ask if they still want to release (maybe metadata-only update)

If no conventional commits found:
- Fall back to listing all commit subjects
- Warn that release notes may need manual editing

### Step 5: Prompt for Version Bump

Read current version from `pubspec.yaml` (line starting with `version:`).

Use AskUserQuestion to ask the user:
- **Header**: "Version"
- **Question**: "Current version is X.Y.Z+N. What type of release is this?"
- **Options**:
  1. **Patch (X.Y.Z+1)** - Bug fixes and minor improvements
  2. **Minor (X.Y+1.0)** - New features, backwards compatible
  3. **Major (X+1.0.0)** - Breaking changes

Build number always increments: N+1 regardless of version type.

### Step 6: Generate English Release Notes

Create user-friendly release notes from the categorized commits:

1. Group by category: Features, Improvements, Bug Fixes
2. Rewrite commit messages to be user-facing:
   - ❌ "feat: add compass rotation mode to map page"
   - ✅ "Compass-based map rotation mode"
3. Keep each item concise (1 sentence, no periods)
4. Deduplicate similar items

### Step 7: Translate Release Notes

Translate the English release notes to all supported locales:
- **Arabic (ar)** - Right-to-left language
- **German (de)**
- **French (fr)**
- **Indonesian (id)**
- **Malay (ms)**
- **Portuguese (pt)** - Also used for pt-BR and pt-PT variants

Translation guidelines:
- Keep translations concise like the English version
- Maintain consistent terminology with existing app translations
- Arabic should feel natural, not literal translations

### Step 8: Update All Files

#### 8a. Version in pubspec.yaml

Update the `version:` line:
```yaml
version: {new_version}+{new_build_number}
```

#### 8b. In-App Release Notes (lib/data/release_notes.dart)

1. Update `version` in `currentRelease` to new version
2. Update `features`, `improvements`, `fixes` lists with new localization keys
3. Add new case statements in `resolveKey()` method for each new key

Example key naming convention:
- Features: `whatsNewFeature{ShortName}` (e.g., `whatsNewFeatureCompassRotation`)
- Improvements: `whatsNewImprovement{ShortName}` (e.g., `whatsNewImprovementPolyline`)
- Fixes: `whatsNewFix{ShortName}` (e.g., `whatsNewFixLocationBug`)

#### 8c. Localization Files (lib/l10n/app_*.arb)

Add new keys to each ARB file:

**app_en.arb** (include @descriptions):
```json
"whatsNewFeatureNewThing": "Description of new thing",
"@whatsNewFeatureNewThing": {
  "description": "Release note for new thing feature."
}
```

**Other locale files** (translations only, no @descriptions):
```json
"whatsNewFeatureNewThing": "Translated description"
```

Files to update:
- `lib/l10n/app_en.arb` - English (with descriptions)
- `lib/l10n/app_ar.arb` - Arabic
- `lib/l10n/app_de.arb` - German
- `lib/l10n/app_fr.arb` - French
- `lib/l10n/app_id.arb` - Indonesian
- `lib/l10n/app_ms.arb` - Malay
- `lib/l10n/app_pt.arb` - Portuguese (base)
- `lib/l10n/app_pt_BR.arb` - Brazilian Portuguese (can copy from pt if same)
- `lib/l10n/app_pt_PT.arb` - European Portuguese (can copy from pt if same)

#### 8d. Android Store Metadata

Update `default.txt` changelog files:

| App Locale | Fastlane Path |
|------------|---------------|
| en | `android/fastlane/metadata/android/en-US/changelogs/default.txt` |
| ar | `android/fastlane/metadata/android/ar/changelogs/default.txt` |
| de | `android/fastlane/metadata/android/de-DE/changelogs/default.txt` |
| fr | `android/fastlane/metadata/android/fr-FR/changelogs/default.txt` |
| fr | `android/fastlane/metadata/android/fr-CA/changelogs/default.txt` |
| pt | `android/fastlane/metadata/android/pt-BR/changelogs/default.txt` |
| pt | `android/fastlane/metadata/android/pt-PT/changelogs/default.txt` |

Format for store release notes (plain text, ~500 char limit):
```
What's New in v{version}:

Features:
• Feature description one
• Feature description two

Improvements:
• Improvement description

Bug Fixes:
• Fix description
```

#### 8e. iOS Store Metadata

Update `release_notes.txt` files:

| App Locale | Fastlane Path |
|------------|---------------|
| en | `ios/fastlane/metadata/en-US/release_notes.txt` |
| ar | `ios/fastlane/metadata/ar-SA/release_notes.txt` |
| de | `ios/fastlane/metadata/de-DE/release_notes.txt` |
| fr | `ios/fastlane/metadata/fr-FR/release_notes.txt` |
| fr | `ios/fastlane/metadata/fr-CA/release_notes.txt` |
| pt | `ios/fastlane/metadata/pt-BR/release_notes.txt` |
| pt | `ios/fastlane/metadata/pt-PT/release_notes.txt` |

Use the same format as Android.

### Step 9: Regenerate Localizations

```bash
flutter gen-l10n
```

This regenerates `lib/l10n/app_localizations*.dart` files from the ARB sources.

### Step 10: Validate

```bash
flutter analyze
```

If analysis fails:
- Show the errors to the user
- Attempt to fix issues (usually missing imports or type errors)
- Re-run analysis until it passes
- If unable to fix, stop and ask for user help

### Step 11: Commit Changes

```bash
git add .
git commit -m "$(cat <<'EOF'
chore(release): prepare v{new_version}

- Update version to {new_version}+{new_build}
- Add release notes for all locales
- Update in-app What's New content
- Update store metadata

EOF
)"
```

### Step 12: Push to Remote

```bash
git push origin develop
```

### Step 13: Create Pull Request

Use the repo's PR template (`.github/pull_request_template.md`) for the body structure. The title must follow this format:

```
chore(release): Release v{new_version}
```

The body should fill in the template sections in `.github/pull_request_template.md`:

If a PR already exists from develop to master:
- Warn the user
- Ask if they want to update the existing PR description

### Step 14: Done

Output a summary:
```
✓ Release v{new_version} prepared successfully!

Version: {old_version} → {new_version}+{new_build}
PR: {pr_url}

Next steps:
1. Review the PR and verify all changes
2. Merge the PR to master
3. CI will automatically build and deploy to stores
```

## File Reference

### Files Modified Per Release

```
pubspec.yaml                                    # Version bump
lib/data/release_notes.dart                     # In-app What's New data + resolveKey()
lib/l10n/app_en.arb                            # English strings + @descriptions
lib/l10n/app_ar.arb                            # Arabic translations
lib/l10n/app_de.arb                            # German translations
lib/l10n/app_fr.arb                            # French translations
lib/l10n/app_id.arb                            # Indonesian translations
lib/l10n/app_ms.arb                            # Malay translations
lib/l10n/app_pt.arb                            # Portuguese (base)
lib/l10n/app_pt_BR.arb                         # Brazilian Portuguese
lib/l10n/app_pt_PT.arb                         # European Portuguese
lib/l10n/app_localizations*.dart               # Auto-generated by flutter gen-l10n
android/fastlane/metadata/android/*/changelogs/default.txt
ios/fastlane/metadata/*/release_notes.txt
```

### Locale Mapping Reference

| App (ARB) | Android Fastlane | iOS Fastlane |
|-----------|------------------|--------------|
| en        | en-US            | en-US        |
| ar        | ar               | ar-SA        |
| de        | de-DE            | de-DE        |
| fr        | fr-FR, fr-CA     | fr-FR, fr-CA |
| id        | (skip)           | (skip)       |
| ms        | (skip)           | (skip)       |
| pt        | pt-BR, pt-PT     | pt-BR, pt-PT |

Note: Indonesian (id) and Malay (ms) are app-only locales, not in store metadata.

## Error Handling

### Common Issues

1. **"No commits since last tag"**
   - Ask user if they want to proceed with a metadata-only release
   - Or abort and wait for more commits

2. **"flutter analyze failed"**
   - Show errors and attempt to fix
   - Usually: JSON syntax errors in ARB files, missing commas, duplicate keys

3. **"PR already exists"**
   - Offer to update the existing PR
   - Or warn and let user decide

4. **"Not on develop branch"**
   - Warn user and ask if they want to proceed anyway
   - Or switch to develop first

5. **"Uncommitted changes"**
   - Ask user to commit or stash first
   - Don't proceed with dirty working directory
