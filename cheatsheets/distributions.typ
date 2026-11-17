#import "theme.typ": *

#sheet(
  number: "01", topic: "Reference", title: "Distributions and draws", accent: rgb("885a31"),
  formula: ("Half-Normal density", [$f_+(x) = 2 phi(x) quad (x >= 0)$]),
  reference-title: "Constructor index",
  file: "examples/distributions.flatppl", example: "Scalar and vector draws",
  illustration: ("Restricting a standard Normal",
    "The standard Normal density is symmetric about zero. Its normalized positive half doubles the density for positive x.",
    [The dashed curve has half its mass on either side of zero. The solid curve is the law used by `z` on line 18. Both integrate to one.]),
  notes: (
    ("Construct a law, then draw", 4, 7, [
      `Normal` returns a probability measure. A binding with `=` gives the measure a name. The `~` in `x ~ standard` introduces a variate with that law. Constructor arguments can be positional or named.
    ]),
    ("Form an array-valued draw", 10, 13, [
      `iid` repeats the same law three times. The dotted constructor uses each entry of `means` with the scalar scale. Each expression defines one product measure whose variates are length-three arrays.
    ]),
    ("Restrict the support", 16, 18, [
      `truncate` keeps the mass in the specified set. Here that mass is $1/2$. `normalize` divides by the retained mass before the draw. It requires finite, strictly positive mass.
    ]),
    ("Recover the law of a value", 21, 22, [
      `lawof(x)` gives a scalar law. `lawof(v)` retains the whole vector, including any dependence among its entries. For this example the coordinates of `v` are independent.
    ]),
  ),
  after-notes: (
    entry("Mixture weights", [
      #code("mix = superpose(weighted(0.3, standard),\n    weighted(0.7, shifted))\nw ~ mix")
      #v(3pt)
      The weights sum to one. A draw is one real value. In the product on line 13, a draw contains three coordinates.
    ]),
  ),
  variants: (
    entry("A correlated vector", [
      #code("cov = rowstack([[1.0, 0.4], [0.4, 2.0]])\nx_vec ~ MvNormal([0.0, 0.0], cov)")
      #v(3pt)
      `MvNormal` takes a mean vector and a positive definite covariance matrix. Here the off-diagonal entry gives the covariance of the coordinates.
    ]),
    entry("A random probability vector", [
      #code("p ~ Dirichlet([2.0, 2.0, 2.0])\ncategory ~ Categorical(p)\ncounts ~ Multinomial(12, p)")
      #v(3pt)
      The concentrations are positive. The entries of `p` sum to one. `category` is in `1..3`. The entries of `counts` sum to 12. `Categorical0` numbers the same categories from zero.
    ]),
    entry("Distribution parameters by name", [
      #code("args = record(mu = 2.0, sigma = 0.5)\nM = Normal(args)")
      #v(3pt)
      The fields supply the constructor's two inputs by name. `sigma` is the standard deviation.
    ]),
  ),
  references: (
    entry("Location and scale", [
      #dist("Normal(mu, sigma)", [$RR$], [Mean and standard deviation.])
      #v(3pt)
      #dist("Cauchy(location, scale)", [$RR$], [Positive scale.])
      #v(3pt)
      #dist("StudentT(nu)", [$RR$], [Degrees of freedom. Use `locscale` for location and scale.])
    ]),
    entry("Positive and bounded values", [
      #dist("Gamma(shape, rate)", [$x >= 0$], [`rate` is inverse scale, also in `Exponential(rate)`.])
      #v(3pt)
      #dist("InverseGamma(shape, scale)", [$x > 0$], [The second argument is the scale.])
      #v(3pt)
      #dist("LogNormal(mu, sigma)", [$x > 0$], [Mean and standard deviation of `log(x)`.])
      #v(3pt)
      #dist("Beta(alpha, beta)", [$[0,1]$], [Two positive shape parameters.])
      #v(3pt)
      #dist("Uniform(interval(a, b))", [$[a,b]$], [The argument is an interval with $a < b$.])
    ]),
    entry("Counts and trials", [
      `Bernoulli(p)` gives one binary outcome. `Binomial(n,p)` counts successes in `n` trials. `Geometric(p)` counts failures before the first success.

      `Poisson(rate)` has mean `rate`. `NegativeBinomial2(mu,psi)` has mean `mu` and variance $mu + mu^2/psi$.
    ]),
  ),
)
