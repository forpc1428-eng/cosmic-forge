---
name: space-realism
description: Physically grounded, photoreal look-development for space and natural scenes — black holes and accretion disks, spiral galaxies, nebulae, star fields, the Sun, planets, moons, rings, atmospheres, lighting angles and colour science — plus how to avoid the generic "AI render" look. Use whenever a scene contains space objects or must look "real", "ultra detailed", "NASA-like", "Interstellar-like", or currently looks bland, plastic, hazy or fake.
---

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
