#import "theme.typ": *

#sheet(
  topic: "Dynamical systems", title: "From a decay law to a likelihood", accent: rgb("476756"),
  formula: ("Initial-value problem", [$y'(t)=-k y(t), quad y(0)=1$]),
  reference-title: "Time grid and measurement model",
  file: "examples/decay-ode.flatppl", example: "A rate from three measurements",
  illustration: ("A trajectory and three readings",
    "Eleven grid points lie along the exponential trajectory. Three observations at times 0, 0.5 and 1 have error bars of 0.05.",
    [The line is the exact solution at $k=1$. Circles mark the solver grid. Diamonds and error bars show the three observations and one measurement standard deviation.]),
  notes: (
    ("Derivative and initial condition", 12, 13, [
      Pass time, the state vector and the rate to `rhs`. Starting from `[1.0]`, `vern7` integrates over the fixed grid. Passing `rate` explicitly makes the trajectory a function of the inferred parameter.
    ]),
    ("Select the measured times", 15, 16, [
      Stack one time per row and one state component per column with `rowstack`. With one-based indexing, rows 1, 6, and 11 give times 0, 0.5, and 1.
    ]),
    ("Gaussian measurement errors", 18, 20, [
      Use the three selected states as Gaussian means with common standard deviation 0.05. Declare the positive rate as the kernel input and condition on the three readings.
    ]),
    ("Likelihood at unit rate", 22, 24, [
      At `rate = 1` the fitted means are 1.00000, 0.60653, and 0.36788. Their Gaussian log likelihood for the observed readings is 5.85410.
    ]),
  ),
  after-notes: (
    entry("Information at the initial time", [
      All rates give the same initial condition. The first reading therefore adds a constant to the log likelihood. The two later readings constrain the decay rate.
    ]),
  ),
  variants: (
    entry("Supply a complete time grid", [
      Use the fixed-step solver from #module-link("flatppl-numerics-ode", "a56b4977b3ca4fced2e986bcbbdb6930b9d8c04a")[`flatppl-numerics-ode`]. `linspace(0.0, 1.0, 11)` includes both endpoints. Each consecutive pair defines one time step.
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
      The solver returns eleven states for three measured times. Only those three states enter the likelihood. Additional grid points refine the integration.
    ]),
    entry("Mesh refinement", [
      #code("fine_t = linspace(0.0, 1.0, 21)")
      #v(3pt)
      On a grid of 21 equally spaced times, select rows 1, 11, and 21. Compare both solutions at the same measured times.
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
