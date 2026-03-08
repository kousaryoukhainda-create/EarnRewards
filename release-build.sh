#!/bin/bash
# 🚀 EarnRewards - Release Build (Optimized)
# Creates a signed, optimized release APK

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "🚀 Building Release APK..."
echo ""

# Check for keystore
KEYSTORE_FILE="${1:-}"

if [ -z "$KEYSTORE_FILE" ]; then
    echo "⚠ No keystore specified. Building unsigned release APK."
    echo "  Usage: ./release-build.sh /path/to/keystore.jks"
    echo ""
    
    ./gradlew assembleRelease \
        --no-daemon \
        --parallel \
        --build-cache \
        --configuration-cache
    
    echo ""
    echo "✓ Release APK built (unsigned)"
    echo "  Location: app/build/outputs/apk/release/"
else
    echo "🔐 Building with keystore: $KEYSTORE_FILE"
    
    if [ ! -f "$KEYSTORE_FILE" ]; then
        echo "✗ Keystore not found: $KEYSTORE_FILE"
        exit 1
    fi
    
    # Prompt for keystore password
    read -sp "Enter keystore password: " KEYSTORE_PASS
    echo ""
    read -sp "Enter key alias: " KEY_ALIAS
    echo ""
    read -sp "Enter key password: " KEY_PASS
    echo ""
    
    ./gradlew assembleRelease \
        -Pandroid.injected.signing.store.file="$KEYSTORE_FILE" \
        -Pandroid.injected.signing.store.password="$KEYSTORE_PASS" \
        -Pandroid.injected.signing.key.alias="$KEY_ALIAS" \
        -Pandroid.injected.signing.key.password="$KEY_PASS" \
        --no-daemon \
        --parallel \
        --build-cache \
        --configuration-cache
    
    echo ""
    echo "✓ Signed Release APK built"
    echo "  Location: app/build/outputs/apk/release/"
fi
