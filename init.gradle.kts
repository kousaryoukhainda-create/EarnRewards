// Gradle Init Script - Automatic Build Optimizations
// Place in: ~/.gradle/init.gradle.kts OR use with: gradle -I init.gradle.kts

// Apply to all builds
allprojects {
    repositories {
        mavenCentral()
        google()
    }
}

// Configure build cache
gradle.settingsEvaluated {
    gradle.buildCache {
        local {
            isEnabled = true
            directory = File(gradle.gradleUserHomeDir, "caches/build-cache")
        }
    }
}

// Performance optimizations
gradle.taskGraph.whenReady {
    println("Build optimization enabled")
}

// Force aapt2 to use non-daemon mode
gradle.taskGraph.whenReady {
    System.setProperty("android.builder.aapt2Daemon", "false")
}
