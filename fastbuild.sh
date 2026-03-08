#!/bin/bash
# ⚡ EarnRewards - ULTRA FAST APK Builder ⚡
# Optimized for maximum build speed
# ==========================================

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Build type (debug/release)
BUILD_TYPE="${1:-debug}"

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   EarnRewards - Ultra Fast APK Builder    ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Function to print section
print_section() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check prerequisites
print_section "📋 Checking Prerequisites"

# Check Java
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | head -1)
    print_success "Java: $java_version"
else
    echo -e "${RED}✗ Java not found${NC}"
    exit 1
fi

# Check memory
MEM_AVAILABLE=$(free -m 2>/dev/null | awk '/^Mem:/{print $7}' || echo "4096")
print_success "Available Memory: ${MEM_AVAILABLE}MB"

# Check ANDROID_HOME
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    print_warning "ANDROID_HOME not set (Gradle will manage SDK)"
else
    print_success "Android SDK: ${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
fi

# Check disk space
DISK_SPACE=$(df -h . 2>/dev/null | awk 'NR==2{print $4}' || echo "Unknown")
print_success "Available Disk: $DISK_SPACE"

echo ""

# Clean build cache option
if [ "$2" == "--clean" ]; then
    print_section "🧹 Cleaning Build Cache"
    ./gradlew clean --no-daemon
    echo ""
fi

# Start build
print_section "🚀 Building $BUILD_TYPE APK"

START_TIME=$(date +%s)
START_TIME_MS=$(date +%s%3N 2>/dev/null || echo "0")

# Gradle command with all optimizations
GRADLE_CMD="./gradlew"
GRADLE_ARGS=""

# Add build type task
if [ "$BUILD_TYPE" == "release" ]; then
    GRADLE_ARGS="assembleRelease"
else
    GRADLE_ARGS="assembleDebug"
fi

# Performance flags
GRADLE_ARGS="$GRADLE_ARGS --no-daemon"
GRADLE_ARGS="$GRADLE_ARGS --parallel"
GRADLE_ARGS="$GRADLE_ARGS --max-workers=4"
GRADLE_ARGS="$GRADLE_ARGS --build-cache"
GRADLE_ARGS="$GRADLE_ARGS --configuration-cache"

# JVM args - optimized for systems with ~2GB RAM
export GRADLE_OPTS="-Xmx1536m -XX:MaxMetaspaceSize=512m -XX:+UseParallelGC -Dfile.encoding=UTF-8"

echo -e "${CYAN}Command: $GRADLE_CMD $GRADLE_ARGS${NC}"
echo -e "${CYAN}JVM Options: $GRADLE_OPTS${NC}"
echo ""

# Run build
$GRADLE_CMD $GRADLE_ARGS

BUILD_STATUS=$?

END_TIME=$(date +%s)
END_TIME_MS=$(date +%s%3N 2>/dev/null || echo "0")

# Calculate build time
if [ "$END_TIME_MS" != "0" ] && [ "$START_TIME_MS" != "0" ]; then
    BUILD_TIME_MS=$((END_TIME_MS - START_TIME_MS))
    BUILD_TIME_S=$((BUILD_TIME_MS / 1000))
    BUILD_TIME_MS_REM=$((BUILD_TIME_MS % 1000))
    BUILD_TIME_FORMAT="${BUILD_TIME_S}.${BUILD_TIME_MS_REM}s"
else
    BUILD_TIME=$((END_TIME - START_TIME))
    BUILD_TIME_FORMAT="${BUILD_TIME}s"
fi

echo ""
print_section "📊 Build Results"

if [ $BUILD_STATUS -eq 0 ]; then
    print_success "Build completed successfully!"
    echo -e "${GREEN}⏱ Build Time: ${BUILD_TIME_FORMAT}${NC}"
    
    # Find APKs
    echo ""
    echo -e "${BLUE}📦 Generated APKs:${NC}"
    
    if [ "$BUILD_TYPE" == "release" ]; then
        APK_PATH="app/build/outputs/apk/release/"
    else
        APK_PATH="app/build/outputs/apk/debug/"
    fi
    
    if [ -d "$APK_PATH" ]; then
        find "$APK_PATH" -name "*.apk" -type f 2>/dev/null | while read -r apk; do
            if [ -f "$apk" ]; then
                APK_SIZE=$(ls -lh "$apk" | awk '{print $5}')
                APK_NAME=$(basename "$apk")
                echo -e "  ${GREEN}✓${NC} $APK_NAME (${APK_SIZE})"
                echo -e "    ${CYAN}Path: $apk${NC}"
            fi
        done
    fi
    
    # Show build cache stats
    echo ""
    echo -e "${BLUE}📈 Build Cache:${NC}"
    if [ -d ".gradle/buildOutputCleanup" ]; then
        CACHE_SIZE=$(du -sh .gradle 2>/dev/null | cut -f1 || echo "Unknown")
        echo -e "  Cache Size: ${CYAN}$CACHE_SIZE${NC}"
    fi
    
else
    echo -e "${RED}✗ Build failed!${NC}"
    echo -e "${RED}Check the error messages above for details.${NC}"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}💡 Tips for even faster builds:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  • Keep Gradle daemon running (default)"
echo -e "  • Use configuration cache: ${YELLOW}--configuration-cache${NC}"
echo -e "  • Build in parallel: ${YELLOW}--parallel${NC}"
echo -e "  • Increase RAM: ${YELLOW}-Xmx4096m${NC}"
echo -e "  • Use SSD for faster I/O"
echo ""

exit $BUILD_STATUS
