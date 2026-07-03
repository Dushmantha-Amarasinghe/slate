import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (spec section 8): reads android/key.properties, which is
// never committed (see .gitignore) — CI writes it from encrypted secrets
// just before the build (see .github/workflows/release.yml). Falls back to
// the debug signing config when the file doesn't exist, so `flutter run
// --release` and the plain CI job (which doesn't build a release APK) keep
// working on a machine that was never given the real release keystore.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.reforatech.slate"
    // flutter.compileSdkVersion (34) is behind what file_picker's transitive
    // flutter_plugin_android_lifecycle dependency requires (36) — pinned
    // explicitly rather than relying on the Flutter tool's default.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications (uses java.time APIs on
        // API levels below 26 via desugaring).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.reforatech.slate"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                // `storeFile` in key.properties is a path relative to this
                // file's directory (android/app/) — e.g. `release.jks` if
                // the keystore sits right next to build.gradle.kts.
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                // No release keystore on this machine — sign with the debug
                // key so local `flutter run --release` still works. This
                // build is NOT installable over a real release build and
                // must never be what's attached to a GitHub Release.
                signingConfigs.getByName("debug")
            }
            // Explicitly off, not just "not set" — Flutter's default release
            // config otherwise enables R8 resource shrinking, which renames
            // resource files (res/ic_notification.png -> res/0N.png, etc.).
            // flutter_local_notifications looks up its icon by resource NAME
            // STRING at runtime (Resources.getIdentifier), not a compile-time
            // R.mipmap reference, so shrinking silently broke it — the app
            // crashed on first launch with "resource could not be found"
            // before ever reaching the first frame, only on a real signed
            // release build (never seen on debug/the emulator). This app is
            // sideloaded via GitHub Releases, not the Play Store, so the APK
            // size savings from shrinking aren't worth reintroducing that
            // whole class of "silently breaks a runtime string lookup" bug.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
