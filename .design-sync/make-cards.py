#!/usr/bin/env python3
"""Generate the Design System pane cards for the tokens-only sync.

Writes ds-bundle/components/<group>/<Name>/<Name>.html (first line is the
@dsCard marker the claude.ai/design pane reads) and ds-bundle/_ds_needs_recompile.
Run from the repo root after editing ds-bundle/tokens/*.css.
"""
import json
import os
import re

OUT = "ds-bundle"


def light_vars(path):
    css = open(os.path.join(OUT, path)).read().split("@media")[0]
    return re.findall(r"(--[a-z0-9-]+):\s*([^;]+);", css)


def page(group, viewport, title, body, extra_css=""):
    return f"""<!-- @dsCard group="{group}" viewport="{viewport}" -->
<!doctype html>
<html data-theme="light"><head><meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>{title}</title>
  <link rel="stylesheet" href="../../../styles.css">
  <style>
    body{{padding:24px;background:var(--background-primary)}}
    h1{{margin:0 0 16px}}
    .cols{{display:grid;grid-template-columns:1fr 1fr;gap:16px}}
    .pane{{padding:16px;border-radius:var(--radius-xl);background:var(--background-primary);color:var(--label-primary);border:1px solid rgba(127,127,127,.25)}}
    .pane-label{{margin:0 0 12px;color:var(--label-secondary)}}
    code{{font:12px/16px ui-monospace,SFMono-Regular,Menlo,monospace;color:var(--label-secondary)}}
    {extra_css}
  </style>
</head><body>
<h1 class="text-title2">{title}</h1>
{body}
</body></html>
"""


def write(group, name, html):
    d = os.path.join(OUT, "components", group, name)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, f"{name}.html"), "w").write(html)


def themed(inner):
    return "<div class='cols'>" + "".join(
        f"<div class='pane' data-theme='{t}'><p class='pane-label text-footnote'>{t.title()}</p>{inner}</div>"
        for t in ("light", "dark")
    ) + "</div>"


# Anxiety levels
LEVELS = [
    ("Minimal", "minimal", "0 – 1.5", "cloud.fill", "☁︎"),
    ("Mild", "mild", "1.5 – 2.5", "cloud.rain.fill", "🌧"),
    ("Moderate", "moderate", "2.5 – 3.5", "cloud.heavyrain.fill", "⛈"),
    ("Severe", "severe", "3.5 – 4", "cloud.bolt.rain.fill", "🌩"),
]
pills = "".join(
    f"<span class='pill text-headline' style='background:var(--system-{k})'>{n}</span>" for n, k, *_ in LEVELS
)
cards = "".join(
    f"<div class='lvl' style='background:var(--cards-{k})'><span class='text-headline'>{n}</span>"
    f"<span class='text-caption'>{r}</span></div>"
    for n, k, r, *_ in LEVELS
)
table = "".join(
    f"<tr><td class='text-subheadline'>{n}</td><td><code>{r}</code></td>"
    f"<td><code>--system-{k}</code></td><td><code>--cards-{k}</code></td><td><code>{sym}</code></td></tr>"
    for n, k, r, sym, _ in LEVELS
)
write("Brand", "AnxietyLevels", page(
    "Brand", "900x620", "Anxiety levels",
    themed(f"<div class='row'>{pills}</div><div class='lvls'>{cards}</div>")
    + f"<table><tr><th>Level</th><th>Range</th><th>Solid</th><th>Card fill</th><th>SF Symbol</th></tr>{table}</table>",
    ".row{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px}"
    ".pill{padding:var(--chip-padding);border-radius:var(--radius-2xl);color:var(--background-primary)}"
    ".lvls{display:grid;grid-template-columns:1fr 1fr;gap:8px}"
    ".lvl{height:72px;border-radius:var(--radius-xl);padding:12px;box-sizing:border-box;color:#fff;display:flex;flex-direction:column;justify-content:space-between}"
    "table{margin-top:16px;border-collapse:collapse;width:100%;color:var(--label-primary)}"
    "th{text-align:left;font:600 12px/16px var(--font-family);color:var(--label-secondary);padding:4px 8px 4px 0}"
    "td{padding:6px 8px 6px 0;border-top:1px solid rgba(127,127,127,.2)}",
))

# Color palette
GROUPS = [
    ("Surfaces", ["--background-primary", "--background-secondary", "--background-tertiary"]),
    ("Text", ["--label-primary", "--label-secondary"]),
    ("Accents", ["--accent", "--dark-blue", "--black-grey", "--black", "--system-blue", "--system-red"]),
]
known = dict(light_vars("tokens/colors.css"))
for _, names in GROUPS:
    for n in names:
        assert n in known, n


def swatches():
    return "".join(
        f"<p class='grp text-footnote'>{g}</p><div class='sw-grid'>"
        + "".join(f"<div class='sw'><div class='chip' style='background:var({n})'></div><code>{n}</code></div>" for n in names)
        + "</div>"
        for g, names in GROUPS
    )


write("Colors", "Palette", page(
    "Colors", "900x620", "Color palette", themed(swatches()),
    ".grp{margin:12px 0 6px;font-weight:600}"
    ".sw-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px}"
    ".sw{display:flex;gap:8px;align-items:center}"
    ".chip{flex:none;width:32px;height:32px;border-radius:var(--radius-md);border:1px solid rgba(127,127,127,.35)}",
))

# Typography
STYLES = ["large-title", "title", "title2", "title3", "headline", "body", "callout", "subheadline", "footnote", "caption"]
type_vars = dict(light_vars("tokens/typography.css"))
rows = "".join(
    f"<div class='ty'><code>.text-{s}<br>{type_vars['--text-' + s]} / {type_vars['--leading-' + s]}</code>"
    f"<span class='text-{s}'>How are you feeling today?</span></div>"
    for s in STYLES
)
write("Type", "Typography", page(
    "Type", "900x700", "Typography (SF Pro, iOS text styles)", rows,
    ".ty{display:grid;grid-template-columns:160px 1fr;gap:16px;align-items:baseline;padding:6px 0;border-top:1px solid rgba(127,127,127,.2)}",
))

# Radius and spacing
shape = light_vars("tokens/shape.css")
radii = "".join(
    f"<div class='r'><div class='box' style='border-radius:var({n})'></div><code>{n}<br>{v}</code></div>"
    for n, v in shape if n.startswith("--radius")
)
space = "".join(
    f"<div class='s'><code>{n}</code><div class='bar' style='width:var({n})'></div><code>{v}</code></div>"
    for n, v in shape if n.startswith("--space")
)
write("Spacing", "RadiusAndSpacing", page(
    "Spacing", "900x560", "Corner radius and spacing",
    f"<p class='text-headline'>Radius</p><div class='rs'>{radii}</div><p class='text-headline'>Spacing</p>{space}",
    ".rs{display:flex;flex-wrap:wrap;gap:16px}"
    ".r{display:flex;flex-direction:column;gap:6px;align-items:center;text-align:center}"
    ".box{width:72px;height:72px;background:var(--cards-mild)}"
    ".s{display:grid;grid-template-columns:90px 1fr 50px;gap:12px;align-items:center;padding:3px 0}"
    ".bar{height:12px;background:var(--system-moderate);border-radius:2px}",
))

open(os.path.join(OUT, "_ds_needs_recompile"), "w").write(json.dumps({"by": "design-sync-cli"}))
print("cards written")
