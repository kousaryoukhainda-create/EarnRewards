#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "=== Fixing aapt2 binaries ==="

# Wait for gradle to download aapt2, then replace with system version
fix_aapt2() {
    find /root/.gradle/caches/transforms-* -name "aapt2" -type f 2>/dev/null | while read -r f; do
        if [ -f "$f" ]; then
            mv "$f" "$f.broken" 2>/dev/null || true
            cp /usr/bin/aapt2 "$f" 2>/dev/null || true
            chmod +x "$f" 2>/dev/null || true
            echo "Fixed: $f"
        fi
    done
}

# Clean and start build in background to download aapt2
echo "Starting gradle build..."

# Run build and fix aapt2 periodically
./gradlew assembleDebug --no-daemon 2>&1 &
BUILD_PID=$!

# Fix aapt2 every 10 seconds while build is running
while kill -0 $BUILD_PID 2>/dev/null; do
    sleep 5
    fix_aapt2
done

wait $BUILD_PID
exit $?
