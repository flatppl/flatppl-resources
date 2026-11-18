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
    ("Bind the observations", 15, 17, [
      `X` has four rows and one column. `reg.NormalGLM` takes one slope per column and returns a law for four responses. `kernelof` infers the three free inputs. Bind the data to its `y` field.
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
      Use these draws on lines 9–11. Keep lines 13–15. Use this `prior` and `K` with the original `L` and `posterior`.
    ]),
    entry("Bounds on the noise scale", [
      #code("domain = cartprod(alpha = reals, beta = reals,\n    sigma = interval(0.1, 2))")
      #v(3pt)
      This set contains parameter records with $0.1 <= sigma <= 2$.
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
      #code("y_count ~ reg.PoissonLogGLM(X, alpha, [beta])\ny_binary ~ reg.BernoulliLogitGLM(\n    X, alpha, [beta])")
      #v(3pt)
      The first constructor models the log mean of a count. The second models the log odds of a binary outcome. Pass the same design and slopes to either.
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
