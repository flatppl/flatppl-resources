#import "theme.typ": *

#sheet(
  topic: "Reference", title: "Distributions and draws", accent: rgb("885a31"),
  formula: ("Half-Normal density", [$f_+(x) = 2 phi(x) quad (x >= 0)$]),
  reference-title: "Constructor index",
  file: "examples/distributions.flatppl", example: "Scalar and vector draws",
  illustration: ("Restricting a standard Normal",
    "The standard Normal density is symmetric about zero. Its normalized positive half doubles the density for positive x.",
    [The dashed curve has half its mass on either side of zero. The solid curve is the law used by `z` on line 18. Both integrate to one.]),
  notes: (
    ("Probability measures and variates", 4, 7, [
      `Normal` constructs a probability measure. Name it with `=`. The declaration `x ~ standard` introduces a variate with that law. Constructors accept positional or named arguments.
    ]),
    ("Independent arrays", 10, 13, [
      `iid` uses the same law for all three entries. The dotted constructor pairs each entry of `means` with the common scale. Both produce a product measure on length-three arrays.
    ]),
    ("Restrict the support", 16, 18, [
      `truncate` retains the mass on the specified set, here $1/2$. To draw from the conditional law, apply `normalize`. The retained mass must be finite and strictly positive.
    ]),
    ("Laws of scalars and vectors", 21, 22, [
      `lawof(x)` gives the scalar law. `lawof(v)` preserves the joint law of the vector. Its coordinates are independent in this example.
    ]),
  ),
  after-notes: (
    entry("Mixture weights", [
      #code("mix = superpose(weighted(0.3, standard),\n    weighted(0.7, shifted))\nw ~ mix")
      #v(3pt)
      A mixture with weights summing to one produces a single real draw. A draw from the product on line 13 has three coordinates.
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
      Supply positive concentrations. The components of `p` sum to one. The category takes values 1, 2 or 3, and the counts sum to 12. Use `Categorical0` for labels 0, 1 and 2.
    ]),
    entry("Distribution parameters by name", [
      #code("args = record(mu = 2.0, sigma = 0.5)\nM = Normal(args)")
      #v(3pt)
      Pass the constructor arguments as named record fields. The field `sigma` denotes the standard deviation.
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
      #dist("Uniform(interval(a, b))", [$[a,b]$], [Use finite endpoints with $a<b$. Use `joint` for a product of interval laws.])
    ]),
    entry("Counts and trials", [
      #lookup((auto, 1fr), ([Law], [Count]),
        [`Bernoulli(p)`], [One binary outcome],
        [`Binomial(n,p)`], [Successes in `n` trials],
        [`Geometric(p)`], [Failures before the first success])
      #v(4pt)
      `Poisson(rate)` has mean and variance `rate`. For `NegativeBinomial2(mu,psi)` the mean is `mu` and the variance is $mu + mu^2/psi$.
    ]),
  ),
)
