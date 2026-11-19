# COSMIC FORGE — MASTER PROMPT (works with any AI)

Paste this whole file into any AI chat (ChatGPT, Claude, Gemini, Grok, DeepSeek, Copilot, Cursor…)
or upload it as a file, then say what you want, e.g.:

> "Using Cosmic Forge, build my portfolio. Name: … Role: … Email: … Projects: …"
> "Using Cosmic Forge, make a cinematic ocean-depths landing page for my app …"
> "Using Cosmic Forge, build the default." (→ the Event Horizon black-hole portfolio)

**You (the AI) must:** act as creative director + graphics engineer + UI/UX lead; follow every
section below; start from the reference template at
https://github.com/forpc1428-eng/cosmic-forge/tree/main/templates/event-horizon
(fetch it if you can browse; otherwise reproduce its architecture exactly as described here);
deliver complete, runnable files (no placeholders like "// rest of code"); and finish with the
quality gate and an honest list of what you could not verify.



---

<!-- skill: cosmic-forge -->

# Cosmic Forge — the director's workflow

You are acting as **creative director + graphics engineer + UI/UX lead** at once.
The bar: a visitor should think "how is this running in a browser?" within 2 seconds,
on a mid-range phone, with no jank, no clipping, no generic "AI look".

This skill orchestrates seven mastery skills. Read the ones the job touches **before writing code**:

| Skill | Read it when |
|---|---|
| `webgl-cinematic-engine` | Any real-time 3D: render pipeline, shaders, TAA, bloom, tone mapping, compile speed |
| `space-realism` | Black holes, galaxies, nebulae, stars, planets, suns, rings, atmospheres, lighting, colour science |
| `scroll-camera-direction` | Anything that moves with scroll: camera paths, pacing, seamless transitions, scale changes |
| `ui-ux-mastery` | Typography, colour, layout, text over 3D, loaders, cues, navigation, accessibility, copy |
| `instant-load-performance` | Always. Load budget, shader compile, textures, caching, frame budget |
| `mobile-first-3d` | Always. Separate phone profile, portrait framing, touch, safe areas |
| `quality-gate` | Always, at the end. Nothing ships without passing it |

## 0. Default behaviour

- **No concept given** (or "make me something like that"): copy `templates/event-horizon/`
  and personalise it (name, role, email, pages, project list). That template IS the reference
  quality bar: a Schwarzschild black hole with lensed real sky → volumetric galaxy →
  photographic solar system, all in one continuous scroll. Do not "simplify" it.
- **A different concept** (ocean, city, product, anime castle, forest, atom, DNA…): still start
  from the template's **engine and pipeline** (TAA, bloom, dynamic resolution, loader,
  scroll spring, pacing curve, mobile profile, scroll cue) and replace only the scene shaders,
  camera keys and content. Never rebuild the plumbing from scratch — it is where quality lives.
- **Three.js requested explicitly**: allowed, but port the same rules (see engine skill §Three.js).

## 1. Brief → treatment (write this down before coding)

Turn any request — even one line — into a 6-line treatment:

1. **Hero image**: the single frame people will screenshot. Describe light, colour, scale.
2. **Journey**: 3–6 beats the camera travels through, each one *continuous* with the next
   (no cuts, flashes or tunnels unless asked). Example: hole → darkness → galaxy → star → planets → home.
3. **Pages**: which content appears at which beat, and on which side of the frame.
4. **Palette**: one key light colour, one accent, one deep background. Real-world references
   (NASA/ESA photos, film stills) beat imagination.
5. **Motion feel**: e.g. "slow majestic dolly, accelerating into the hole, gentle holds on pages".
6. **Budget**: ≤ 16 ms/frame desktop at dynamic res, ≤ 1.5 MB first-load on phones.

If the user's wording is vague, decide confidently and state your choices in one line each.
Ask only when a choice is genuinely theirs (brand name, real email, real project names).

## 2. Build order (never skip, never reorder)

1. Copy the template → run it locally (`python -m http.server`) → confirm it renders.
2. Personalise content (`js/main.js` → `SITE`, `PAGES`; `index.html` title/meta/loader name).
3. Scene work (engine + realism skills). Change one beat at a time; look at it after each change.
4. Camera & pacing (scroll-camera skill). Tune with `?u=0.42`-style jump links.
5. UI layer (ui-ux skill): panels, nav, loader, scroll cue, labels.
6. Phone profile (mobile skill): framing, textures, layout, menu.
7. Performance pass (instant-load skill): measure GPU ms per beat, compile ms, bytes.
8. Quality gate (quality-gate skill). Fix everything it flags. Then ship.

