#import "theme.typ": *

#sheet(
  topic: "Particle physics", title: "Counting experiments", accent: rgb("355b76"),
  formula: ("Expected yield in channel j", [$lambda_j = T_j (b rho_j + epsilon_j S)$]),
  reference-title: "Counts and spectra",
  file: "examples/particle-physics.flatppl", example: "Two channels, one background scale",
  illustration: ("Expected and observed counts",
    "Channel one has 3 background and 1.6 signal events expected, with 5 observed. Channel two has 8 and 2.8 expected, with 10 observed.",
    [For `S = 2` and `b_scale = 1` the means are 4.6 and 10.8. The diamonds mark the synthetic counts supplied in `channels.counts`.]),
  notes: (
    ("Keep the channel inputs together", 5, 9, [
      Each row describes one channel. `channels.exposure` and the other field selections return whole columns. Exposure and efficiency multiply production to give a count.
    ]),
    ("Broadcast the yield equation", 14, 18, [
      `b_scale` rescales both detected background rates. Efficiency acts on produced signal `S`. The dotted Poisson constructor makes an array of conditionally independent channel counts.
    ]),
    ("Bind the full count vector", 21, 26, [
      The prior has two fields, `S` and `b_scale`. The kernel exposes both. Its observation record has one field, `counts`, whose array already contains both channels.
    ]),
    ("Check the rate calculation", 29, 32, [
      `functionof` extracts the expected counts for the same point used in `logdensityof`. Summing the two Poisson log masses gives `log_L` $approx -3.86616$.
    ]),
  ),
  after-notes: (
    entry("A calibration constraint", [
      #code("L_all = joint_likelihood(L, L_cal)")
      #v(3pt)
      An independent calibration can constrain the same `b_scale`. Share its name between the two likelihoods. Their log densities add.
    ]),
  ),
  variants: (
    entry("Independent channel uncertainties", [
      #code("b_scales ~ iid(LogNormal(0, 0.2), 2)")
      #v(3pt)
      A two-element draw gives each channel a separate background scale. For this variant replace the shared scalar in the prediction, prior, kernel boundary and score point.
    ]),
    entry("A histogram with two templates", [
      #code("expected = ns .* s_template .+ nb .* b_template\nbins ~ Poisson.(expected)")
      #v(3pt)
      Each entry represents a disjoint bin. If each template sums to one, `ns` and `nb` are total yields in the histogram.
    ]),
  ),
  references: (
    entry("Define the observation window", [
      #code("window = interval(0, 10)\nsignal = normalize(truncate(\n    Normal(5, 0.2), window))\nbackground = Uniform(window)")
      #v(3pt)
      Normalize the shapes on the same window when their coefficients give the expected yields there.
    ]),
    entry("Retain event energies and count", [
      #code("I = superpose(weighted(ns, signal),\n    weighted(nb, background))\nevents ~ PoissonProcess(I)")
      #v(3pt)
      The intensity mass gives the expected count. The event array carries both its length and its positions, so its likelihood already includes the count term.
    ]),
    entry("Condition on the event count", [
      #code("shape = normalize(I)\nenergy ~ iid(shape, n)")
      #v(3pt)
      Fixing `n` leaves the energy shape. To keep counts in disjoint energy bins, use `BinnedPoissonProcess(edges,I)`.
    ]),
    entry("Count successes in fixed trials", [
      #code("passed ~ Binomial(trials, efficiency)")
      #v(3pt)
      Use the trial total when it is known. A Poisson yield instead describes a random total over an exposure.
    ]),
  ),
)
