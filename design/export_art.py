"""Export editable SVG artwork to the PNG sizes used by the app."""

from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parent.parent
DESIGN = ROOT / "design"
MEDIA = ROOT / "entry/src/main/resources/base/media"
RENDERER = "rsvg-convert"


def render(svg_path: Path, png_path: Path, width: int, height: int) -> None:
    subprocess.run(
        [RENDERER, "--width", str(width), "--height", str(height),
         "--output", str(png_path), str(svg_path)],
        check=True,
    )


def glass_svg(level: int) -> str:
    # Five discrete states. The goal state deliberately leaves a little air.
    fill_fractions = (0.0, 0.25, 0.5, 0.75, 0.94)
    water_y = 386 - round(fill_fractions[level] * 274)
    water = ""
    if level > 0:
        water = f"""
        <g clip-path="url(#inside)">
          <path d="M65 {water_y} C112 {water_y - 12} 151 {water_y + 12} 200 {water_y}
                   S288 {water_y - 12} 335 {water_y} L335 428 H65 Z"
                fill="url(#water)"/>
          <path d="M65 {water_y} C112 {water_y - 12} 151 {water_y + 12} 200 {water_y}
                   S288 {water_y - 12} 335 {water_y}"
                fill="none" stroke="#D6FBFF" stroke-width="5" opacity=".9"/>
          <circle cx="146" cy="{water_y + 55}" r="9" fill="#D5FBFF" opacity=".66"/>
          <circle cx="249" cy="{water_y + 92}" r="6" fill="#D5FBFF" opacity=".58"/>
          <circle cx="197" cy="{water_y + 141}" r="5" fill="#D5FBFF" opacity=".5"/>
        </g>"""

    if level == 0:
        mouth = '<path d="M176 273 Q200 256 224 273" fill="none" stroke="#26165D" stroke-width="7" stroke-linecap="round"/>'
    elif level < 3:
        mouth = '<path d="M180 266 H220" fill="none" stroke="#26165D" stroke-width="7" stroke-linecap="round"/>'
    else:
        mouth = '<path d="M176 257 Q200 280 224 257" fill="none" stroke="#26165D" stroke-width="7" stroke-linecap="round"/>'

    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 480">
      <defs>
        <linearGradient id="water" x1="0" y1="0" x2=".75" y2="1" objectBoundingBox="true">
          <stop offset="0" stop-color="#A7F3FF"/>
          <stop offset=".4" stop-color="#00C9E5"/>
          <stop offset="1" stop-color="#1687CC"/>
        </linearGradient>
        <linearGradient id="glass" x1="0" y1="0" x2="1" y2=".8" objectBoundingBox="true">
          <stop offset="0" stop-color="#E8FAFF" stop-opacity=".94"/>
          <stop offset=".5" stop-color="#FFFFFF" stop-opacity=".2"/>
          <stop offset="1" stop-color="#D7EDFF" stop-opacity=".7"/>
        </linearGradient>
        <clipPath id="inside">
          <path d="M91 112 L116 382 Q200 409 284 382 L309 112 Z"/>
        </clipPath>
      </defs>
      <ellipse cx="200" cy="420" rx="111" ry="17" fill="#271369" opacity=".13"/>
      <path d="M82 97 L108 390 Q200 423 292 390 L318 97 Z"
            fill="url(#glass)"/>
      {water}
      <path d="M112 119 L132 362" fill="none" stroke="#FFFFFF" stroke-width="13"
            stroke-linecap="round" opacity=".75"/>
      <path d="M288 129 L270 350" fill="none" stroke="#FFFFFF" stroke-width="6"
            stroke-linecap="round" opacity=".36"/>
      <path d="M82 97 L108 390 Q200 423 292 390 L318 97"
            fill="none" stroke="#402080" stroke-width="8" stroke-linejoin="round" stroke-linecap="round"/>
      <ellipse cx="200" cy="97" rx="118" ry="20" fill="none"
               stroke="#402080" stroke-width="7"/>
      <circle cx="165" cy="237" r="5" fill="#26165D"/>
      <circle cx="235" cy="237" r="5" fill="#26165D"/>
      {mouth}
    </svg>""".replace("\n      \n", "\n")


def icon_svg() -> str:
    return """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
      <defs>
        <linearGradient id="tile" x1="0" y1="0" x2="1" y2="1" objectBoundingBox="true">
          <stop offset="0" stop-color="#261261"/>
          <stop offset="1" stop-color="#6024B5"/>
        </linearGradient>
        <linearGradient id="liquid" x1="0" y1="0" x2=".6" y2="1" objectBoundingBox="true">
          <stop offset="0" stop-color="#9FF3FF"/>
          <stop offset=".45" stop-color="#00C9E5"/>
          <stop offset="1" stop-color="#1687CC"/>
        </linearGradient>
        <clipPath id="inside"><path d="M149 151 L171 367 Q256 394 341 367 L363 151 Z"/></clipPath>
      </defs>
      <rect width="512" height="512" rx="104" fill="url(#tile)"/>
      <circle cx="410" cy="107" r="64" fill="#FF27B7" opacity=".2"/>
      <path d="M137 132 L164 378 Q256 410 348 378 L375 132 Z"
            fill="#F8F3FF" fill-opacity=".96"/>
      <g clip-path="url(#inside)">
        <path d="M124 214 C175 199 215 230 256 214 S341 200 388 214 L388 416 H124 Z"
              fill="url(#liquid)"/>
        <path d="M124 214 C175 199 215 230 256 214 S341 200 388 214"
              fill="none" stroke="#D8FBFF" stroke-width="6"/>
        <circle cx="206" cy="272" r="10" fill="#E8FDFF" opacity=".56"/>
        <circle cx="300" cy="302" r="6" fill="#E8FDFF" opacity=".56"/>
      </g>
      <path d="M168 171 L186 344" fill="none" stroke="#FFFFFF" stroke-width="12"
            stroke-linecap="round" opacity=".82"/>
      <path d="M137 132 L164 378 Q256 410 348 378 L375 132"
            fill="none" stroke="#261261" stroke-width="11" stroke-linejoin="round"/>
      <ellipse cx="256" cy="132" rx="119" ry="22" fill="none"
               stroke="#261261" stroke-width="9"/>
      <circle cx="224" cy="259" r="5" fill="#261261"/>
      <circle cx="288" cy="259" r="5" fill="#261261"/>
      <path d="M230 282 Q256 305 282 282" fill="none" stroke="#261261"
            stroke-width="7" stroke-linecap="round"/>
    </svg>"""


def main() -> None:
    icon = DESIGN / "app-icon.svg"
    icon.write_text(icon_svg(), encoding="utf-8")
    render(icon, ROOT / "AppScope/resources/base/media/icon.png", 512, 512)
    render(icon, MEDIA / "icon.png", 512, 512)
    render(icon, MEDIA / "startIcon.png", 256, 256)

    for level in range(5):
        source = DESIGN / f"glass-{level:02}.svg"
        source.write_text(glass_svg(level), encoding="utf-8")
        render(source, MEDIA / f"glass{level:02}.png", 400, 480)


if __name__ == "__main__":
    main()
