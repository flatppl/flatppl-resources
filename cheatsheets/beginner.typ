#import "theme.typ": *

#sheet(
  number: "02", title: "Beginner / modelling", topic: "First model",
  subtitle: "Build a regression graph, attach observations, and name the posterior. Assumes the distributions sheet.",
  accent: rgb("236d62"), file: "examples/beginner.flatppl",
  model_title: "A line with uncertain noise",
  model_note: [The file defines a graph. Text order does not determine evaluation order. Every module name has one binding.],
  notes: (
    (1, "Name the unknowns", 8, 10, [
      `~` creates a stochastic node. `=` creates a deterministic binding. A prior describes uncertainty before the observations enter the likelihood.
    ]),
    (2, "Describe every observation", 13, 14, [
      `.+` and `.*` work element by element. The scalar `sigma` serves every row. `Normal.(mu, sigma)` builds an array-valued product measure.
    ]),
    (3, "Attach data, then update", 22, 25, [
      `kernelof` holds the named parameters at its boundary. `likelihoodof` binds the observed record. `bayesupdate` weights the prior by that likelihood.
    ]),
  ),
  refs: (
    ref("Three objects to keep distinct", [
      *Variate:* `y` is a model value.\
      *Measure:* `prior` describes possible parameter records.\
      *Likelihood:* `L` scores parameters at the fixed observed data.
    ]),
    ref("The interface is a record", [
      The observation field is named `y` in both `K` and the data record. The parameter fields match the kernel's inputs.

      #code("logdensityof(L, point)")
      This returns a log-likelihood. Replace `L` with `posterior` to score the unnormalized posterior.
    ]),
    ref("Small syntax reference", [
      #code("a = 2 * b\nx ~ Normal(a, 1)\nr = record(a = a, x = x)\nv = [1.0, 2.0, 3.0]\nfirst = v[1]")
      Indexing starts at 1. Records give values names. Arrays collect values of a common structure.
    ]),
    ref("A parameter without a prior", [
      #code("mu = elementof(reals)")
      This declares a parameter domain. It does not assign a probability law. Use it for a likelihood-only model.
    ]),
    ref("Comments and documentation", [
      `#` starts a plain comment. `%` attaches a doc-comment to a binding. `%%%` fences a block doc-comment.
    ]),
  ),
  takeaway: [*Read the pipeline:* stochastic graph → `prior` + `K` → `L` at observed data → `posterior`. The posterior is a measure, not a set of draws.],
  sources: "Spec: Variates and measures · Kernels and kernelof · Likelihoods and posteriors",
)
