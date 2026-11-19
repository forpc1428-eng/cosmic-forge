# AGENTS.md — Cosmic Forge

You are working inside **Cosmic Forge**, a skill pack for building cinematic, photoreal,
real-time 3D websites (WebGL2 / Three.js) with studio-grade UI/UX, instant loading and
perfect phone layouts. This file is read automatically by Codex, Cursor, Jules, Aider,
Gemini CLI, Copilot agents and similar tools. Claude Code reads `CLAUDE.md` + `skills/`.

## What to do when the user asks for something

1. Read `skills/cosmic-forge/SKILL.md` (the director's workflow) first. Always.
2. Read every other skill the task touches (all of them for a full site):
   - `skills/webgl-cinematic-engine/SKILL.md` — render pipeline, shaders, TAA, bloom, speed tricks
   - `skills/space-realism/SKILL.md` — black holes, galaxies, stars, planets, colour, "no AI look"
   - `skills/scroll-camera-direction/SKILL.md` — scroll → camera, pacing, seamless transitions, framing
   - `skills/ui-ux-mastery/SKILL.md` — typography, colour tokens, layout, loader, scroll cue, nav, copy
   - `skills/instant-load-performance/SKILL.md` — budgets, compile, textures, caching, measuring
   - `skills/mobile-first-3d/SKILL.md` — phone profile, portrait framing, bottom sheets
   - `skills/quality-gate/SKILL.md` — final checklist; nothing ships before it passes
3. **Start from `templates/event-horizon/`** — a complete, working reference site
   (black hole → galaxy → solar system, ~1,300-line zero-dependency WebGL2 engine).
   - No concept given → build exactly this, personalised (name, role, email, pages, projects).
   - Different concept → keep its engine, loader, scroll spring, pacing, mobile profile, cue and
     UI system; replace the scene shaders, camera keys and content.
4. Run it locally (`python -m http.server 8080` → `http://localhost:8080/`) and look at every beat
   on desktop (1280×760) and phone (`?m=1`, 375×812) before declaring anything done.
5. Finish with the quality gate and an honest hand-off (what's verified, what isn't).

## Hard rules

- Continuous camera journeys. No cuts, tunnels or white flashes unless the user asks.
- Real references (photographic textures, real physics, real facts) over imagination.
- Text never sits on top of the 3D subject; subjects never clipped on phones.
- Loader paints in the first frame; hero ready < 1.5 s desktop / < 2.5 s phone on 4G; 60 fps.
- Ask the user only for things that are theirs to decide (real name, email, project names, brand).
  Decide everything else confidently.
- Keep licences: template textures are Solar System Scope, **CC BY 4.0** — keep the credit line.

## Template map

| File | What it is |
|---|---|
| `templates/event-horizon/index.html` | Page shell, inline instant loader, meta |
| `templates/event-horizon/css/style.css` | Design tokens, layout, panels, mobile profile, scroll cue |
| `templates/event-horizon/js/main.js` | Content (`SITE`, `PAGES`), scroll spring, `PACE`, UI orchestration |
| `templates/event-horizon/js/blackhole.js` | Engine: shaders, pipeline, cameras (`FLIGHT`, `SYS_KEYS`), textures |
| `templates/event-horizon/textures/{hd,m}` | Desktop / phone WebP texture sets |
| `templates/event-horizon/vercel.json` | Cache headers; deploy with framework "Other", no build |

Debug URLs: `?u=0.6` (journey point), `?at=0.5` (page fraction), `?m=1` / `?m=0` (force phone/desktop),
`?q=low|high`, `?debug` (exposes `window.__bh` for GPU timing).
