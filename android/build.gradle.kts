allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// file_picker's own build.gradle conditionally applies the Kotlin Android
// plugin only when AGP < 9 (relying on Flutter's "built-in Kotlin" for AGP
// 9+ instead). Flutter's built-in-Kotlin detection statically text-scans
// each plugin's build.gradle for an `apply plugin: 'org.jetbrains.kotlin
// .android'` line to decide whether to auto-apply Kotlin for it — since
// that line is present in file_picker's file (just gated behind the AGP9
// check it doesn't evaluate), Flutter wrongly assumes Kotlin is already
// handled and skips its fallback, so on AGP 9 nothing ever applies Kotlin
// to that module and its .kt sources silently fail to compile. `beforeProject`
// runs before a project's own build script, so this reliably wins the race.
gradle.beforeProject {
    if (name == "file_picker") {
        pluginManager.apply("org.jetbrains.kotlin.android")
    }
}

// Forcing that plugin application above also skips the jvmTarget = 17 the
// same AGP9-gated block would otherwise have set, so Kotlin falls back to
// whatever JDK is running Gradle (21 here) while javac stays pinned to 17
// (file_picker's compileOptions block, unconditional) — an "inconsistent
// JVM target" build failure. Pin file_picker's Kotlin compile output to 17
// to match, via dynamic Groovy-style access so this doesn't need a static
// Kotlin Gradle Plugin import on this script's classpath. Scoped to just
// this module — other plugins (e.g. home_widget) already keep their own
// java/kotlin targets consistent with each other and don't need this.
subprojects {
    if (name == "file_picker") {
        tasks.matching { it.name.startsWith("compile") && it.name.endsWith("Kotlin") }.configureEach {
            withGroovyBuilder {
                getProperty("kotlinOptions").withGroovyBuilder {
                    setProperty("jvmTarget", "17")
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
