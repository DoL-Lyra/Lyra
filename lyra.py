"""
Lyra constellation info CLI
---------------------------------

A small, dependency-free command line tool that prints facts about the
Lyra constellation. Run this file directly for a quick summary,
or pass flags to choose JSON or specific sections.

Examples:
  python lyra.py            # summary (default)
  python lyra.py --all      # all sections, human-readable
  python lyra.py --all --json
  python lyra.py --section stars
  python lyra.py --section deep_sky_objects --json
"""

from __future__ import annotations

import argparse
import json
from typing import Any, Dict, List


# Curated reference data about Lyra (天琴座)
LYRA_DATA: Dict[str, Any] = {
    "name": "Lyra",
    "chinese_name": "天琴座",
    "abbreviation": "Lyr",
    "genitive": "Lyrae",
    "symbolism": "the Lyre (harp)",
    "area_sq_deg": 286,  # IAU area ~286.5 sq. deg
    "quadrant": "NQ4",
    "right_ascension": "18h 14m to 19h 28m",
    "declination": "+25° to +47°",
    "brightest_star": {
        "name": "Vega (α Lyrae)",
        "magnitude": 0.03,
        "distance_ly": 25.0,
        "spectral_type": "A0V",
        "notes": (
            "Among the brightest stars in the night sky; part of the Summer Triangle."
        ),
    },
    "notable_stars": [
        {
            "name": "Sheliak (β Lyrae)",
            "type": "eclipsing binary variable",
            "magnitude": "3.4–4.3",
            "notes": "Prototype of β Lyrae-type variables.",
        },
        {
            "name": "Sulafat (γ Lyrae)",
            "type": "giant star",
            "magnitude": "3.25",
        },
        {
            "name": "δ Lyrae",
            "type": "multiple star system",
            "magnitude": "5.6",
        },
        {
            "name": "RR Lyrae",
            "type": "pulsating variable (RR Lyrae class)",
            "magnitude": "7.1–8.1",
            "notes": "Standard candle for the cosmic distance scale.",
        },
    ],
    "deep_sky_objects": [
        {
            "name": "M57 (Ring Nebula)",
            "type": "planetary nebula",
            "magnitude": 8.8,
            "distance_ly": 2300,
            "notes": "Iconic ring shape between β and γ Lyrae.",
        },
        {
            "name": "M56",
            "type": "globular cluster",
            "magnitude": 8.3,
            "distance_ly": 32700,
        },
    ],
    "meteor_showers": [
        {
            "name": "Lyrids",
            "peak": "April 21–22",
            "parent_body": "Comet C/1861 G1 (Thatcher)",
            "zenithal_hourly_rate": "~18",
            "notes": "Fast meteors with occasional fireballs.",
        }
    ],
    "neighbors": ["Cygnus", "Draco", "Hercules", "Vulpecula"],
    "visibility": {
        "best_months": "May–September (Northern Hemisphere)",
        "latitudes": "Visible between +90° and −40°; best in northern skies",
        "evening_appearance": "High from northeast to overhead in summer evenings",
    },
    "mythology": (
        "In Greek mythology, Lyra represents the lyre of Orpheus; after his death, "
        "Zeus placed the lyre among the stars."
    ),
    "links": {
        "iau": "https://www.iau.org/public/themes/constellations/",
        "wikipedia": "https://en.wikipedia.org/wiki/Lyra",
    },
}


SECTION_ALIASES = {
    "overview": [
        "name",
        "chinese_name",
        "abbreviation",
        "genitive",
        "symbolism",
        "area_sq_deg",
        "quadrant",
        "right_ascension",
        "declination",
        "brightest_star",
    ],
    "stars": ["brightest_star", "notable_stars"],
    "deep_sky_objects": ["deep_sky_objects"],
    "meteor_showers": ["meteor_showers"],
    "visibility": ["visibility"],
    "neighbors": ["neighbors"],
    "mythology": ["mythology"],
    "links": ["links"],
}


def _select_data_for_section(section: str) -> Dict[str, Any]:
    keys = SECTION_ALIASES.get(section)
    if not keys:
        raise KeyError(f"Unknown section: {section}")
    return {k: LYRA_DATA[k] for k in keys if k in LYRA_DATA}


def summary_text() -> str:
    b = LYRA_DATA["brightest_star"]
    lines = [
        f"{LYRA_DATA['name']} ({LYRA_DATA['chinese_name']}) — {LYRA_DATA['symbolism']}",
        f"Abbr.: {LYRA_DATA['abbreviation']}  Genitive: {LYRA_DATA['genitive']}  Quadrant: {LYRA_DATA['quadrant']}",
        f"RA: {LYRA_DATA['right_ascension']}   Dec: {LYRA_DATA['declination']}   Area: {LYRA_DATA['area_sq_deg']} sq. deg",
        f"Brightest star: {b['name']}  mag {b['magnitude']}  ~{b['distance_ly']} ly  ({b['spectral_type']})",
        f"Best months: {LYRA_DATA['visibility']['best_months']} — look for Vega, part of the Summer Triangle.",
    ]
    return "\n".join(lines)


def section_text(section: str) -> str:
    data = _select_data_for_section(section)
    lines: List[str] = [section.replace("_", " ").title()]
    lines.append("-" * len(lines[0]))
    for key, value in data.items():
        pretty_key = key.replace("_", " ").title()
        if isinstance(value, list):
            lines.append(f"{pretty_key}:")
            for item in value:
                if isinstance(item, dict):
                    head = item.get("name") or item.get("type") or "•"
                    details = ", ".join(
                        f"{k}={v}" for k, v in item.items() if k != "name"
                    )
                    lines.append(f"  - {head}{' — ' + details if details else ''}")
                else:
                    lines.append(f"  - {item}")
        elif isinstance(value, dict):
            lines.append(f"{pretty_key}:")
            for k, v in value.items():
                lines.append(f"  - {k}: {v}")
        else:
            lines.append(f"{pretty_key}: {value}")
    return "\n".join(lines)


def all_text() -> str:
    parts = [summary_text()]
    for sec in (
        "stars",
        "deep_sky_objects",
        "meteor_showers",
        "visibility",
        "neighbors",
        "mythology",
        "links",
    ):
        parts.append("")
        parts.append(section_text(sec))
    return "\n".join(parts)


def main(argv: List[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="lyra",
        description="Print information about the Lyra constellation (天琴座).",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Print all sections (human-readable).",
    )
    parser.add_argument(
        "--section",
        choices=sorted(SECTION_ALIASES.keys()),
        help="Print one specific section.",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output JSON instead of human-readable text.",
    )

    args = parser.parse_args(argv)

    if args.all:
        if args.json:
            print(json.dumps(LYRA_DATA, indent=2, ensure_ascii=False))
        else:
            print(all_text())
        return 0

    if args.section:
        try:
            data = _select_data_for_section(args.section)
        except KeyError as e:
            parser.error(str(e))
            return 2

        if args.json:
            print(json.dumps(data, indent=2, ensure_ascii=False))
        else:
            print(section_text(args.section))
        return 0

    # Default: summary
    if args.json:
        summary_obj = {
            "name": LYRA_DATA["name"],
            "chinese_name": LYRA_DATA["chinese_name"],
            "abbreviation": LYRA_DATA["abbreviation"],
            "brightest_star": LYRA_DATA["brightest_star"]["name"],
            "best_months": LYRA_DATA["visibility"]["best_months"],
        }
        print(json.dumps(summary_obj, indent=2, ensure_ascii=False))
    else:
        print(summary_text())
    return 0


if __name__ == "__main__":  # pragma: no cover - CLI entry point
    raise SystemExit(main())
