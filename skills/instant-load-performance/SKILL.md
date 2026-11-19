---
name: instant-load-performance
description: Make heavy 3D/WebGL sites open almost instantly and stay at 60 fps — first-paint loader, critical path, shader compile scheduling, texture tiers (WebP, 4K desktop / 1–2K phone), off-thread decode and staggered GPU uploads, caching headers (Vercel), frame budgets and dynamic resolution, and how to measure all of it. Use always when shipping a 3D site, and whenever someone says "slow", "laggy", "takes long to open", "heavy", or "make it load in microseconds".
---

# Instant load & frame budget

"Microseconds" isn't physically possible for a 3D site; the achievable goal is:
**first paint < 100 ms (loader), hero interactive < 1.5 s desktop / < 2.5 s on 4G phones, 60 fps after.**

## 1. Budgets (check them, don't guess)

| | Desktop | Phone |
|---|---|---|
| Blocking bytes before the loader paints | ~6 KB (HTML + inline CSS) | same |
| Bytes before hero reveal | ≤ 1.5 MB | ≤ 400 KB |
| Total textures (lazy) | ≤ 6 MB | ≤ 1.3 MB |
| GPU frame time at chosen scale | ≤ 16 ms | ≤ 16 ms |
| Shader link time (first scene) | ≤ 1 s | ≤ 1.5 s |

## 2. Critical path

1. `index.html` contains the loader markup + **inline critical CSS** + `@font-face` for 2 fonts.
2. `<link rel=modulepreload>` for the JS modules; `<link rel=preload as=font crossorigin>` for 2 WOFF2s.
3. JS creates the WebGL context and starts **all** shader compiles at once
   (`KHR_parallel_shader_compile`), awaits only the hero's programs.
4. Hero-critical textures first (sky panorama, then whatever the hero shows); everything else
   streams in priority order while the user reads the hero.
5. Warm-up frames behind the loader → reveal.

## 3. Shaders

- `uZero` loop trick (see engine skill) — the single biggest win on Windows.
- Split programs: hero program small; later scenes in a separate, lazily awaited program.
- Prime each heavy program with one hidden draw during idle time (`requestIdleCallback`).

## 4. Textures

- Two sets: `textures/hd` (4K max, WebP q82–95) and `textures/m` (1–2K, WebP q72–92). Pick by profile.
  Keep star panoramas at high quality — lossy encoders erase faint stars (compare bright-star counts).
- Downscale anything never seen large (moons, distant planets) — 2K is plenty.
- Greyscale data (clouds) as single-channel source → much smaller.
- `fetch → blob → createImageBitmap({premultiplyAlpha:'none', colorSpaceConversion:'none'})` off-thread,
  then **one `texImage2D` per frame** from a queue + `generateMipmap`. No upload hitch.
- Respect `MAX_TEXTURE_SIZE` (resize the bitmap if needed).

## 5. Caching & hosting (Vercel/Netlify/static)

```json
{ "headers": [
  { "source": "/textures/(.*)", "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }] },
  { "source": "/fonts/(.*)",    "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }] },
  { "source": "/js/(.*)",       "headers": [{ "key": "Cache-Control", "value": "public, max-age=0, must-revalidate" }] },
  { "source": "/css/(.*)",      "headers": [{ "key": "Cache-Control", "value": "public, max-age=0, must-revalidate" }] }
]}
```
Validate it as JSON before committing (a stray `\.` breaks Vercel deploys). No build step needed:
Vercel → Framework "Other", output = repo root.

## 6. Runtime

- Dynamic resolution (engine skill) — the only reliable way to hold 60 fps across GPUs.
- Skip rendering when the tab is hidden; stop the GPU when a scene is fully faded out.
- Measure, per journey beat: `render(); gl.finish(); t0; render×4; readPixels(1px); /4`.
  Record a table (desktop + phone profile). Anything > 2× the cheapest beat gets optimised:
  bake it, reduce steps, or lower that beat's resolution.
- Note: a hidden/background browser tab throttles rAF to ~1 fps — never judge smoothness there.
