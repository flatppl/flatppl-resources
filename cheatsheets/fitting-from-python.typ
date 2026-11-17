#import "theme.typ": *

#let driver(start, end) = code(read("examples/fit.py").split("\n").slice(start - 1, end).join("\n"), lang: "python")

#sheet(
  topic: "Inference in Python", title: "From a model to a fit", accent: rgb("365d70"),
  formula: ("Likelihood estimate", [$hat(tau) = frac(n, sum_i (y_i - overline(y))^2)$]),
  reference-title: "Python driver",
  file: "examples/fitting-from-python.flatppl", example: "A Gaussian mean and precision",
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
      The sample mean is 1.15 and the squared deviations sum to 2.68. The maximum-likelihood precision is therefore $8/2.68=2.98507$. The fitted log likelihood is $log L=-6.97701$.
    ]),
  ),
  variants: (
    entry("Python imports", [
      #driver(1,6)
    ]),
    entry("Run the fit", [
      Run `python examples/fit.py` from the cheatsheets directory with FlatPPL, NumPy, JAX and Optimistix installed. The script prints both estimates and checks them against the analytic solution.
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
