#import "theme.typ": *
#sheet(
  number: "02", title: "Simple models", topic: "Beginner",
  subtitle: "Define parameters, vectorize observations, construct a likelihood and posterior, and evaluate a named point.",
  accent: rgb("236d62"), file: "examples/beginner.flatppl",
  model_title: "Complete regression model",
  model_note: [Parameter domains and priors are separate bindings.],
  model_refs: (
    ref("Stochastic parameter bindings", [
      #code("alpha ~ Normal(0,5)\nbeta ~ Normal(0,2)\nsigma ~ LogNormal(0,0.5)\nK = kernelof(record(y = y),\n    alpha, beta, sigma)")
      Use `lawof` on these prior variates.
    ]),
  ),
  notes: (
    (1, "Parameters and domains", 9, 11, [
      `elementof(S)` declares a parameter in set `S`. It assigns no prior. Here `alpha` and `beta` are real and `sigma` is positive. Values can vary between likelihood evaluations.
    ]),
    (2, "Observations and the likelihood", 14, 17, [
      Dots apply operations elementwise. `~` creates a variate. `kernelof` exposes the three `elementof` inputs and closes over fixed data. Observation fields and array shapes must match.
    ]),
    (3, "An optional prior and posterior", 20, 25, [
      The record names fields `alpha`, `beta`, and `sigma` to match the likelihood inputs. `bayesupdate` returns an unnormalized posterior. Omit this block for likelihood-only inference.
    ]),
    (4, "Scores and reusable predictions", 27, 29, [
      A likelihood point is a record, including for a single parameter. `logdensityof(L, point)` returns a log-likelihood. Lines 31–32 extract the fixed-data predictor as a function of the two coefficients.
    ]),
  ),
  notes_refs: (
    ref("A point and a parameter domain", color: graph-color, [
      #code("domain = cartprod(alpha = interval(-5,5),\n    beta = interval(-3,3),\n    sigma = interval(0.1,2))")
      A point supplies values. A domain describes a parameter set. Neither assigns prior mass or replaces observed data.
    ]),
  ),
  refs: (
    ref("Bindings and collections", [
      #code("v = [1, 2, 3]\nr = record(a = 1, b = 2)\nt = (1, 2)\nx = v[1]\nz = r.a")
      Indices start at 1. Records name fields. Tuples bundle objects. Module names have one binding and dependencies form an acyclic graph.
    ]),
    ref("Changing the observation family", [
      #code("rate = exp.(mu)\ny_count ~ Poisson.(rate)\np = invlogit.(mu)\ny_binary ~ Bernoulli.(p)")
      Use a predictor whose transformed values lie in the distribution's parameter domain. Bind the corresponding count or binary data in `likelihoodof`.
    ]),
    ref("IID and broadcast observations", [
      #code("ys ~ iid(Normal(alpha,sigma),\n    lengthof(y_data))\nzs ~ Normal.(mu,sigma)")
      The first repeats one distribution. The second varies its mean per observation. Independence is conditional on shared parameters.
    ]),
    ref("Priors and parameter domains", [
      #code("tau ~ normalize(truncate(\n    Cauchy(0, 2), interval(0, inf)))")
      `elementof(S)` specifies a domain, not a prior. A truncated prior needs normalization before a draw. Distribution parameters must remain valid throughout their domains.
    ]),
    ref("Documentation and fixed data", [
      `#` starts a discarded comment. `%` attaches documentation to one binding. `%%%` delimits block documentation. `_data` is a convention, not observation syntax.

      Literal data and `external` inputs are fixed. A caller supplies an `external` input at module load time.
    ]),
    ref("Authoring sequence", [
      Declare data and priors. Define predictors and observation variates. Retain all inferred parameters. Match kernel inputs and observation fields. Score a named point before inference.
    ]),
  ),
  takeaway: [After this sheet: author a complete simple Bayesian or likelihood-only model with explicit parameter domains.],
)
