<img src="branding/logo-rounded.svg" alt="FlatPPL" width="72" align="right">

# FlatPPL resources

Cheatsheets and brand assets for FlatPPL.

## Cheatsheets

Download the [complete 19-sheet collection](cheatsheets/flatppl-cheatsheets.pdf). [Zero to hero](cheatsheets/zero-to-hero.pdf) covers the steps for a first model.

| Sheet | Outcome |
| --- | --- |
| [Zero to hero](cheatsheets/zero-to-hero.pdf) | Write, score, and check a model from three counts |
| [Distributions](cheatsheets/distributions.pdf) | Construct scalar, vector, and product distributions |
| [Beginner: simple models](cheatsheets/beginner.pdf) | Author a complete Bayesian or likelihood-only model |
| [Intermediate: hierarchical models](cheatsheets/intermediate.pdf) | Author grouped and multilevel models |
| [Advanced: measure composition](cheatsheets/advanced.pdf) | Build models from measures and kernels |
| [Einstein summation and reductions](cheatsheets/einstein-reductions.pdf) | Compute calibration residuals by run, sensor, or sensor pair |
| [Metric Einstein summation](cheatsheets/metric-einstein.pdf) | Recover the same squared distance after a change of sensor coordinates |
| [Posterior prediction](cheatsheets/posterior-prediction.pdf) | Distinguish uncertainty in a mean from a new reading |
| [From a model to a fit](cheatsheets/fitting-from-python.pdf) | Fit a FlatPPL likelihood from Python and verify the estimate |
| [Rounded readings and detection flags](cheatsheets/measurement.pdf) | Score the events an instrument actually reports |
| [Profiling and marginalization](cheatsheets/profile-marginal.pdf) | Profile or integrate a nuisance background |
| [Particle counting and spectra](cheatsheets/particle-physics.pdf) | Combine channels, nuisances, templates, and event intensities |
| [Hadron amplitudes and Dalitz plots](cheatsheets/hadron-physics.pdf) | Construct a Bose-symmetric amplitude and phase-space measure |
| [Neutrino oscillations](cheatsheets/neutrino-physics.pdf) | Connect propagation functions to observed counts |
| [Forward-folding a photon spectrum](cheatsheets/gamma-ray-response.pdf) | Predict detector counts from a true-energy spectrum |
| [From a decay law to a likelihood](cheatsheets/decay-ode.pdf) | Fit observations at selected solution times |
| [Two spins and a partition function](cheatsheets/two-spins.pdf) | Build and normalize a finite Gibbs measure |
| [FlatPPL for Python](cheatsheets/python-sdk.pdf) | Compile a query, differentiate it, and evaluate a batch with JAX |
| [The FlatPPL CLI](cheatsheets/cli.pdf) | Find commands for checking, converting, compiling, and packaging a model |

Each worked example occupies one A4 landscape page, with its complete program beside four annotated excerpts. The CLI reference groups commands by task.
The [corpus map](cheatsheets/examples-map.md) links every curated example to the relevant level or domain.
[Sources and build instructions](cheatsheets/README.md) accompany the PDFs.

## Branding

[branding/](branding/) contains copies of the logo, editable art, wordmark, and favicon set.
The sheets use the [rounded squircle badge](branding/logo-rounded.svg).
Brand assets use [CC BY 4.0](branding/LICENSE.txt).

## Build

With Typst 0.15.1 or later:

```sh
make -C cheatsheets
```
