# Earn Rewards App with AdMob Integration

A complete Android application that displays Bitcoin prices with integrated Google AdMob ads for monetization.

## Features

- **Real-time Bitcoin Price Display** - Shows current Bitcoin price with price change percentage
- **Banner Ads** - Persistent banner ad at the bottom of the screen
- **Interstitial Ads** - Full-screen ads shown on user action
- **Rewarded Ads** - Users can watch ads to unlock premium features
- **Material Design UI** - Modern, clean interface with Bitcoin-themed colors

## Ad Types Implemented

### 1. Banner Ad
- Displayed at the bottom of the screen
- Always visible while using the app
- Generates consistent passive income

### 2. Interstitial Ad
- Full-screen ad shown when user clicks "Refresh" or "Show Interstitial Ad"
- Higher revenue per impression
- Best shown at natural breaks in user flow

### 3. Rewarded Ad
- Users voluntarily watch ads to unlock premium features
- Highest revenue per view
- Best user experience (opt-in)

## Setup Instructions

### Prerequisites
- Android Studio Arctic Fox or newer
- JDK 17
- Android SDK 34

### Step 1: Create AdMob Account
1. Go to [AdMob](https://admob.google.com/)
2. Sign in with your Google account
3. Create a new app (Android)
4. Get your **AdMob App ID**

### Step 2: Create Ad Units
In AdMob dashboard, create these ad units:
1. **Banner Ad Unit** - For banner ads
2. **Interstitial Ad Unit** - For full-screen ads
3. **Rewarded Ad Unit** - For rewarded video ads

### Step 3: Update Ad IDs
Replace the test ad IDs in `app/src/main/res/values/strings.xml`:

```xml
<string name="banner_ad_unit_id">YOUR_BANNER_AD_UNIT_ID</string>
<string name="interstitial_ad_unit_id">YOUR_INTERSTITIAL_AD_UNIT_ID</string>
<string name="rewarded_ad_unit_id">YOUR_REWARDED_AD_UNIT_ID</string>
```

Also update the App ID in `AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="YOUR_ADMOB_APP_ID"/>
```

### Step 4: Build and Run
```bash
# Navigate to project directory
cd EarnRewards

# Build debug APK
./gradlew assembleDebug

# Or open in Android Studio and run
```

## Project Structure

```
EarnRewards/
├── app/
│   ├── src/main/
│   │   ├── java/com/ykapps/earnrewards/
│   │   │   └── MainActivity.kt          # Main activity with ad logic
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   └── activity_main.xml    # UI layout
│   │   │   ├── values/
│   │   │   │   ├── strings.xml          # Ad unit IDs & strings
│   │   │   │   ├── colors.xml           # App colors
│   │   │   │   └── themes.xml           # App theme
│   │   │   └── drawable/                # Icons
│   │   └── AndroidManifest.xml          # App manifest
│   └── build.gradle.kts                 # App-level build config
├── build.gradle.kts                     # Project-level build config
├── settings.gradle.kts                  # Project settings
└── gradle.properties                    # Gradle properties
```

## Monetization Tips

1. **Banner Ads**: Best for consistent, passive income. Place where they're always visible but don't interfere with UX.

2. **Interstitial Ads**: Show at natural breaks (level complete, content refresh). Don't show too frequently.

3. **Rewarded Ads**: Highest engagement. Offer meaningful rewards (premium features, extra content, etc.).

4. **Best Practices**:
   - Don't place ads too close to clickable elements
   - Follow AdMob policies to avoid account suspension
   - Test with test ad IDs before publishing
   - Monitor ad performance in AdMob dashboard

## Testing

The app currently uses **test ad IDs** provided by Google. These will show test ads and won't generate revenue.

Test Ad IDs included:
- Banner: `ca-app-pub-3940256099942544/6300978111`
- Interstitial: `ca-app-pub-3940256099942544/1033173712`
- Rewarded: `ca-app-pub-3940256099942544/5224354917`

## Publishing to Play Store

1. Create a signed release APK or App Bundle
2. Create a developer account on [Google Play Console](https://play.google.com/console)
3. Upload your app
4. Complete the store listing
5. Submit for review

## Important Notes

⚠️ **Before Publishing**:
- Replace test ad IDs with your real AdMob IDs
- Ensure compliance with AdMob policies
- Add a privacy policy (required for AdMob)
- Test thoroughly on real devices

## License

This project is provided as-is for educational purposes.

## Support

For AdMob support, visit [AdMob Help Center](https://support.google.com/admob)
