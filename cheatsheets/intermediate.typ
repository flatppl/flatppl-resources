#import "theme.typ": *

#sheet(
  topic: "Intermediate", title: "Hierarchical models", accent: rgb("365d70"),
  formula: ("Group intercept", [$a_g = mu_a + tau z_g, quad z_g tilde.op cal(N)(0,1)$]),
  reference-title: "Indexing and pooling",
  file: "examples/intermediate.flatppl", example: "Grouped logistic regression",
  illustration: ("One intercept per observation",
    "Three intercepts a1, a2, a3 each feed two observations. In row order the result is a1, a2, a3, a1, a2, a3.",
    [`a[group_data]` repeats the existing group values. Rows 1 and 4 use the same `a[1]` each time the model is evaluated.]),
  notes: (
    ("Draw the group coordinates", 11, 15, [
      `z` contains `G` independent standard Normals. The scalar `tau` scales each entry and `mu_a` shifts it. Conditional on those two population parameters, each intercept has mean `mu_a` and standard deviation `tau`.
    ]),
    ("Index once per observation", 18, 20, [
      The integer array `group_data` selects one intercept for each row of `x_data`. The dotted link returns a probability per row. The Bernoulli product shares the slope and the group intercepts.
    ]),
    ("Expose the full hierarchy", 23, 28, [
      The prior contains `mu_a`, `tau`, `z` and `beta`. Naming the same four variates in `kernelof` cuts their prior dependencies at the boundary. `likelihoodof` then fixes the outcome array.
    ]),
    ("Supply the latent vector", 31, 33, [
      A point supplies all four inputs, including the length-`G` vector. With `z` zero, every intercept equals `mu_a`. `logdensityof(posterior, point)` also includes the prior log density.
    ]),
  ),
  after-notes: (
    entry("Extract the group transform", [
      #code("f_a = functionof(a, mu_a, tau, z)\nintercepts = f_a(1, 2, [-1, 0, 1])")
      #v(3pt)
      The explicit boundary fixes the positional order. These arguments give `[-1, 1, 3]`.
    ]),
  ),
  variants: (
    entry("Use centered coordinates", [
      #code("a ~ iid(Normal(mu_a, tau), G)")
      #v(3pt)
      Replace the `z` draw and its affine transform with this draw of `a`. Also replace `z` by `a` in the prior record, kernel boundary and score point. Both constructions give the same conditional law of the intercepts.
    ]),
    entry("Reuse a component", [
      #code("part = load_module(\"component.flatppl\")\nK_group = part.observation_kernel")
      #v(3pt)
      Export the reified kernel from the component. A caller can then bind new observations to the same kernel.
    ]),
  ),
  references: (
    entry("Known errors for each group", [
      #code("theta ~ iid(Normal(mu, tau), J)\ny ~ Normal.(theta, std_errs_data)")
      #v(3pt)
      In the eight-schools model each group has an uncertain effect and a known measurement error. Retain `mu`, `tau` and the full `theta` vector.
    ]),
    entry("Pool success rates", [
      #code("a_shape = phi * kappa\nb_shape = (1 - phi) * kappa\ntheta ~ iid(Beta(a_shape, b_shape), J)\ny ~ Binomial.(trials_data, theta)")
      #v(3pt)
      `phi` sets the population mean. At a fixed mean, larger `kappa` concentrates group rates more tightly. The data supply one trial total and one count per group.
    ]),
    entry("Call a reified function", [
      #code("f(a, b) = a + b\nu = f(1, 2)\nv = f(record(b = 2, a = 1))")
      #v(3pt)
      An explicit boundary accepts positional inputs. A matching record supplies named inputs when the callable cannot accept one positional argument.
    ]),
    entry("Check the array axes", [
      Group labels run from one through `G`. The gathered intercepts, predictor values and outcomes all have the observation axis. `z` and `a` have the group axis.
    ]),
  ),
)
