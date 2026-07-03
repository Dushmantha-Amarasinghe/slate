# Slate

A premium, offline-first to-do app by Refora Technologies. Monochrome design
with one sparing accent color, built with Flutter + Riverpod + Drift.

## Install & updates

Slate is distributed via [GitHub Releases](../../releases) only — it is not
on the Play Store. Download
[the latest slate.apk](../../releases/latest/download/slate.apk) — this link
always points at the newest release — allow "install unknown apps" for your
browser/file manager when prompted, and install it.

After that, the app checks for updates itself: on launch (at most once an
hour) and via Settings → Updates → "Check for updates". When a newer release
is found, an in-app card shows the version and release notes with an
**Update Now** button, which downloads the APK and hands off to the system
installer — no need to come back to GitHub manually.

## Development

```sh
flutter pub get
flutter run
```

Regenerate Drift's generated code after touching anything under
`lib/core/db/`:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

Run the full check before committing:

```sh
flutter analyze
flutter test
```

## Cutting a release

See [RELEASING.md](RELEASING.md) for the one-time signing setup and the
steps to publish a new version.
