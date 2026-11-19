---
name: ui-ux-mastery
description: Studio-level UI/UX for immersive and 3D websites — typography systems, colour tokens and contrast, layout over moving 3D, text panels, navigation and phone menus, custom loaders, idle scroll cues, micro-interactions and easing, copywriting, accessibility and reduced motion. Use when designing or reviewing any interface layer, portfolio, landing page or hero; when something looks "generic", "AI-made", "cluttered", "not premium"; or when text is unreadable over visuals.
---

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
