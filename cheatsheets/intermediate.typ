#import "theme.typ": *

#sheet(
  topic: "Intermediate", title: "Hierarchical models", accent: rgb("365d70"),
  formula: ("Group intercept", [$a_g = mu_a + tau z_g, quad z_g tilde.op cal(N)(0,1)$]),
  reference-title: "Indexing and pooling",
  file: "examples/intermediate.flatppl", example: "Grouped logistic regression",
  illustration: ("Group membership by observation",
    "Three intercepts a1, a2, a3 each feed two observations. In row order the result is a1, a2, a3, a1, a2, a3.",
    [`a[group_data]` repeats the existing group values. Rows 1 and 4 use the same `a[1]` each time the model is evaluated.]),
  notes: (
    ("Noncentered intercepts", 11, 15, [
      Draw `G` independent standard Normals for `z`. Multiply each entry by `tau` and add `mu_a`. Conditional on these population parameters, each intercept has mean `mu_a` and standard deviation `tau`.
    ]),
    ("Index the intercept by group", 18, 20, [
      Use the integer labels in `group_data` to select an intercept for each row of `x_data`. The dotted link gives one Bernoulli probability per row. The rows share a slope and the intercepts of their respective groups.
    ]),
    ("The hierarchical likelihood", 23, 28, [
      The prior has fields `mu_a`, `tau`, `z` and `beta`. Make all four variates inputs to `kernelof` to cut their prior dependencies. Then bind the observed outcomes with `likelihoodof`.
    ]),
    ("Supply the latent vector", 31, 33, [
      Supply all four fields, including the length-`G` latent vector. Setting `z` to zero sets every intercept to `mu_a`. The posterior log density includes the prior contribution.
    ]),
  ),
  after-notes: (
    entry("From latent coordinates to intercepts", [
      #code("f_a = functionof(a, mu_a, tau, z)\nintercepts = f_a(1, 2, [-1, 0, 1])")
      #v(3pt)
      The argument list in `functionof` sets the positional order. These values give the intercepts `[-1, 1, 3]`.
    ]),
  ),
  variants: (
    entry("Use centered coordinates", [
      #code("a ~ iid(Normal(mu_a, tau), G)")
      #v(3pt)
      Draw `a` directly and remove the affine transform of `z`. Substitute `a` for `z` in the prior record, kernel inputs and evaluation point. The conditional law of the intercepts is the same in both parameterizations.
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
      `phi` sets the population mean. At fixed `phi`, increasing `kappa` concentrates the group rates around that mean. Supply a trial total and a success count for each group.
    ]),
    entry("Call a reified function", [
      #code("f(a, b) = a + b\nu = f(1, 2)\nv = f(record(b = 2, a = 1))")
      #v(3pt)
      An explicit boundary accepts positional inputs. A matching record supplies named inputs when the callable cannot accept one positional argument.
    ]),
    entry("Group and observation indices", [
      Group labels range from one through `G`. The gathered intercepts, predictors and outcomes have one entry per observation. The arrays `z` and `a` have one entry per group.
    ]),
  ),
)
