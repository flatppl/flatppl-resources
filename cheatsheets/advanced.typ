#import "theme.typ": *

#sheet(
  number: "04", title: "Advanced / inference", topic: "Scores and prediction",
  subtitle: "Choose the measure to score or predict from. Assumes model construction and reification.",
  accent: rgb("97583e"), file: "examples/advanced.flatppl",
  model_title: "One model, several inference objects",
  model_note: [FlatPPL defines the inference objects. A host tool selects and runs an optimizer, sampler, or integration method.],
  notes: (
    (1, "Two routes to a posterior", 9, 17, [
      `bayesupdate` combines a prior and likelihood. `restrict` conditions the joint law on `y`. Both retain `mu` and produce the same unnormalized posterior here.
    ]),
    (2, "Choose the scoring target", 20, 22, [
      `log_L` scores the likelihood. `log_post` also includes the prior density. Even a one-parameter likelihood takes a named parameter record.
    ]),
    (3, "Predict through the kernel", 25, 31, [
      `normalize` gives a probability measure. `predict` passes the record's `mu` field to `K`. `kchain` integrates over parameters and keeps four new observations.
    ]),
  ),
  refs: (
    ref("Know the normalizing constant", [
      `posterior` has density $L(mu) pi(mu)$. Its mass is the evidence $Z$. `post_prob` has density $L(mu) pi(mu) / Z$.

      Relative posterior scores do not need $Z$. A normalized posterior density does.
    ]),
    ref("An exact check for this example", [
      The prior variance is 4. The noise variance is 1. There are four observations with mean 1.

      $ v = (1/4 + 4)^(-1) = 4/17 $
      $ m = v (0/4 + 4 times 1) = 16/17 $
      The posterior marginal for `mu` is `Normal(16/17, sqrt(4/17))`.
    ]),
    ref("Joint, marginal, or predictive?", [
      #code("lawof(record(mu = mu, y = y))\nlawof(record(y = y))\nkchain(post_prob, predict)")
      The joint law retains `mu` and `y`. The prior predictive integrates out `mu`. The posterior predictive instead uses the updated parameter law.
    ]),
    ref("A changed coordinate needs a density", [
      `pushfwd(f, M)` transforms a measure. A bijective transform's density needs its inverse and volume element. `bijection` can supply both.

      A deterministic function from `functionof` alone does not define a prior on its inputs.
    ]),
    ref("Check the engine's query support", [
      Normalization, evidence, and predictive densities can require integration. Engines may refuse unsupported queries. Defining a measure does not promise a closed-form density.
    ]),
  ),
  takeaway: [*Choose a target:* maximum likelihood uses `L`. MAP and posterior samplers use `posterior`. Prediction uses a parameter probability law followed by `K`.],
  sources: "Spec: Likelihoods and posteriors · Measure restriction · Dependent composition",
)
