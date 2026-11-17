#import "theme.typ": *

#sheet(
  topic: "Advanced", title: "Measure composition", accent: rgb("70516f"),
  formula: ("Mixture measure", [$M = p M_1 + (1-p) M_2$]),
  reference-title: "Measure operators",
  file: "examples/advanced.flatppl", example: "A mixture of Normal and Gamma laws",
  illustration: ("A weighted sum of two densities",
    "At p = 0.4 and mu = −1, the density sums a weighted Normal and a weighted Gamma. Only the Normal contributes below zero.",
    [At `p = 0.4` and `mu = -1` the Normal carries 40% of the mass. Below zero the Gamma density vanishes and the sum follows the Normal contribution.]),
  notes: (
    ("Bind component measures", 11, 12, [
      `M1` and `M2` denote measures on the real line. The Normal location `mu` is free. The Gamma shape and rate are fixed. A constructor alone introduces no variate.
    ]),
    ("Mixture weights", 13, 14, [
      Scale the component masses with `weighted` and add them on their common event space with `superpose`. The weights sum to one for every admissible `p`.
    ]),
    ("Build a kernel from a measure", 17, 21, [
      `iid` forms the product over observations. Name the resulting array `y` with `joint`. The kernel returned by `functionof` takes `p` and `mu`. The independent prior uses the same field names.
    ]),
    ("Marginal and conditional laws", 24, 29, [
      `jointchain` retains both the parameters and `y`. `kchain` integrates out the parameters. `disintegrate` recovers a prior and a kernel for `y`. Fixing `y` with `restrict` gives the unnormalized posterior.
    ]),
  ),
  after-notes: (
    entry("Mixture log likelihood", [
      At `point` the five observations give $sum_i log(p f_1(y_i)+(1-p) f_2(y_i)) approx -8.93513$. Sum the component densities within each observation before taking its logarithm.
    ]),
  ),
  variants: (
    entry("Build a mixture from a table", [
      #code("components = table(mu = [-2, 2],\n    sigma = [0.7, 0.9])\nweights ~ Dirichlet([2, 2])\nM = ksuperpose(Normal, weights, components)")
      #v(3pt)
      Each table row supplies named constructor arguments for one component. Draw the vector of weights on the simplex.
    ]),
    entry("Project a joint law", [
      #code("mu_law = pushfwd(fn(get(_, [\"mu\"])),\n    joint_model)")
      #v(3pt)
      Projection retains the selected field. Its density may require integration over the omitted variables.
    ]),
  ),
  references: (
    entry("Transform a measure", [
      #code("f = bijection(exp, log, identity)\npositive = pushfwd(f, Normal(0, 1))")
      #v(3pt)
      Supply the forward map, inverse and forward log-volume. At $y>0$, the new log density is the old one at $log y$ minus $log y$.
    ]),
    entry("Weight a continuous base", [
      #code("base = Lebesgue(interval(-2, 2))\nw(x, p) = exp(-p.a * x^2)\nM = weighted(w, base, record(a = 2))")
      #v(3pt)
      `weighted` calls `w(x,p)`. `normalize(M)` divides by total mass and requires a finite, positive integral.
    ]),
    entry("Event intensity and total yield", [
      #code("I = superpose(weighted(6, M1),\n    weighted(4, M2))\nevents ~ PoissonProcess(I)")
      #v(3pt)
      The Normal and Gamma laws each have unit mass. Their weights give an expected event count of ten. Normalizing `I` gives the distribution of one event.
    ]),
    entry("Compose sequential kernels", [
      #code("step(x, p) = Normal(p.rho*x, p.sigma)\npath = markovchain(step, 0.0, 20,\n    record(rho = 0.8, sigma = 0.2))")
      #v(3pt)
      The draw contains the 20 successive states after the initial value. Use `kscan` for a transition with an exogenous input at each step.
    ]),
  ),
)
