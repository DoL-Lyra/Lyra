# Lyra (天琴座) – A tiny CLI for constellation facts

This repo contains a small, dependency‑free Python script that prints information about the Lyra constellation (天琴座). It can output a concise summary, specific sections (stars, deep sky objects, etc.), or the full dataset in human‑readable text or JSON.

## Features

- Zero dependencies, pure Python
- Human‑readable or JSON output
- Select specific sections (e.g., stars, deep_sky_objects, meteor_showers)
- Sensible default summary

## Quick Start

- Python 3.8+ recommended
- No installation needed—just run the script

```bash
python lyra.py              # summary (default)
python lyra.py --all        # print all sections
python lyra.py --all --json # full dataset as JSON
python lyra.py --section stars
python lyra.py --section deep_sky_objects --json
```

## Usage

```plain
usage: lyra [-h] [--all] [--section {deep_sky_objects,links,meteor_showers,mythology,neighbors,overview,stars,visibility}] [--json]

Print information about the Lyra constellation (天琴座).

options:
  -h, --help            show this help message and exit
  --all                 Print all sections (human-readable).
  --section {…}         Print one specific section.
  --json                Output JSON instead of human-readable text.
```

Sections include:

- `overview` – basic identifiers, coordinates, brightest star, area
- `stars` – brightest star and notable stars (e.g., Vega, β Lyrae / Sheliak, γ Lyrae / Sulafat, RR Lyrae)
- `deep_sky_objects` – M57 (Ring Nebula), M56
- `meteor_showers` – the Lyrids (peak ~April 21–22)
- `visibility` – best months, latitudes, where to look
- `neighbors` – nearby constellations
- `mythology` – brief myth background
- `links` – reference links

## Notes on Accuracy

Values (e.g., magnitudes, distances, RA/Dec bounds, area) are representative and rounded for readability. For precision work, consult primary catalogs or the IAU pages.

## License

MIT. See terms in your use case if embedding or redistributing.
