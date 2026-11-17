#import "theme.typ": *

#sheet(
  topic: "Bayesian inference", title: "Posterior prediction", accent: rgb("44684f"),
  formula: ("One new reading", [$V_("new") = h^T V h + sigma^2$]),
  reference-title: "Posterior and predictive intervals",
  file: "examples/posterior-prediction.flatppl", example: "Linear regression with known noise",
  illustration: ("Mean line and new readings",
    "Two nested 90 percent bands surround the posterior mean line. Four data points and a slice at x = 1.5 show the difference in width.",
    [The dark band contains 90% posterior probability for the mean at each $x$. The light band covers 90% of the predictive law for a new reading.]),
  notes: (
    ("Fix the design and prior", 9, 11, [
      Each row of `X` is `[1, x]`. The intercept and slope have independent zero-mean Normal priors with standard deviations 5 and 2. The noise scale is known.
    ]),
    ("Form the coefficient posterior", 13, 15, [
      Add the data precision $X^T X/sigma^2$ to the prior precision `P0`. Invert the sum to obtain the posterior covariance `V`. Its product with the data term gives the posterior mean `m`.
    ]),
    ("Add the variance of a new reading", 19, 21, [
      At `x_new` the design row is `h`. The fitted mean and the new reading both have expectation `center`. Their variances differ by the independent measurement variance `sigma^2`. The fitted mean has variance `v_mean`.
    ]),
    ("Simulate a new reading", 23, 26, [
      Use one coefficient draw for the entire line. At the selected input, pass the next RNG state to the draw of a reading. This adds independent observation noise.
    ]),
  ),
  after-notes: (
    entry("Take a pointwise interval", [
      `probit(0.95)` gives the two-sided 90% Normal multiplier. Subtract and add each half-width to `center` for its corresponding interval.
    ]),
  ),
  variants: (
    entry("Intervals at a fixed predictor", [
      At $x=1.5$, both distributions have mean 2.498.
      #v(4pt)
      #lookup((1.25fr, 1fr, 1fr), ([Quantity], [5% quantile], [95% quantile]), numeric: true,
        [Fitted mean], [2.087], [2.909],
        [New reading], [1.579], [3.417])
    ]),
    entry("Predict a whole curve", [
      #code("line_grid = beta[1] .+ beta[2] .* x\nreplica ~ Normal.(line_grid, sigma)")
      #v(3pt)
      Use the same intercept and slope draw at every new input. Independent fresh noise at each input produces a simulated data set from that line.
    ]),
  ),
  references: (
    entry("Where the bands widen", [
      The four design values run from 0 to 3. Uncertainty in the slope matters more away from the middle of that range. Both bands widen toward the edges.
    ]),
    entry("Intercept–slope covariance", [
      The fitted mean has variance $V_(11) + 2 x V_(12) + x^2 V_(22)$. The middle term accounts for posterior covariance between the intercept and slope.
    ]),
    entry("Two points on one fitted line", [
      For design rows $h_a$ and $h_b$, shared coefficients give covariance $h_a^T V h_b$. Independent measurement errors add $sigma^2$ to each observation variance and leave this cross-covariance unchanged.
    ]),
    entry("An unknown noise scale", [
      In the beginner model, `sigma` also has a prior. Use the same joint posterior draw of intercept, slope, and noise scale for each replicated data set.
    ]),
    entry("Compare observations with replications", [
      Replicate the four observations at their original predictor values. Compare the observed maximum absolute residual, for example, with the same statistic in the replications.
    ]),
  ),
)
