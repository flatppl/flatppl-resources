#import "theme.typ": *

#let driver(start, end) = code(read("examples/fit.py").split("\n").slice(start - 1, end).join("\n"), lang: "python")

#sheet(
  topic: "Inference in Python", title: "From a model to a fit", accent: rgb("365d70"),
  formula: ("Likelihood estimate", [$hat(tau) = frac(n, sum_i (y_i - overline(y))^2)$]),
  reference-title: "Python driver",
  file: "examples/fitting-from-python.flatppl", example: "A Gaussian mean and precision",
  companions: ("examples/fit.py",),
  illustration: ("Likelihood contours in mean and precision",
    "Likelihood contours in mean and precision surround the exact maximum at 1.15 and 2.985. A cross marks the estimate.",
    [Contours show drops in log likelihood from its maximum. The cross marks the fitted mean and precision in their model coordinates.]),
  notes: (
    ("External observations", 6, 6, [
      Declare the eight readings as an external real vector. Supply them from Python with `.set(observed=data)`. A new vector of the same shape can use the same model.
    ]),
    ("Choose fitting coordinates", 8, 10, [
      Declare a real mean and a positive precision. Pass $1/sqrt(tau)$ as the Normal standard deviation.
    ]),
    ("Name the kernel inputs", 12, 13, [
      Use `iid` for eight independent readings with a common law. `kernelof` takes the two fitted parameters. Its output record contains the reading vector under `y`.
    ]),
    ("Select the likelihood from Python", 15, 15, [
      Bind `y` to the eight readings with `likelihoodof`. Select the resulting binding in Python by its name, `"L"`. Minimize the negative log likelihood.
    ]),
  ),
  after-notes: (
    entry("Analytic maximum", [
      The eight observations have mean 1.15 and sum of squared deviations 2.68. At the maximum, $log L=-6.97701$.
      #v(4pt)
      #lookup((1.1fr, 1fr, 1.15fr), ([Parameter], [Fit coordinate], [Model estimate]), numeric: true,
        [Mean `mu`], [$mu$], [$1.15$],
        [Precision `tau`], [$log tau$], [$8/2.68 approx 2.98507$])
    ]),
    entry("Why the variance uses eight", [
      At $mu=overline(y)$, the likelihood equation for $tau$ is
      #v(3pt)
      $ (partial ell)/(partial tau) = n/(2 tau) - frac(1,2) sum_i (y_i-overline(y))^2 = 0. $
      #v(3pt)
      Solving for $tau$ gives the likelihood estimate with divisor $n$ in the variance.
    ]),
  ),
  variants: (
    entry("Save and run the fit", [
      Save the model as `fitting-from-python.flatppl`. Copy the five Python blocks in reading order into `fit.py` beside it. Run `python fit.py` with FlatPPL, JAX, NumPy and Optimistix installed.
    ]),
    entry("Python imports", [
      #driver(1,6)
    ]),
    entry("Bind the data", [
      #driver(8,12)
      #v(3pt)
      `Path` locates the model beside the driver, independently of the current working directory.
    ]),
  ),
  references: (
    entry("Evaluate in free coordinates", [
      #driver(14,18)
      #v(3pt)
      Set `jacobian=False` to optimize in log precision while preserving the likelihood at the corresponding model point.
    ]),
    entry("Return to model coordinates", [
      #driver(20,23)
      #v(3pt)
      Keep the minimization inside the 64-bit context. Apply `constrain` to recover the fitted `mu` and positive `tau`.
    ]),
    entry("Check the result", [
      #driver(25,28)
      #v(3pt)
      NumPy divides by eight for the default variance of these observations. Its reciprocal gives the maximum-likelihood precision.
    ]),
  ),
)
