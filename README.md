# Trill Eraser

Offline, on-device photo object remover packaged as an Android APK project.

## What it is

A native Android app (Kotlin + `WebView`) that bundles the Trill Eraser HTML/JS/CSS
photo editor as a local asset (`app/src/main/assets/index.html`). It runs **100%
offline** — nothing is uploaded, no network permission is requested, and images
are processed entirely on the device.

## Features

- **Detect** — tap to isolate an object by colour similarity (flood-fill + contour trace)
- **Brush** — paint over custom removal areas, adjustable size
- **Lasso** — draw a freehand loop around what to remove
- **Clear / Undo / Redo** — undo history with branching snapshots
- **Pinch-to-zoom & pan** — fine detail work
- **Before/After compare slider** — drag to compare
- **Save** — export the result as PNG
- **Edge-aware inpainting** — Sobel semantic edge detection keeps hard lines sharp
  and blends soft edges (hair, foliage, smoke) naturally; exemplar texture
  synthesis copies real background detail instead of blurring

## Project structure

```
app/src/main/
  AndroidManifest.xml       # no internet permissions
  assets/index.html         # bundled photo editor (offline)
  java/com/trilleraser/app/MainActivity.kt   # WebView host + file picker
  res/layout/activity_main.xml
  res/drawable/ic_launcher.xml
  res/values/{strings,themes}.xml
build.gradle, settings.gradle, gradle.properties
gradlew / gradlew.bat
```

## Build the APK

This repo contains the Gradle project source, **not** a pre-built APK (no Android
SDK / Java toolchain is available in this checkout). Build it with Android Studio
or the Gradle wrapper on a machine with SDK 34 + JDK installed:

```bash
# debug APK -> app/build/outputs/apk/debug/app-debug.apk
./gradlew assembleDebug

# release APK (sign it yourself for Play Store distribution)
./gradlew assembleRelease
```

`gradlew`/`gradlew.bat` are thin wrapper starters; ensure `gradle` is on your
`PATH` or set `GRADLE_HOME` (Android Studio will generate the official wrapper
on first sync).

## Minimum SDK

- `minSdk 24` (Android 7.0)
- `targetSdk 34` (Android 14)

## External reference / attribution

Ideas for edge-aware, context-aware inpainting were ported (re-implemented
client-side, offline) from:

> **magic-eraser-studio / PhotoWeaver** — https://github.com/onlyoneshakibul/magic-eraser-studio  
> License: MIT

See `REFERENCE.md` for details on what was and was not integrated, and why the
cloud/server-side parts of that project were deliberately excluded.

## License

Trill Eraser wrapper code is provided as-is. The bundled editor UI is the
original Trill Eraser work. Ported inpainting concepts follow the MIT license of
the reference repository above.
