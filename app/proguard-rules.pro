# Optimized ProGuard Rules for EarnRewards
# These rules are optimized for faster shrinking and smaller APK

# ==========================================
# GENERAL SETTINGS
# ==========================================

# Enable aggressive optimization
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/removal/writer,!field/removal/value,!method/removal/*,!class/merging/*

# Allow access to private members
-allowaccessmodification

# Don't warn about missing classes
-dontwarn

# Keep signature information for reflection
-keepattributes Signature
-keepattributes *Annotation*

# Keep line number information for debugging
-keepattributes SourceFile,LineNumberTable

# ==========================================
# ADMOB SPECIFIC RULES
# ==========================================

# Keep AdMob classes
-keep class com.google.android.gms.ads.** { *; }
-keep interface com.google.android.gms.ads.** { *; }

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Firebase if used
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# ==========================================
# KOTLIN SPECIFIC RULES
# ==========================================

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembers class kotlinx.coroutines.** { volatile <fields>; }

# Keep Kotlin reflection
-keep class kotlin.reflect.** { *; }

# ==========================================
# ANDROIDX RULES
# ==========================================

# Keep AndroidX classes
-keep class androidx.** { *; }
-dontwarn androidx.**

# Keep Material Design components
-keep class com.google.android.material.** { *; }
-dontwarn com.google.android.material.**

# Keep Lifecycle components
-keep class androidx.lifecycle.** { *; }

# Keep ViewBinding
-keepclassmembers class * extends androidx.viewbinding.ViewBinding { *; }

# ==========================================
# APP SPECIFIC RULES
# ==========================================

# Keep your model classes (if any)
-keep class com.ykapps.earnrewards.model.** { *; }

# Keep MainActivity
-keep class com.ykapps.earnrewards.MainActivity { *; }

# Keep all classes in your package
-keep class com.ykapps.earnrewards.** { *; }

# ==========================================
# JSON / SERIALIZATION
# ==========================================

# Keep generic signature of Call, Response (Retrofit, OkHttp)
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

# Keep JSON annotations
-keepattributes EnclosingMethod, InnerClasses

# ==========================================
# OPTIMIZATION CLASSES
# ==========================================

# Remove logging in release builds (smaller APK)
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# ==========================================
# NATIVE METHODS
# ==========================================

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom Views
-keepclasseswithmembers class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Keep Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final ** serialVersionUID;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