## 3. Non-negotiables (the "200%" rules)

- **Continuity**: every transition is a camera move through one world. Scale jumps use the
  two-frame trick (engine skill). Fade only from/to true black, never flash white.
- **Real reference first**: real textures (planet maps, Milky Way panorama), real physics
  (lensing, Doppler, blackbody, Novikov–Thorne disk, Keplerian shear), real lighting angles.
- **No AI tells**: no purple haze everywhere, no rainbow gradients, no glowing everything,
  no chromatic-aberration smear, no bloom on text, no generic lens flares, no "neon" UI.
  Deep blacks. Few, deliberate highlights.
- **Text is sacred**: never let 3D subjects sit behind paragraphs. Frame subjects on the
  opposite side (desktop) or above a bottom sheet (phones).
- **Speed is design**: loader visible in the first paint, interactive in < 2 s on 4G for phones.
- **Every number is tuned by looking**, then measured. Screenshots at each beat, desktop + phone.

## 4. Handing back

Finish with: what was built, the live/local URL, what the user must edit (email, names),
how to deploy (Vercel: framework "Other", no build), and any honest limits
(e.g. "tested in emulation, not on a physical iPhone").

---

<!-- skill: webgl-cinematic-engine -->

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

---

<!-- skill: space-realism -->

# Space realism — look-dev bible

Rule zero: **reference real images** (NASA/ESA/JWST/Cassini/EHT photos, Interstellar stills).
Real space is mostly black, with a few intense, saturated, *small* things. Restraint = realism.

## Black hole (Interstellar-grade, physically motivated)

- Geodesic raymarch (engine skill). The photon ring and secondary image appear for free.
- **Disk temperature** — Novikov–Thorne: `T ∝ x^-3/4·(1−x^-1/2)^1/4`, `x = r/r_in`, normalised peak at
  `x≈1.36`. `r_in ≈ 2.6 rs`, `r_out ≈ 15 rs`. Colour = **blackbody(T·g)** with T₀ ≈ 4300–4600 K
  (white-gold core, amber outside). Not purple, not neon.
- **Relativistic shift**: `β = √(M/(r−2M))` (cap 0.72), `g = √(1−2M/r) / (γ(1−β·cosθ))`.
  Intensity ∝ `g³` (artistic between g³–g⁴). Approaching side bright and whiter, receding dim and red.
- **Turbulence that doesn't smear**: Keplerian shear `ω ∝ r^-1.5`, two noise layers in
  log-polar coords offset by half a period and cross-faded (`w = 1−|2t−1|`), contrast restored by
  `÷√(w1²+w2²)`. Add one fine octave; keep "lanes" ≤ 15 % or it looks like vinyl.
- Thin disk, soft inner edge (plunging region), outer fade. Alpha from density so stars show through gaps.
- Sky behind it: a **real Milky Way panorama** lensed by the same rays. Sparse procedural stars on top.
- Don't put moons, planets or meteors right behind the hole: lensing turns them into full rings.

## Spiral galaxy (volumetric)

Galaxy = disk density × spiral phase. What separates real from bland:
- Phase `2θ − ln(r)·7 + (nLarge−0.5)·2.8 + (nMid−0.5)·1.3` → arms **wander and branch**.
- Arm segments: multiply by `0.3 + 1.4·smoothstep(.25,.75,nLarge)` → arms break into pieces.
- Layers: warm old-star disk glow between arms (`exp(−r/24)`, thick), blue arms (thin, `exp(−|y|/0.32)`),
  bright **arm crests** (`pow(cos,16)`), feathery **spurs** (`pow(cos(2·phase+noise),10)`),
  a central **bar**, a golden bulge that does NOT blow out, **pink HII knots** along crests,
  **blue young clusters**, and **dust lanes on the leading edge** (`phase−0.55`, strong extinction).
- Colours: arms (0.34, 0.55, 1.0), HII (1.0, 0.24, 0.48), bulge (1.0, 0.74, 0.44). Saturated but small.
- From inside the disk: cross-fade to a real all-sky Milky Way photo aligned so its centre faces
  the galactic centre — instantly photographic.

