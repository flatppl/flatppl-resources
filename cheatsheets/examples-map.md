# Examples and sheet coverage

The 29 curated FlatPPL modules map to the sheets below. Extension examples introduce further constructs and remain linked exercises.
The map uses [flatppl-examples at 3bb871d](https://github.com/flatppl/flatppl-examples/tree/3bb871d797db03434784d2683313880ac4493a7f/examples).

| Corpus module | Sheet or level | Language pattern |
| --- | --- | --- |
| [minimal.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/minimal.flatppl) | Distributions / beginner | Values, sets, draws, documentation, reification |
| [linear-regression.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/linear-regression.flatppl) | Beginner anchor | Complete prior–kernel–likelihood–posterior construction |
| [poisson-model.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/poisson-model.flatppl) | Beginner | Scalar rate and IID count observations |
| [capture-recapture.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/capture-recapture.flatppl) | Beginner | Bounded parameter and Binomial likelihood |
| [poisson-glm-link.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/poisson-glm-link.flatppl) | Beginner / intermediate | Named predictor, link function, deterministic broadcasting |
| [gamma-reparam.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/gamma-reparam.flatppl) | Beginner / intermediate | Record-valued helper and constructor auto-splatting |
| [best-estimation.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/best-estimation.flatppl) | Beginner extension | Two observation arrays, shared parameter, location-scale Student-t |
| [eight-schools.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/eight-schools.flatppl) | Intermediate | Centered latent array, hyperpriors, known observation errors |
| [hierarchical-logistic.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/hierarchical-logistic.flatppl) | Intermediate anchor | Group indexing, shared population, link function |
| [partial-pooling.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/partial-pooling.flatppl) | Intermediate | Mean/concentration parameterization and Beta–Binomial hierarchy |
| [rasch-1pl.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/rasch-1pl.flatppl) | Intermediate | Two index arrays, latent person/item effects, long-format data |
| [plant-growth-group-effects.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/plant-growth-group-effects.flatppl) | Intermediate / advanced extension | Identifiability, zerosum support, tilt onto a constrained base |
| [ordinal-cheese-tasting.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/ordinal-cheese-tasting.flatppl) | Advanced extension | Ordered support, tilt, cumulative probabilities, Multinomial counts |
| [normal-mixture.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/normal-mixture.flatppl) | Advanced | Table-valued component inputs, Dirichlet weights, ksuperpose |
| [dissimilar-mixture.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/dissimilar-mixture.flatppl) | Advanced anchor | Different component families, weighted superposition, normalization |
| [zero-inflated-binomial.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/zero-inflated-binomial.flatppl) | Advanced | Discrete mixture with a point-mass component |
| [bayesian_inference_1.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_1.flatppl) | Advanced | Explicit prior and measure-valued observation expression |
| [bayesian_inference_2.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_2.flatppl) | Advanced | Stochastic graph and explicit reification |
| [bayesian_inference_3.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_3.flatppl) | Advanced | Structural disintegration of a joint law |
| [bayesian_inference_4.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_4.flatppl) | Advanced | Restriction of the joint law to observed fields |
| [bayesian_inference_common.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_common.flatppl) | Intermediate / advanced support | Reusable functions and module composition |
| [bayesian_inference_priors.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/bayesian_inference_priors.flatppl) | Intermediate / advanced support | Imported prior measures |
| [ar1-noise-estimation.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/ar1-noise-estimation.flatppl) | Advanced | Markov kernel, trajectory measure, explicit callback parameters |
| [hgf-binary-2level.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/hgf-binary-2level.flatppl) | Advanced extension | Deterministic state recursion with scan |
| [hgf-binary-3level.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/hgf-binary-3level.flatppl) | Advanced extension | Larger state record and explicit scan parameters |
| [aggregates.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/aggregates.flatppl) | Einstein summation and reductions | Retained and reduced axes, output order, means, and products |
| [signal-background-counting.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/signal-background-counting.flatppl) | Particle physics anchor | Channel tables, nuisances, yields, count and spectrum terms |
| [resonance-chebyshev-mixture.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/resonance-chebyshev-mixture.flatppl) | Particle / hadron physics | Coherent amplitude, continuous base measure, incoherent backgrounds |
| [dminus-to-3pi-amplitude.flatppl](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/dminus-to-3pi-amplitude.flatppl) | Hadron physics anchor | Dalitz kinematics, spin factors, Bose symmetry, density weighting |

## Authoring outcomes

- **Beginner:** declare parameters and domains with `elementof`, define fixed data, vectorize an observation model, construct a likelihood, optionally assign a prior and posterior, and score a named point.
- **Intermediate:** define population and latent group variables, gather by group, choose centered or noncentered coordinates, and preserve the complete hierarchical interface.
- **Advanced:** construct a model from measures, combine components through products or superposition, compose kernels, transform or project a law, and condition or normalize the resulting measure.

## Reductions used in the sheets

| Sheet | Adaptation |
| --- | --- |
| [Simple models](beginner.pdf) | The regression structure remains. `elementof` declares the parameter domains first. Separate prior variates give a law over the same named inputs for an optional Bayesian update. Independent coefficient and LogNormal scale priors replace the original conjugate scale coupling. |
| [Hierarchical models](intermediate.pdf) | The grouped logistic predictor remains. Standard-Normal latent coordinates produce noncentered intercepts, with simpler scale and slope priors. |
| [Measure composition](advanced.pdf) | The Normal–Gamma mixture retains unknown weight and location. Component scale and Gamma parameters are fixed. Measures replace prior and observation draws. |
| [Particle counting](particle-physics.pdf) | Five-channel counts and event spectra reduce to two count channels and one shared background-scale nuisance. Spectral and point-process extensions occupy the reference column. |
| [Hadron physics](hadron-physics.pdf) | The 211-line Dalitz example reduces to 37 lines. Scalar invariant formulas replace four-vectors and spin tensors. Both identical-pion pairings remain, with one scalar resonance and a constant reference amplitude. |
| [Neutrino physics](neutrino-physics.pdf) | The three-flavour matter model reduces to a two-flavour vacuum formula. The example fits an angle and mass splitting to synthetic fixed-trial counts. Full propagation and detector conventions remain in the references. |

The intermediate parameterization also follows [the noncentered radon example](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/posteriordb/radon_variable_intercept_slope_noncentered.flatppl).

## Further worked examples

| Sheet | Source and adaptation |
| --- | --- |
| [Zero to hero](zero-to-hero.pdf) | The rate example adds unequal exposures, a named likelihood, a conjugate update and a predictive count to the [corpus Poisson model](https://github.com/flatppl/flatppl-examples/blob/3bb871d797db03434784d2683313880ac4493a7f/examples/poisson-model.flatppl). |
| [Einstein reductions](einstein-reductions.pdf) | The calibration example applies the corpus contraction to two sensors. Different output axes yield residual sums by run, means by sensor, and the matrix of sensor cross-products. [Multi-axis aggregation](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/04-design.md#sec:aggregate) |
| [Metric Einstein summation](metric-einstein.pdf) | A shear transforms the first calibration residual and its covariance. The Mahalanobis distance and its directional derivative provide checks on lowering and storage. The lower-output calculation follows the [metric tensor fixture](https://github.com/flatppl/flatppl-testsuite/blob/61aa59475e38700b4465580b56c448a594d06c31/corpora/coverage/metric_tensor/model.flatppl) and [metric-aware summation rules](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/04-design.md#sec:metricsum). |
| [Posterior prediction](posterior-prediction.pdf) | The four data pairs and coefficient priors come from the [beginner listing](examples/beginner.flatppl). Fixing the noise at 0.5 gives exact posterior and predictive intervals. |
| [From a model to a fit](fitting-from-python.pdf) | The eight readings and BFGS fit come from the [SDK Optimistix example](https://github.com/flatppl/flatppl-python/blob/d7d5881f85d46634124356c26ee7daff469f73f9/examples/optimistix_fit.py). Free parameters suffice for the likelihood fit. The [Python driver](examples/fit.py) checks the estimates against the sample moments. |
| [Rounded readings](measurement.pdf) | The two Gaussian event probabilities are written directly in FlatPPL. The instrument resolutions, rounding cell and flag come from the [coarsened measurement example](https://github.com/flatppl-community/flatppl-stats-measurement/blob/c296dc3b975be62fa759468881ee8fa568879a71/examples/coarsened.flatppl). |
| [Profiling and marginalization](profile-marginal.pdf) | The sheet uses the observations from the [single-bin lab](https://github.com/flatppl-community/flatppl-stats-counts/blob/4f0a6a8eedf0595d1d779fe6ba6a5579fa96eaf4/examples/lab.flatppl). It writes the joint count law explicitly and imports the background fit and exact Gamma marginal from the [counts module](https://github.com/flatppl-community/flatppl-stats-counts/tree/4f0a6a8eedf0595d1d779fe6ba6a5579fa96eaf4). |
| [Gamma-ray response](gamma-ray-response.pdf) | A matrix product exposes the attenuation, quadrature, and migration factors from the [synthetic ON/OFF spectrum](https://github.com/flatppl-community/flatppl-astro-gamma/blob/4ef7f6a001d6bf2701741653fa34a6a56019fe18/examples/synthetic-onoff.flatppl). The figure also accounts for lost counts. |
| [Decay ODE](decay-ode.pdf) | The sheet takes its three readings and time grid from the [decay playground](https://github.com/flatppl-community/flatppl-numerics-ode/blob/a56b4977b3ca4fced2e986bcbbdb6930b9d8c04a/examples/playground.flatppl). It imports the `vern7` solver from the [ODE module](https://github.com/flatppl-community/flatppl-numerics-ode/tree/a56b4977b3ca4fced2e986bcbbdb6930b9d8c04a). |
| [Two spins](two-spins.pdf) | An original four-atom Ising measure illustrates the [measure algebra](https://github.com/flatppl/flatppl-design/blob/eed1724e276357d159a32f21b2ead7c5d709298a/docs/06-measure-algebra.md#superpose). Direct enumeration checks both the partition function and each atom’s mass. |
| [FlatPPL for Python](python-sdk.pdf) | The [driver](examples/python_sdk.py) loads a [two-input query](examples/score.flatppl) based on the [Python SDK quickstart](https://github.com/flatppl/flatppl-python/blob/b88d0f3d1eb613a5d1f0a230d437272c997611e5/docs/quickstart.md). The value and derivative follow from the unit Normal density. |
| [The FlatPPL CLI](cli.pdf) | The [Rust driver](https://github.com/flatppl/flatppl-rust/tree/e0d7315a8fda955750335a2c5f6ea260f17f5583/crates/cli) supplies the commands. The examples use the Python sheet’s query, the ON/OFF model for bundles, and the rate model for Stan export. |

## Physics library references

- [flatppl-amplitudes at a522f9e](https://github.com/flatppl-community/flatppl-amplitudes/tree/a522f9ef883239faf81658c763f1f4bd180b5206): kinematics, lineshapes, angular factors, and larger amplitude models.
- [flatppl-physics-neutrinos at 6c8aa0e](https://github.com/flatppl-community/flatppl-physics-neutrinos/tree/6c8aa0eaa169e5b2046b44e5941392e3816a3566): three-flavour vacuum and matter propagation, matrix orientation, units, and mass conventions. Load its main.flatppl as nu for the full-library snippets.

The reduced Dalitz shape requires numerical integration for its parameter-dependent normalization. Defining that measure does not establish engine support for its normalized likelihood.
