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
      `M1` and `M2` are measures on the real line. `M1` depends on the free location `mu`. The Gamma component has fixed shape and rate. Neither constructor introduces a variate.
    ]),
    ("Scale and add mass", 13, 14, [
      `weighted` scales each component's mass. `superpose` adds the two measures on their common event space. The complementary weights make the result a probability measure for every allowed `p`.
    ]),
    ("Build a kernel from a measure", 17, 21, [
      `iid` forms the product over observations. `joint` assigns the array to the field `y`. `functionof` turns the expression into a kernel with inputs `p` and `mu`. The independent prior has those same fields.
    ]),
    ("Keep, integrate or condition", 24, 29, [
      `jointchain` retains the parameters alongside `y`. `kchain` integrates them out. `disintegrate` splits the joint into a kernel for `y` and a prior. Fixing `y` with `restrict` gives the unnormalized posterior.
    ]),
  ),
  after-notes: (
    entry("Read the likelihood score", [
      At `point` the five observations contribute $sum_i log(p f_1(y_i)+(1-p) f_2(y_i)) approx -8.93513$. Each observation gets its own mixture sum before the log densities are added.
    ]),
  ),
  variants: (
    entry("Build a mixture from a table", [
      #code("components = table(mu = [-2, 2],\n    sigma = [0.7, 0.9])\nweights ~ Dirichlet([2, 2])\nM = ksuperpose(Normal, weights, components)")
      #v(3pt)
      Each row supplies one component's named constructor arguments. The simplex-valued draw supplies the weights.
    ]),
    entry("Keep the mass for an event process", [
      #code("I = superpose(weighted(ns, signal),\n    weighted(nb, background))\nevents ~ PoissonProcess(I)")
      #v(3pt)
      For unit-mass shapes, `ns + nb` is the expected event count. Normalizing `I` would discard this count information.
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
    entry("Project a joint law", [
      #code("mu_law = pushfwd(fn(get(_, [\"mu\"])),\n    joint_model)")
      #v(3pt)
      The projection keeps the named field. Evaluating its density can require integrating over the omitted variables.
    ]),
    entry("Compose sequential kernels", [
      #code("step(x, p) = Normal(p.rho*x, p.sigma)\npath = markovchain(step, 0.0, 20,\n    record(rho = 0.8, sigma = 0.2))")
      #v(3pt)
      The draw contains the 20 successive states after the initial value. Use `kscan` for a transition with an exogenous input at each step.
    ]),
  ),
)
