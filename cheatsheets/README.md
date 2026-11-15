# FlatPPL cheatsheets

Seven A4 landscape sheets combine a complete vertical example, four annotated excerpts, and related patterns.
The three core levels progress from complete simple models to hierarchy and explicit measure composition.
The domain sheets assume the relevant core levels and introduce physical conventions alongside the code.

| Sheet | Main example | Additional coverage |
| --- | --- | --- |
| [Distributions](distributions.pdf) | Scalar and array-valued draws | Supports, parameters, correlated vectors, simplex weights |
| [Beginner](beginner.pdf) | Complete linear regression | Counts, binary observations, likelihood-only parameters, named points |
| [Intermediate](intermediate.pdf) | Noncentered grouped logistic regression | Centered effects, eight schools, Beta–Binomial pooling, helpers, modules |
| [Advanced](advanced.pdf) | A measure-composed Normal–Gamma mixture | Products, intensities, transformations, callback parameters, Markov kernels |
| [Particle physics](particle-physics.pdf) | Two count channels with a shared nuisance | Templates, selection windows, point processes, calibration likelihoods |
| [Hadron physics](hadron-physics.pdf) | A 37-line Bose-symmetric Dalitz amplitude | Phase-space Jacobian, interference, efficiency, normalization |
| [Neutrino physics](neutrino-physics.pdf) | Two-flavour vacuum appearance | Three-flavour API, units, matter, response, physical limits |

[Read the full set](flatppl-cheatsheets.pdf).
The [example map](examples-map.md) covers all 29 curated corpus modules, their learning roles, and the reductions used here.

## Build and edit

Run `make` in this directory with Typst 0.15.1 or later. No Typst packages are required.
The fonts are Helvetica Neue with Arial fallback, DejaVu Sans Mono with Menlo fallback, and Typst's math fonts.

Each sheet has its own `.typ` source. `theme.typ` holds the shared layout, logo, colors, type, and code renderer.
The `.flatppl` files in `examples/` supply both the complete examples and the excerpts.
Update excerpt line ranges when changing the examples. The layout rejects columns that exceed the available height.

The layout follows the supplied Wren reference, with a separate slate, teal, ochre, and copper palette.
The build uses the repository root to load `branding/logo-rounded.svg`.

## Syntax highlighting

Code blocks use an unmodified copy of the [Sublime/syntect FlatPPL grammar at f3efb30](https://github.com/flatppl/flatppl-grammars/blob/f3efb30adf9990859b28f2c58ed505a3b0a43bea/sublime/flatppl.sublime-syntax), under its [MIT license](syntax/LICENSE.txt).
`syntax/flatppl.tmTheme` defines print colors. Typst's highlighted line elements preserve multiline lexical state while adding line numbers and excerpt markers.

## Language and model sources

The sheets follow FlatPPL 0.1 at specification commit `eed1724e276357d159a32f21b2ead7c5d709298a`:

- [Language design](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/04-design.md): variates, reification, calls, broadcasting, modules.
- [Canonical syntax](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/05-syntax.md): bindings, documentation, functions, indexing.
- [Measure algebra](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/06-measure-algebra.md): products, mixtures, weighted densities, kernels, conditioning, normalization.
- [Distributions](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/08-distributions.md): constructor signatures and parameterizations.

The [corpus map](examples-map.md) records the source revisions and model changes.
Adapted examples retain their [MIT license](examples/LICENSE.txt) and [attribution](examples/NOTICE.md).
The line breaks and comments are intentional. Lint with `flatppl lint --allow not-canonical --deny-warnings examples/*.flatppl`.

## Numerical scope

The main examples define complete FlatPPL models. Their point predictions and tractable likelihoods have direct numerical checks.
A model's existence does not imply that every engine supports its density, sampling, or normalization queries.
The Dalitz example's unnormalized weight has an independent four-vector check. Its parameter-dependent normalizer needs numerical integration.
The neutrino model is an illustrative two-flavour vacuum reduction with synthetic data, not an experimental likelihood.
