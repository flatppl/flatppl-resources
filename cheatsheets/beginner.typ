#import "theme.typ": *

#sheet(
  topic: "Beginner", title: "Parameters and likelihoods", accent: rgb("285c48"),
  formula: ("Conditional mean", [$mu_i = alpha + beta x_i$]),
  reference-title: "Predictions and variants",
  file: "examples/beginner.flatppl", example: "Linear regression",
  illustration: ("Prediction at a named point",
    "The mean follows y = 1 + x. Four observations lie just above or below the line.",
    [At `point`, `fitted` gives `[1, 2, 3, 4]`. The four residuals give `log_L` $approx -1.10317$ for $sigma = 0.5$.]),
  notes: (
    ("Declare the parameter domains", 9, 11, [
      Declare a free parameter on `S` with `elementof(S)`. The regression permits real coefficients and requires a positive scale. Each can vary before a prior is specified.
    ]),
    ("Bind the observations", 14, 17, [
      The dotted operations apply the predictor and Normal constructor across `x_data`. Declare all three inputs in `kernelof` and bind the four observations to its `y` field with `likelihoodof`.
    ]),
    ("A prior on the named parameters", 20, 25, [
      Give the prior draws `a`, `b` and `s` the field names used by the likelihood. `lawof` returns their joint law. `bayesupdate` weights it by `L` to give an unnormalized posterior.
    ]),
    ("Log likelihood and fitted means", 27, 32, [
      Pass all three parameters to `logdensityof` in one record. The mean depends only on the two coefficients. `functionof` therefore takes two inputs and returns the four fitted means at the original predictors.
    ]),
  ),
  variants: (
    entry("Starting from prior draws", [
      #code("alpha ~ Normal(0, 5)\nbeta ~ Normal(0, 2)\nsigma ~ LogNormal(0, 0.5)\nprior = lawof(record(alpha = alpha,\n    beta = beta, sigma = sigma))\nK = kernelof(record(y = y), alpha, beta, sigma)")
      #v(3pt)
      These draws replace the `elementof` bindings. Keep lines 14–15 and expose the three variates in `kernelof`.
    ]),
    entry("Bounds on the noise scale", [
      #code("domain = cartprod(alpha = reals, beta = reals,\n    sigma = interval(0.1, 2))")
      #v(3pt)
      The named product defines the search domain. Specifying a prior also assigns mass to subsets of that domain.
    ]),
  ),
  after-notes: (
    entry("Predict at a new input", [
      #code("mean_at(x, a, b) = a + b*x\npred = mean_at(5, point.alpha, point.beta)")
      #v(3pt)
      `f_mean` uses the four fixed `x_data` values. This helper also takes `x` as an argument and gives a mean of 6 at `x = 5`.
    ]),
  ),
  references: (
    entry("Change the observation family", [
      #code("rate = exp.(mu)\ny_count ~ Poisson.(rate)\np = invlogit.(mu)\ny_binary ~ Bernoulli.(p)")
      #v(3pt)
      Bind integer counts or binary responses under the corresponding field name in `likelihoodof`.
    ]),
    entry("Common and observation-specific means", [
      #code("ys ~ iid(Normal(alpha, sigma), 4)\nzs ~ Normal.(mu, sigma)")
      #v(3pt)
      All entries of `ys` have the same mean. Each entry of `zs` uses its corresponding mean in `mu`. In each case, the observations are conditionally independent.
    ]),
    entry("Field names and indices", [
      #code("r = record(a = 1, b = 2)\nu = r.a\nv = [1, 2, 3]\nw = v[1]")
      #v(3pt)
      Record fields have names. Array indices start at one. Each binding has a single definition within a module.
    ]),
    entry("Supply fixed inputs", [
      #code("n = external(posintegers)")
      #v(3pt)
      Supply `n` when loading the module. The suffix `_data` denotes a naming convention. Bind the observations with `likelihoodof`.

      Use `#` for a comment, `%` for documentation on a binding, and paired `%%%` lines for a documentation block.
    ]),
  ),
)
