#!/usr/bin/env bash

set -u
set -o pipefail

PROJECT_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
EXPECTED_APK_REL="app/build/outputs/apk/debug/app-debug.apk"
LOG_DIR="/tmp/acs-build"
LOG_FILE="$LOG_DIR/assemble-debug.log"

is_valid_sdk() {
    [ -n "${1:-}" ] && [ -d "$1" ] && { [ -f "$1/source.properties" ] || [ -d "$1/platforms" ] || [ -d "$1/build-tools" ]; }
}

find_sdk() {
    for candidate in \
        "${ANDROID_SDK_ROOT:-}" \
        "${ANDROID_HOME:-}" \
        "$HOME/Android/Sdk" \
        "$HOME/android-sdk" \
        "$HOME/.android/sdk" \
        "/data/data/com.itsaky.androidide/files/usr/lib/android-sdk" \
        "/data/data/com.itsaky.androidide/files/home/android-sdk" \
        "/data/data/com.itsaky.androidide/files/home/.android/sdk" \
        "/data/user/0/com.itsaky.androidide/files/usr/lib/android-sdk" \
        "/data/user/0/com.itsaky.androidide/files/home/android-sdk" \
        "/data/user/0/com.itsaky.androidide/files/home/.android/sdk"
    do
        if is_valid_sdk "$candidate"; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

if [ "$PWD" != "$PROJECT_ROOT" ] || [ ! -f "$PROJECT_ROOT/settings.gradle" ] || [ ! -f "$PROJECT_ROOT/build.gradle" ] || [ ! -f "$PROJECT_ROOT/gradlew" ]; then
    echo "ERROR: Run this script from the project root: $PROJECT_ROOT"
    exit 1
fi

chmod +x "$PROJECT_ROOT/gradlew"

SDK_PATH="$(find_sdk || true)"
if [ -n "$SDK_PATH" ]; then
    printf 'sdk.dir=%s\n' "$SDK_PATH" > "$PROJECT_ROOT/local.properties"
    echo "Using Android SDK: $SDK_PATH"
elif [ ! -f "$PROJECT_ROOT/local.properties" ]; then
    echo "ERROR: Android SDK not found."
    echo "Set ANDROID_SDK_ROOT or ANDROID_HOME, or install the SDK in ACS before building."
    exit 1
else
    echo "Android SDK not auto-detected; using existing local.properties"
fi

mkdir -p "$LOG_DIR"

echo "Stopping Gradle daemons..."
"$PROJECT_ROOT/gradlew" --stop >/dev/null 2>&1 || true

echo "Building debug APK..."
if "$PROJECT_ROOT/gradlew" :app:assembleDebug --no-daemon --stacktrace 2>&1 | tee "$LOG_FILE"; then
    echo
    echo "Debug APK:"
    echo "$PROJECT_ROOT/$EXPECTED_APK_REL"
    exit 0
fi

echo
echo "Build failed. Last Gradle output:"
tail -n 120 "$LOG_FILE" || true
echo
echo "Expected debug APK path:"
echo "$PROJECT_ROOT/$EXPECTED_APK_REL"
echo "Full build log: $LOG_FILE"
exit 1
