#import "theme.typ": *

#let driver(start, end) = code(read("examples/fit.py").split("\n").slice(start - 1, end).join("\n"), lang: "python")

#sheet(
  topic: "Inference in Python", title: "From a model to a fit", accent: rgb("365d70"),
  formula: ("Likelihood estimate", [$hat(tau) = frac(n, sum_i (y_i - overline(y))^2)$]),
  reference-title: "Python driver",
  file: "examples/fitting-from-python.flatppl", example: "A Gaussian mean and precision",
  illustration: ("The peak in model coordinates",
    "Likelihood contours in mean and precision surround the exact maximum at 1.15 and 2.985. A cross marks the estimate.",
    [Contours show drops in log likelihood from its maximum. The cross marks the fitted mean and precision in their model coordinates.]),
  notes: (
    ("Declare the data boundary", 6, 6, [
      `external` declares a real vector of length eight. Python supplies its values with `.set(observed=data)`. The same model accepts a second vector with this shape.
    ]),
    ("Choose fitting coordinates", 8, 10, [
      The mean is real and the precision is positive. The Normal constructor takes a standard deviation. Its value is $1/sqrt(tau)$.
    ]),
    ("Name the kernel inputs", 12, 13, [
      `iid` gives eight independent readings from one law. `kernelof` exposes the two fitted parameters. The output record names the vector `y`.
    ]),
    ("Expose the likelihood", 15, 15, [
      `likelihoodof` fixes `y` to the eight supplied readings. Python selects this binding by the string `"L"`. The objective uses the negative log likelihood.
    ]),
  ),
  after-notes: (
    entry("A second, exact estimate", [
      The sample mean is 1.15. The sum of squared deviations is 2.68, so the maximum-likelihood precision is $8/2.68=2.98507$. At that point $log L=-6.97701$.
    ]),
  ),
  variants: (
    entry("Python imports", [
      #driver(1,6)
    ]),
    entry("Run the companion", [
      Run `python examples/fit.py` from the cheatsheets directory with FlatPPL, NumPy, JAX and Optimistix installed. The script prints both estimates and checks them against the analytic solution.
    ]),
    entry("Bind the data", [
      #driver(8,12)
      #v(3pt)
      The driver sits beside its `.flatppl` file. `Path` resolves the model relative to the driver, regardless of the working directory.
    ]),
  ),
  references: (
    entry("Evaluate in free coordinates", [
      #driver(14,18)
      #v(3pt)
      `jacobian=False` keeps the likelihood value at the corresponding model point. The optimizer can search freely in log precision.
    ]),
    entry("Minimize, then recover the point", [
      #driver(20,23)
      #v(3pt)
      These lines remain inside the 64-bit context. `constrain` maps the fitted values back to `mu` and positive `tau`.
    ]),
    entry("Check the result", [
      #driver(25,28)
      #v(3pt)
      NumPy’s default variance divides by eight. Its reciprocal is the maximum-likelihood precision for these data.
    ]),
  ),
)
