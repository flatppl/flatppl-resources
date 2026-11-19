# Cheatsheet gallery

Run from the repository root with Typst, Bun, and Poppler installed.

```sh
make -C cheatsheets check-pdfs
bun gallery/build.mjs
python3 -u -m http.server 0 --bind 127.0.0.1 --directory build/gallery
```

Open the loopback URL printed by the server. Set `FLATPPL_THEME_DIR` to the FlatPPL theme checkout or an extracted theme release when it is outside the normal sibling location.

The gallery uses the same theme fragments and assets as the FlatPPL site. Assign each new sheet to a topic in `gallery/build.mjs`. Titles and descriptions come from the repository index. Previews and PDFs come from the same build.

GitHub Actions publishes `build/gallery/` at [learn.flatppl.org](https://learn.flatppl.org/). The PDFs come from the same build as the release downloads. The gallery opens them directly through GitHub Pages, as the [specification](https://spec.flatppl.org/) does. The workflow verifies the pinned theme archive before use.