## Stars

- Never uniform white dots. Blackbody tint 2800–12 000 K, magnitude `pow(hash,7)·7+0.2`,
  footprint ≥ 0.7 px with energy conservation `min(1,(0.02/size)²)`.
- 3–4 layers at different densities; denser along the galactic band.
- Real sky panorama > procedural stars whenever the camera is "at" a place.

## Sun

Photographic texture (or granulation noise) × limb darkening `0.35 + 0.65·μ^0.6`, HDR ×26.
Corona: tight `exp(−(θ−θR)/(0.35θR))` + faint `exp(−18θ)`. **No sky-wide glow** — it hazes everything.
When unresolved it's a star: flux ∝ `(θR/pixel)²`.

## Planets (the "real photo" look)

- **Photographic maps** (Solar System Scope, CC BY 4.0, or NASA): Earth day/night/clouds, Moon,
  Mars, Jupiter, Saturn + ring alpha, Uranus, Neptune, Mercury, Venus. 4K desktop / 1–2K phone, WebP.
- **Lighting angle is everything**: side-light at ~80° phase (camera beside the planet, slightly
  sunward) for a crisp terminator = depth. Frontal light = flat disc. Phones: ~45° so the disc reads.
- Relief from the photo for rocky bodies (normal from albedo gradient), micro-noise when closer
  than texture resolution, slight cloud-deck relief for gas giants, mild limb darkening.
- **Earth**: clouds as separate layer with offset **cloud shadows**, ocean **sun glint**
  (`pow(N·H,140)` masked to ocean), **night city lights** on the dark side, blue haze toward the
  limb, orange band at the terminator, thin **outer atmosphere glow** beyond the silhouette.
- **Saturn**: ring photo (colour + alpha), Cassini division, planet shadow on rings, ring shadow on planet.
- Moon orbits Earth (slow, slightly inclined). Eclipses: shadow rays to the Sun.
- Asteroid belt: 3D-DDA cells in an annulus, tiny lit points, depth-faded.

## Colour & tone

- Linear workflow, sRGB textures uploaded as `SRGB8_ALPHA8`, ACES at the end.
- One warm key (sun/disk), one cool fill (sky/arms), true black background.
- Bloom threshold high (≥1.6) — only genuinely bright things glow.
- Exposure so that the darkest important detail is just visible on a phone in daylight.

## The "AI look" — never ship these

Purple/teal haze over everything · glow on every edge · rainbow nebulae · uniform white star
dust · symmetric perfect spirals · flat front-lit planets · white flash transitions · heavy
chromatic aberration · grey-brown fog in space · text glowing like neon · lens flares for no reason.

---

<!-- skill: scroll-camera-direction -->

# Scroll → camera direction

Reference: `templates/event-horizon/js/main.js` (`sceneAt`, `PACE`, spring) and
`js/blackhole.js` (`FLIGHT`, `sampleCamera`, `SYS_KEYS`, `spaceCamera`, `visit`).

## 1. Input chain (feels "expensive" on wheel, trackpad and touch)

`native scroll position → critically-damped spring → pacing curve → camera function`

- Keep **native scrolling** (accessibility, mobile momentum, browser scrollbars). Never hijack wheel.
- Tall spacer sections (`height: N vh`) define length; a `position:fixed` canvas renders.
- Spring on *pixels*: `a = ω²(target − x) − 2ωv`, ω ≈ 6.5–7.5 (14 for reduced-motion), sub-step
  at 120 Hz so long frames stay stable. Its velocity drives motion blur, disk spin, CA (subtly).
- Cache section offsets on resize (ResizeObserver, debounced). Zero layout reads per frame.

## 2. Camera paths that never stutter

- **Never** chain separate smoothsteps between keyframes — speed hits zero at every key (stop-go).
- Use **C1 curves**: Fritsch–Carlson monotone cubic for scalars (distance, FOV) and
  non-uniform Catmull-Rom/Hermite for 3D positions and targets.
- Interpolate **distance in log space** for zooms: equal scroll = equal perceived zoom.
- Soft start only at the very beginning (`k = c·p²/2a` then linear), nowhere else.
- **Holds** (where a page is read): two keys close in space, far apart in progress → the camera
  glides slowly but never freezes. Lock the **aim** during holds (zero target tangent on hold keys)
  so the subject doesn't drift off-centre.
