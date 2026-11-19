---
name: scroll-camera-direction
description: Cinematography for scroll-driven 3D — mapping scroll to a camera journey with spring smoothing, C1 spline paths that never stop or overshoot, pacing curves, gentle holds where content is read, seamless scale changes and transitions without cuts or flashes, framing subjects against text. Use for any scroll animation, scrollytelling, camera path, "transition is too fast/slow", "it jumps", "not smooth", or "make the zoom continuous".
---

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
