#import "theme.typ": *

#sheet(
  number: "04", title: "Measure algebra", topic: "Advanced",
  subtitle: "Reified laws, likelihood objects, conditioning, normalization, and kernel composition.",
  accent: rgb("97583e"), file: "examples/advanced.flatppl",
  model_title: "Measure operations on a stochastic graph",
  model_note: [Measures, kernels, and likelihoods are first-class objects. Density evaluation and numerical inference are separate operations on those objects.],
  notes: (
    (1, "Laws and kernels", 9, 11, [
      `prior` retains `mu`. `joint_model` retains both `mu` and `y`. The explicit boundary in `K` makes `mu` an input rather than a stochastic ancestor to marginalize.
    ]),
    (2, "Likelihood and restriction", 14, 17, [
      `likelihoodof` binds observed data to a kernel. `bayesupdate` weights the prior by the likelihood. `restrict` constructs the same unnormalized posterior directly from this joint law.
    ]),
    (3, "Normalization and composition", 25, 29, [
      `normalize` gives unit mass. `kchain` integrates over its input variate and retains the final output. The adapter `predict` extracts `mu` from the parameter record before calling `K`.
    ]),
  ),
  refs: (
    ref("Density evaluation", [
      #code("densityof(L, point)\nlogdensityof(L, point)\nlogdensityof(posterior, point)")
      A likelihood is an object, not an ordinary function. Its parameter point is a record, including for a single input. The last expression includes the prior density.
    ]),
    ref("Structural disintegration", [
      #code("K_alt, prior_alt = disintegrate(\n    [\"y\"], joint_model)")
      The selector names the observation fields. `disintegrate` returns a tuple containing the conditional kernel and the marginal measure on the remaining fields.
    ]),
    ref("Mass and normalization", [
      `bayesupdate` and `restrict` return unnormalized measures. `totalmass` evaluates the total mass of a closed measure. `normalize` requires finite, positive mass.

      In this example the posterior mass is the evidence. Its evaluation, and predictive density evaluation, may require integration that an engine cannot perform.
    ]),
    ref("Dependent composition", [
      #code("jointchain(prior, predict)\nkchain(prior, predict)")
      `jointchain` retains intermediate and final variates. `kchain` retains only the final variate. A kernel with one positional input receives a record whole, which motivates the adapter.
    ]),
    ref("Transformation and projection", [
      #code("pushfwd(exp, Normal(0, 1))\npushfwd(fn(get(_, [\"mu\"])),\n    joint_model)")
      `pushfwd` transforms a measure or projects selected fields. `fn` turns a hole expression, containing `_`, into a function.

      Density evaluation requires the inverse and volume element, or a marginalization procedure, as appropriate.
    ]),
  ),
  takeaway: [*Object interfaces:* `lawof` retains selected variates. `kernelof` exposes graph inputs. `likelihoodof` fixes observations. Measure operations act on the resulting objects.],
  sources: "Specification: Reification to measures · Likelihoods and posteriors · Structural disintegration · Dependent composition",
)
