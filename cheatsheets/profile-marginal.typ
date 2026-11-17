#import "theme.typ": *

#sheet(
  topic: "Likelihood inference", title: "Profiling and marginalization", accent: rgb("70516f"),
  formula: ("A nuisance parameter", [$L_(p) (s) = max_(b >= 0) L(s,b)$]),
  reference-title: "Comparing signal likelihoods",
  file: "examples/profile-marginal.flatppl", example: "One signal and one control count",
  illustration: ("Profile and marginal signal likelihoods",
    "Joint likelihood contours and the best background at each signal sit above the profile and marginal signal curves.",
    [The ridge shows the fitted background at each signal. Each log-likelihood curve in the lower panel has its own maximum at zero. The dashed curve integrates over the Gamma prior.]),
  notes: (
    ("Signal and control counts", 13, 15, [
      The signal region has Poisson mean `s + b`. The control exposure is five times larger, with mean `5*b`. The observed counts are 7 and 12, respectively.
    ]),
    ("Profile at fixed signal", 17, 19, [
      At a fixed `s`, maximize the joint likelihood over nonnegative background. Inserting the maximizer `b_hat(s)` gives the profile likelihood as a function of `s`.
    ]),
    ("Integrate a background prior", 21, 24, [
      For integer counts the module integrates exactly against a Gamma prior for `b`. Shape 2 and rate 1 give a prior mean of 2.
    ]),
    ("Evaluation at a fixed signal", 26, 29, [
      At `s = 3` the fitted background is 2.53424. Before shifting the curves to their peaks, the log likelihoods are −4.26916 for profiling and −5.37638 for marginalization.
    ]),
  ),
  after-notes: (
    entry("Check the joint maximum", [
      The control count gives $hat(b)=12/5=2.4$. The signal region then gives $hat(s)=7-2.4=4.6$. Both means reproduce their observed counts.
    ]),
  ),
  variants: (
    entry("Evaluate a signal scan", [
      #code("scan_p(t) = counts.onoff_profile_loglikelihood(\n    n, m, t, ratio)\ngrid = linspace(0.0, 12.0, 61)\nlp = scan_p.(grid)\nlm = marginal.(grid)")
      #v(3pt)
      Evaluate the module’s scalar profile formula and the Gamma marginal on the same grid. The dots broadcast both calls over the signal values.
    ]),
    entry("The integral over background", [
      At fixed signal the marginal likelihood is $integral_0^infinity L(s,b) pi(b) dif b$. The Gamma density weights each background interval in the integral.
    ]),
  ),
  references: (
    entry("Locations of the maxima", [
      The profile peaks at 4.60 and the marginal near 4.73 for this prior. Measure changes in log likelihood relative to each curve’s own maximum.
    ]),
    entry("Background fit at zero signal", [
      At `s = 0` the two regions have means $b$ and $5b$. The total of 19 counts across six exposure units gives $hat(b)(0)=19/6$. This fixes the first point on the profile ridge.
    ]),
    entry("Interpret the exposure ratio", [
      `ratio` is the control exposure divided by the signal-region exposure. Since `b` denotes the expected signal-region background count, multiplying it by `ratio` gives the expected control count.
    ]),
    entry("From a marginal likelihood to a posterior", [
      The background prior affects only the marginal curve. Multiply that curve by a signal prior and normalize to obtain a signal posterior. The #module-link("flatppl-stats-counts", "4f0a6a8eedf0595d1d779fe6ba6a5579fa96eaf4")[counts module] supplies both scan functions.
    ]),
  ),
)
