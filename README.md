<img src="branding/logo-rounded.svg" alt="FlatPPL" width="72" align="right">

# FlatPPL resources

Cheatsheets and brand assets for FlatPPL.

## Cheatsheets

Browse the [cheatsheet gallery](https://learn.flatppl.org/) to preview the sheets and open them in your browser.

Select a title to download its one-page PDF. Start with *Zero to hero* to write and check a first model.

| Sheet | Outcome |
| --- | --- |
| [Zero to hero](https://github.com/flatppl/flatppl-resources/releases/latest/download/zero-to-hero.pdf) | Write, score, and check a model from three counts |
| [Distributions](https://github.com/flatppl/flatppl-resources/releases/latest/download/distributions.pdf) | Construct scalar, vector, and product distributions |
| [Beginner: simple models](https://github.com/flatppl/flatppl-resources/releases/latest/download/beginner.pdf) | Author a complete Bayesian or likelihood-only model |
| [Intermediate: hierarchical models](https://github.com/flatppl/flatppl-resources/releases/latest/download/intermediate.pdf) | Author grouped and multilevel models |
| [Advanced: measure composition](https://github.com/flatppl/flatppl-resources/releases/latest/download/advanced.pdf) | Build models from measures and kernels |
| [The regression module](https://github.com/flatppl/flatppl-resources/releases/latest/download/regression-module.pdf) | Build a design matrix and choose a response law for continuous readings, counts or classes |
| [The formula API](https://github.com/flatppl/flatppl-resources/releases/latest/download/formula-api.pdf) | Translate equations into regression formulas for population terms, group effects, curves, and observation laws |
| [Einstein summation and reductions](https://github.com/flatppl/flatppl-resources/releases/latest/download/einstein-reductions.pdf) | Compare inputs and results for indexed products, axis permutations, and reductions |
| [Metric Einstein summation](https://github.com/flatppl/flatppl-resources/releases/latest/download/metric-einstein.pdf) | Recover the same squared distance after a change of sensor coordinates |
| [Posterior prediction](https://github.com/flatppl/flatppl-resources/releases/latest/download/posterior-prediction.pdf) | Distinguish uncertainty in a mean from a new reading |
| [Hidden Markov models](https://github.com/flatppl/flatppl-resources/releases/latest/download/hidden-markov.pdf) | Score three noisy readings, smooth the hidden states, and verify the result by enumerating paths |
| [From a model to a fit](https://github.com/flatppl/flatppl-resources/releases/latest/download/fitting-from-python.pdf) | Fit a FlatPPL likelihood from Python and verify the estimate |
| [Rounded readings and detection flags](https://github.com/flatppl/flatppl-resources/releases/latest/download/measurement.pdf) | Score the events an instrument actually reports |
| [Profiling and marginalization](https://github.com/flatppl/flatppl-resources/releases/latest/download/profile-marginal.pdf) | Profile or integrate a nuisance background |
| [Particle counting and spectra](https://github.com/flatppl/flatppl-resources/releases/latest/download/particle-physics.pdf) | Combine channels, nuisances, templates, and event intensities |
| [Hadron amplitudes and Dalitz plots](https://github.com/flatppl/flatppl-resources/releases/latest/download/hadron-physics.pdf) | Construct a Bose-symmetric amplitude and phase-space measure |
| [Neutrino oscillations](https://github.com/flatppl/flatppl-resources/releases/latest/download/neutrino-physics.pdf) | Connect propagation functions to observed counts |
| [Forward-folding a photon spectrum](https://github.com/flatppl/flatppl-resources/releases/latest/download/gamma-ray-response.pdf) | Predict detector counts from a true-energy spectrum |
| [From a decay law to a likelihood](https://github.com/flatppl/flatppl-resources/releases/latest/download/decay-ode.pdf) | Fit observations at selected solution times |
| [Two spins and a partition function](https://github.com/flatppl/flatppl-resources/releases/latest/download/two-spins.pdf) | Build and normalize a finite Gibbs measure |
| [FlatPPL for Python](https://github.com/flatppl/flatppl-resources/releases/latest/download/python-sdk.pdf) | Compile a query, differentiate it, and evaluate a batch with JAX |
| [The FlatPPL CLI](https://github.com/flatppl/flatppl-resources/releases/latest/download/cli.pdf) | Find commands for checking, converting, compiling, and packaging a model |

Each worked example occupies one A4 landscape page, with its complete program beside four annotated excerpts. The formula reference pairs equations with formula strings. The CLI reference groups commands by task.
Each PDF contains its example files as attachments. Specialist sheets assume the core language and can be read in any order.
The [authoring guide](cheatsheets/README.md) describes the layout. The [example map](cheatsheets/examples-map.md) traces the worked models to their sources.

## Branding

[branding/](branding/) contains copies of the logo, editable art, wordmark, and favicon set.
The sheets use the [rounded squircle badge](branding/logo-rounded.svg).
Brand assets use [CC BY 4.0](branding/LICENSE.txt).

## Build

GitHub Actions builds the sheets on Ubuntu and publishes each PDF in the [latest release](https://github.com/flatppl/flatppl-resources/releases/latest).
To build the same PDFs locally, use Typst 0.15.1 and Make.

```sh
make -C cheatsheets
```

The PDFs appear in `build/cheatsheets/`.
