---
name: cosmic-forge
description: Master workflow for building cinematic, photoreal, real-time 3D web experiences (space, black holes, galaxies, planets, or any "universe" / object scene) with scroll-driven camera journeys, studio-grade UI/UX, instant loading and perfect mobile layouts. Use whenever the user asks for a 3D / WebGL / Three.js / immersive / "awwwards-level" / cinematic / scroll-animation website, portfolio, landing page, hero scene or product scene — or says "make it like the black hole site". If the user gives no concept, build the default: the Event Horizon black-hole → galaxy → solar-system portfolio in templates/event-horizon.
---

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
