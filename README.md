# 🌌 Cosmic Forge

**A skill pack that teaches any AI to build cinematic, photoreal, real-time 3D websites** —
black holes, galaxies, planets or any "universe" scene — with seamless scroll camera journeys,
studio-grade UI/UX, instant loading and perfect phone layouts.

Default build (when you don't describe anything else): **Event Horizon** — fall into a
physically-based black hole, emerge in a volumetric spiral galaxy, dive to the Sun and fly past
every planet to Earth, all in one continuous scroll. The complete working site lives in
[`templates/event-horizon`](templates/event-horizon).

> Made by **Vedant Bhayani**. Zero-dependency WebGL2 engine (~1,300 lines), ~6 MB desktop /
> ~1.2 MB phone textures, 60 fps with dynamic resolution.

---

## What's inside

| Path | Purpose |
|---|---|
| `skills/cosmic-forge/` | **Director's workflow** — brief → treatment → build order → non-negotiables. Routes to the others. |
| `skills/webgl-cinematic-engine/` | Render pipeline, black-hole raymarching, TAA, bloom, ACES, 7 s→0.9 s compile trick, galaxy→planet zoom |
| `skills/space-realism/` | Black holes, galaxies, stars, Sun, planets, atmospheres, colour science, "no AI look" list |
| `skills/scroll-camera-direction/` | Scroll spring, C1 camera splines, pacing curves, seamless transitions, framing |
| `skills/ui-ux-mastery/` | Typography, colour tokens, layout over 3D, instant loader, idle scroll cue, nav, copy, a11y |
| `skills/instant-load-performance/` | Budgets, critical path, shader scheduling, WebP texture tiers, caching, measuring |
| `skills/mobile-first-3d/` | Dedicated phone profile, portrait framing that never clips, bottom sheets |
| `skills/quality-gate/` | Final checklist — nothing ships until it passes |
| `templates/event-horizon/` | The full reference site (default output) |
| `AGENTS.md` | Universal instructions for coding agents (Codex, Cursor, Jules, Aider, Gemini CLI, Copilot…) |
| `MASTER_PROMPT.md` | **One file for any chat AI** — paste or upload it (generated from all skills) |
| `CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.github/copilot-instructions.md` | Per-tool pointers |
| `.claude-plugin/` | Makes the repo installable as a Claude Code plugin |
| `scripts/` | Installers + `build-master-prompt.py` |

---

## Install / use with your AI

### Claude Code
```bash
/plugin marketplace add forpc1428-eng/cosmic-forge
/plugin install cosmic-forge@cosmic-forge
```
or clone and run the installer (copies the skills to `~/.claude/skills`):
```bash
git clone https://github.com/forpc1428-eng/cosmic-forge.git && cd cosmic-forge && ./scripts/install.sh
```
Windows PowerShell: `.\scripts\install.ps1`

### Cursor · Codex · Jules · Aider · Gemini CLI · Copilot agents
Clone the repo (or copy `AGENTS.md`, `skills/` and `templates/` into your project). These tools
read `AGENTS.md` / `.cursor/rules` / `.github/copilot-instructions.md` / `GEMINI.md` automatically.

### ChatGPT · Gemini · Claude.ai · Grok · DeepSeek · any chat AI
Upload or paste [`MASTER_PROMPT.md`](MASTER_PROMPT.md), then ask. If the AI can browse,
tell it to use the template at `https://github.com/forpc1428-eng/cosmic-forge/tree/main/templates/event-horizon`.

---

## Example requests

- *"Using Cosmic Forge, build the default with my details: name …, role …, email …, projects …"*
- *"Using Cosmic Forge, make a cinematic deep-ocean landing page for my diving app."*
- *"Using Cosmic Forge, turn my product (a watch) into a scroll journey from macro gears to the full piece."*
- *"Using Cosmic Forge, run the quality gate on my site and fix everything."*

## Try the template locally
```bash
cd templates/event-horizon && python -m http.server 8080
```
Open `http://localhost:8080/` · debug links: `?u=0.6` (jump), `?m=1` (phone profile), `?debug`.
Deploy: Vercel → Import → Framework **Other**, no build command.

---

## Honest note

No instruction file can make every AI produce *identical* results — models differ. Cosmic Forge
gets as close as possible by shipping **working code** (the template) plus exact recipes, numbers
and a verification checklist, so an AI adapts a proven engine instead of improvising one.
Stronger coding AIs with file access and a browser (to look at their own output) get the best results.

## Credits & licence
Code: MIT © 2026 Vedant Bhayani. Planet & Milky Way imagery: [Solar System Scope](https://www.solarsystemscope.com/textures/),
CC BY 4.0 — keep the credit visible. Fonts: Bodoni Moda, Montserrat (SIL OFL 1.1).
