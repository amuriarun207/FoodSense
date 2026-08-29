#!/usr/bin/env python3
"""Normalize App Store icon (1024 RGB, no alpha) and launch logo (transparent emblem)."""

from pathlib import Path

from PIL import Image

ASSETS = Path("/Users/arunkumar/.cursor/projects/Users-arunkumar-workspace-FoodSense/assets")
ICON_SRC = ASSETS / "AppIcon-1024.png"
LOGO_SRC = ASSETS / "LaunchLogo.png"

ICON_DST = Path("/Users/arunkumar/workspace/FoodSense/FoodSense/Assets.xcassets/AppIcon.appiconset/AppIcon.png")
LOGO_DST = Path("/Users/arunkumar/workspace/FoodSense/FoodSense/Assets.xcassets/LaunchLogo.imageset/LaunchLogo.png")

BRAND = (27, 122, 67)  # #1B7A43


def flatten_icon(src: Path, dst: Path) -> None:
    image = Image.open(src).convert("RGBA")
    image = image.resize((1024, 1024), Image.Resampling.LANCZOS)
    canvas = Image.new("RGB", (1024, 1024), BRAND)
    canvas.paste(image, mask=image.split()[-1])
    dst.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(dst, format="PNG", optimize=True)
    print(f"Wrote icon {dst} mode={canvas.mode} size={canvas.size}")


def transparent_logo(src: Path, dst: Path) -> None:
    image = Image.open(src).convert("RGBA")
    image = image.resize((1024, 1024), Image.Resampling.LANCZOS)
    pixels = image.load()
    width, height = image.size
    samples = [
        pixels[8, 8][:3],
        pixels[width - 9, 8][:3],
        pixels[8, height - 9][:3],
        pixels[width - 9, height - 9][:3],
    ]
    bg = tuple(sum(c[i] for c in samples) // 4 for i in range(3))

    def near_background(rgb: tuple[int, int, int]) -> bool:
        return sum((a - b) ** 2 for a, b in zip(rgb, bg)) < 1400

    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if near_background((r, g, b)):
                pixels[x, y] = (r, g, b, 0)

    dst.parent.mkdir(parents=True, exist_ok=True)
    image.save(dst, format="PNG", optimize=True)
    print(f"Wrote launch logo {dst} mode={image.mode} size={image.size}")


if __name__ == "__main__":
    flatten_icon(ICON_SRC, ICON_DST)
    source = LOGO_SRC if LOGO_SRC.exists() else ICON_SRC
    transparent_logo(source, LOGO_DST)
