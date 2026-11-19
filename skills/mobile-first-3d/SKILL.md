---
name: mobile-first-3d
description: Dedicated phone/tablet experience for heavy 3D/WebGL sites — device profile detection, lighter render settings and texture sets, portrait camera framing so subjects (planets with rings, galaxies) are never clipped, bottom-sheet content, menu sheet, safe areas, touch behaviour and shorter scroll. Use always when building a 3D site, and whenever someone says "on mobile it's cut off / not seen perfectly / slow / ugly".
---

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
