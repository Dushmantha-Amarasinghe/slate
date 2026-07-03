# Releasing Slate

Distribution is GitHub Releases only (see `.github/workflows/release.yml`
and README.md). This doc covers the one-time signing setup and the steps to
cut a new version.

## One-time setup

### 1. Generate the release keystore

Do this once, on a machine you trust, **not** in CI:

```sh
keytool -genkey -v -keystore slate-release.jks -keyalg RSA -keysize 2048 -validity 10000 \
  -alias slate \
  -dname "CN=Dushmantha Amarasinghe, OU=Core Team, O=Refora Technologies, L=Colombo, ST=Western, C=LK"
```

You'll be prompted for a keystore password and a key password — record both
in a password manager. **This keystore is the app's permanent signing
identity.** If it's lost, no future release can be installed as an update
over an existing install — every user would have to uninstall and reinstall.
Keep at least 2 secure backups outside this repo (e.g. a password manager's
file storage + an encrypted drive), and never commit `slate-release.jks` or
`android/key.properties` (both are gitignored already).

### 2. Add the GitHub Actions secrets

In the repo's Settings → Secrets and variables → Actions, add:

| Secret | Value |
|---|---|
| `RELEASE_KEYSTORE_BASE64` | `base64 -w0 slate-release.jks` (Windows: `certutil -encode slate-release.jks tmp.b64` then strip the header/footer lines) |
| `RELEASE_KEYSTORE_PASSWORD` | the keystore password from step 1 |
| `RELEASE_KEY_ALIAS` | `slate` (or whatever `-alias` you used) |
| `RELEASE_KEY_PASSWORD` | the key password from step 1 |

The release workflow decodes the keystore into `android/app/release.jks` and
writes `android/key.properties` at build time, then deletes both once the
build finishes (`if: always()` cleanup step) — neither ever gets committed.

### 3. Privacy policy

Published via GitHub Pages from `docs/privacy/index.html` — enable it once
under Settings → Pages → Deploy from a branch → `main` / `/docs`. Linked from
Settings → About in the app.

## Cutting a release

1. Bump the version in `pubspec.yaml` (`version: X.Y.Z+B`).
2. Commit that change.
3. Tag it and push the tag:
   ```sh
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
4. The `Release` workflow builds a signed `slate.apk` (same filename on
   every release, so `.../releases/latest/download/slate.apk` always works),
   runs `flutter analyze`/`flutter test` first, computes its SHA-256
   checksum, and publishes both as a GitHub Release with auto-generated
   notes from the commits since the last tag. Edit the release body
   afterward into short, user-facing language — it's shown directly in the
   app's "Update available" card.

## Verifying the end-to-end update flow

Before trusting a release, confirm on a real device: install an older
signed build → open Settings → Updates → "Check for updates" → confirm the
new version and notes appear → tap **Update Now** → confirm the download
progress bar, the install prompt, and the update installing successfully →
confirm the app still opens with existing data intact.