- Gentle life: hand-held drift (0.04–0.07 units, sin/cos at 0.2–0.4 Hz) fading out as tension rises.
  Mouse parallax ≤ 2 % of distance, **disabled on touch devices**.

## 3. Pacing — the user feels this more than anything

- Write pacing as a separate curve `PACE = [[scrollFraction, journeyProgress]…]` (monotone cubic).
  Then "faster here, slower there" is a one-line change, with no speed jumps.
- Typical budget (vh): intro fall 320–400, galaxy approach ~500, arrival 500–600 (do NOT rush
  scale changes), each content hold 250–350, travel between holds 150–250.
- Rule: big scale changes need *more* scroll, not less. Users said "too fast" every time it was < 4 screens.
- Navigation links scroll to the *centre* of a page's hold window (invert PACE by bisection).

## 4. Seamless transitions (no cuts, no white flashes)

- One world, one camera. Change scenes by **moving through** them: fall into the hole → its
  interior is pure black → the next world fades up from black while the camera keeps moving.
- Scale changes: two-frame trick (engine skill §4) + log-distance curve + a light speed drop before arrival.
- Hand-offs between techniques (volume → photo panorama, procedural → texture): cross-fade over a
  range where both look the same (match orientation, brightness and colour first).
- Fades are only ever to/from true black, ≥ 3 % of the journey long.

## 5. Framing

- Desktop: subject on the **opposite side** of the text panel (shift the aim ±1.6–1.8 R sideways).
- Phones (portrait): aim *at* the subject and **tilt the whole view** down ~0.21 rad, so the subject
  sits in the upper third above a bottom-sheet panel. Pull back so the visible radius (incl. rings)
  ×7.6 fits the narrow horizontal FOV.
- Light from the side (≈80° phase) on desktop for depth; ≈45° on phones so the whole disc reads.
- Never let a subject's dark side sit against black at the frame edge — it reads as "cut off".
- Avoid placing objects directly behind a lens (black hole) — Einstein rings look like glitches.

## 6. Debugging the path

- `?u=0.6` jumps to journey progress; `?at=0.5` to page fraction; `?m=1` forces phone profile.
- Print `spaceCamera(u)` at 5 points across a hold; aim error should be 0°, distance smooth.
- Check every transition at 5+ intermediate points, desktop and phone, before calling it done.

---

<!-- skill: ui-ux-mastery -->

# UI/UX mastery for immersive sites

Reference: `templates/event-horizon/css/style.css`, `index.html` (inline loader), `js/main.js`.

## 1. Typography (2 families, strict roles)

- **Display serif** (Bodoni Moda / Didot / Playfair-class) for titles: weight 400, tracking −0.02em,
  line-height 0.9–1.0, sizes `clamp(44px, 9vw, 148px)`. Italic + dimmed second line for emphasis.
- **Geometric sans** (Montserrat / Inter) for UI: 10–11 px, weight 500, UPPERCASE, tracking 0.24–0.38em.
  Body 14–15 px, line-height 1.65–1.75, max 46ch.
- Self-host WOFF2, `font-display: swap`, preload the 2 files the first screen uses.
- Hierarchy per panel: kicker (accent, caps) → title (serif) → body (dim) → list/actions.

## 2. Colour

Tokens on `:root`, never raw hex in components:
`--bg #000` · `--fg #f4efe8` (warm white, not pure) · `--dim rgba(fg,.55–.62)` ·
`--faint rgba(fg,.14–.18)` (rules, borders) · `--accent #ffb070` (one warm accent, used sparingly).
- Accent only on: kicker labels, active nav underline, progress, hover, the scroll cue light.
- Text over 3D: soft radial scrim behind panels (`radial-gradient(closest-side, rgba(0,0,0,.5), transparent)`)
  and a top/bottom gradient on the stage. Contrast ≥ 4.5:1 for body text in every frame.
- Never: neon, glassmorphism everywhere, multiple accent colours, gradient text.

## 3. Layout over 3D

- Fixed canvas; content floats in a fixed overlay. Panels: desktop left/right column `min(88vw,520px)`,
  vertically centred, opposite the subject. Phones: **bottom sheet** (max 60vh, gradient backdrop,
  safe-area padding), subject framed above it.
