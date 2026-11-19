"""Regenerates MASTER_PROMPT.md from skills/*/SKILL.md (run after editing any skill)."""
import pathlib, re
root = pathlib.Path(__file__).resolve().parent.parent
order = ["cosmic-forge", "webgl-cinematic-engine", "space-realism", "scroll-camera-direction",
         "ui-ux-mastery", "instant-load-performance", "mobile-first-3d", "quality-gate"]
head = """# COSMIC FORGE — MASTER PROMPT (works with any AI)

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

"""
out = [head]
for name in order:
    text = (root / "skills" / name / "SKILL.md").read_text(encoding="utf-8")
    text = re.sub(r"^---\n.*?\n---\n", "", text, count=1, flags=re.S).strip()
    out.append(f"\n\n---\n\n<!-- skill: {name} -->\n\n" + text)
(root / "MASTER_PROMPT.md").write_text("".join(out) + "\n", encoding="utf-8")
print("MASTER_PROMPT.md:", sum(len(x) for x in out), "chars")
