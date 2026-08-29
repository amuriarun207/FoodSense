#!/usr/bin/env python3
"""Export simulator captures to App Store Connect pixel sizes. No marketing frames."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "AppStore" / "screenshots" / "raw"
OUT = ROOT / "AppStore" / "screenshots"
OUT_67 = OUT / "1284x2778"
OUT_65 = OUT / "1242x2688"

FILES = [
    "01-home.png",
    "02-search.png",
    "03-nutrition.png",
    "04-quantity.png",
    "05-health.png",
    "06-favorites.png",
    "07-categories.png",
    "08-settings.png",
    "09-spices.png",
    "10-offline.png",
]


def fit(im: Image.Image, size: tuple[int, int]) -> Image.Image:
    """High-quality resize to an exact App Store size. Aspect is nearly identical."""
    return im.convert("RGB").resize(size, Image.Resampling.LANCZOS)


def main() -> None:
    OUT_67.mkdir(parents=True, exist_ok=True)
    OUT_65.mkdir(parents=True, exist_ok=True)
    for name in FILES:
        src = RAW / name
        if not src.exists():
            raise SystemExit(f"missing {src}")
        im = Image.open(src)
        img67 = fit(im, (1284, 2778))
        img65 = fit(im, (1242, 2688))
        img67.save(OUT_67 / name, "PNG", optimize=True)
        img65.save(OUT_65 / name, "PNG", optimize=True)
        img67.save(OUT / name, "PNG", optimize=True)
        print(f"{name}: {im.size} -> 1284x2778 and 1242x2688")


if __name__ == "__main__":
    main()
