#import "theme.typ": *

#sheet(
  topic: "Dynamical systems", title: "From a decay law to a likelihood", accent: rgb("476756"),
  formula: ("Initial-value problem", [$y'(t)=-k y(t), quad y(0)=1$]),
  reference-title: "Integrating and observing",
  file: "examples/decay-ode.flatppl", example: "A rate from three measurements",
  illustration: ("A trajectory and three readings",
    "Eleven grid points lie along the exponential trajectory. Three observations at times 0, 0.5 and 1 have error bars of 0.05.",
    [The line is the exact solution at $k=1$. Circles mark the solver grid. Diamonds and error bars show the three observations and one measurement standard deviation.]),
  notes: (
    ("Pass the derivative as a function", 10, 11, [
      `rhs` accepts time, a state vector, and a rate. `vern7` starts at `[1.0]` and advances along the fixed time grid. The explicit argument `rate` links the solver to inference.
    ]),
    ("Select the measured times", 13, 14, [
      `rowstack` puts one time in each row and one state component in each column. FlatPPL uses one-based indices. Rows 1, 6, and 11 correspond to times 0, 0.5, and 1.
    ]),
    ("Attach a noise law", 16, 18, [
      The three selected states become Gaussian means with common standard deviation 0.05. The kernel exposes the positive rate. The likelihood fixes its output to the three readings.
    ]),
    ("Check the rate in physical units", 20, 22, [
      At `rate = 1`, `fitted` gives 1.00000, 0.60653, and 0.36788. Scoring the observed readings against those means gives a log likelihood of 5.85410.
    ]),
  ),
  after-notes: (
    entry("What the initial reading measures", [
      The first prediction is fixed at the initial condition for every rate. Its reading contributes a constant to the log likelihood. The two later readings constrain the decay rate.
    ]),
  ),
  variants: (
    entry("Supply a complete time grid", [
      The package in `lib/ode` ships beside this example. `linspace(0.0, 1.0, 11)` includes both endpoints. Each neighbouring pair sets one solver step.
    ]),
    entry("Use the closed form as a check", [
      #code("exact = exp.(-1.0 .* t_grid)")
      #v(3pt)
      For this derivative, $y(t)=exp(-k t)$. At $k=1$, compare the numerical and exact solutions at each grid point before attaching the measurement law.
    ]),
    entry("Inspect the residuals", [
      #code("resid = (y_data .- fitted) ./ 0.05")
      #v(3pt)
      In units of measurement noise, the residuals at rate one are approximately 0.40, −0.73, and 0.24.
    ]),
  ),
  references: (
    entry("Separate solver and data indices", [
      The solver returns eleven states. The data contain three measurements. Only values at observed times contribute to the likelihood. Extra solver points refine the integration.
    ]),
    entry("Refine the mesh consistently", [
      #code("fine_t = linspace(0.0, 1.0, 21)")
      #v(3pt)
      With 21 evenly spaced times on the same interval, select rows 1, 11, and 21. Check predictions at the same physical times against the original grid.
    ]),
    entry("Extend to coupled states", [
      An initial vector with several entries describes a coupled system. Return a derivative vector of the same length. Choose the observed state components from the corresponding solution columns.
    ]),
    entry("Add a prior for the decay rate", [
      #code("k ~ LogNormal(0, 0.5)\nprior = lawof(record(rate = k))\nposterior = bayesupdate(L, prior)")
      #v(3pt)
      The prior uses the same positive rate field as the likelihood.
    ]),
  ),
)
