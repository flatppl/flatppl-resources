#import "theme.typ": *

#sheet(
  topic: "Measurement models", title: "Rounded readings and detection flags", accent: rgb("885a31"),
  formula: ("Probability of a rounding interval", [$P(a < Y < b) = F(b) - F(a)$]),
  reference-title: "Observation conventions",
  file: "examples/measurement.flatppl", example: "Two instruments, one mean",
  illustration: ("Rounding cell and detection threshold",
    "The first Gaussian shades the cell from 0.95 to 1.05. The second shades the tail above 1.20.",
    [At $mu=1$, the first instrument reports a rounded value of 1.0. The second reports that its reading exceeded 1.20. Shading shows the probability of each report.]),
  notes: (
    ("Express both Gaussian tails", 10, 11, [
      Standardize the reading by the instrument’s scale. `invprobit` evaluates the standard Normal CDF. By Gaussian symmetry, `invprobit((m - x) / s)` gives the upper-tail probability directly.
    ]),
    ("Use the recorded interval", 13, 16, [
      A report of 1.0 to the nearest tenth places the reading between 0.95 and 1.05. The second instrument has scale 0.3 and reports one threshold crossing.
    ]),
    ("Indicators for the two reports", 18, 21, [
      Assign one Bernoulli variable to each reported event. Conditional independence of the readings given `mu` makes their likelihood a product of two factors.
    ]),
    ("Condition on the two reports", 23, 25, [
      Set both indicator fields to one for these reports. The likelihood depends on the common mean. `at_one` evaluates it at the mean used in the figure.
    ]),
  ),
  after-notes: (
    entry("Tail subtraction", [
      When both edges exceed the mean, the difference of upper tails avoids cancellation. The #module-link("flatppl-stats-measurement", "c296dc3b975be62fa759468881ee8fa568879a71")[measurement module] exposes this calculation as `gaussian_interval_probability`.
    ]),
  ),
  variants: (
    entry("Check a symmetric cell", [
      #code("p_at_center = 2 * invprobit(0.05 / 0.2) - 1")
      #v(3pt)
      The cell extends a quarter of a standard deviation on either side of the mean. Gaussian symmetry gives the same interval probability.
    ]),
    entry("Check the likelihood by hand", [
      At $mu=1$, the rounding probability is 0.197413 and the flag probability is 0.252493. Their product is 0.0498452, with log likelihood −2.99883.
    ]),
    entry("A reading below threshold", [
      #code("other = record(cell = 1, flag = 0)\nL_other = likelihoodof(K, other)")
      #v(3pt)
      A zero contributes the probability of a reading at or below the threshold.
    ]),
  ),
  references: (
    entry("Set the rounding cell", [
      For a displayed value $r$ with spacing $d$, use the edges $r-d/2$ and $r+d/2$. Under a continuous Gaussian law, the endpoint convention leaves the probability unchanged.
    ]),
    entry("Censoring and selection", [
      Censoring preserves the number of readings beyond a limit. For a catalogue containing only detections, model the selection probability or the detected-event count.
    ]),
    entry("Two reports from one reading", [
      The product above describes independent readings. For a rounded value and flag derived from a single reading, take the probability of the intersection.
    ]),
    entry("Combine identical threshold trials", [
      #code("hits ~ Binomial(20, p_flag)")
      #v(3pt)
      If all twenty independent readings share the same threshold and noise scale, retain their total number of detections.
    ]),
  ),
)
