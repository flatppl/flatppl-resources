#import "theme.typ": *

#sheet(
  topic: "Likelihood inference", title: "Profiling and marginalization", accent: rgb("70516f"),
  formula: ("A nuisance parameter", [$L_(p) (s) = max_(b >= 0) L(s,b)$]),
  reference-title: "Comparing signal likelihoods",
  file: "examples/profile-marginal.flatppl", example: "One signal and one control count",
  illustration: ("One nuisance parameter, two curves",
    "Joint likelihood contours and the best background at each signal sit above the profile and marginal signal curves.",
    [The ridge follows the best background at each signal. Below it, each signal curve is shifted to its own peak. The dashed curve integrates over the Gamma prior.]),
  notes: (
    ("Write the observation law", 11, 13, [
      The signal region has mean `s + b`. The control region has five times the background exposure, so its mean is `5*b`. The two observed counts are 7 and 12.
    ]),
    ("Profile at fixed signal", 15, 17, [
      `b_hat(s)` maximizes the joint likelihood over nonnegative background for the supplied signal. Evaluating at that background leaves a function of `s` alone.
    ]),
    ("Integrate a background prior", 19, 22, [
      The library computes the exact Gamma-background marginal for integer counts. Shape 2 and rate 1 give a prior mean of 2. This step specifies a law for `b`.
    ]),
    ("Compare at the same signal", 24, 27, [
      At `s = 3`, the fitted background is 2.53424. The profile log likelihood is −4.26916 and the marginal log likelihood is −5.37638, before the shifts in the figure.
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
      The library supplies a scalar formula for the profile score. Both dotted calls evaluate the same signal grid.
    ]),
    entry("The integral over background", [
      For a fixed signal, the marginal is $integral_0^infinity L(s,b) pi(b) dif b$. The Gamma density and the differential specify how much weight each background value receives.
    ]),
    entry("Keep the signal interpretation", [
      Both curves depend on the signal. To form a Bayesian posterior for the signal from the marginal, specify its prior and normalize their product.
    ]),
  ),
  references: (
    entry("Read a likelihood scan", [
      The profile peaks at 4.60. The marginal peaks near 4.73 for this prior. Comparing their drops from the peak shows how each treats nearby signal values.
    ]),
    entry("Interpret the exposure ratio", [
      `ratio` is the control exposure divided by the signal-region exposure. `b` already denotes a mean count in the signal region. Multiplying by the ratio gives control counts.
    ]),
    entry("Move the background assumption", [
      Changing Gamma shape or rate changes the marginal curve. The profile depends only on the joint count law and the constraint $b>=0$. The packaged library supplies both calculations.
    ]),
  ),
)
