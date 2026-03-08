// Build performance configuration
// Apply this to profile and optimize build times

// Enable build profiling
// Run: ./gradlew assembleDebug --profile
// Report will be in: build/reports/profile/

// For continuous optimization monitoring, add to CI:
// ./gradlew assembleDebug --build-scan

// Performance tips:
// 1. Use --configuration-cache for 20-30% faster builds after first run
// 2. Use --parallel for multi-project builds
// 3. Keep Gradle daemon running (default in gradle.properties)
// 4. Use build cache: ./gradlew assembleDebug --build-cache
