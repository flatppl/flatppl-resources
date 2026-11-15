#import "theme.typ": *

#sheet(
  number: "01", title: "Distribution constructors", topic: "Reference",
  subtitle: "Constructor arguments, variates, product measures, and support restriction.",
  accent: rgb("9a6936"), file: "examples/distributions.flatppl",
  model_title: "Scalar and array-valued distributions",
  model_note: [A distribution constructor returns a measure. `draw`, also written `~`, introduces a variate. `lawof` reifies a variate as a measure.],
  notes: (
    (1, "Constructors and draws", 4, 7, [
      Built-in constructors accept positional or keyword arguments. `standard` and `shifted` denote measures. `x` and `y` denote stochastic values.
    ]),
    (2, "IID products and broadcasting", 10, 13, [
      `iid(M, n)` repeats one measure. A broadcast constructor applies its arguments elementwise and returns one array-valued product measure, rather than an array of measures.
    ]),
    (3, "Restricted support", 16, 18, [
      `truncate(M, S)` restricts the support without normalizing. `normalize` produces a probability measure when the remaining mass is finite and positive.
    ]),
  ),
  refs: (
    ref("Real-valued distributions", [
      #dist("Normal(mu, sigma)", [$RR$], [`sigma` is the standard deviation, not the variance.])
      #v(4pt)
      #dist("StudentT(nu)", [$RR$], [Standard form. Location and scale: `locscale(StudentT(nu), m, s)`.])
      #v(4pt)
      #dist("Cauchy(location, scale)", [$RR$], [The location and positive scale are named explicitly.])
    ]),
    ref("Positive and bounded supports", [
      #dist("Gamma(shape, rate)", [$x >= 0$], [`rate` is the inverse scale.])
      #v(4pt)
      #dist("Exponential(rate)", [$x >= 0$], [`rate` is the inverse scale.])
      #v(4pt)
      #dist("LogNormal(mu, sigma)", [$x > 0$], [Both parameters refer to `log(x)`.])
      #v(4pt)
      #dist("Beta(alpha, beta)", [$0 <= x <= 1$], [Both arguments are positive shape parameters.])
    ]),
    ref("Discrete and multivariate distributions", [
      #dist("Bernoulli(p) / Binomial(n, p)", [], [Binary values / counts from `n` trials.])
      #v(4pt)
      #dist("Poisson(rate)", [$0, 1, 2, ...$], [`rate` is the expected count.])
      #v(4pt)
      #dist("NegativeBinomial2(mu, psi)", [], [Expected count `mu`, positive overdispersion parameter `psi`.])
      #v(4pt)
      #dist("Categorical(p)", [$1, ..., n$], [`p` is a probability vector. `Categorical0(p)` uses indices $0, ..., n-1$.])
      #v(4pt)
      #dist("MvNormal(mu, cov)", [vector], [Mean vector and positive definite covariance matrix.])
      #v(4pt)
      #dist("Dirichlet(alpha)", [simplex], [`alpha` is a vector of positive concentrations.])
    ]),
  ),
  takeaway: [*Notation:* `x ~ M` is equivalent to `x = draw(M)`. Distribution constructors and measure operations produce objects that can be bound to names.],
  sources: "Specification: Built-in distributions · Broadcasting · Support restriction",
)
