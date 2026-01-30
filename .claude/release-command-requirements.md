# Release Command Requirements

Requirements for a `/release` slash command to automate the SimplyQibla release pipeline.

## Overview

The command should handle everything up to the final manual review in Play Console and App Store Connect.

---

## Tasks the Command Should Perform

### 1. Version Bump
- Prompt for release type: `patch`, `minor`, or `major`
- Update `pubspec.yaml` version string (e.g., `3.0.4+35` → `3.0.5+36`)
- Increment both version name AND build number

### 2. Generate Release Notes (All Locales)
- Prompt user for a summary of changes (in English)
- Generate release notes for all 7 supported locales:
  - `en-US` (English)
  - `ar` (Arabic)
  - `de-DE` (German)
  - `fr-FR` (French)
  - `id` (Indonesian)
  - `ms` (Malay)
  - `pt-BR` (Portuguese)

**Files to update:**
- Android: `android/fastlane/metadata/android/{locale}/changelogs/default.txt`
- iOS: `ios/fastlane/metadata/{locale}/release_notes.txt`

**Constraints:**
- Android changelog: Max 500 characters
- iOS release notes: Max 4000 characters
- Translations should be natural, not robotic

### 3. Create Pull Request
- Ensure on `develop` branch (or create feature branch)
- Commit all changes with message: `release: v{version}`
- Push branch to remote
- Create PR from current branch → `master`

**PR should follow template:** `.github/pull_request_template.md`

Fill in the sections:
- **What?** → Release v{version} to production
- **How?** → Bumped version, updated release notes for all locales
- **Why?** → {user-provided description of changes}

### 4. Pre-flight Checks
Before creating PR, verify:
- [ ] All tests pass (`flutter test`)
- [ ] No analyzer issues (`flutter analyze`)
- [ ] Version is higher than current master
- [ ] Release notes exist for all locales
- [ ] Release notes are within character limits

---

## Locale Mapping Reference

| Language | Android Locale | iOS Locale |
|----------|---------------|------------|
| English | `en-US` | `en-US` |
| Arabic | `ar` | `ar-SA` |
| German | `de-DE` | `de-DE` |
| French | `fr-FR` | `fr-FR` |
| Indonesian | `id` | `id` |
| Malay | `ms` | `ms` |
| Portuguese | `pt-BR` | `pt-BR` |

---

## What Happens After PR Merge

(Automated by CI - no action needed from command)

1. GitHub Actions triggers on merge to `master`
2. Android AAB built and uploaded to Play Store as **draft**
3. Android metadata uploaded automatically
4. iOS metadata uploaded automatically
5. GitHub Release created with tag `v{version}`
6. Xcode Cloud builds and uploads iOS binary separately

---

## Manual Steps (Not Automated)

These require human review and cannot be automated:

1. **Play Console**: Review draft release → Roll out to production
2. **App Store Connect**: Review build → Submit for review
3. **Post-release**: Monitor for crashes/issues

---

## Future Enhancements

- [ ] Changelog generation from git commits since last release
- [ ] Screenshot automation if UI changes
- [ ] Slack/Discord notification on PR creation
- [ ] Dry-run mode to preview changes without committing
