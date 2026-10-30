# External reference — magic-eraser-studio / PhotoWeaver

**Source:** https://github.com/onlyoneshakibul/magic-eraser-studio  
**License:** MIT  
**Project title in source repo:** PhotoWeaver 🎨 ("AI Object Remover 2026")

## What was taken from it

The linked repository is primarily a marketing / landing page for a cloud-based
object-removal service. Its `index.html` is obfuscated / encoded and is **not**
integrable source code, and its processing is server-side (requires a backend
and network), which contradicts Trill Eraser's core promise of running fully
offline on-device with nothing uploaded.

What *was* integrated (re-implemented cleanly, client-side, offline, no network):

| Idea from README | How it appears in Trill Eraser |
|---|---|
| **Semantic edge detection** — preserve hard edges (buildings, cars), blend soft edges (hair, foliage, smoke) | Sobel edge map computed on the original image; during exemplar texture synthesis, hole pixels near strong edges borrow from patches whose edge orientation aligns, keeping lines sharp; soft edges fall back to colour-matched feathered blending |
| **Exemplar / context-aware inpainting** — generate replacement pixels from surrounding context rather than blur | Multi-scale Laplacian diffusion for structure, followed by 5×5 patch-match texture synthesis that copies real background detail (grass, sand, water, fabric) from the best-matching known neighbourhood |
| **Adaptive resolution preservation** — full native resolution, tiled processing for large images | Image is processed at native resolution (capped at 1200px for memory); diffusion operates across scales; texture synthesis searches a local neighbourhood so detail is preserved locally |

## What was NOT integrated (and why)

- **Cloud / server-side processing** — Trill Eraser runs 100% offline in a WebView; no backend, no uploads, no network permission.
- **Batch processing (server queue)** — not applicable to a local-only app.
- **The obfuscated `index.html`** — not real source code; not copied.
- **40MP / tiled multi-megapixel processing** — memory-bound on device; kept to the 1200px cap used by the original Trill Eraser.

## Attribution

Trill Eraser is an independent re-implementation inspired by the feature
descriptions in magic-eraser-studio's README. Ported concepts are re-written
from scratch; no source code from that repository was copied. The original
Trill Eraser UI, detection flood-fill, contour tracing, and diffusion core
remain as authored.

```
MIT License (source repo: onlyoneshakibul/magic-eraser-studio)
```