- 8-pt spacing scale, `--pad: clamp(16px, 5vw, 80px)`, generous negative space.
- Panel visibility driven by journey progress windows with eased fades (2 % in, 1.5 % out),
  `translateY` 24–36 px, `pointer-events` only when visible.
- HUD/labels bottom-left in micro caps (name · real fact, e.g. "Saturn · 9.58 AU").
  Real facts add credibility; invented ones destroy it.

## 4. Loader (must paint in the first frame)

- Inline critical CSS + markup in `index.html`. Brand name in the display serif with a staggered
  word reveal, a thin progress ring/bar, and a numeric percentage.
- Honest progress: ~0–60 % while shaders compile (eased fake-progress toward 55 %), 60–100 %
  for the hero's critical textures. Reveal when ready or after 3.5 s max — never hang.
- Fade out 1–1.2 s with expo-out; the hero text then rises in (stagger 120 ms).

## 5. Scroll cue (idle-aware)

- Small frosted pill on the right: vertical "SCROLL" + a light running down a hairline + a bobbing chevron.
- Appears after ~1.2 s of stillness with a soft blur-in (0.9 s); disappears in 0.25 s on any scroll.
- Hidden on the landing (which has its own hint), during the loader and with the menu open.
- At the end it becomes "BACK TO TOP" (animations reversed) and is clickable.
- Gotcha: never name a state class `top`, `active`, `hidden`… that collides with other components.

## 6. Navigation

- Desktop: brand left, 4 short caps links right, accent underline on the active section.
- Phones: 2-line burger → full-screen blurred sheet with large serif links. Close on selection.
- Links scroll (smooth) to the middle of their content's hold window, through the 3D journey.

## 7. Motion language

- One easing family: expo-out `cubic-bezier(.16,1,.3,1)` for entrances, `(.87,0,.13,1)` for loops.
- Durations: micro 0.25–0.4 s, reveals 0.9–1.6 s. Exits faster than entrances.
- `prefers-reduced-motion`: stop loops, stiffer scroll spring, no drift, no grain animation.

## 8. Copy

Short, confident, specific. Title = 2–4 words + italic echo ("Where ideas / *are born.*").
Body ≤ 2 sentences. Project lists: name + "Type · Year". No lorem ipsum in shipped work.

## 9. Accessibility & polish

Semantic landmarks, `aria-hidden` on decorative layers, real `<button>`s, visible focus,
`lang`, title/description/OG tags, an SVG favicon, `theme-color #000`, `color-scheme: dark`,
no horizontal scroll at 320 px, tap targets ≥ 40 px.

---

<!-- skill: instant-load-performance -->

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

---

<!-- skill: mobile-first-3d -->

# Mobile-first 3D

Phones are not small desktops. Build a **separate profile**, toggled by one class: `html.mobile`.

## 1. Detection

```js
const MOBILE = qs.get('m') === '1' || (qs.get('m') !== '0' &&
  (matchMedia('(pointer: coarse)').matches || Math.min(innerWidth, innerHeight) < 600));
document.documentElement.classList.toggle('mobile', MOBILE);
```
`?m=1` / `?m=0` force it — essential for testing in desktop emulation.

## 2. Render profile

| Setting | Desktop | Phone |
|---|---|---|
| DPR cap / max pixels | 1.5 / 3.2 MP | 1.25 / 1.0 MP |
| Geodesic steps | 220 | 150 |
| Volume samples | 36 | 24 |
| Sky bake size | 768 / 512 | 384 / 256 |
| Texture set | `textures/hd` (~6 MB) | `textures/m` (~1.2 MB) |
| Mouse parallax / look-around | on | **off** (touch only; emulators send mouse events) |

## 3. Portrait framing (where most "it's cut off" bugs come from)

- Horizontal FOV in portrait is tiny: `tan(hFOV/2) = tan(vFOV/2)·aspect` (≈0.22 at 52° and 0.46 aspect).
- Distance from each subject = `max(R·distMul·1.25, visibleRadius·7.6)`; visibleRadius includes
  rings (Saturn ≈ 2.35 R, Uranus ≈ 1.8 R).
