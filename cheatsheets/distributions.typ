#import "theme.typ": *

#sheet(
  number: "01", title: "Distributions", topic: "Distribution reference",
  subtitle: "Choose the support. Name the parameters. Keep rates, scales, and standard deviations distinct.",
  accent: rgb("9a6936"), file: "examples/distributions.flatppl",
  model_title: "Counts across unequal exposures",
  model_note: [The example uses one latent rate. Counts are independent *given* that rate. Marginally, they share uncertainty.],
  notes: (
    (1, "A measure and a variate", 5, 6, [
      `rate_dist` names a distribution. `lambda` names a random value drawn from it. Here $E[lambda] = 2$ and $"Var"(lambda) = 2$.
    ]),
    (2, "Vary the expected count", 9, 10, [
      The dot applies `Poisson` to each mean. At `lambda = 2`, the expected counts are `[1, 2, 4]`. Exposure scales the mean.
    ]),
    (3, "IID or varying parameters?", 17, 22, [
      `at_two` keeps means `[1, 2, 4]`. `equal_law` gives three independent counts with mean 2 each. `iid` repeats the same measure.
    ]),
  ),
  refs: (
    ref("Real values", [
      #dist("Normal(mu, sigma)", [$RR$], [Mean `mu`, standard deviation `sigma > 0`.])
      #v(4pt)
      #dist("StudentT(nu)", [$RR$], [Standard form. Use `locscale(StudentT(nu), m, s)` for location and scale.])
      #v(4pt)
      #dist("Cauchy(location, scale)", [$RR$], [Positive scale. The mean and variance do not exist.])
    ]),
    ref("Positive values and probabilities", [
      #dist("Gamma(shape, rate)", [$x >= 0$], [Mean `shape / rate`. Variance `shape / rate^2`.])
      #v(4pt)
      #dist("Exponential(rate)", [$x >= 0$], [Mean `1 / rate`. The rate is the inverse scale.])
      #v(4pt)
      #dist("LogNormal(mu, sigma)", [$x > 0$], [`mu` and `sigma` describe `log(x)`.])
      #v(4pt)
      #dist("Beta(alpha, beta)", [$0 <= x <= 1$], [Positive shapes. Mean `alpha / (alpha + beta)`.])
    ]),
    ref("Counts, categories, and vectors", [
      #dist("Bernoulli(p) / Binomial(n, p)", [], [A 0/1 outcome / successes in `n` trials.])
      #v(4pt)
      #dist("Poisson(rate)", [$0, 1, 2, ...$], [Mean and variance equal `rate`.])
      #v(4pt)
      #dist("NegativeBinomial2(mu, psi)", [], [Mean `mu`. Variance `mu + mu^2 / psi`.])
      #v(4pt)
      #dist("Categorical(p)", [$1, ..., n$], [Probability vector. `Categorical0(p)` starts at 0.])
      #v(4pt)
      #dist("MvNormal(mu, cov)", [vector], [Mean vector and positive definite covariance.])
      #v(4pt)
      #dist("Dirichlet(alpha)", [simplex], [Positive concentrations. Entries sum to 1.])
    ]),
  ),
  takeaway: [*Support restriction:* `truncate(M, S)` keeps the mass inside `S`. Use `normalize(truncate(M, S))` for a probability distribution.],
  sources: "Spec: Built-in distributions · Broadcasting · Support restriction",
)
