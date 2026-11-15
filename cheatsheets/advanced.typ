#import "theme.typ": *
#sheet(
  number: "04", title: "Measure composition", topic: "Advanced",
  subtitle: "Construct mixtures, products, dependent laws, transformations, and sequential models from first-class measures.",
  accent: rgb("97583e"), file: "examples/advanced.flatppl",
  model_title: "A complete mixture model",
  model_note: [Sources: `dissimilar-mixture` and the `bayesian_inference` series.],
  model_refs: (
    ref("Many components from a table", [
      #code("components = table(mu = [-2,2],\n    sigma = [0.7,0.9])\nweights ~ Dirichlet([2,2])\nM = ksuperpose(Normal, weights, components)")
      Simplex weights give unit mass. Table columns bind constructor arguments by name. See `normal-mixture`.
    ]),
  ),
  notes: (
    (1, "Measures and explicit parameters", 7, 12, [
      `elementof` declares free parameters. A constructor yields a measure, without drawing a variate. Both component measures here act on real scalars, despite their different supports.
    ]),
    (2, "Weighted sum versus product", 13, 14, [
      `weighted` scales mass and `superpose` adds measures. These complement weights sum to one, so the mixture is normalized. General weights require `normalize`. `iid` forms the observation product.
    ]),
    (3, "Independent prior and observation kernel", 17, 21, [
      `joint` constructs an independent prior over named parameters. The observation kernel returns a record with field `y`. Its input record and the prior variate have the same field names.
    ]),
    (4, "Dependent composition and conditioning", 24, 29, [
      `jointchain` retains parameters and observations. `kchain` marginalizes the parameters. `disintegrate` recovers a kernel and marginal. `restrict` conditions the joint law without automatically normalizing it.
    ]),
  ),
  refs: (
    ref("Measure transformations", [
      #code("positive = pushfwd(exp, Normal(0,1))\nmu_law = pushfwd(fn(get(_, [\"mu\"])),\n    joint_model)")
      Transform values or project fields. A transformed density needs an inverse and volume element. A projected density can require marginalization.
    ]),
    ref("Finite intensity and event counts", [
      #code("I = superpose(weighted(ns, signal),\n    weighted(nb, background))\nevents ~ PoissonProcess(I)")
      With unit-mass component shapes, total intensity is `ns + nb`. Do not normalize an intensity whose mass represents an expected count.
    ]),
    ref("Support and density-defined measures", [
      #code("base = Lebesgue(interval(-2,2))\nM = normalize(weighted(\n    x -> exp(-x^4), base))")
      `weighted(f, M)` multiplies by a nonnegative density factor. Supply a domain with finite, positive total mass after weighting.
    ]),
    ref("Explicit callback parameters", [
      #code("w(x,p) = exp(-p.a * x^2)\nM = weighted(w, base, record(a = 2))")
      The optional final object becomes the callback's final argument. This keeps changing parameters explicit rather than closing over stochastic values.
    ]),
    ref("Sequential kernels", [
      #code("step(x,p) = Normal(p.rho*x,p.sigma)\npath = markovchain(step, 0.0, 20,\n    record(rho = 0.8, sigma = 0.2))")
      The trajectory excludes its initial value. `kscan` also supplies an exogenous value at each step. Independent broadcasting does not represent sequential dependence.
    ]),
    ref("Normalization and engine support", [
      `bayesupdate` and `restrict` preserve unnormalized mass. `totalmass` and `normalize` can require integration. A defined measure need not have a tractable density. A host tool performs optimization or sampling on the chosen target.
    ]),
  ),
  takeaway: [*Corpus:* `normal-mixture`, `dissimilar-mixture`, `bayesian_inference_1/3/4`, `ar1-noise-estimation`. After this sheet: construct and combine measure-valued models directly.],
  sources: "Corpus: dissimilar-mixture · normal-mixture · bayesian_inference_* · Spec: Measure algebra, Explicit callback parameters",
)
