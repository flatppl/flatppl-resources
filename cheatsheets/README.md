# FlatPPL cheatsheets

The collection contains eighteen worked examples and one CLI reference. Each occupies one A4 landscape page. Letters A–D mark the annotated passages in the worked examples.
Start with the rate model on the first page. The two tensor sheets can be read together before the detector-response example.
The three core levels progress from complete simple models to hierarchy and explicit measure composition.
The domain sheets assume the relevant core levels and introduce physical conventions alongside the code.

| Sheet | Main example | Additional coverage |
| --- | --- | --- |
| [Zero to hero](zero-to-hero.pdf) | Poisson counts with unequal exposures | Host data, positive rates, likelihoods, priors, prediction, and a conjugate check |
| [Distributions](distributions.pdf) | Scalar and array-valued draws | Supports, parameters, correlated vectors, simplex weights |
| [Beginner](beginner.pdf) | Complete linear regression | Parameter domains with `elementof`, optional priors, counts, binary observations, named points |
| [Intermediate](intermediate.pdf) | Noncentered grouped logistic regression | Centered effects, eight schools, Beta–Binomial pooling, helpers, modules |
| [Advanced](advanced.pdf) | A measure-composed Normal–Gamma mixture | Products, intensities, transformations, callback parameters, Markov kernels |
| [Einstein summation and reductions](einstein-reductions.pdf) | Two sensor calibrations over three runs | Predictions, squared residuals by run and sensor, Boolean reductions, and cross-products |
| [Metric Einstein summation](metric-einstein.pdf) | A sensor reports the sum of two coordinates | Mahalanobis distance, covariance, lower components, directional derivatives, and invariant mass |
| [Posterior prediction](posterior-prediction.pdf) | The beginner regression with known noise | Coefficient draws, predictive variance, pointwise intervals, and replicated data |
| [From a model to a fit](fitting-from-python.pdf) | Gaussian mean and precision from eight readings | External data, free coordinates, BFGS, and a closed-form estimate |
| [Rounded readings and detection flags](measurement.pdf) | A rounding cell and an independent threshold flag | CDF differences, Gaussian tails, conditional independence, and censoring |
| [Profiling and marginalization](profile-marginal.pdf) | One signal count and one control count | Joint likelihood, conditional background maximum, and a Gamma marginal |
| [Particle physics](particle-physics.pdf) | Two count channels with a shared nuisance | Templates, selection windows, point processes, calibration likelihoods |
| [Hadron physics](hadron-physics.pdf) | A 37-line Bose-symmetric Dalitz amplitude | Phase-space Jacobian, interference, efficiency, normalization |
| [Neutrino physics](neutrino-physics.pdf) | Two-flavour vacuum appearance | Three-flavour API, units, matter, response, physical limits |
| [Forward-folding a photon spectrum](gamma-ray-response.pdf) | Three true energies and two reconstructed bins | Quadrature, attenuation, exposure, migration, and losses |
| [From a decay law to a likelihood](decay-ode.pdf) | An exponential decay with three readings | Derivative callbacks, fixed-step integration, and measurement noise |
| [Two spins and a partition function](two-spins.pdf) | Four states of an Ising pair | Point masses, Boltzmann weights, degeneracy, and correlation |
| [FlatPPL for Python](python-sdk.pdf) | A two-input Normal log density | Loading, compilation, gradients, batching, external data, and free coordinates |
| [The FlatPPL CLI](cli.pdf) | Commands grouped by task | Diagnostics, type inference, conversion, code generation, module preparation, and ZIP bundles |

[Read the full set](flatppl-cheatsheets.pdf).
The [example map](examples-map.md) covers all 29 curated corpus modules, their learning roles, and the reductions used here.

## Build and edit

Run `make` in this directory with Typst 0.15.1 or later. No Typst packages are required.
Titles use Libertinus Serif. Body text uses Helvetica Neue with Arial as a fallback. Code uses DejaVu Sans Mono with Menlo as a fallback.

Each sheet has its own `.typ` source. `theme.typ` holds the shared layout, logo, colors, type, and code renderer.
The programs in `examples/` supply both the complete listings and the excerpts. The SDK and CLI sheets use the same five-line [query](examples/score.flatppl).
Update excerpt line ranges when changing the examples. The layout checks code widths, excerpt ranges and column heights.

The build loads the squircle logo from `branding/` and the finished figures from `figures/`.
To redraw the figures after changing the examples, run `python figures/draw.py` in this directory with Matplotlib and NumPy available. Then run `make`.
The combined PDF has a bookmark for each sheet. `sheets.txt` sets the build list, page order, and folios.

## Syntax highlighting

FlatPPL blocks use an unmodified copy of the [Sublime/syntect FlatPPL grammar at f3efb30](https://github.com/flatppl/flatppl-grammars/blob/f3efb30adf9990859b28f2c58ed505a3b0a43bea/sublime/flatppl.sublime-syntax), under its [MIT license](syntax/LICENSE.txt).
`syntax/flatppl.tmTheme` defines print colors. Typst's highlighted line elements preserve multiline lexical state while adding line numbers and excerpt markers.

## Language and model sources

The sheets follow FlatPPL 0.1 at specification commit `eed1724e276357d159a32f21b2ead7c5d709298a`:

- [Language design](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/04-design.md): variates, reification, calls, broadcasting, modules.
- [Canonical syntax](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/05-syntax.md): bindings, documentation, functions, indexing.
- [Measure algebra](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/06-measure-algebra.md): products, mixtures, weighted densities, kernels, conditioning, normalization.
- [Distributions](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/08-distributions.md): constructor signatures and parameterizations.

The [corpus map](examples-map.md) records the source revisions and model changes.
Adapted examples retain their [MIT license](examples/LICENSE.txt) and [attribution](examples/NOTICE.md).
Run `make check-examples` with the FlatPPL CLI on your path to lint all models and infer their types.
On first use, `flatppl prepare` fetches the pinned counts and ODE modules and their dependencies. In a terminal, the CLI asks for approval before downloading new URLs.
Once cached, the examples also work offline. Building the PDFs with `make` requires no downloads.
Run `python examples/fit.py` with the FlatPPL Python SDK, JAX, NumPy, and Optimistix to reproduce the host fit.
Run `python examples/python_sdk.py` with the FlatPPL Python SDK and JAX for the compiled score, gradient, and batch. Run the commands on the CLI reference from `examples/`.

## Numerical scope

The main examples define complete FlatPPL models. Their point predictions and tractable likelihoods have direct numerical checks.
A model's existence does not imply that every engine supports its density, sampling, or normalization queries.
The Dalitz example's unnormalized weight has an independent four-vector check. Its parameter-dependent normalizer needs numerical integration.
The neutrino model is an illustrative two-flavour vacuum reduction with synthetic data, not an experimental likelihood.
