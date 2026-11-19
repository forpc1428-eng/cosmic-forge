---
name: webgl-cinematic-engine
description: Film-quality real-time rendering in the browser with raw WebGL2 (or Three.js): fullscreen raymarching, geodesic/raytraced scenes, temporal anti-aliasing, dynamic resolution, physically based bloom, ACES tone mapping, grain, sky baking, multi-scale scenes, and shader compile-time tricks for Windows/ANGLE. Use for any 3D/WebGL/GLSL/shader/Three.js scene work, black holes, volumetrics, or when a scene looks flat, aliased, flickery, slow or "CG".
---

# WebGL cinematic engine

Reference implementation: `templates/event-horizon/js/blackhole.js` (≈1,300 lines, zero deps).
Read it. Reuse it. The pipeline below is proven on desktop GPUs and mid-range phones.

## 1. Frame pipeline (keep this exact order)

1. **Scene pass** → `raw` RGBA16F target at a *dynamic internal resolution* (viewport only — never reallocate).
   Sub-pixel **Halton(2,3) jitter** on the projection, 8-frame cycle.
2. **TAA resolve** → history ping-pong. 3×3 neighbourhood clamp in *tonemapped* space
   (`c/(1+luma)`), blend `0.86 − motion*6`, floor 0.3. Reset history on scale change or scene switch.
   Kills star sparkle, shimmer, stair-steps and lets you use 30–50 % fewer samples.
3. **Upscale** to full canvas res with a mild 4-tap sharpen (`0.08 + 0.35*(1−scale)`).
4. **Bloom**: 6-mip chain. First downsample = 13-tap CoD filter with **Karis average** + soft-knee
   threshold (~1.6–1.8 HDR); upsample = 9-tap tent, additive. Amount 0.05–0.08. Never bloom UI.
5. **Composite**: tiny CA (≤ 0.004 — more smears stars), exposure ~0.95–1.05, **ACES fitted**,
   gamma, vignette 0.7–1.0, triangular grain 0.025 (also dithers 8-bit banding), optional fade.

Render targets RGBA16F when `EXT_color_buffer_float` exists, else RGBA8. Fullscreen triangle, not quad.

## 2. Speed rules that matter more than anything

- **Windows/ANGLE compile trap**: D3D unrolls loops and inlines everything → 7 s+ link times.
  Add `uniform int uZero;` (always 0) and write every loop as `for(int i=uZero; i<N; i++)`.
  Measured: black-hole shader link 7 s → 0.9 s.
- **KHR_parallel_shader_compile**: start all `linkProgram`s immediately, poll
  `COMPLETION_STATUS_KHR` with `setTimeout` (rAF pauses in hidden tabs), only *await* the
  programs the first screen needs. Compile later scenes in the background.
- **Bake what doesn't move**: direction-only skies (nebulae, distant galaxies, Milky Way seen
  from inside) → cubemap once at load (384–768 px/face). Per-pixel fbm is the #1 GPU cost.
- **Dynamic resolution**: measure average frame ms every 0.6 s; >19.5 ms → scale −0.06 and set a
  ceiling (scale−0.02) so it never oscillates; <17.6 ms for 4 windows → +0.04. Range 0.42–1.0.
- **Pixel cap**: `maxPixels` 3.2 MP desktop, 1.0 MP phone; DPR cap 1.5 desktop / 1.25 phone.
- **No per-frame allocations** in JS; no layout reads in the frame loop (cache offsets on resize).
- Pause on `visibilitychange`; handle `webglcontextlost` (preventDefault) / `restored` (reload).
- Warm up: render 2–3 frames of the first scene behind the loader, `gl.finish()`, then reveal.

## 3. Raymarching recipes

**Black hole (Schwarzschild, rs = 1)** — integrate photon paths with velocity Verlet:
`a = −1.5·h²·p/r⁵`, `h = |p × v|`, step `dt = clamp(0.075·r, 0.008, 2.6)`, first step jittered by
interleaved gradient noise. Capture at r < 1; escape when r > far and moving outward.
Thin disk: detect `y` sign change, interpolate the crossing, front-to-back alpha composite.
Disk shading → see `space-realism` §Black hole. 220 steps desktop, 150 phone.

**Volumes (galaxy, nebula, clouds)**: intersect a bounding slab/sphere, march 36 (desktop) /
24 (phone) samples with **quadratic spacing** `t = t0 + (t1−t0)·f²` (dense near the eye),
jittered per pixel per frame; accumulate `col += T·emission·dt; T *= exp(−extinction·dt)`;
early-out at T < 0.02. TAA turns the noise into smooth gradients.

**3D star fields with real parallax**: 3D-DDA through grid cells (22 steps), one hashed star
per cell, brightness ∝ 1/t² (clamped), Gaussian footprint ≥ 0.75 px, density from the
scene's mass distribution. Shrink the cell size with zoom level so stars always stream past.

**Analytic objects** (planets, rings, moons): `sph()` ray–sphere, ring = plane hit + radius band,
shadows by a second ray toward the light. Cheaper and sharper than meshes for spheres.

## 4. Seamless multi-scale worlds (galaxy → planet with no cut)

Float32 can't hold "galaxy" and "planet" in one coordinate system. Use **two frames that
share one camera orientation**: galaxy units and system units with `K = 1e5`.
Compute both eye positions in **JS doubles**: `eyeS = (eyeG − sunG)·K`. Render the galaxy
from `eyeG`, the planets from `eyeS`. While far, the sun is a star-like point whose flux follows
`(angularRadius/pixel)²` — it *becomes* the resolved disc naturally. Cross-fade the volumetric
galaxy into a real panorama (or baked cube) once inside it. Result: one unbroken zoom of 10⁸×.

## 5. Textures

- Equirectangular maps sampled with `eqUV(n) = (0.5 + atan(n.z,n.x)/2π, 0.5 − asin(n.y)/π)`.
- **No seam**: use `textureLod` with an analytic LOD from the pixel footprint
  (`log2(texW·0.159·pixAng·t/R/μ) − 0.5`), never `texture()` with derivatives in branches.
- Upload **one texture per frame** from a queue (decode off-thread with `createImageBitmap`),
  `SRGB8_ALPHA8` for colour, `RGBA8` for data (clouds, alpha), mipmaps + 8× anisotropy.
- Bind a 1×1 dummy to every sampler until the real one arrives (avoids type-conflict errors).
- Relief from a photo: finite-difference the albedo luminance → perturb the normal (k≈5 rocky, ≈1 gas).

## 6. Three.js port (when the user insists)

Same rules: `WebGLRenderer({antialias:false, powerPreference:'high-performance'})`,
`EffectComposer` with HalfFloat targets, your own TAA or `TAARenderPass`, `UnrealBloomPass`
(threshold ≥ 1.5, strength ≤ 0.6), `OutputPass` with ACES. Fullscreen raymarched effects as a
`ShaderMaterial` on a fullscreen triangle. Don't mix 50 meshes + post FX on phones.

## 7. Debug harness (ship it, gated behind `?debug`)

Expose `window.__engine`. Time a scene: render once, `gl.finish()`, render ×4, `readPixels`
1 px to force sync, divide. Probe NaNs by `readPixels(FLOAT)` on targets — one NaN pixel
spreads through bloom and blacks out the whole frame. Common NaN sources: `pow(neg, x)`,
`smoothstep(e,e,x)`, `Inf` in ACES. Clamp inputs.
