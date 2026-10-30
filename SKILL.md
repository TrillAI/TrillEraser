---
name: trill-eraser-offline-webview
description: Build and maintain Trill Eraser — an offline, on-device photo object remover packaged as an Android WebView app. Covers WebView security, permissionless image selection, ANR-safe main-thread inpainting, and edge-aware texture synthesis.
license: MIT
metadata:
  author: TrillAI
  last-updated: '2026-10-30'
  keywords:
  - Android
  - WebView
  - Offline
  - Inpainting
  - Security
  - ANR
  - Photo Picker
---

## Overview

Trill Eraser is a native Android app (Kotlin + `WebView`) that bundles a
photo object-removal editor as a local asset (`app/src/main/assets/index.html`).
It runs **100% offline** — no network permission, no remote URLs, no uploads.

## 1. WebView security (android/skills/security)

### Permissions — least privilege

`AndroidManifest.xml` declares **zero permissions**. Image selection uses the
zero-permission Photo Picker
(`ActivityResultContracts.OpenDocument` / `ACTION_OPEN_DOCUMENT` with
`CATEGORY_OPENABLE`), per `android-permissions-security`. No
`READ_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`, or `CAMERA` permission is needed.

### WebView configuration

`MainActivity.kt` enables JavaScript and file access **solely** so the bundled
editor can read canvas pixel data and save results locally:

- `javaScriptEnabled = true` — required by the editor UI
- `domStorageEnabled = true` — editor state persistence
- `allowFileAccessFromFileURLs` / `universalAccessFromFileURLs` — canvas
  pixel readback from local assets
- **No** `cleartextTraffic` to remote hosts; `usesCleartextTraffic="true"` is
  set only because the manifest declares it for local asset loading, no actual
  network is used

All loaded content is `file:///android_asset/index.html`. External links (if
any) open in the system browser via `Intent.ACTION_VIEW`.

### Intent security

- `MainActivity` is `android:exported="true"` with the `MAIN`/`LAUNCHER`
  filter — correct for the app entry point
- File picker uses an **implicit** system intent (`ACTION_OPEN_DOCUMENT`) —
  the recommended zero-permission pattern
- External links use `Intent.ACTION_VIEW` with `FLAG_ACTIVITY_NEW_TASK` — no
  intent redirection risk; the target is resolved by the system
- No `PendingIntent`, no exported services/receivers/providers, no custom
  permissions

## 2. ANR prevention (android/skills/performance/anr-audit-and-fix)

WebView JavaScript executes on the Android main thread. The `inpaint()`
function performs computationally expensive image processing (multi-scale
diffusion + 5×5 patch-match texture synthesis) that could block the main thread
and trigger an Application Not Responding on large masks.

**Mitigation — time-based yielding:**

- `maybeYield()` checks `performance.now()` and yields via `await raf()` when
  30ms have elapsed since the last yield
- Yield points are inserted in the 48-iteration diffusion loop (every 8
  iterations or when time budget expires), the 10-iteration refinement loop,
  and the texture-synthesis loop (every 64 pixels)
- This keeps the UI responsive and prevents ANRs on large removal areas

## 3. Edge-aware inpainting (edge detection + exemplar texture synthesis)

The `inpaint()` function reconstructs removed regions using:

1. **Multi-scale Laplacian pyramid + diffusion** — reconstructs coarse
   background structure across scales
2. **Sobel semantic edge detection** — computes an edge map of the original
   image before inpainting; hard edges (buildings, cars, furniture) are carried
   across the mask boundary with orientation alignment; soft edges (hair,
   foliage, smoke) use feathered colour matching
3. **Exemplar texture synthesis** — every hole pixel borrows texture from the
   best-matching known neighbourhood patch (5×5 patch-match, weighted by colour
   similarity and edge-orientation alignment), preserving real background
   detail (grass, sand, water, fabric) instead of blurring
4. **Colour correction** — fill colour is shifted to match the mean of the
   mask's border ring for seamless blending

Ideas ported (re-implemented client-side, offline) from
magic-eraser-studio/PhotoWeaver (MIT). No source code copied; cloud/server-side
parts deliberately excluded.

## 4. System bars / insets

The editor UI uses CSS `env(safe-area-inset-bottom)` for system bar padding
and `100vh` height. `windowSoftInputMode="adjustResize"` is set in the manifest
for keyboard handling. The app is edge-to-edge aware via CSS safe-area
variables rather than Jetpack Compose insets (WebView-based UI).

## 5. Build

Requires Android SDK 34 + JDK:

```bash
./gradlew assembleDebug   # -> app/build/outputs/apk/debug/app-debug.apk
./gradlew assembleRelease # sign for Play Store distribution
```

- `minSdk 24`, `targetSdk 34`
- No network permissions
- `hardwareAccelerated="true"` for WebView rendering
