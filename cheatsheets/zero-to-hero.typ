#import "theme.typ": *

#sheet(
  topic: "Quick reference", title: "Zero to hero", accent: rgb("285c48"),
  formula: ("One rate, unequal exposures", [$n_i tilde.op "Poisson"(r t_i)$]),
  reference-title: "Writing a model",
  file: "examples/zero-to-hero.flatppl", example: "One rate from three counts",
  illustration: ("What the fitted rate predicts",
    "Three bars give expected counts of 1.5, 3 and 1.5. Three diamonds show the observed counts of 2, 3 and 1.",
    [At `rate = 1.5`, doubling the exposure doubles the expected count. The diamonds are the three observed counts.]),
  notes: (
    ("Set the data and the support", 6, 8, [
      The two arrays pair each count with its exposure. The Gamma draw gives the positive rate a prior with shape 2 and rate 1.
    ]),
    ("Build the observation law", 10, 11, [
      Use `=` for a calculation and `~` for a draw. `.*` scales each exposure. `Poisson.(expected)` gives one independent count per array entry.
    ]),
    ("Name what the data fix", 13, 16, [
      `K` takes the rate and returns a law over the field `n`. `likelihoodof` fixes that field to the counts. `bayesupdate` combines the resulting likelihood with the prior.
    ]),
    ("Score a point and predict", 18, 21, [
      `logdensityof` takes a named parameter record. `functionof` exposes the expected counts as a callable. At this point it returns `[1.5, 3.0, 1.5]`.
    ]),
  ),
  after-notes: (
    entry("Check a model by hand", [
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
      Keep the observation law, `K`, and `L`. This declaration supplies a free parameter for a likelihood fit. The `prior` and `posterior` bindings belong to the Bayesian version.
    ]),
    entry("Check the log likelihood", [
      At `rate = 1.5`, the sum of three Poisson log probabilities is $-3.97267$. This checks the data order, the exposure scale, and the likelihood in one calculation.
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
      Replace the literal with this declaration. Bind a length-three count vector before querying `L`. Keep the output field name `n` in the kernel and observation record.
    ]),
    entry("Extend the predictor", [
      #code("eta = alpha .+ beta .* x\nexpected = exposure .* exp.(eta)")
      #v(3pt)
      Declare the intercept and slope as parameters. Give the kernel both inputs. The exponential link keeps each mean positive.
    ]),
    entry("Choose what to compute", [
      Fit `L` for a maximum-likelihood estimate or sample `posterior` for parameter uncertainty. Here the exact Gamma update supplies a rate draw for the next exposure. Its predicted mean count is $2 times 1.6=3.2$.
    ]),
  ),
)
