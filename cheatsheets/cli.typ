#import "theme.typ": *

#let accent = rgb("695638")
#for file in ("score.flatppl", "ws.json", "hs.json", "r.formula.json") { attach-example("examples/" + file) }
#let command(title, source, body) = entry(title, [
  #block(width: 100%, inset: (x: 5pt, y: 4pt),
    fill: accent.lighten(96%), stroke: (left: 1pt + accent))[
    #code(source, lang: "bash")
  ]
  #v(4pt)
  #body
])

#sheet-page("The FlatPPL CLI", "Command-line reference", accent,
  ("Command help", text(font: mono, size: 9.5pt, "flatppl <command> --help")),
  grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
    column("Write and check", (
      entry("The input file · score.flatppl", [
        #code(read("examples/score.flatppl").trim())
        #v(4pt)
        Save this listing as `score.flatppl` in an empty folder. Run the commands there. The query scores a Normal reading. The posterior uses the observed value 1.
      ]),
      command("Check or apply formatting",
        "flatppl fmt --check score.flatppl\nflatppl fmt score.flatppl", [
        #lookup((auto, 1fr), ([Arguments to `fmt`], [Result]),
          [`--check FILE`], [Exit 1 if the file needs formatting.],
          [`FILE`], [Format the file in place.],
          [`-` or no path], [Format stdin to stdout.])
      ]),
      command("Check diagnostics",
        "flatppl lint --deny-warnings score.flatppl", [
        Promote warnings to errors for CI. Use `--allow`, `--warn`, or `--deny` with a rule name to set its level.
      ]),
      command("Find commands and flags",
        "flatppl --version\nflatppl --help\nflatppl help stablehlo\nflatppl completions zsh", [
        Top-level help lists the commands in the installed build. Subcommand help lists options and defaults. The last command prints a shell completion script.
      ]),
      entry("Read an exit status", [
        #table(columns: (auto, 1fr), stroke: none, inset: (x: 2pt, y: 2.4pt),
          [`0`], [Command succeeded.],
          [`1`], [Input, I/O or lint error, or formatting differs.],
          [`2`], [Invalid command-line option.],
          [`3`], [The chosen compiler cannot emit the model.])
      ]),
    ), accent),
    column("Inspect and convert", (
      command("Infer types and shapes",
        "flatppl infer score.flatppl typed.flatpir", [
        Each `--level` includes the preceding levels.
        #v(3pt)
        #lookup((auto, 1fr), ([Level], [Information added to FlatPIR]),
          [`phase`], [Binding phases],
          [`type`], [Structural types and literal dimensions],
          [`valueset`], [Strongest known value set],
          [`normalization`], [Mass classes for measures and kernels],
          [`shape` (default)], [Resolved fixed-phase dimensions])
      ]),
      command("Trace parameter dependence",
        "flatppl analyze --data-input x score.flatppl", [
        Mark `x` as data. The report identifies `mu` as the sole parameter component and shows which inputs each log-density term uses.
      ]),
      command("Convert or typeset a model",
        "flatppl convert score.flatppl score.flatpir\nflatppl convert typed.flatpir view.flatppl\nflatppl convert score.flatppl score.typ", [
        File extensions select the formats. Use `.flatpir.json` for JSON or `.tex`, `.typ`, `.md`, or `.html` for mathematical notation. `--no-header` omits the generated-file banner.
      ]),
      command("Fetch module dependencies",
        "flatppl prepare score.flatppl", [
        The printed model uses built-ins. For models with remote imports, `prepare` fetches and caches them after approval. Set `FLATPPL_CACHEDIR` to choose the cache for offline use.
      ]),
      command("Import a model",
        "flatppl convert --from pyhf ws.json fit.flatppl\nflatppl convert --from hs3 hs.json h.flatppl\nflatppl convert r.formula.json r.flatppl", [
        Extract the three JSON inputs from this PDF. The pyhf and HS³ importers use the `hs3` feature. Formula specifications use `formula`.
      ]),
    ), accent),
    column("Compile and share", (
      command("Emit deterministic source",
        "flatppl determinize --keep outputs \\\n  score.flatppl -o pure.flatppl", [
        Print deterministic FlatPDL in surface syntax. `--keep outputs` retains the selected binding and its dependencies. Use `--emit flatpir` for S-expressions.
      ]),
      command("Emit StableHLO",
        "flatppl stablehlo --dtype f64 \\\n  score.flatppl -o score.mlir", [
        The output is textual StableHLO. Sample mode requires a model with a sampling signature.
        #v(3pt)
        #lookup((auto, auto, 1fr), ([Option], [Default], [Alternative]),
          [`--mode`], [`logdensity`], [`sample`],
          [`--dtype`], [`f32`], [`f64`],
          [`--target`], [`cpu`], [`gpu`])
      ]),
      command("Export a Stan posterior",
        "flatppl stan --target posterior \\\n  score.flatppl -o mean.stan \\\n  --data mean.json", [
        The `stan` feature writes the model and its data. Stan sampling statements omit additive log-density terms independent of the parameters.
      ]),
      command("Pack a model",
        "flatppl pack score.flatppl score.flatppl.zip", [
        Prepare remote imports first. The new archive includes the entry model, its imports, and referenced data.
      ]),
      command("Open a portable model",
        "flatppl infer score.flatppl.zip packed.flatpir\nflatppl unpack score.flatppl.zip score-copy", [
        Inspect a ZIP directly, or extract it into a new directory to edit its contents. The entry file is `main.flatppl`.
      ]),
    ), accent),
  ),
)
