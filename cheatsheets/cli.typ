#import "theme.typ": *

#let accent = rgb("695638")
#let command(title, source, body) = entry(title, [
  #block(width: 100%, inset: (x: 5pt, y: 4pt),
    fill: accent.lighten(96%), stroke: (left: 1pt + accent))[
    #code(source, lang: "bash")
  ]
  #v(4pt)
  #body
])

#sheet-page("cli", "The FlatPPL CLI", "Command-line reference", accent,
  ("Command help", text(font: mono, size: 9.5pt, "flatppl <command> --help")),
  grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
    column("Write and check", (
      entry("The input file · score.flatppl", [
        #code(read("examples/score.flatppl").trim())
        #v(4pt)
        Run the commands from `cheatsheets/examples`. This query accepts a reading and a mean and returns a Normal log density.
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
          [`1`], [Formatting check found a change.],
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
        "flatppl prepare profile-marginal.flatppl", [
        The ON/OFF example uses the #module-link("flatppl-stats-counts", "4f0a6a8eedf0595d1d779fe6ba6a5579fa96eaf4")[counts module]. `prepare` caches its pinned imports after approval. Set `FLATPPL_CACHEDIR` to choose the cache. Inference can then run offline.
      ]),
      command("Import a likelihood",
        "flatppl convert --from pyhf ws.json fit.flatppl\nflatppl convert --from hs3 hs.json h.flatppl", [
        Supply a pyhf workspace or an HS³ document as the JSON input. Both importers require a CLI build with the `hs3` feature.
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
        "flatppl stan --target posterior \\\n  zero-to-hero.flatppl -o rate.stan \\\n  --data rate.json", [
        The rate model exports its named posterior and observed data. The CLI build needs the `stan` feature.
      ]),
      command("Pack a model",
        "flatppl pack profile-marginal.flatppl counts.zip", [
        Prepare remote imports first. The new archive includes the entry model, its imports, and referenced data.
      ]),
      command("Open a portable model",
        "flatppl infer counts.zip packed.flatpir\nflatppl unpack counts.zip counts-copy", [
        Inspect a ZIP directly, or extract it into a new directory to edit its contents. The entry file is `main.flatppl`.
      ]),
    ), accent),
  ),
)