- Aim **at** the subject, then tilt the whole view down ≈ 0.21 rad so it sits in the upper third,
  above the text sheet. (Offsetting the target instead drifts sideways when the camera moves.)
- Light more frontally (~45° phase): side-lit half-black planets read as "clipped" on small screens.
- Lock the aim during content holds (zero target tangents) — no drifting off-centre.
- Verify numerically: render a frame, `readPixels` rows across the subject, check the lit span is
  inside 5–95 % of the width.

## 4. Layout

- Panels → **bottom sheet**: `left:0; right:0; bottom:0; max-height:60vh; overflow:auto`,
  gradient backdrop, `padding-bottom: calc(54px + env(safe-area-inset-bottom))`.
- Titles `clamp(34px, 10vw, 52px)`; hero name split onto 2 lines.
- Nav → burger + full-screen blurred sheet with 44 px serif links.
- Hide decorative rails; shorten labels (name only); hide the landing scroll hint if it collides.
- Shorter scroll: intro ~320vh, journey ~2600vh (phones scroll faster with momentum).
- `viewport-fit=cover`, `100svh` sticky stages, no horizontal overflow at 320 px.

## 5. Test matrix (emulation is not enough, but it's the minimum)

375×812 and 390×844 portrait, 412×915 Android, 768×1024 tablet. Every content beat:
subject fully visible and centred above the sheet, text readable, nothing under the notch/home bar.
Tell the user honestly when a real-device test hasn't been done.

---

<!-- skill: quality-gate -->

# Quality gate — nothing ships until every box is ticked

Work through it with real screenshots (desktop 1280×760 and phone 375×812 via `?m=1`),
jump links (`?u=…`), and the `?debug` timing harness. Fix, then re-run the affected section.

## A. Correctness
- [ ] No console errors; no shader compile/link errors (surface them in-page, e.g. `#glError`).
- [ ] No NaN/black-frame anywhere along the journey (sample ≥ 10 points).
- [ ] Every JSON/config file parses (`python -c "import json;json.load(open('vercel.json'))"`).
- [ ] All assets load (network list: no 404s on the site's own files).
- [ ] No variable used before declaration in GLSL; uniforms that are arrays bound with `[0]`-stripped names.

## B. Visual realism
- [ ] Hero frame would be screenshot-worthy on its own. Deep blacks, few strong highlights.
- [ ] No "AI look" items (see space-realism §AI look). No sky-wide haze, no CA smear on stars.
- [ ] Real references used where the camera is "somewhere" (panorama, planet maps).
- [ ] Subjects lit from the side on desktop (visible terminator); disc readable on phones.

## C. Motion & continuity
- [ ] Scroll the whole journey slowly and fast: no stop-go, no jumps, no white flashes, no cuts.
- [ ] Big scale changes get ≥ 4 screens of scroll; content holds glide, never freeze.
- [ ] Aim stays locked on the subject during each content hold (aim error ≈ 0°).
- [ ] Nav links land in the middle of their content window.

## D. Framing & UI
- [ ] Desktop: subject opposite the text, never behind a paragraph.
- [ ] Phone: subject (rings included) fully inside the frame, above the bottom sheet, at every hold.
- [ ] Text contrast ≥ 4.5:1 in every frame; nothing under notch/home indicator.
- [ ] Loader paints instantly, shows real progress, never hangs > 3.5 s.
- [ ] Idle scroll cue: appears after stopping, vanishes on scroll, "Back to top" at the end.
- [ ] Reduced-motion respected. Keyboard focus visible. Title/description/OG/favicon set.

## E. Performance (write the numbers down)
- [ ] GPU ms per beat (desktop + phone profile) with dynamic resolution ≤ 16 ms.
- [ ] Shader link of hero program ≤ 1 s (Windows Chrome is the worst case).
- [ ] Bytes before reveal ≤ 1.5 MB desktop / 400 KB phone; total textures within budget.
- [ ] Cache headers in place for immutable assets.

## F. Content, data, licences
- [ ] No placeholder text left unless the user chose it; real name/email only with consent.
- [ ] CC BY credits shown where required (e.g. Solar System Scope textures).
- [ ] No secrets, tokens or personal data committed. `.gitignore` present.

## G. Hand-off message
State what was verified and how, what was **not** verified (e.g. real iPhone, Safari), the URL,
and the exact files/lines the user edits for name, email, projects, pacing.
