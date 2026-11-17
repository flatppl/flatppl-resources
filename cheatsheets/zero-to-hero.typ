#import "theme.typ": *

#sheet(
  topic: "Quick reference", title: "Zero to hero", accent: rgb("285c48"),
  formula: ("One rate, unequal exposures", [$n_i tilde.op "Poisson"(r t_i)$]),
  reference-title: "Writing a model",
  file: "examples/zero-to-hero.flatppl", example: "One rate from three counts",
  illustration: ("Expected and observed counts",
    "Three bars give expected counts of 1.5, 3 and 1.5. Three diamonds show the observed counts of 2, 3 and 1.",
    [At `rate = 1.5`, doubling the exposure doubles the expected count. The diamonds are the three observed counts.]),
  notes: (
    ("Set the data and the support", 6, 8, [
      Entry `i` pairs a count with its exposure. The Gamma prior has shape 2 and rate 1 and restricts the event rate to positive values.
    ]),
    ("Build the observation law", 10, 11, [
      Use `=` for a calculation and `~` for a draw. Multiplication by `rate` acts elementwise. The dotted Poisson constructor gives independent counts at the resulting means.
    ]),
    ("Condition on the observed counts", 13, 16, [
      At each rate, `K` gives a law for the record field `n`. Supply the observed counts to `likelihoodof`, then pass the likelihood and prior to `bayesupdate`.
    ]),
    ("Score a point and predict", 18, 21, [
      Evaluate `logdensityof` at a record with the field `rate`. The function returned by `functionof` gives the expected counts `[1.5, 3.0, 1.5]` at that rate.
    ]),
  ),
  after-notes: (
    entry("Analytic rate estimate", [
      The counts sum to 6 over 4 exposure units. The likelihood peaks at $6/4=1.5$. The exact posterior is `Gamma(8, 5)` with mean 1.6.
    ]),
    entry("Check the file before fitting", [
      Save the listing as `model.flatppl`. Run `flatppl infer model.flatppl model.flatpir` to check names, types and shapes. Then compare `log_L` with the hand calculation.
    ]),
  ),
  variants: (
    entry("A likelihood without a prior", [
      #code("rate = elementof(posreals)")
      #v(3pt)
      For a likelihood fit, retain the observation law, `K`, and `L`. Declare the free rate with `elementof`. Add the `prior` and `posterior` bindings for Bayesian inference.
    ]),
    entry("Check the log likelihood", [
      At `rate = 1.5` the three log probabilities sum to `log_L` $approx -3.97267$. Each column pairs one count with its own exposure.
      #v(4pt)
      #lookup((1.5fr, 1fr, 1fr, 1fr), ([Exposure], [1], [2], [1]), numeric: true,
        [Observed count], [2], [3], [1],
        [Poisson mean], [1.5], [3], [1.5],
        [Log probability], [−1.38222], [−1.49592], [−1.09453])
    ]),
  ),
  references: (
    entry("Choose the data shape", [
      A scalar parameter can serve every row. Use `iid(M, n)` for repeated draws from one law. Use a dotted constructor when its parameters vary across rows.
    ]),
    entry("Change the observation family", [
      #code("y ~ Normal.(mu, sigma)\nhits ~ Binomial.(trials, prob)")
      #v(3pt)
      Use a Normal law for continuous readings. Use a Binomial law for successes out of known trial totals. Name the observed field in both `K` and `L`.
    ]),
    entry("Accept data from the host", [
      #code("counts = external(cartpow(nonnegintegers, 3))")
      #v(3pt)
      Declare the counts as external and supply a length-three vector before evaluating `L`. Use the same field name, `n`, in the kernel and the observation record.
    ]),
    entry("Extend the predictor", [
      #code("eta = alpha .+ beta .* x\nexpected = exposure .* exp.(eta)")
      #v(3pt)
      Declare the intercept and slope as parameters. Give the kernel both inputs. The exponential link keeps each mean positive.
    ]),
    entry("Estimation and prediction", [
      Maximize `L` to estimate the rate, or sample `posterior` to quantify its uncertainty. For prediction, draw a rate from the exact Gamma posterior. The mean count for the next exposure is $2 times 1.6=3.2$.
    ]),
  ),
)
