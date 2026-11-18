# FlatPPL cheatsheets

The collection contains nineteen worked examples and one CLI reference. Each occupies one A4 landscape page. Letters A–D mark the annotated passages in the worked examples.
Zero to Hero and the beginner, intermediate and advanced sheets each introduce a complete model. The specialist sheets assume the language covered in those four. Each introduces its own notation, data and model.

Each PDF includes its model in the attachments pane. The fitting sheet includes both the model and its Python script. The CLI sheet includes pyhf, HS³ and formula inputs. Save attachments in one folder to run them. The measurement, profiling and ODE models and the optional three-flavour example import pinned community modules.

| Sheet | Main example | Additional coverage |
| --- | --- | --- |
| [Zero to hero](https://github.com/flatppl/flatppl-resources/releases/latest/download/zero-to-hero.pdf) | Poisson counts with unequal exposures | Host data, positive rates, likelihoods, priors, prediction, and a conjugate check |
| [Distributions](https://github.com/flatppl/flatppl-resources/releases/latest/download/distributions.pdf) | Scalar and array-valued draws | Supports, parameters, correlated vectors, simplex weights |
| [Beginner](https://github.com/flatppl/flatppl-resources/releases/latest/download/beginner.pdf) | Linear regression in core FlatPPL | Parameter domains, dotted arithmetic and Normal draws, optional priors and named evaluation points |
| [Intermediate](https://github.com/flatppl/flatppl-resources/releases/latest/download/intermediate.pdf) | Noncentered grouped logistic regression | Centered effects, group measurement errors, Beta–Binomial pooling, and reuse of an observation kernel |
| [Advanced](https://github.com/flatppl/flatppl-resources/releases/latest/download/advanced.pdf) | A measure-composed Normal–Gamma mixture | Products, intensities, transformations, callback parameters, Markov kernels |
| [The regression module](https://github.com/flatppl/flatppl-resources/releases/latest/download/regression-module.pdf) | Pulse counts at two gain settings | A two-column design, Poisson rate ratios and all ten response constructors |
| [Einstein summation and reductions](https://github.com/flatppl/flatppl-resources/releases/latest/download/einstein-reductions.pdf) | Two sensor calibrations over three runs | Predictions, squared residuals by run and sensor, Boolean reductions, and cross-products |
| [Metric Einstein summation](https://github.com/flatppl/flatppl-resources/releases/latest/download/metric-einstein.pdf) | A sensor reports the sum of two coordinates | Mahalanobis distance, covariance, lower components, directional derivatives, and invariant mass |
| [Posterior prediction](https://github.com/flatppl/flatppl-resources/releases/latest/download/posterior-prediction.pdf) | The beginner regression with known noise | Coefficient draws, predictive variance, pointwise intervals, and replicated data |
| [From a model to a fit](https://github.com/flatppl/flatppl-resources/releases/latest/download/fitting-from-python.pdf) | Gaussian mean and precision from eight readings | External data, free coordinates, BFGS, and a closed-form estimate |
| [Rounded readings and detection flags](https://github.com/flatppl/flatppl-resources/releases/latest/download/measurement.pdf) | A rounding cell and an independent threshold flag | CDF differences, Gaussian tails, conditional independence, and censoring |
| [Profiling and marginalization](https://github.com/flatppl/flatppl-resources/releases/latest/download/profile-marginal.pdf) | One signal count and one control count | Joint likelihood, conditional background maximum, and a Gamma marginal |
| [Particle physics](https://github.com/flatppl/flatppl-resources/releases/latest/download/particle-physics.pdf) | Two count channels with a shared nuisance | Templates, selection windows, point processes, calibration likelihoods |
| [Hadron physics](https://github.com/flatppl/flatppl-resources/releases/latest/download/hadron-physics.pdf) | A 37-line Bose-symmetric Dalitz amplitude | Phase-space Jacobian, interference, efficiency, normalization |
| [Neutrino physics](https://github.com/flatppl/flatppl-resources/releases/latest/download/neutrino-physics.pdf) | Two-flavour vacuum appearance | Three-flavour API, units, matter, response, physical limits |
| [Forward-folding a photon spectrum](https://github.com/flatppl/flatppl-resources/releases/latest/download/gamma-ray-response.pdf) | Three true energies and two reconstructed bins | Quadrature, attenuation, exposure, migration, and losses |
| [From a decay law to a likelihood](https://github.com/flatppl/flatppl-resources/releases/latest/download/decay-ode.pdf) | An exponential decay with three readings | Derivative callbacks, fixed-step integration, and measurement noise |
| [Two spins and a partition function](https://github.com/flatppl/flatppl-resources/releases/latest/download/two-spins.pdf) | Four states of an Ising pair | Point masses, Boltzmann weights, degeneracy, and correlation |
| [FlatPPL for Python](https://github.com/flatppl/flatppl-resources/releases/latest/download/python-sdk.pdf) | A two-input Normal log density | Raw-string models, formulas, portable ZIPs, gradients, batching and inference targets |
| [The FlatPPL CLI](https://github.com/flatppl/flatppl-resources/releases/latest/download/cli.pdf) | Commands grouped by task | Diagnostics, type inference, conversion, code generation, module preparation, and ZIP bundles |

Each title links to its PDF in the [latest release](https://github.com/flatppl/flatppl-resources/releases/latest).
The [example map](examples-map.md) covers all 29 curated corpus modules, their learning roles, and the reductions used here.

## Build and edit

Run `make` in this directory with Typst 0.15.1 to build the PDFs in `../build/cheatsheets/`.
Run `make check-pdfs` with Poppler installed to verify that each sheet fits on one page.
Body text uses [Liberation Sans 2.1.5](https://github.com/liberationfonts/liberation-fonts), included under the [SIL Open Font License](fonts/LICENSE.txt).
Typst supplies Libertinus Serif for titles, DejaVu Sans Mono for code and New Computer Modern Math for equations.

Each sheet has its own `.typ` source. `theme.typ` holds the shared layout, logo, colors, type, and code renderer.
The programs in `examples/` supply the listings and PDF attachments. The SDK script defines its query inline. The [CLI model](examples/score.flatppl) declares both a query and a posterior.
Update excerpt line ranges when changing the examples. The layout checks code widths, excerpt ranges and column heights.

The build loads the squircle logo from `branding/` and the finished figures from `figures/`.
To redraw the figures after changing the examples, run `python figures/draw.py` in this directory with Matplotlib and NumPy available. Then run `make`.
List each sheet in `sheets.txt` for the Linux build and release. Each sheet credits Jessica Cox in its lower-right margin.

## Syntax highlighting

FlatPPL blocks use an unmodified copy of the [Sublime/syntect FlatPPL grammar at 5c48c5b](https://github.com/flatppl/flatppl-grammars/blob/5c48c5b2f162bd16ec754cfd164db0bd7f815a3d/sublime/flatppl.sublime-syntax), under its [MIT license](syntax/LICENSE.txt).
`syntax/flatppl.tmTheme` defines print colors. Typst's highlighted line elements preserve multiline lexical state while adding line numbers and excerpt markers.

## Language and model sources

The sheets follow FlatPPL 0.1 at specification commit `42242456ad06657b3348919402740df3db9788c1`:

- [Language design](https://github.com/flatppl/flatppl-design/blob/42242456ad06657b3348919402740df3db9788c1/docs/04-design.md): variates, reification, calls, broadcasting, modules.
- [Canonical syntax](https://github.com/flatppl/flatppl-design/blob/42242456ad06657b3348919402740df3db9788c1/docs/05-syntax.md): bindings, documentation, functions, indexing.
- [Measure algebra](https://github.com/flatppl/flatppl-design/blob/42242456ad06657b3348919402740df3db9788c1/docs/06-measure-algebra.md): products, mixtures, weighted densities, kernels, conditioning, normalization.
- [Distributions](https://github.com/flatppl/flatppl-design/blob/42242456ad06657b3348919402740df3db9788c1/docs/08-distributions.md): constructor signatures and parameterizations.
- [Standard modules](https://github.com/flatppl/flatppl-design/blob/42242456ad06657b3348919402740df3db9788c1/docs/09-standard-modules.md) define the matrix regression laws and two-body kinematics used here.

The [corpus map](examples-map.md) records the source revisions and model changes.
Adapted examples retain their [MIT license](examples/LICENSE.txt) and [attribution](examples/NOTICE.md).
Run `make check-examples` with the FlatPPL CLI on your path to lint all models and infer their types.
On first use, `flatppl prepare` fetches the pinned measurement, counts, ODE and neutrino modules and their dependencies. In a terminal, the CLI asks for approval before downloading new URLs.
Once cached, the examples also work offline. Building the PDFs with `make` requires no downloads.
Run `python examples/fit.py` with the FlatPPL Python SDK, JAX, NumPy, and Optimistix to reproduce the host fit.
Run `python examples/python_sdk.py` with the FlatPPL Python SDK and JAX for the compiled score, gradient, and batch. Test the CLI reference in a fresh folder containing `score.flatppl`, `ws.json`, `hs.json` and `r.formula.json` from its PDF.

## Numerical scope

The main examples define complete FlatPPL models. Their point predictions and tractable likelihoods have direct numerical checks.
A model's existence does not imply that every engine supports its density, sampling, or normalization queries.
The Dalitz example's unnormalized weight has an independent four-vector check. The JS engine requires external quadrature for this normalizer. At `p0` the integral is 1.17878135 and the first event has log density −0.52870.
The neutrino model is an illustrative two-flavour vacuum reduction with synthetic data, not an experimental likelihood.
