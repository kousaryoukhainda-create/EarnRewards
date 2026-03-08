plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.ykapps.earnrewards"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.ykapps.earnrewards"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // Enable vector drawable support for faster rendering
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        debug {
            // Speed up debug builds
            isMinifyEnabled = false
            isDebuggable = true
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Enable incremental compilation for release
            isPseudoLocalesEnabled = false
        }
    }

    // Set custom APK file name with build type and timestamp
    applicationVariants.all {
        val variant = this
        outputs.all {
            val output = this as? com.android.build.gradle.internal.api.BaseVariantOutputImpl
            output?.outputFileName = "EarnRewards-${variant.buildType.name}-${variant.versionName}.apk"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        // Optimize for speed
        freeCompilerArgs += listOf(
            "-Xskip-runtime-version-check",
            "-Xno-call-assertions",
            "-Xno-param-assertions"
        )
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
        aidl = false
        renderScript = false
        resValues = false
        shaders = false
        compose = false
    }

    packaging {
        resources {
            // Exclude unnecessary resources to reduce APK size and build time
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "/META-INF/DEPENDENCIES"
            excludes += "/META-INF/LICENSE"
            excludes += "/META-INF/LICENSE.txt"
            excludes += "/META-INF/NOTICE"
            excludes += "/META-INF/NOTICE.txt"
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    
    // AdMob SDK
    implementation("com.google.android.gms:play-services-ads:22.6.0")
    
    // Lifecycle components
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    
    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
