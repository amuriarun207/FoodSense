#!/usr/bin/env python3
"""Export simulator captures to App Store Connect pixel sizes. No marketing frames."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
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

JOBS = [
    {
        "raw": ROOT / "AppStore" / "screenshots" / "raw",
        "outputs": [
            (ROOT / "AppStore" / "screenshots" / "1284x2778", (1284, 2778), True),
            (ROOT / "AppStore" / "screenshots" / "1242x2688", (1242, 2688), False),
        ],
        "drag": ROOT / "AppStore" / "screenshots",
    },
    {
        "raw": ROOT / "AppStore" / "screenshots" / "raw-ipad",
        "outputs": [
            (ROOT / "AppStore" / "screenshots" / "ipad" / "2064x2752", (2064, 2752), True),
            (ROOT / "AppStore" / "screenshots" / "ipad" / "2048x2732", (2048, 2732), False),
        ],
        "drag": ROOT / "AppStore" / "screenshots" / "ipad",
    },
]


def fit(im: Image.Image, size: tuple[int, int]) -> Image.Image:
    rgb = im.convert("RGB")
    if rgb.size == size:
        return rgb
    return rgb.resize(size, Image.Resampling.LANCZOS)


def export_set(raw: Path, outputs: list, drag: Path) -> None:
    if not raw.exists():
        print(f"skip (no folder): {raw}")
        return
    missing = [name for name in FILES if not (raw / name).exists()]
    if missing:
        print(f"skip {raw.name}: missing {', '.join(missing)}")
        return
    drag.mkdir(parents=True, exist_ok=True)
    for folder, size, is_primary in outputs:
        folder.mkdir(parents=True, exist_ok=True)
        for name in FILES:
            im = Image.open(raw / name)
            out = fit(im, size)
            out.save(folder / name, "PNG", optimize=True)
            if is_primary:
                out.save(drag / name, "PNG", optimize=True)
            print(f"{name}: {im.size} -> {size[0]}x{size[1]}")


def main() -> None:
    for job in JOBS:
        export_set(job["raw"], job["outputs"], job["drag"])


if __name__ == "__main__":
    main()
