#!/bin/sh
# Gradle wrapper thin starter.
# Requires a Gradle installation (from Android Studio or `brew install gradle` etc.).
# Set GRADLE_HOME or ensure `gradle` is on your PATH.

APP_HOME=$(cd "$(dirname "$0")" && pwd) || exit 1

# Locate a java executable
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/bin/java" ]; then
        JAVACMD="$JAVA_HOME/bin/java"
    else
        echo "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME" >&2
        exit 1
    fi
else
    JAVACMD=java
    command -v java >/dev/null 2>&1 || {
        echo "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH." >&2
        exit 1
    }
fi

# Locate the gradle executable
if [ -n "$GRADLE_HOME" ] ; then
    if [ -x "$GRADLE_HOME/bin/gradle" ]; then
        GRADLECMD="$GRADLE_HOME/bin/gradle"
    else
        echo "ERROR: GRADLE_HOME is set to an invalid directory: $GRADLE_HOME" >&2
        exit 1
    fi
else
    GRADLECMD=gradle
    command -v gradle >/dev/null 2>&1 || {
        echo "ERROR: Gradle not found. Install Gradle (or Android Studio) and add it to PATH, or set GRADLE_HOME." >&2
        exit 1
    }
fi

exec "$GRADLECMD" --project-dir "$APP_HOME" "$@"
