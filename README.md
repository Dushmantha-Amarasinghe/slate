<p align="center">
  <img src="assets/branding/app_icon.png" width="96" alt="Slate icon" />
</p>

<h1 align="center">Slate</h1>

<p align="center">
  <strong>A premium, offline-first to-do app for Android.</strong><br />
  Monochrome design, one sparing accent color, nothing leaves your device.
</p>

<p align="center">
  <img src="https://img.shields.io/github/v/release/Dushmantha-Amarasinghe/slate?style=flat-square&labelColor=343b41&color=5bb8f5&label=release" alt="release" />
  <img src="https://img.shields.io/github/downloads/Dushmantha-Amarasinghe/slate/total?style=flat-square&labelColor=343b41&color=e8883a&label=downloads" alt="downloads" />
  <img src="https://img.shields.io/badge/platform-Android-3ddc84?style=flat-square&labelColor=343b41&logo=android&logoColor=white" alt="platform" />
  <a href="https://dushmantha-amarasinghe.github.io/slate/privacy/"><img src="https://img.shields.io/badge/privacy-policy-5bb8f5?style=flat-square&labelColor=343b41&logo=googlechrome&logoColor=white" alt="privacy policy" /></a>
</p>

<p align="center">
  <a href="https://github.com/Dushmantha-Amarasinghe/slate/releases/latest/download/slate.apk">
    <img src="https://img.shields.io/badge/Download%20for%20Android-000000?style=for-the-badge&logo=android&logoColor=white" alt="Download for Android" />
  </a>
</p>

---

## What it is

Slate is a to-do app built around one idea: a daily task list shouldn't compete for your attention. Monochrome UI, one accent color reserved for overdue tasks and reminders, and no account, no ads, no analytics — everything is stored on your device.

- **Today / All Tasks / Calendar / Stats** — a focused daily view, the full backlog, a due-date calendar, and a streak + completion-rate dashboard
- **Reminders that actually fire** — exact-time alarms that survive a reboot, with Done/Snooze actions right on the notification
- **Subtasks, tags, priorities, recurrence** — the structure a real task list needs, without turning into a project management tool
- **Voice notes** — record a quick note on any task, played back offline
- **Home screen widget** — today's top tasks and a quick-add button, with overdue tasks called out
- **Streak-unlocked accent colors** — a small reward for showing up daily
- **Export / import** — your data as a plain JSON file, yours to keep

## Install & updates

Slate is distributed via [GitHub Releases](../../releases) only — it isn't on the Play Store. Download the latest build below, allow "install unknown apps" for your browser when prompted, and install it.

<p align="center">
  <a href="https://github.com/Dushmantha-Amarasinghe/slate/releases/latest/download/slate.apk">the latest slate.apk</a>
  — this link always points at the newest release.
</p>

After that, the app checks for updates itself: on launch (at most once an hour) and via Settings → Updates → "Check for updates". When a newer release is found, an in-app card shows the version and release notes with an **Update Now** button, which downloads the APK with a live progress bar and hands off to the system installer — no need to come back to GitHub manually.

## Privacy

No account, no analytics, no ads, no server. Full details: [Privacy Policy](https://dushmantha-amarasinghe.github.io/slate/privacy/).

---

## Development

### Prerequisites

- Flutter (stable channel)
- Android Studio / an Android SDK for building & running

### Commands

```sh
flutter pub get    # install dependencies
flutter run         # run on a connected device/emulator
flutter analyze     # static analysis
flutter test        # unit + widget + migration tests
```

Regenerate Drift's generated code after touching anything under `lib/core/db/`:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

### Cutting a release

See [RELEASING.md](RELEASING.md) for the one-time signing setup and the steps to publish a new version.

---

## Stack

| | Technology |
|--|-----------|
| Framework | Flutter |
| State management | Riverpod |
| Local database | Drift (SQLite) |
| Navigation | go_router |
| Notifications | flutter_local_notifications + timezone |
| Voice notes | record + just_audio |
| Home screen widget | home_widget (native Android `AppWidgetProvider`) |
| Distribution | GitHub Releases + a built-in update checker |

---

<p align="center">
  Slate by <a href="https://github.com/Dushmantha-Amarasinghe">Refora Technologies</a>
</p>
