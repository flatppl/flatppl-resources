# FlatPPL cheatsheets

Four A4 landscape sheets pair a complete vertical example with excerpts, line references, and two columns of notes.
Rounded frames and tinted cards follow the supplied Wren reference, with a separate FlatPPL palette of slate, teal, ochre, and copper.
Each sheet includes the FlatPPL logo in a strongly rounded squircle badge.

| Sheet | Scope | Assumes |
| --- | --- | --- |
| [Distributions](distributions.pdf) | Parameters, supports, IID versus broadcast | Basic probability |
| [Beginner](beginner.pdf) | Regression, priors, observations, posterior assembly | Distributions |
| [Intermediate](intermediate.pdf) | Partial pooling, helpers, reification, modules | Beginner |
| [Advanced](advanced.pdf) | Likelihood and posterior scores, conditioning, prediction | Intermediate |

[Read the full set](flatppl-cheatsheets.pdf).

## Build

Run `make` in this directory with Typst 0.15.1 or later. No Typst packages are required.
The theme uses Helvetica Neue with Arial fallback, DejaVu Sans Mono with Menlo fallback, and Typst's math fonts.

Each sheet has its own `.typ` file. `theme.typ` holds the page layout, colors, type, code panels, and excerpt styles.
The build uses the repository root to load the logo from `branding/`.
The `.flatppl` files in `examples/` supply both the full examples and the excerpts. Edit those files, then update excerpt line ranges if needed.

## Language sources

The sheets follow FlatPPL 0.1 and the local specification at commit `eed1724e276357d159a32f21b2ead7c5d709298a`.

- [Language design](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/04-design.md): Variates and measures, Calling conventions, Reification to measures, Reification to functions and kernels, Kernels and `kernelof`, Broadcasting, Module composition.
- [Canonical syntax](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/05-syntax.md): Comments, Documentation, Named functions, Indexing and slicing.
- [Measure algebra](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/06-measure-algebra.md): Support restriction, Likelihoods and posteriors, Measure restriction, Dependent composition, Transformation and projection.
- [Built-in distributions](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/08-distributions.md): signatures and parameterizations.

The advanced sheet distinguishes language objects from engine query support. Its posterior mean and variance follow the Normal–Normal conjugate update.

The examples use deliberate line breaks and plain comments for the teaching layout. The canonical formatter removes those comments and rewrites the helper syntax.
Lint them with `flatppl lint --allow not-canonical --deny-warnings examples/*.flatppl`.
