#import "theme.typ": *

#sheet(
  topic: "Intermediate", title: "Hierarchical models", accent: rgb("365d70"),
  formula: ("Group intercept", [$a_g = mu_a + tau z_g, quad z_g tilde.op cal(N)(0,1)$]),
  reference-title: "Indexing and pooling",
  file: "examples/intermediate.flatppl", example: "Grouped logistic regression",
  illustration: ("Which rows use the new intercept?",
    "Group intercepts 0, 1 and 0 feed six observation rows. The highlighted branches connect group 2 to rows 2 and 5.",
    [At `point`, `a[group_data]` gives `[0, 1, 0, 0, 1, 0]`. Rows 2 and 5 share the intercept of 1. Their predictors differ.]),
  notes: (
    ("Noncentered intercepts", 11, 15, [
      Draw `G` independent standard Normals for `z`. Multiply each entry by `tau` and add `mu_a`. Conditional on these population parameters, each intercept has mean `mu_a` and standard deviation `tau`.
    ]),
    ("Index the intercept by group", 18, 18, [
      Change `z[2]` from 0 to 1 with $mu_a=0$ and $tau=beta=1$. Two rows gain one unit of log odds. Applying `invlogit` gives their success probabilities.
      #v(3pt)
      #lookup((auto, auto, 1fr, 1fr), ([Row], [$x_i$], [$z_2=0$], [$z_2=1$]), numeric: true,
        [2], [0.4], [0.599], [0.802],
        [5], [0.8], [0.690], [0.858])
    ]),
    ("The hierarchical likelihood", 23, 28, [
      The prior has fields `mu_a`, `tau`, `z` and `beta`. Make all four variates inputs to `kernelof` to cut their prior dependencies. Then bind the observed outcomes with `likelihoodof`.
    ]),
    ("Evaluate all six rows", 31, 36, [
      `predict(point)` returns the six probabilities in observation order. Set `z` to `[0, 0, 0]` on line 32 and evaluate again. Only entries 2 and 5 change. `log_L` scores the six observed outcomes at the same point.
    ]),
  ),
  variants: (
    entry("Use centered coordinates", [
      #code("a ~ iid(Normal(mu_a, tau), G)")
      #v(3pt)
      Replace the draw and transform of `z` with this draw of `a`. Use `a` in the prior, kernel and evaluation point. Its conditional law stays the same.
    ]),
    entry("Reuse the observation kernel", [
      #code("new_y = [0, 1, 0, 1, 1, 0]\nL_new = likelihoodof(K, record(y = new_y))")
      #v(3pt)
      Bind six new outcomes. `K` keeps the original groups, predictors and row order.
    ]),
  ),
  references: (
    entry("Known errors for each group", [
      #code("theta ~ iid(Normal(mu_a, tau), G)\ny_hat ~ Normal.(theta, [0.3, 0.2, 0.4])")
      #v(3pt)
      As in eight schools, each group has an uncertain effect and a known standard error. Here the three errors correspond to groups 1, 2 and 3.
    ]),
    entry("Pool success rates", [
      #code("phi ~ Beta(2, 2)\nkappa = 10\nrates ~ iid(Beta(phi*kappa, (1-phi)*kappa), G)\nhits ~ Binomial.([8, 12, 10], rates)")
      #v(3pt)
      `phi` sets the population mean. At fixed `phi`, increasing `kappa` concentrates the group rates around that mean. Supply a trial total and a success count for each group.
    ]),
    entry("Recover the group intercepts", [
      #code("f_a = functionof(a, mu_a, tau, z)\nintercepts = f_a(1, 2, [-1, 0, 1])")
      #v(3pt)
      At $mu_a=1$ and $tau=2$, these latent values give the intercepts `[-1, 1, 3]`. Gather from this vector with `group_data` to obtain one intercept per row.
    ]),
    entry("Shared and group intercepts", [
      The regression module’s `BernoulliLogitGLM` takes one shared intercept. Here `a[group_data]` supplies a separate intercept for each group. The dotted Bernoulli law uses the probability for each row.
    ]),
  ),
)
