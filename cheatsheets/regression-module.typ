#import "theme.typ": *

#sheet(
  topic: "Standard module", title: "The regression module", accent: rgb("28645e"),
  formula: ("Log expected count", [$log(mu_i) = alpha + x_i^T beta$]),
  reference-title: "Response families",
  file: "examples/regression-module.flatppl", example: "Pulse counts at two gain settings",
  illustration: ("Expected counts by gain",
    "At levels minus one, zero and one, expected counts are 2, 4 and 8 at low gain and 6, 12 and 24 at high gain. Open symbols show observed counts.",
    [Curves give the expected counts at `point`. Symbols show the observed counts. At level zero, switching to high gain raises the mean from 4 to 12.]),
  notes: (
    ("Rows are runs, columns are predictors", 7, 11, [
      Each row is a one-second run. `colstack` forms a $6 times 2$ matrix from signal level and gain (0 low, 1 high). Pass the intercept separately.
    ]),
    ("One law for six counts", 13, 15, [
      `beta[1]` multiplies level and `beta[2]` multiplies gain. One undotted call gives a law for six conditionally independent counts with means $exp(eta_i)$.
    ]),
    ("Condition on the observed counts", 17, 20, [
      Make `alpha` and `beta` kernel inputs, then bind the counts to `y` in row order. The prior uses the same parameter fields as the likelihood.
    ]),
    ("Evaluate the rate ratios", 26, 30, [
      A unit increase in level doubles the rate. High gain triples it at any level. Row 5 records 13 counts with mean 12. Its log probability is $-2.24838$. Summing over all six rows gives `log_L` $approx -12.16848$.
    ]),
  ),
  after-notes: (
    entry("One trial or a fixed trial total", [
      #code("hit ~ reg.BernoulliLogitGLM(X, alpha, beta)\nhits ~ reg.BinomialLogitGLM(X, 12, alpha, beta)")
      #v(3pt)
      Both use `p = invlogit.(eta)`. Bernoulli gives one binary outcome per row. Binomial counts successes in 12 trials. For a vector of trial totals, use `Binomial.(totals, p)`.
    ]),
  ),
  variants: (
    entry("Unordered classes", [
      #code("A = [0.0, 0.4, -0.2]\nB = rowstack([[0.0, 0.5, 1.0],\n              [0.0, 1.0, -0.5]])\nlabel ~ reg.CategoricalLogitGLM(X, A, B)")
      #v(3pt)
      Classes 1–3 each have an intercept in `A` and a column in `B`. Class 1 has zero intercept and slopes, fixing the reference. Softmax converts the scores to probabilities.
    ]),
    entry("Ordered classes", [
      #code("grade ~ reg.OrderedLogitGLM(X, beta, [-1, 1])")
      #v(3pt)
      Two increasing cutpoints give three grades. They set the location. For cutpoint $t_j$, $P(Y_i <= j) = op("invlogit")(t_j - x_i^T beta)$.
    ]),
  ),
  references: (
    entry("Score a new run", [
      #code("X_new = rowstack([[0.5, 1.0]])\nnew_law = reg.PoissonLogGLM(\n    X_new, point.alpha, point.beta)\nlp17 = logdensityof(new_law, [17])")
      #v(3pt)
      One run still needs a matrix with one row. At level 0.5 and high gain its mean is $12 sqrt(2) approx 16.97$. Supply the observed count in a length-one vector.
    ]),
    entry("Continuous readings", [
      #code("y_n ~ reg.NormalGLM(X, alpha, beta, 0.5)\ny_t ~ reg.StudentTGLM(X, 4, alpha, beta, 0.5)")
      #v(3pt)
      Both laws have location $eta_i = alpha + x_i^T beta$. The Normal standard deviation is 0.5. The Student law has four degrees of freedom and scale 0.5.
    ]),
    entry("Overdispersed counts", [
      #code("y_nb ~ reg.NegativeBinomial2LogGLM(\n    X, alpha, beta, 4.0)")
      #v(3pt)
      The mean is still $mu_i = exp(eta_i)$. With $psi=4$, the variance is $mu_i + mu_i^2/4$. A run with mean 12 has variance 48 under this law and 12 under the Poisson law.
    ]),
    entry("Positive readings and fractions", [
      #code("delay ~ reg.GammaLogGLM(X, alpha, beta, 3.0)\nfrac_y ~ reg.BetaLogitGLM(X, alpha, beta, 8.0)")
      #v(3pt)
      The Gamma law has mean $exp(eta_i)$ and shape 3. The Beta law has mean $p_i = op("invlogit")(eta_i)$ and shape parameters $8 p_i$ and $8(1-p_i)$.
    ]),
  ),
)
