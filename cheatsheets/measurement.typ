#import "theme.typ": *

#sheet(
  topic: "Measurement models", title: "Rounded readings and detection flags", accent: rgb("885a31"),
  formula: ("A rounded value is an event", [$P(a < Y < b) = F(b) - F(a)$]),
  reference-title: "Observation conventions",
  file: "examples/measurement.flatppl", example: "Two instruments, one mean",
  illustration: ("Two reports, two shaded areas",
    "The first Gaussian shades the cell from 0.95 to 1.05. The second shades the tail above 1.20.",
    [At $mu=1$, the first instrument reports a rounded value of 1.0. The second reports that its reading exceeded 1.20. Shading shows the probability of each report.]),
  notes: (
    ("Express both Gaussian tails", 10, 11, [
      `invprobit` is the standard Normal CDF. Standardize by the instrument’s scale. Gaussian symmetry gives the upper tail directly through `invprobit((m - x) / s)`.
    ]),
    ("Use the recorded interval", 13, 16, [
      Rounding to tenths maps a report of 1.0 to the cell from 0.95 to 1.05. The second device has scale 0.3 and records a single threshold crossing.
    ]),
    ("Make two event indicators", 18, 21, [
      Each Bernoulli variable records whether its event occurred. The readings are conditionally independent given `mu`, so the joint report has two likelihood factors.
    ]),
    ("Condition on the two reports", 23, 25, [
      Both events occurred, hence both fields equal one. The likelihood remains a function of the shared mean. `at_one` scores the two reports at the value used in the figure.
    ]),
  ),
  after-notes: (
    entry("Why the interval has two branches", [
      When both cell edges exceed the mean, subtract their upper-tail probabilities. This avoids cancellation from subtracting two CDF values close to one.
    ]),
  ),
  variants: (
    entry("Check a symmetric cell", [
      #code("p_at_center = 2 * invprobit(0.05 / 0.2) - 1")
      #v(3pt)
      At the displayed value, the edges lie a quarter of a standard deviation on either side of the mean. Symmetry gives the same interval probability.
    ]),
    entry("Check the likelihood by hand", [
      At $mu=1$, the rounding probability is 0.197413 and the flag probability is 0.252493. Their product is 0.0498452, with log likelihood −2.99883.
    ]),
    entry("Read a failed detection", [
      #code("other = record(cell = 1, flag = 0)\nL_other = likelihoodof(K, other)")
      #v(3pt)
      A zero contributes the probability of a reading at or below the threshold.
    ]),
  ),
  references: (
    entry("Set the rounding cell", [
      For a displayed value $r$ with spacing $d$, use the edges $r-d/2$ and $r+d/2$. Under a continuous Gaussian law, the endpoint convention leaves the probability unchanged.
    ]),
    entry("Distinguish two kinds of data", [
      A censored record tells you how many readings fell beyond a limit. If only detected events enter a catalogue, model the selection probability or the detected-event count.
    ]),
    entry("Count each reading once", [
      These two factors describe two independent readings. If one device reports both a rounded value and a flag for the same reading, use the intersection of their events.
    ]),
    entry("Combine identical threshold trials", [
      #code("hits ~ Binomial(20, p_flag)")
      #v(3pt)
      If all twenty independent readings share the same threshold and noise scale, retain their total number of detections.
    ]),
  ),
)
