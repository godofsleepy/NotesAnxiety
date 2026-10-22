# NotesAnxiety design tokens

NotesAnxiety is a native SwiftUI iOS journaling app. Each note is tagged with an anxiety level and categories. **This project ships tokens only, with no components.** Build UI with plain HTML/React and style it with the CSS variables below. Design for an iPhone screen (390px wide), using iOS conventions: large titles, inset grouped lists, bottom toolbars, and SF Symbols-style icons.

## Setup
Load `styles.css`. It `@import`s `tokens/colors.css`, `tokens/typography.css` and `tokens/shape.css`, and sets the `body` background, text color and font. Dark mode follows `prefers-color-scheme`. To force a mode, set `data-theme="dark"` or `data-theme="light"` on `<html>`. Read those three files before styling: they are the full vocabulary.

## Color: always `var(--*)`, never raw hex
- Surfaces: `--background-primary` (page), `--background-secondary` (#383838, dark panels), `--background-tertiary` (translucent scrim)
- Text: `--label-primary`, `--label-secondary` (70% opacity)
- Accents: `--accent`, `--dark-blue`, `--black-grey` (unselected chip fill), `--system-blue` (links, tint), `--system-red` (destructive actions)
- `--black` is off-white (#FEFFFF) despite its name. Use it only where the app does: as text on dark fills.

## Anxiety levels: the core of the brand
A level is a 0–4 value that is bucketed into four named levels. Each level has a solid color, a card fill and a weather icon:

| Level | Range | Solid | Card fill | Icon (SF Symbol) |
|---|---|---|---|---|
| Minimal | 0 to <1.5 | `--system-minimal` | `--cards-minimal` | cloud.fill |
| Mild | 1.5 to <2.5 | `--system-mild` | `--cards-mild` | cloud.rain.fill |
| Moderate | 2.5 to <3.5 | `--system-moderate` | `--cards-moderate` | cloud.heavyrain.fill |
| Severe | 3.5 to 4 | `--system-severe` | `--cards-severe` | cloud.bolt.rain.fill |

Use the solid color for icons, chart marks and status pills. Use the card fill for large translucent card backgrounds. Always show the level name or icon next to the color, never color alone.

## Typography
System font only (`--font-family`, SF Pro). Use the text-style classes `.text-large-title`, `.text-title`, `.text-title2`, `.text-title3`, `.text-headline`, `.text-body`, `.text-callout`, `.text-subheadline`, `.text-footnote` and `.text-caption`. For custom rules, use the `--text-*`/`--leading-*` pairs with `--font-weight-*`.

## Shape and spacing
Radii: `--radius-md` (8px, list cells and fields), `--radius-xl` (20px, cards), `--radius-2xl` (25px, chips and status pills). Spacing: `--space-1`…`--space-8`, and `--space-5` (16px) is the default screen padding. Chips use `--chip-padding`.

## Example: status pill and category chips
```html
<span style="display:inline-flex;gap:var(--space-1);align-items:center;padding:var(--chip-padding);
  border-radius:var(--radius-2xl);background:var(--system-moderate);color:var(--background-primary)"
  class="text-headline">☂︎ Moderate</span>

<button class="text-subheadline" style="border:0;padding:var(--chip-padding);border-radius:var(--radius-2xl);
  background:var(--black-grey);color:#fff">Work</button>   <!-- unselected -->
<button class="text-subheadline" style="border:0;padding:var(--chip-padding);border-radius:var(--radius-2xl);
  background:#fff;color:gray">Sleep</button>              <!-- selected -->
```
