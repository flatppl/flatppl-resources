#import "theme.typ": *

#sheet(
  topic: "Bayesian inference", title: "Posterior prediction", accent: rgb("44684f"),
  formula: ("One new reading", [$V_("new") = h^T V h + sigma^2$]),
  reference-title: "Reading predictive intervals",
  file: "examples/posterior-prediction.flatppl", example: "The beginner regression revisited",
  illustration: ("Mean line and new readings",
    "Two nested 90 percent bands surround the posterior mean line. Four data points and a slice at x = 1.5 show the difference in width.",
    [The dark band contains 90% posterior probability for the mean at each $x$. The light band covers 90% of the predictive law for a new reading.]),
  notes: (
    ("Fix the design and prior", 9, 11, [
      A row of `X` is `[1, x]`. The intercept and slope retain independent, zero-mean Normal priors with standard deviations 5 and 2. Here the noise scale is known.
    ]),
    ("Form the coefficient posterior", 13, 15, [
      `P0` is the prior precision. Independent Gaussian errors add $X^T X/sigma^2$ to it. Inversion gives the posterior covariance `V`. Multiplying by the data term gives its mean `m`.
    ]),
    ("Add the variance of a new reading", 19, 21, [
      `h` is the design row at `x_new`. Both predictions have mean `center`. Coefficient uncertainty contributes `v_mean`. A fresh independent measurement adds `sigma^2`.
    ]),
    ("Draw one coherent prediction", 23, 26, [
      Draw one coefficient vector for the whole line. At the chosen input, draw a reading around that line with the next RNG state. This final draw adds observation noise.
    ]),
  ),
  after-notes: (
    entry("Take a pointwise interval", [
      `probit(0.95)` gives the two-sided 90% Normal multiplier. Subtract and add each half-width to `center` for its corresponding interval.
    ]),
  ),
  variants: (
    entry("Check one vertical slice", [
      At $x=1.5$, both distributions center on 2.498. The 90% interval for the mean is $[2.087, 2.909]$. For a fresh reading it is $[1.579, 3.417]$.
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
    entry("Read the covariance term", [
      For intercept and slope, the variance of the fitted line is $V_(11) + 2 x V_(12) + x^2 V_(22)$. The off-diagonal entry matters because the two fitted coefficients covary.
    ]),
    entry("An unknown noise scale", [
      In the beginner model, `sigma` also has a prior. Use the same joint posterior draw of intercept, slope, and noise scale for each replicated data set.
    ]),
    entry("Compare observations with replications", [
      Generate replicated data at the original four inputs. Compare a statistic such as the largest absolute residual with its distribution across replicated data sets.
    ]),
  ),
)
