---
name: visual-explainer-ja
description: Present a visual HTML report in Japanese with a fixed dark theme based on Japan's Digital Agency Design System. Use with Visual Explainer for standalone reports such as architecture explainers, review summaries, plans, recaps, and comparisons. Do not use for ordinary chat, Markdown reports, or figures that do not need an HTML page.
compatibility: Requires the visual-explainer skill and its HTML renderer.
---

# Visual Explainer in Japanese

1. Keep the analysis and drafting in the relevant pstack workflow. Carry its conclusion, evidence, sources, and caveats into [Visual Explainer](https://github.com/nicobailon/visual-explainer). Use Visual Explainer for page structure, figures, and rendering. If the upstream skill is missing, report the missing dependency rather than substituting a different renderer.
2. Set `lang="ja"` on the HTML document. Write titles, captions, figure labels, controls, and accessible names in Japanese. Keep identifiers, paths, commands, and quoted evidence as written. Follow an explicit request for a different language or theme.
3. For the default appearance, set `data-register="instrument"` on the document. Keep the kit marker, then inline [theme.css](assets/theme.css) in a `<style>` element after the marker. Use the supplied CSS variables for HTML and SVG, including links, chart labels, and status colors. Do not link to the local CSS file. Do not add a theme or font picker or switch palettes with the operating system.
4. Use the upstream browser check. Inspect the rendered page on desktop and at a narrow width. Check Japanese wrapping and glyphs, keyboard focus, and contrast for text and figure labels. Use words or shapes in addition to color for statuses. Share the rendered HTML, not the source template.

The theme adapts the Digital Agency Design System's [color guidance](https://design.digital.go.jp/dads/foundations/color), [typography](https://design.digital.go.jp/dads/foundations/typography), and [local design system guidance](https://design.digital.go.jp/dads/guidance/local-design-system). It is a workspace dark theme, not an official Digital Agency theme or a claim of accessibility conformance.
