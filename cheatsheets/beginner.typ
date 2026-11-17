#import "theme.typ": *

#sheet(
  number: "02", topic: "Beginner", title: "Parameters and likelihoods", accent: rgb("285c48"),
  formula: ("Conditional mean", [$mu_i = alpha + beta x_i$]),
  reference-title: "Predictions and variants",
  file: "examples/beginner.flatppl", example: "Linear regression",
  illustration: ("Prediction at a named point",
    "The mean follows y = 1 + x. Four observations lie just above or below the line.",
    [At `point`, `fitted` gives `[1, 2, 3, 4]`. The four residuals give `log_L` $approx -1.10317$ for $sigma = 0.5$.]),
  notes: (
    ("Declare the parameter domains", 9, 11, [
      `elementof(S)` introduces a free input with values in `S`. The scale must be positive. A caller can already vary these inputs without specifying a prior.
    ]),
    ("Bind the observations", 14, 17, [
      The dots apply the predictor and the Normal constructor across `x_data`. `kernelof` exposes the three free inputs. `likelihoodof` fixes the kernel's field `y` to the four observed responses.
    ]),
    ("Attach a prior", 20, 25, [
      The draws `a`, `b` and `s` acquire the likelihood's input names in the record. `lawof` takes their joint law. `bayesupdate` weights that law by `L`, giving an unnormalized posterior.
    ]),
    ("Score a point and predict", 27, 32, [
      `logdensityof` takes the full parameter record. `functionof` exposes only the two coefficients used by `mu`. Its result is a length-four vector on the original predictor values.
    ]),
  ),
  variants: (
    entry("Starting from prior draws", [
      #code("alpha ~ Normal(0, 5)\nbeta ~ Normal(0, 2)\nsigma ~ LogNormal(0, 0.5)\nprior = lawof(record(alpha = alpha,\n    beta = beta, sigma = sigma))\nK = kernelof(record(y = y), alpha, beta, sigma)")
      #v(3pt)
      These draws replace the `elementof` bindings. Keep lines 14–15 and expose the three variates in `kernelof`.
    ]),
    entry("Bound the scale during a search", [
      #code("domain = cartprod(alpha = reals, beta = reals,\n    sigma = interval(0.1, 2))")
      #v(3pt)
      The named product describes allowed points for a search. A prior assigns mass to parameter values.
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
    entry("Repeat a law or vary its mean", [
      #code("ys ~ iid(Normal(alpha, sigma), 4)\nzs ~ Normal.(mu, sigma)")
      #v(3pt)
      `ys` shares one mean across observations. `zs` takes one mean per entry of `mu`. Both are independent conditional on their parameters.
    ]),
    entry("Read records and arrays", [
      #code("r = record(a = 1, b = 2)\nu = r.a\nv = [1, 2, 3]\nw = v[1]")
      #v(3pt)
      Record fields have names. Array indices start at one. Each binding has a single definition within a module.
    ]),
    entry("Supply fixed inputs", [
      #code("n = external(posintegers)")
      #v(3pt)
      The caller supplies `n` at module load time. The suffix `_data` is a convention. `likelihoodof` fixes the observed values.

      Use `#` for a comment, `%` for documentation on a binding, and paired `%%%` lines for a documentation block.
    ]),
  ),
)
