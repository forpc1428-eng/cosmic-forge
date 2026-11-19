---
name: quality-gate
description: Final verification checklist for cinematic 3D/WebGL websites before shipping — visual realism, continuity of transitions, framing on desktop and phones, text legibility, loader and cues, performance numbers, console/shader errors, config validity, licences and personal data. Use at the end of every build or change, and whenever asked "is it perfect?", "check everything", "ready to deploy?".
---

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
